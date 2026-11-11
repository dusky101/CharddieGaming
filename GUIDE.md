# Installing CF Gaming

## Before you start

- A Mac with **Apple silicon** (an M-series chip: Apple menu › About This Mac).
- **macOS 27** or later.
- Each person who plays on their own **Mac account**: each account has its own CF Gaming, cases and games.

## 1. Install it

1. Download the newest `CFMacGaming-<version>.dmg` from **[Releases](https://github.com/dusky101/CharddieGaming/releases/latest)**.
2. Open it and double-click **CF Gaming**. If macOS asks about an app downloaded from the Internet, click **Open**.
3. Click **Install**. CF Gaming moves itself into the Applications folder in your home folder, offers a shortcut on your Desktop, and opens from there. No administrator's password is needed.
4. Eject the disk image.

## 2. Rosetta

Windows games need Apple's **Rosetta 2**. If it's missing, CF Gaming says so when it opens. Open **Terminal**, paste this, press Return and type an administrator's password:

```bash
softwareupdate --install-rosetta --agree-to-license
```

## 3. The first launch

1. **Recording:** CF Gaming asks to record your games. Click **Allow…** and follow macOS's steps, or **Not Now**.
2. **Auto Setup** takes you through a few steps, each one skippable:
   - **Who Plays:** add each person, with their colour and picture;
   - **Colours:** pick a look;
   - **Steam:** CF Gaming installs Steam into a case of its own. Sign in to your Steam account when it opens;
   - **Older Setups:** if this Mac has Charddie Gaming 1.0 or a CrossOver bottle with Steam, bring its games across without downloading them again.
3. Choose **Manual Setup** instead to go straight to CF Gaming.

## 4. Playing

- **Windows games:** install them in Steam. They appear on Home and in the Steam case by themselves; click **Play**.
- **Console games:** put them in one folder, with a folder for each console, then open **Settings › RetroArch** and click **Set Up Consoles…**.
- **Anything else:** **New Case**, at the top of Home.

## Updates

CF Gaming looks for a new version once a day and installs it when nothing is playing. **CF Gaming › Check for Updates…** looks now.

## More help

The full guide is in the app: **Help › CF Gaming Guide**, or the **?** on each Settings page. If something goes wrong, **Help › Show Logs** shows what happened.
