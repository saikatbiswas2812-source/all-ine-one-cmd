# L4xxyHost — Server & Panel Installer

A community-maintained toolkit for deploying and managing game-server infrastructure.

> **Status:** The L4xxyHost dashboard and theme-studio navigation are under automated shell checks. Theme/extension package execution is intentionally disabled until third-party package provenance, checksums, and compatibility are reviewed. Other legacy installers are not certified production-ready.

## Features

- Pterodactyl Panel and Wings installer modules
- Additional panel installers (Reviactyl, Paymenter, Mythical, Convoy, and others where included)
- VPS, themes, toolbox and extra utilities
- Terminal-based server dashboard

## Requirements

- Ubuntu/Debian versions supported by the selected installer
- Root or sudo access
- A clean VPS is recommended for panel installations
- Domain and DNS pointed to the server for HTTPS setup
- Required ports opened in your provider firewall

## Run from a local clone

```bash
git clone https://github.com/saikatbiswas2812-source/all-ine-one-cmd.git
cd all-ine-one-cmd
chmod +x menu/run.sh menu/UI.sh
sudo bash menu/run.sh
```

## Important safety notes

- Read the selected installer before execution. Installers can change packages, services, firewall rules and databases.
- Back up existing panel data and configuration before upgrades or removal.
- The dashboard launcher runs local files only; it does not download and execute a remote menu payload.
- Theme and extension install/remove actions are temporarily disabled because the bundled third-party Blueprint packages have not completed source, checksum, and compatibility review.
- Legacy panel, Wings, toolbox, VM, and Extras scripts are still separate modules and must be audited and tested on supported systems before production use.
- Do not use destructive uninstall options on an existing server without a verified backup.
- Destructive removal actions are intentionally not offered by the dashboard.
- Never publish API keys, passwords, tokens, panel credentials or private configuration files.

## One-command installer

On Ubuntu/Debian, run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/saikatbiswas2812-source/all-ine-one-cmd/main/install.sh)
```

This clones or fast-forward-updates the repository under `~/L4xxyHost` and launches the dashboard. It does **not** install Pterodactyl, Wings, Docker, Blueprint, or server services.

Run repository checks after cloning:

```bash
cd ~/L4xxyHost
bash tests/smoke.sh
```

## One-line installer domain

The intended command is:

```bash
bash <(curl -fsSL https://petro.l4xxyhost.in)
```

This command will work only after the domain DNS, HTTPS hosting and root installer endpoint have been configured and tested. It is **not yet a live installer endpoint**.

## License and provenance

The existing repository license file is retained. This project is a rebranded fork; upstream sources and third-party components remain subject to their respective licenses and terms.