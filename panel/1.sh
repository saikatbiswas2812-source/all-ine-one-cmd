#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
C=$'\033[1;36m'; P=$'\033[1;35m'; R=$'\033[1;31m'; G=$'\033[1;32m'; N=$'\033[0m'
run(){ local f="$ROOT/$1"; if [[ -f "$f" ]]; then bash "$f"; else echo "${R}Not available in this checkout: $1${N}"; fi; read -r -p "Press Enter to continue..." _; }
while true; do
 clear
 echo "${P}╔══════════════════════════════════════════════╗${N}"
 echo "${P}║${N} ${C}L4XXYHOST — PANEL DEPLOYMENTS${N}               ${P}║${N}"
 echo "${P}╚══════════════════════════════════════════════╝${N}"
 echo "  1) Pterodactyl"
 echo "  2) Reviactyl"
 echo "  3) Paymenter"
 echo "  4) Mythical (check installer requirements)"
 echo "  5) Convoy (check installer requirements)"
 echo "  6) Pteroca"
 echo "  7) Jexactyl"
 echo "  0) Back"
 read -r -p "Select > " opt
 case "$opt" in
  1) run "panel/pterodactyl/run.sh" ;;
  2) run "panel/reviactyl/run.sh" ;;
  3) run "panel/paymenter/run.sh" ;;
  4) run "panel/mythical/run.sh" ;;
  5) run "panel/Convoy/install.sh" ;;
  6) run "panel/pteroca/install.sh" ;;
  7) run "panel/Jexactyl/install.sh" ;;
  0) exit 0 ;;
  *) echo "${R}Invalid selection.${N}"; sleep 1 ;;
 esac
done
