# Security Policy

## Supported Versions

This repository contains personal dotfiles for an Arch Linux + Hyprland setup ("ShadowArch").
Only the latest commit on the `main` branch is supported.

| Version | Supported |
| ------- | --------- |
| `main` (latest commit) | ✅ |
| Older commits / tags | ❌ |

## Reporting a Vulnerability

If you discover a security-related issue in these configs or scripts — for example unsafe
shell scripting, accidentally committed secrets, overly permissive file permissions, or an
abusable systemd user service — please report it responsibly.

**Preferred channels (in order):**
1. Open a **private vulnerability report** via the GitHub *Security* tab of this repository.
2. Open a regular [issue](https://github.com/asifahamed-ece/dotfiles/issues) with the
   prefix `[SECURITY]` in the title (if the issue is not sensitive).

**Please include:**
1. A description of the issue and its exact location (file / line).
2. Steps to reproduce or a minimal proof-of-concept.
3. The affected environment (Arch Linux + Hyprland version, shell, etc.).

## Response Timeline (Best Effort)

This is a personal, student-maintained project, so handling is best-effort:

- Acknowledgement within **48 hours**.
- Fix or mitigation plan within **7 days** for confirmed issues.
- Public credit in the commit message / README if you want it.

## Scope

**In scope:**
- Shell scripts under `hypr/.config/hypr/scripts/` and `waybar/.config/waybar/scripts/`
  (command injection, unsafe temp-file handling, unquoted expansions).
- Systemd user services under `systemd/.config/systemd/`.
- Secrets or credentials accidentally committed to the repository.
- Unsafe permissions or behavior introduced by `install.sh`.

**Out of scope:**
- Vulnerabilities in upstream software (Hyprland, Waybar, Kitty, Rofi, Wofi, Yazi,
  Arch Linux packages, etc.) — please report those to the respective maintainers.
- Issues that require physical access to the machine.
- Social engineering attacks.

## Known Considerations

- Some configs historically reference `/home/shadow`; `install.sh` rewrites these to the
  installing user's `$HOME`. This is cosmetic, not a vulnerability.
- All scripts are intended to run as a **regular user** with no elevated privileges.
  Never run `install.sh` or any script from this repo as root.

## Thank You

Thanks for helping keep this repository — and everyone who installs it — safe. 🐧
