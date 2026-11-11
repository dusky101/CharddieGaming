#!/bin/zsh
# Builds RetroArch's Mupen64Plus-Next core for Apple silicon, as libretro's osx-arm64 job does.
#
#   zsh scripts/build.zsh libretro   src/ exactly at the pin, unpatched: libretro's own build, "3.0-Vulkan 15bada8"
#   zsh scripts/build.zsh buildfix   with patch 0001 only (the build fix): a control, "3.0-Vulkan 15bada8-buildfix"
#   zsh scripts/build.zsh glfix      with all of patches/ (#664): ours, "3.0-Vulkan 15bada8-glfix"
#
# Each mode is a number of patches from the series in patches/, taken in order: none, the first, or all. The script
# moves src/ between those states itself (applying or undoing patches), but only when src/ is exactly one of them.
#
# With macOS SDK 27.0 (Xcode 27.0), "libretro" doesn't build: custom/dependencies/libpng/pngpriv.h:518 wants <fp.h>,
# and custom/dependencies/libzlib/zutil.h:128 redefines fdopen, both under TARGET_OS_MAC, which the SDK's own
# headers define. Patch 0001 removes both guards. libretro's own core was built with SDK 15.0 (its LC_BUILD_VERSION).
#
# The result goes to build/<mode>/mupen64plus_next_libretro.dylib, with build/<mode>/build.log (make's whole output)
# and build/<mode>/BUILD-INFO.txt (what was built, from what, with what). Nothing is written outside this project.
#
# How libretro builds it (read, not inferred):
# - ci-templates osx-arm64.yml at 31b0ce3100ad226f58ec9fcd9e29915307e72505 (git.libretro.com,
#   libretro-infrastructure/ci-templates), job .libretro-osx-arm64-make-default, which the core's .gitlab-ci.yml
#   job libretro-build-osx-arm64 extends. Its variables reach make as environment variables, not as command-line
#   ones, so they're passed the same way here: platform=osx arch=arm CC=clang CXX=clang++ CROSS_COMPILE=1
#   LIBRETRO_APPLE_PLATFORM=arm64-apple-macos10.15 LIBRETRO_APPLE_ISYSROOT=$(xcodebuild -version -sdk macosx Path),
#   then "make -f Makefile -j$NUMPROC" in the source's root.
# - The Makefile's osx block then adds -target and -isysroot (CROSS_COMPILE=1), turns on ParaLLEl-RSP,
#   ParaLLEl-RDP, threaded audio and LLE, and leaves the dynarec off (WITH_DYNAREC empty).
#
# Differences from libretro's job, none of which changes the code built:
# - The environment is emptied first (env -i), so nothing from Marc's shell (CFLAGS, LDFLAGS, MAKEFLAGS…) leaks in.
# - GIT_VERSION is given on make's command line. libretro's job takes it from "git rev-parse --short HEAD", but
#   src/ is unpacked from GitHub's archive, so has no commit for that to read.
# - make runs with one job per core rather than the job's 1 + cores/5: only the time differs.
# - "make clean" runs first. The Makefile has no header dependencies (no -MMD), so a patched header would
#   otherwise not be recompiled.
#
# The core's version string is "3.0" FLAVOUR_VERSION GIT_VERSION (libretro/libretro.c:657), FLAVOUR_VERSION being
# "-Vulkan" with ParaLLEl-RDP (custom/mupen64plus-next_common.h:156). The Makefile turns GIT_VERSION into
# -DGIT_VERSION=\"$(GIT_VERSION)\", so its value carries its own quotes and leading space: '" 15bada8"'.

emulate -L zsh
setopt err_exit pipe_fail no_unset

readonly PROJECT="${0:A:h:h}"
readonly SRC="$PROJECT/src"
readonly PATCHES_DIR="$PROJECT/patches"

readonly PIN=15bada85906593376e8fd697f1b0b3af3a20f512
readonly PIN_SHORT=15bada8
readonly PIN_TREE=34209af94c9d9e80ee12336347e9867f1865740b   # the pin's git tree, from GitHub's API
readonly CORE=mupen64plus_next_libretro.dylib

fail() { print -u2 -r -- "build.zsh: $*"; exit 1; }

(( $# == 1 )) || fail "usage: zsh scripts/build.zsh <libretro|buildfix|glfix>"
readonly MODE="$1"
all_patches=( "$PATCHES_DIR"/*.patch(N) )
case "$MODE" in
  libretro) readonly SUFFIX="$PIN_SHORT"          WANT=0 ;;
  buildfix) readonly SUFFIX="$PIN_SHORT-buildfix" WANT=1 ;;
  glfix)    readonly SUFFIX="$PIN_SHORT-glfix"    WANT=${#all_patches} ;;
  *)        fail "unknown mode '$MODE': use libretro, buildfix or glfix" ;;
esac
(( ${#all_patches} >= 2 )) || fail "patches/ should hold #664's two patches, and has ${#all_patches}"
[[ "${all_patches[1]:t}" == 0001-libpng-zlib-drop-the-TARGET_OS_MAC-guards.patch ]] ||
  fail "the first patch is ${all_patches[1]:t}, not 0001-libpng-zlib-drop-the-TARGET_OS_MAC-guards.patch"
mode_patches=( "${(@)all_patches[1,WANT]}" )
mode_names=( "${(@)mode_patches:t}" )
readonly TREE_IS="the pin's with ${WANT} of ${#all_patches} patches"
readonly VERSION="3.0-Vulkan $SUFFIX"
readonly OUT="$PROJECT/build/$MODE"
readonly LOG="$OUT/build.log"

# 1. The source. src/'s git index must be the pin's tree: it's never changed, as the patches touch only the files.
# What's built is the working tree, so its own tree is worked out too, in a temporary index, and must be exactly the
# pin's with the mode's patches. It must also start as one of the known states (the pin with the first 0, 1 … n
# patches), or nothing is touched. So an edit to any of the pin's files stops the build, as does any new file, except
# one that git ignores: src/'s own .gitignore files (*.o, *.d, *.dylib, *.so, *.a, *.js and others, which the build
# makes or never compiles) and Marc's global ignore file (.DS_Store and the like).
[[ -d "$SRC/.git" ]] || fail "no src/.git: unpack the source first (zsh scripts/unpack-source.zsh <zip>)"
index_tree=$(git -C "$SRC" write-tree) || fail "can't read src/'s git index"
[[ "$index_tree" == "$PIN_TREE" ]] || fail "src/'s index is tree $index_tree, not the pin's $PIN_TREE"

mkdir -p "$PROJECT/build"
scratch=$(mktemp -d "$PROJECT/build/treecheck.XXXXXX")
trap 'rm -rf -- "${scratch:?}"' EXIT

# The tree of src/'s working tree, as git would commit it.
working_tree() {
  GIT_INDEX_FILE="$scratch/working.index" git -C "$SRC" read-tree "$PIN_TREE" &&
  GIT_INDEX_FILE="$scratch/working.index" git -C "$SRC" -c core.autocrlf=false add -A &&
  GIT_INDEX_FILE="$scratch/working.index" git -C "$SRC" write-tree
}
# The tree of the pin with the first $1 patches applied.
tree_with() {
  GIT_INDEX_FILE="$scratch/with.index" git -C "$SRC" read-tree "$PIN_TREE" &&
  { (( $1 == 0 )) || GIT_INDEX_FILE="$scratch/with.index" git -C "$SRC" apply --cached "${(@)all_patches[1,$1]}"; } &&
  GIT_INDEX_FILE="$scratch/with.index" git -C "$SRC" write-tree
}

known=()   # known[k + 1]: the tree with the first k patches
for (( k = 0; k <= ${#all_patches}; k++ )); do
  t=$(tree_with $k) || fail "the first $k patches don't apply to the pin"
  known+=( "$t" )
done
expected="${known[WANT + 1]}"

tree=$(working_tree) || fail "can't work out src/'s working tree"
have=${known[(i)$tree]}   # 1-based place of the working tree among the known trees; past the end if none
(( have <= ${#known} )) ||
  fail "src/ isn't the pin with any number of the patches (tree $tree); see git -C src status"
have=$(( have - 1 ))      # now the number of patches applied (not "(( have -= 1 ))": 0 would trip err_exit)
if (( have > WANT )); then
  undo=( "${(@Oa)all_patches[WANT + 1,have]}" )   # undone last first
  git -C "$SRC" apply -R "${undo[@]}"
  print -r -- "Undone: ${(j:, :)${(@)undo:t}}"
elif (( have < WANT )); then
  todo=( "${(@)all_patches[have + 1,WANT]}" )
  git -C "$SRC" apply "${todo[@]}"
  print -r -- "Applied: ${(j:, :)${(@)todo:t}}"
else
  print -r -- "Already at ${TREE_IS}${mode_names:+ (${(j:, :)mode_names})}"
fi
tree=$(working_tree) || fail "can't work out src/'s working tree"
[[ "$tree" == "$expected" ]] ||
  fail "src/ isn't $TREE_IS (tree $tree, not $expected); see git -C src status"

# 2. The toolchain, as libretro's job finds it.
sdk_path=$(xcodebuild -version -sdk macosx Path)
sdk_version=$(xcodebuild -version -sdk macosx SDKVersion)
xcode_version=$(xcodebuild -version | paste -sd ' ' -)
clang_version=$(clang --version | sed -n 1p)
jobs=$(sysctl -n hw.ncpu)

build_env=(
  PATH=/usr/bin:/bin:/usr/sbin:/sbin
  "HOME=$HOME"
  "TMPDIR=${TMPDIR:-/tmp}"
  platform=osx
  arch=arm
  CC=clang
  CXX=clang++
  CROSS_COMPILE=1
  LIBRETRO_APPLE_PLATFORM=arm64-apple-macos10.15
  "LIBRETRO_APPLE_ISYSROOT=$sdk_path"
)

# 3. Build, with make's whole output in the log.
mkdir -p "$OUT"
rm -f "$OUT/$CORE" "$OUT/BUILD-INFO.txt"
print -r -- "Building '$MODE' ($VERSION) with $xcode_version, SDK $sdk_version; log: ${LOG#"$PROJECT"/}"
started=$SECONDS
{
  print -r -- "# build.zsh $MODE, $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  print -r -- "# env: ${build_env[*]}"
  # GIT_VERSION goes to clean as well, or the Makefile's default runs git rev-parse in src/, which has no commit.
  env -i "${build_env[@]}" make -C "$SRC" -f Makefile clean GIT_VERSION="\" $SUFFIX\"" &&
  env -i "${build_env[@]}" make -C "$SRC" -f Makefile -j"$jobs" GIT_VERSION="\" $SUFFIX\""
} >"$LOG" 2>&1 || {
  print -u2 -r -- "build.zsh: make failed after $(( SECONDS - started ))s; the end of ${LOG#"$PROJECT"/}:"
  tail -n 40 "$LOG" >&2
  exit 1
}
mv "$SRC/$CORE" "$OUT/$CORE"

# 4. libretro's job's own checks (otool -L, lipo -info, arm64), then ours: the version string.
otool -L "$OUT/$CORE"
arch_info=$(lipo -info "$OUT/$CORE")
print -r -- "$arch_info"
[[ "$arch_info" == *arm64* ]] || fail "wrong arch: $arch_info"
# grep reads everything (no -q): under pipefail, an early exit could kill strings with SIGPIPE and fail falsely.
strings "$OUT/$CORE" | grep -Fx -- "$VERSION" >/dev/null || fail "the core's version string isn't '$VERSION'"
sha256=$(shasum -a 256 "$OUT/$CORE" | cut -d ' ' -f 1)

{
  print -r -- "mode:            $MODE"
  print -r -- "version string:  $VERSION"
  print -r -- "source:          libretro/mupen64plus-libretro-nx $PIN (tree $PIN_TREE)"
  print -r -- "built tree:      $tree (src/'s working tree: $TREE_IS)"
  for p in "${mode_patches[@]}"; do
    print -r -- "patch:           ${p:t} sha256 $(shasum -a 256 "$p" | cut -d ' ' -f 1)"
  done
  print -r -- "built:           $(date -u '+%Y-%m-%dT%H:%M:%SZ') in $(( SECONDS - started ))s"
  print -r -- "toolchain:       $xcode_version; $clang_version; SDK $sdk_version ($sdk_path)"
  print -r -- "make:            env -i ${build_env[*]} make -C src -f Makefile -j$jobs GIT_VERSION='\" $SUFFIX\"'"
  print -r -- "architecture:    $arch_info"
  print -r -- "size:            $(stat -f %z "$OUT/$CORE") bytes"
  print -r -- "sha256:          $sha256"
} >"$OUT/BUILD-INFO.txt"

print -r -- "Built ${OUT#"$PROJECT"/}/$CORE in $(( SECONDS - started ))s: '$VERSION', sha256 $sha256"
