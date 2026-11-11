# CF Gaming

**CF Gaming** is a Mac app for playing games on Apple silicon Macs. It plays **Windows games** through its own copy of Wine, and keeps your **Mac games and console emulators** beside them, so everything you play is in one place, with its artwork, ready to start with one click. No CrossOver, Parallels or Windows licence is needed.

## What it does

- **Windows games:** a Steam case installs Steam, and the games you download in it appear by themselves. A game with its own installer goes in a case of its own.
- **Console games:** RetroArch and its cores play your games from many consoles, each console in a case of its own with its box art. xemu, Xenia Edge, Dolphin, RPCS3, PCSX2 and ScummVM play theirs.
- **Mac games:** Steam for Mac's games, and groups of Mac games you choose.
- **Home:** every game on shelves, with a search, and a page for each game.
- **People:** each person has their own colour, picture and cases.
- **Recording:** press **⌃⇧R** while a game runs to record it, with your voices.
- **Controllers:** every controller tested and set up for each console, and CF Gaming itself can be used with one.
- **Saves:** memory cards and save files for the PlayStation, PlayStation 2, Dreamcast and Nintendo 64.
- **Updates:** CF Gaming keeps itself, RetroArch, its cores and the emulators up to date.
- **A guide in the app:** **Help › CF Gaming Guide**.

## Installing

You need a Mac with **Apple silicon** and **macOS 27** or later.

1. Download the newest `CFMacGaming-<version>.dmg` from **[Releases](https://github.com/dusky101/CharddieGaming/releases/latest)**.
2. Open it and double-click **CF Gaming**. If macOS asks about an app downloaded from the Internet, click **Open**.
3. Click **Install**. CF Gaming moves itself into your Applications folder and opens. No administrator's password is needed.

From then on, it updates itself. **[GUIDE.md](GUIDE.md)** has the first launch, step by step.

## In this repository

- **Releases:** each version of CF Gaming, its updates, and the patches made to Wine.
- **`cores/`:** CF Gaming's own build of RetroArch's Mupen64Plus-Next core, which CF Gaming downloads when it's needed, with its licence and source.

Wine is under the GNU LGPL and Mupen64Plus-Next under the GNU GPL version 2; every part's licence is in the app, under **Help › Licences and Notices**. CF Gaming is free, made for family use, and not affiliated with Apple, CodeWeavers, Valve, Microsoft or libretro.
