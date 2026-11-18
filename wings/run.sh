#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
WINGS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
C=$'\033[1;36m'; P=$'\033[1;35m'; G=$'\033[1;32m'; Y=$'\033[1;33m'; R=$'\033[1;31m'; N=$'\033[0m'

pause(){ read -r -p "Press Enter to continue..." _; }
need_root(){ if [[ "$EUID" -ne 0 ]]; then echo "${R}Run this option as root.${N}"; return 1; fi; }
show(){
 clear
 echo "${P}╔══════════════════════════════════════════════════════╗${N}"
 echo "${P}║${N}       ${C}L4XXYHOST — WINGS CONTROL CENTER${N}             ${P}║${N}"
 echo "${P}╚══════════════════════════════════════════════════════╝${N}"
 printf "  Host: %s | OS: %s\n" "$(hostname)" "$(. /etc/os-release 2>/dev/null; echo "${PRETTY_NAME:-unknown}")"
 if command -v systemctl >/dev/null 2>&1; then
   printf "  Wings service: %s\n" "$(systemctl is-active wings 2>/dev/null || true)"
 else
   echo "  Wings service: systemd unavailable"
 fi
 echo
 echo "  1) Configure SSL with Certbot (keeps existing certificates)"
 echo "  2) Install Wings (local script)"
 echo "  3) Wings manager (local script)"
 echo "  0) Back"
 echo
}
ssl_setup(){
 need_root || { pause; return; }
 if ! command -v nginx >/dev/null 2>&1; then echo "${Y}Nginx not detected. Install/configure Nginx first.${N}"; pause; return; fi
 read -r -p "Enter node domain (e.g. node.example.com): " domain
 if [[ ! "$domain" =~ ^([A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z]{2,}$ ]]; then
   echo "${R}Invalid domain. No changes made.${N}"; pause; return
 fi
 apt-get update && apt-get install -y certbot python3-certbot-nginx
 echo "${Y}Requesting/renewing certificate for $domain. Existing certificates will not be deleted.${N}"
 certbot --nginx -d "$domain"
 pause
}
run_local(){
 local file="$1"
 if [[ ! -f "$file" ]]; then echo "${R}Required local script missing: $file${N}"; pause; return; fi
 need_root || { pause; return; }
 bash "$file"
 pause
}
while true; do
 show
 read -r -p "L4xxyHost Wings > " opt
 case "$opt" in
  1) ssl_setup ;;
  2) run_local "$WINGS_DIR/install.sh" ;;
  3) run_local "$WINGS_DIR/mang.sh" ;;
  0) exit 0 ;;
  *) echo "${R}Invalid option.${N}"; sleep 1 ;;
 esac
done
