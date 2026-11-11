# Mupen64Plus-Next `3.0-Vulkan 15bada8-glfix` for Apple silicon

Made by `scripts/package.zsh` on 2026-11-11T21:33:13Z, from `build/glfix/` and this project's own files. The first four sections are what the script checked as it made the package, and what `build.zsh` recorded as it built the core (`build/glfix/BUILD-INFO.txt`). Only this file is committed: the rest of `dist/3.0-Vulkan-15bada8-glfix/` is ignored by git, and made again with `zsh scripts/package.zsh ~/Downloads/mupen64plus-libretro-nx-develop.zip`.

This is **not libretro's build.** It's libretro's `develop` at `15bada8`, with the two commits of [libretro/mupen64plus-libretro-nx#664](https://github.com/libretro/mupen64plus-libretro-nx/pull/664), not yet merged, which make GLideN64 draw on Apple silicon. Its version string says so.

## The package

| File | Bytes | SHA-256 |
|---|---:|---|
| `mupen64plus_next_libretro.dylib` | 6,935,232 | `6d0271c9c2f46ecc9fc6ad62b17a71f3ff21b31b1f0a2a452b3adfe2d81ca979` |
| `LICENSE` | 18,092 | `8177f97513213526df2cf6184d8ff986c675afb514d4e68a404010521b880643` |
| `source/mupen64plus-libretro-nx-develop.zip` | 16,482,778 | `45cef40fbe18446f690bbe445dfe649fe5031feb2db8df853d56d30943677d51` |
| `source/build.zsh` | 10,255 | `0970dda2cb260943360fbd0ee743ddd3f9b8d4571916fd5718b3127cf8bebbed` |
| `source/patches/0001-libpng-zlib-drop-the-TARGET_OS_MAC-guards.patch` | 1,850 | `5114f33d4fbf397a120186eeb1d786a9347295cea8ea454722f62a444003df5e` |
| `source/patches/0002-GLideN64-only-enable-rect-barycoords-with-coverage.patch` | 2,414 | `c744b5e6e7dc0227b50074d185f3f9f189ce4af0dd2da8c1a8b61a6e88fc5f81` |

The core has no `com.apple.quarantine` (`xattr`, checked): it was built here, not downloaded. macOS marks `LICENSE` and `source/mupen64plus-libretro-nx-develop.zip` with the quarantine of Marc's download of the zip: harmless for files that are only read.

## The core

- **Version string:** `3.0-Vulkan 15bada8-glfix`, found in the file with `strings`. libretro's build of the same commit says `3.0-Vulkan 15bada8` (stage 3).
- **Built** 2026-11-11T04:44:28Z by `scripts/build.zsh glfix`, the script in `source/build.zsh` (last committed in `839b990`, with no change since; its modification time, 2026-11-11T04:43:33Z, is before the build began at 2026-11-11T04:44:18Z).
- **Architecture:** arm64 only (`lipo -info`). Minimum macOS 11.0, SDK 27.0 (`LC_BUILD_VERSION`).
- **Signature:** `Signature=adhoc`, `flags=0x20002(adhoc,linker-signed)`, `TeamIdentifier=not set` (`codesign -dv`). `codesign --verify --strict` passes.
- **Links** only to macOS's own libraries (`otool -L`): `/System/Library/Frameworks/AudioToolbox.framework/Versions/A/AudioToolbox`, `/usr/lib/libSystem.B.dylib`, `/System/Library/Frameworks/OpenGL.framework/Versions/A/OpenGL`, `/usr/lib/libc++.1.dylib`.

## Its source

- **libretro/mupen64plus-libretro-nx**, `develop` at `15bada85906593376e8fd697f1b0b3af3a20f512` (tree `34209af94c9d9e80ee12336347e9867f1865740b`).
- **`source/mupen64plus-libretro-nx-develop.zip`** is GitHub's zip of `develop` (https://codeload.github.com/libretro/mupen64plus-libretro-nx/zip/refs/heads/develop), downloaded by Marc on 11 November 2026, when `develop` was the pin. Its comment, written by `git archive`, is the pin. `scripts/unpack-source.zsh` unpacks it and proves its tree is the pin's, byte for byte.
- **The patches**, applied in order (`git apply`), are #664's two commits:
  1. `source/patches/0001-libpng-zlib-drop-the-TARGET_OS_MAC-guards.patch`, from commit `b1b0391f863f9481439b24adf35d4b18fa71b6bf`.
  2. `source/patches/0002-GLideN64-only-enable-rect-barycoords-with-coverage.patch`, from commit `ccdeffb8e0f1f7acb53b7a0d97f3008c49cfa64a`.
- **The tree built:** the pin with both patches is tree `b319b53aed396fb5e37082d88afd3e3709667177`, the one `build.zsh` built (worked out again here, in a temporary git index).
- **`LICENSE`:** GPL-2.0, the pin's own `LICENSE` (git blob `d159169d1050894d3ea3b98e1c965c4058208fe1`).

## How it was built

- **Toolchain:** Xcode 27.0 Build version 27A266a; Apple clang version 21.0.0 (clang-2100.3.34.2); SDK 27.0 (/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX27.0.sdk).
- **In this project:** `zsh scripts/unpack-source.zsh <zip>`, then `zsh scripts/build.zsh glfix`.
- **make**, as `build.zsh` ran it, in this project's folder. `HOME` and `TMPDIR` were the builder's own, and change nothing built:

  ```sh
  env -i PATH=/usr/bin:/bin:/usr/sbin:/sbin HOME="$HOME" TMPDIR="$TMPDIR" platform=osx arch=arm CC=clang CXX=clang++ CROSS_COMPILE=1 LIBRETRO_APPLE_PLATFORM=arm64-apple-macos10.15 LIBRETRO_APPLE_ISYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX27.0.sdk make -C src -f Makefile -j18 GIT_VERSION='" 15bada8-glfix"'
  ```

## For CF Gaming

What CF Gaming needs to import this core, from this project's tests (handovers 03 to 05) and from the core's and RetroArch 1.22.2's source (`69a4f0ea1e8aaf442ae4858f2e7f2b31a1776576`). How it imports it is CF Gaming's own stage.

### Importing the core

- **Check it first:** its SHA-256 (the table above), arm64 only, and its version string.
- **Signed like libretro's:** libretro's own build is ad-hoc and linker-signed too, with no team (`codesign -dv`, stage 5), so an import finds no signing difference.
- **Its file name is libretro's,** `mupen64plus_next_libretro.dylib`, so in a cores folder each replaces the other.
  - **Install… from libretro must not overwrite it,** or GLideN64 is black again.
  - **A way back to libretro's build:** keep libretro's file to put back, or install it again from libretro.
- **What to show on the Cores page:** the version string, `3.0-Vulkan 15bada8-glfix`. RetroArch reads it from the core (`library_version`, `libretro/libretro.c:657`), and `strings` finds it in the file without loading it. The name, `library_name` (line 656), is libretro's own `Mupen64Plus-Next`, so only the version tells them apart.
- **Its licence:** GPL-2.0. If CF Gaming ships the core to anyone, `LICENSE` and `source/` go with it, as applesauce's do (GPL-2.0 section 3(a), `LICENSE` lines 134 to 159). That's this project's reading, not legal advice.
- **Renderers:** GLideN64 draws, through RetroArch's `glcore` driver (OpenGL 4.1 over Metal), where libretro's build stays black. ParaLLEl-RDP draws too, as with libretro's (stage 4). ParaLLEl-RDP stays the suggestion for play without packs.

### Texture packs (`.hts`)

- **The renderer must be GLideN64** (`mupen64plus-rdp-plugin = "gliden64"`): ParaLLEl-RDP doesn't read packs.
- **The four options, set together.** Each is off by default (`libretro/libretro_core_options.h` at the pin):

  | Option | Set to | Default | Key's line |
  |---|---|---|---:|
  | `mupen64plus-txHiresEnable` | `"True"` | `"False"` | 927 |
  | `mupen64plus-txHiresFullAlphaChannel` | `"True"` | `"False"` | 955 |
  | `mupen64plus-EnableEnhancedHighResStorage` | `"True"` | `"False"` | 997 |
  | `mupen64plus-CorrectTexrectCoords` | `"Auto"` | `"Off"` | 422 |

  - **`EnableEnhancedHighResStorage` is required for a `.hts`,** not only a memory saving. It sets GLideN64's file storage (`custom/GLideN64/mupenplus/Config_mupenplus.cpp:220`, `GLideN64/src/TextureFilterHandler.cpp:66–67`), and only then is the pack's name `.hts` (`GLideN64/src/GLideNHQ/TxHiResCache.cpp:88–94`, `TxUtil.h:33–34`). Without it, GLideN64 looks for a `.htc`, and the pack isn't found.
- **The internal resolution:** GLideN64 renders at `mupen64plus-43screensize`, `"640x480"` by default (key at line 87), and RetroArch only scales that to the window, so most of a 4K pack's detail is lost. Offer sizes up to the window's own. The tests used `"2880x2160"`, one of the option's values. `mupen64plus-EnableNativeResFactor` must stay `"0"` (line 157), or it takes over.
- **Where:** `Mupen64plus/cache/` in RetroArch's system folder, CF Gaming's own (`custom/GLideN64/mupenplus/CommonAPIImpl_mupenplus.cpp:61–70`, `TextureFilterHandler.cpp:97–103`).
- **The file's name** is `<the ROM's internal name>_HIRESTEXTURES.hts`, with any colon removed (`TxHiResCache.cpp:88–94`). The internal name is `RSP.romname` (`TextureFilterHandler.cpp:85–86`): `THE LEGEND OF ZELDA` for Ocarina of Time, so OoT Reloaded's file is `THE LEGEND OF ZELDA_HIRESTEXTURES.hts`. A pack under any other name isn't found (inferred).
- **Keep packs read-only.** GLideN64's file storage has a path that truncates the file (`GLideN64/src/GLideNHQ/TxCache.cpp:614–668`). It's for building a cache, not for reading a finished pack, but a read-only file can't be harmed either way. In the tests the pack was read-only and sandboxed, and was unchanged after all 11 runs (SHA-256).
- **Memory and start-up:** OoT Reloaded v11.0.0 4K, one 28.4 GiB `.hts`, added about 410–440 MiB of peak memory, with no start-up time that a 20-second run could measure (stage 5, Ocarina of Time (U) 1.2).
- **Unpacking:** that pack is a 3.95 GB `.7z` that unpacks to 28.4 GiB, so check the free space first. macOS's own `bsdtar` (libarchive 3.7.4, with liblzma) unpacks 7-Zip: it took 146 seconds.

### RetroArch's defaults that act on a fresh config

If RetroArch starts with a config that doesn't set these keys, it uses its defaults (RetroArch 1.22.2):

- **`bundle_assets_extract_enable`** is true on Apple platforms (`config.def.h:97–98`, `configuration.c:1764`). While the assets' extract version differs from the last one recorded, as on a fresh config, the menu unpacks the app's `assets.zip` into `bundle_assets_dst` (`menu/menu_driver.c:3799–3820`). That's `~/Library/Application Support/RetroArch` (`frontend/drivers/platform_darwin.m:455–468`), and Marc's RetroArch's `assets.zip` is 190,814,736 bytes (both read in stage 4). Set it to `"false"` unless that's wanted.
- **`microphone_enable`** is true where RetroArch is built with microphone support (`config.def.h:1248–1250`, under `HAVE_MICROPHONE`; `configuration.c:1873`), so RetroArch asks macOS for the microphone (inferred).
- **`config_save_on_exit`** is true (`config.def.h:574`, `configuration.c:1813`): RetroArch writes its settings back to the config as it quits.

### What's proved and what's inferred

- **Proved** (read in the source at the pins, or run): everything above that cites a file and line, a command, or a stage's test, and the first four sections, which `scripts/package.zsh` checked or `build.zsh` recorded.
- **Inferred:**
  - that GLideN64's truncating path never runs for a finished `.hts` (the tests didn't depend on it);
  - that a pack under another name isn't found (read in `_getFileName`, not tried);
  - that Marc's RetroArch is built with `HAVE_MICROPHONE`, and that macOS then asks for permission (the tests turned the microphone off);
  - the GPL reading above.
