# LoL Friend Cleaner

## Télécharger / Download

[**Télécharger LoL Friend Cleaner gratuitement**](https://github.com/Amendai00/LoL-Friend-Cleaner/releases/tag/v1.1.0-beta)

**Free Windows utility to clean your League of Legends friends list.**

LoL Friend Cleaner connects to the local League of Legends client and helps you remove all friends from your list without deleting them manually one by one.

> **Beta — destructive action.** Removing friends is difficult to undo. Review the preview and save your CSV backup before proceeding.

## Features

- Graphical Windows interface
- Automatic local LoL client detection
- Friends list preview
- Mandatory CSV backup before deletion
- Double confirmation
- Progress display and final summary
- Free to use

## Download

Download `LoL_Friend_Cleaner_Public_v1.0.zip` from [GitHub Releases](../../releases) (under **Assets**). Do not confuse the GitHub-generated "Source code (zip)" archive with the ready-to-run package.

## Usage

1. Download and extract the ZIP.
2. Open League of Legends and sign in.
3. Double-click `LANCER.bat`.
4. Click **Detecter mes amis** to inspect the list.
5. Click **Tout supprimer**, save the required CSV backup, and complete both confirmations if you intend to remove every friend.
6. Re-detect friends afterwards to verify the result.

## Requirements

- Windows 10 or 11
- Windows PowerShell 5.1 and `curl.exe`
- League of Legends client running and connected

The app does not ask for your Riot account password. Local requests are made to `127.0.0.1`.

## Limitations and safety

- **Unofficial tool:** not affiliated with or endorsed by Riot Games.
- Uses an unsupported local client API; client updates may break the tool.
- The local client uses a self-signed certificate. HTTPS certificate validation is disabled for local requests to the loopback interface only.
- CSV export is a record of friends, **not a restore button**; to re-add a friend you must send a new invitation.
- This public beta has not been extensively tested on different Windows computers.
- Never share Riot client authorization tokens in GitHub issues or screenshots.

## Français

LoL Friend Cleaner est un utilitaire Windows gratuit qui permet de supprimer tous les amis de sa liste League of Legends. Lancez le client LoL, ouvrez `LANCER.bat`, vérifiez les comptes détectés et confirmez seulement si vous souhaitez réellement supprimer tous vos amis. Une sauvegarde CSV est obligatoire.
