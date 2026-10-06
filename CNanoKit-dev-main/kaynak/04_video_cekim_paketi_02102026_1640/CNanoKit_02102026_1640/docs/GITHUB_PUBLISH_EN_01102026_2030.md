# Publishing on GitHub for the first time — step by step (English)

This guide is for publishing a package like CNanoKit **yourself**, from the browser, with no git commands. It takes about 30–45 minutes.

> **Timing:** publish only after the authors you mention (FREELOADER, Positron) have had a chance to comment. The first release does **not** include the `src\` folder; source is shared on request.

## 0. Checklist before publishing
- [ ] Publish the **clean package** only: the folder extracted from `CNanoKit_v0.5_…zip`.
- [ ] **No `log\` folder and no `settings.ini`.** They are specific to your PC.
- [ ] **No third-party files** such as FREELOADER.exe or its hex, `.bas` or `.py` files. Link to the author instead.
- [ ] No real name, e-mail or company name inside the files.
- [ ] `README.md` is at the **top** of the folder.

## 1. Account (once)
1. Go to https://github.com/signup and enter an e-mail, a password and a **username**. The username is public.
2. Enable **two-factor authentication**: Settings → Password and authentication. Save the **recovery codes**.
3. Privacy:
   - Settings → Emails → tick **Keep my email addresses private**.
   - Public profile → leave *Name* empty, or use your nickname.

## 2. New repository
1. Click **+** → **New repository**.
2. Fill in:
   - Name: `CNanoKit`
   - Visibility: **Public**
   - Do not add a README, .gitignore or licence (the package already has them).
3. Click **Create repository**.

## 3. Upload
1. Click **"uploading an existing file"**.
2. Select everything in the package folder (Ctrl+A) and drag it into the browser. Folders work in Chrome and Edge. The limit is 100 files per upload and 25 MB per file.
3. Commit message: `CNanoKit 0.5 first release`. Then click **Commit changes**.
4. Check: the README is shown below the file list, and "MIT license" appears on the right.

## 4. Topics
In About (gear icon), add `pic18 positron proton-ide curiosity-nano microchip pic18f56q71 pymcuprog serial-monitor`.

## 5. Release
1. Go to **Releases** → **Create a new release**.
2. Tag `v0.5` (create on publish). Title `CNanoKit 0.5`.
3. Write short notes in TR and EN, and add the tested versions.
4. Drop the package zip into "Attach binaries" and click **Publish release**.
5. Download it yourself once and test the install.

## 6. Updates
1. **Add file → Upload files** overwrites files with the same name. Write a clear commit message.
2. Make a new release with tag `v0.5`.
3. To delete a file: open it → **…** → **Delete file**. The old version stays in the history.

## 7. Feedback
**Issues** is on by default. **Discussions** can be enabled in Settings → General.

## 8. Later: GitHub Desktop
Install it from https://desktop.github.com. Clone the repository, edit the files locally, then **Commit to main** → **Push origin**.

## 9. Safety
- Never put passwords, keys or personal documents in a repository. Deleting them is not enough because the history keeps them; change the secret instead.
- Do not upload other people's programs; link to them.
