# Charddie Gaming — setup and user guide

This guide takes you from installing Charddie Gaming to playing games, and covers bringing games across from CrossOver, controllers and fixing problems. The last section is for building a new release.

---

## 1. Before you start

Check the Mac has:

- **Apple silicon**: Apple menu → About This Mac should show an M-series chip.
- **macOS 27** or later.
- **An administrator's password**, to install the app.
- **The child's (or if its your boss's) own user account.** Each account gets its own Steam and games.

## 2. Installing the app

Use **one** of these.

### Option A: the installer package (recommended)

1. Copy `CharddieGaming-1.0.pkg` to the Mac (for example by AirDrop or a USB drive).
2. Double-click it and follow the steps. It asks for an administrator's password.
3. **Charddie Gaming** is now in the Applications folder.

### Option B: copy the app

1. Copy `CharddieGaming.app` into the **Applications** folder.
2. If you copy it on a USB drive, the drive must be formatted as **APFS** or **Mac OS Extended**. Drives formatted for Windows (exFAT or FAT) break parts of the app. If you're unsure, zip it first and unzip it on the other Mac.

Both files are signed and notarised by Apple, so the Mac opens them without any security warnings.

### Rosetta

Windows games need Apple's **Rosetta 2**. If it's missing, Charddie Gaming says so when it opens, with a button to copy the command. An administrator then opens **Terminal**, pastes this command, presses Return and enters their password:

```bash
softwareupdate --install-rosetta --agree-to-license
```

Then click **Check Again** in Charddie Gaming.

## 3. The first launch

1. Open **Charddie Gaming** from Applications, Launchpad or Spotlight. You can also keep it in the Dock (right-click its Dock icon → Options → Keep in Dock).
2. The window shows **Setting up Steam**, with three steps: *Preparing Windows*, *Installing Steam* and *Finishing off*. This takes about a minute and only ever happens once.
3. Steam opens and shows **Updating Steam…** while it downloads the rest of itself from Valve (about 336 MB). Let it finish.
4. macOS may ask: **Allow "Charddie Gaming" to find devices on local networks?** Click **Allow**. Steam uses this for Remote Play and to find games on other computers at home. Choosing Don't Allow only switches those features off.
5. **Sign in to Steam** with the child's own Steam account.

The Charddie Gaming window now says **Steam is running**.

## 4. Everyday use

- **To play:** click **Charddie Gaming**. Steam opens, and games start from Steam's Library as usual.
- **The Charddie Gaming window can be closed.** The app stays in the Dock while Steam runs.
- **The Dock menu** (right-click the Charddie Gaming icon) offers **Open Steam**, **Stop Steam**, **Game Controllers…**, **Import Games from CrossOver…** and **Show Logs**. The same items are in the **Steam** menu at the top of the screen.
- **When you've finished:** quit Charddie Gaming (**⌘Q**) or choose **Stop Steam**. Either one closes Steam and everything it started, cleanly.
- **New games:** download them in Steam in the normal way.

You'll see **two Steam icons** in the Dock. The one with the window is the real one; the other does nothing. That's a known quirk, and CrossOver does the same.

## 5. Bringing games across from CrossOver

If the games are already downloaded in CrossOver, you don't need to download them again.

1. **Quit CrossOver completely** (CrossOver → Quit CrossOver).
2. In Charddie Gaming, choose **Import Games from CrossOver…**. It's a button on the "Steam is ready to play" screen, and also in the Steam menu and the Dock menu.
3. A folder window opens in CrossOver's **Bottles** folder. Choose the bottle that has Steam and the games (usually called **Steam**), then click **Choose**.
4. The list shows every game that's fully installed there, with its size. Games already in Charddie Gaming are shown but can't be ticked.
5. Tick the games you want and click **Import**.
6. Steam closes, the games are copied in, and Steam opens again. It checks the files, then the games show **Play**.

Copying is instant, and the copies take **no extra space** while both sets of files stay the same. Once Steam updates a game in Charddie Gaming, that game's files are stored separately. When everything plays in Charddie Gaming, the CrossOver copy can be removed to free space.

## 6. Game controllers

1. Pair the controller in **System Settings → Bluetooth**. Hold the controller's pairing button until it appears, then click **Connect**.
2. To check it works, choose **Game Controllers…** from the Dock menu. The controller should appear under **Connected (XInput devices)**. The **XInput** tab shows each button and stick as you press it.
3. Start the game and use the controller.

Notes:

- **Xbox controllers** show up once and work best.
- A **Nintendo N64** controller shows up twice. It still works, but some games may see two players.
- If Steam's own controller settings get in the way, look in **Steam → Settings → Controller**.

## 7. Game settings that work well

- **Planet Coaster 2** on the boys' M4 Pro Macs: the **High** preset with **TAA**, VSync off. Leave AMD FSR 3 Frame Generation off: it raises the frame count, but trees look poor and it uses more power.
- **Closing other apps helps.** Heavy background work, such as Photos analysing pictures, costs frames.

## 8. If something goes wrong

| Problem | What to do |
|---|---|
| Steam won't open, or looks stuck | Choose **Stop Steam**, wait a few seconds, then **Open Steam**. If it's still stuck, quit and reopen Charddie Gaming. |
| The mouse pointer has disappeared | Choose **Stop Steam**, or quit Charddie Gaming. The pointer comes back as soon as the game stops. |
| "Something went wrong" | Click **Try Again**. **Show Log** opens the log that explains what happened. |
| "Rosetta is needed" | See the **Rosetta** section in section 2. |
| Set-up was interrupted (for example the Mac was shut down) | Just open Charddie Gaming again. It notices the unfinished set-up, puts it to one side and starts again. |
| The Local Network question appears again | It's normal after an update. Click **Allow**. |
| Steam's menu at the top of the screen won't close | Click Steam's window, or press Esc. |

For anything else, choose **Show Logs** and look at the newest `steam-…` log. Those logs are also what to send when asking for help.

## 9. Removing Charddie Gaming

1. Quit Charddie Gaming.
2. Drag **Charddie Gaming** from Applications to the Bin.
3. Steam and the games are **still kept** in `~/Library/Application Support/CharddieGaming`, so reinstalling the app brings everything back. To remove the games too, delete that folder. **This deletes the downloaded games**, so only do it deliberately.

---

## 10. For maintainers: building a new release

Everything below happens in `~/Codingapps/CFWine/Packaging`. The full detail is in `~/Codingapps/GPTK4/CHARDDIE-GAMING-HANDOVER.md`.

1. **Stage the engine**, if the Wine build has changed or `build/Engine` is missing. The script won't overwrite an existing engine, so move the old one aside first (don't delete it):
   ```bash
   scripts/stage-engine.zsh
   ```
2. **Test the engine.** The scratch folder must be outside `~/Codingapps`:
   ```bash
   tests/test-engine.zsh build/Engine /tmp/charddie-tests
   ```
3. **Test the engine code:**
   ```bash
   swift test --package-path CharddieEngine
   ```
4. **Bump the version** in Xcode (target → General → Version and Build), then choose **Product → Archive**. The "Embed and sign engine" build phase embeds and signs the engine. Allow keychain access to the Developer ID key ("Always Allow").
5. In the Organizer, choose **Distribute App → Direct Distribution**. Xcode notarises the app. Then export it.
6. **Check the exported app:**
   ```bash
   scripts/verify-app.zsh "/path/to/CharddieGaming.app"
   ```
   Everything should pass. With Direct Distribution, it also reports that Apple's two D3DMetal files have been re-signed by Xcode. That's known; see the handover, section 11.
7. **Build the installer**: drop the app into **NotarisePKGTool**, which signs, notarises and staples `CharddieGaming-<version>.pkg`.
8. **Try it** on a test account or one of the boys' Macs before handing it out.

To test changes without touching the real Steam, start the app with a throwaway data folder:

```bash
open --env CHARDDIE_DATA_ROOT=/tmp/charddie-test build/CharddieGaming.app
```
