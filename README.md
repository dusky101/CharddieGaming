# Charddie Gaming

**Charddie Gaming** is a Mac app that lets Charlie and Freddie play their Windows games through Steam on their Apple silicon MacBooks: click one icon and Steam opens. It needs no CrossOver, no Parallels and no Windows licence.

The first time it opens, it sets up a private Windows environment and installs Steam. From then on, clicking the icon goes straight to Steam. Games already downloaded in CrossOver can be brought across in seconds, without downloading them again.

Version **1.0 (1)**, signed with a Developer ID and notarised by Apple.

---

## How it works

Charddie Gaming bundles its own copy of **Wine**, the open-source layer that runs Windows programs on macOS, together with Apple's **D3DMetal**, which turns DirectX 10, 11 and 12 graphics into Metal. Older DirectX 9 games use Wine's own graphics code. The Windows programs are Intel code, which Apple's **Rosetta 2** translates.

| Part | What it is |
|---|---|
| Wine | The open-source (LGPL) Wine from CodeWeavers' CrossOver 26.3 source release, plus four patches of our own: Steam's web view, two fixes for Wine's synchronisation server, and proper names in the Dock |
| D3DMetal 4.0b2 | From Apple's Game Porting Toolkit, included as Apple supplies it |
| GStreamer | Plays the videos inside games |
| SDL | Makes Bluetooth game controllers (Xbox, PlayStation, Switch) work in games |
| Steam installer | Valve's own, signed by Valve, installed silently on first launch |

None of CrossOver's own (proprietary) parts are used: not its app, its bottle manager or its compatibility database.

## Features

- **One-click Steam.** The first launch sets everything up in about a minute; later launches open Steam straight away.
- **Import Games from CrossOver.** Brings games across from a CrossOver bottle as APFS clones: instant, and they take no extra disk space. CrossOver's copy isn't changed.
- **Game controllers.** Bluetooth pads paired in System Settings work in games. A Game Controllers panel is one click away.
- **Clean stop.** Stop Steam, or quit the app, and every Windows process is closed properly. That also gives the mouse pointer back if a game hid it.
- **Friendly on the Mac.** Steam appears in the Dock and menu bar as "Steam". The app has its own Dock menu, logs, and help screens for problems such as a missing Rosetta.

## Requirements

- A Mac with **Apple silicon** (M1 or later).
- **macOS 27** or later.
- **Rosetta 2.** It's usually installed already; the app explains how to install it if not.
- About 1.5 GB for the app, plus the space the games need.
- An internet connection and a Steam account.

## Tested games

| Game | DirectX | Result |
|---|---|---|
| Planet Coaster 2 | 12 | Plays smoothly (High preset recommended on M4 Pro Macs) |
| Train Simulator Classic, 64-bit | 9 | Plays, with full scenery |
| Train Simulator Classic, "DX12 Experimental" | 12 (D3D9-on-12) | Doesn't work (it needs a Microsoft component that isn't available) |
| eFootball | 11 | To be confirmed on the boys' Macs |

## Known issues

- Steam shows **two Steam icons** in the Dock. The left one has no window. CrossOver does the same; a fix is planned.
- Steam's menu-bar menu stays open until you click Steam's window.
- Steam writes a small crash report each time it closes. It's harmless.
- A Nintendo N64 controller shows up twice. Xbox controllers show up once.

## Where things are kept

Everything is per user, so each person on the Mac has their own Steam and games:

| What | Where |
|---|---|
| Steam and its games | `~/Library/Application Support/CharddieGaming/Bottles/Steam` |
| Logs | `~/Library/Logs/CharddieGaming` (the newest 10 of each kind) |
| Caches | `~/Library/Caches/CharddieGaming` |

## Setting up and using it

See **[GUIDE.md](GUIDE.md)**: installing, first launch, importing games, controllers and troubleshooting, plus how to build a new release.

## This repository

| Folder | Contents |
|---|---|
| `CharddieGaming/` | The Xcode project for the SwiftUI app (macOS 27) |
| `CharddieEngine/` | A Swift package that runs the engine: bottle set-up, starting and stopping Steam, the Wine environment, logs, the CrossOver importer. Tests: `swift test` |
| `scripts/` | `stage-engine.zsh` (prepares the engine), `embed-engine.zsh` (the Xcode build phase that embeds and signs it), `build-app.zsh`, `verify-app.zsh` |
| `tests/` | Engine tests: the DX12 probe, the GStreamer check, relocation and Steam runs |
| `Design/AppIcon/` | The icon's source layers |

The Wine source, its patches and the dependencies live next to this folder, in `CFWine/CXWine-26.3` and `CFWine/Dependencies`. The full engineering history is in the handover documents in `~/Codingapps/GPTK4`.

## Licences and credits

- **Wine:** GNU LGPL 2.1 or later. Built from CodeWeavers' CrossOver 26.3.0 source release; our patches are in `CFWine/CXWine-26.3/patches`.
- **D3DMetal:** © Apple, under the Game Porting Toolkit licence, which allows non-commercial distribution with Apple's notices kept. Charddie Gaming is free and made for family use.
- **GStreamer** (and the libraries it ships with), **SDL**, **GnuTLS**, **Nettle** and **GMP:** under their own licences.

The full notices are in the app under **Help → Licences and Notices**.

Charddie Gaming is not affiliated with or endorsed by Apple, CodeWeavers, Valve or Microsoft. Steam, CrossOver, DirectX and Windows are trademarks of their owners.
