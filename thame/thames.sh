#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
PANEL_DIR="/var/www/pterodactyl"
R=$'\033[38;5;196m'; G=$'\033[38;5;120m'; Y=$'\033[38;5;220m'
C=$'\033[38;5;203m'; M=$'\033[38;5;196m'; P=$'\033[38;5;124m'
W=$'\033[1;37m'; D=$'\033[38;5;245m'; N=$'\033[0m'; B=$'\033[1m'

names=(
  "nebula" "euphoriatheme" "BetterAdmin" "abysspurple" "amberabyss"
  "catppuccindactyl" "crimsonabyss" "emeraldabyss" "nightadmin" "refreshtheme"
  "slice" "darkenate" "recolor" "bluetables" "ultradarkadmin" "xlpaneltheme"
  "lememtheme" "slate" "kaelixprime" "m3dactyl"
)

pause(){ printf '
  %sPress Enter to continue...%s' "$D" "$N"; read -r _ || true; }
panel_ready(){ [[ -f "$PANEL_DIR/artisan" ]]; }
is_installed(){ [[ -d "$PANEL_DIR/storage/extensions/$1" ]]; }

header(){
  clear
  printf '
  %s╔══════════════════════════════════════════════════════════════════════╗%s
' "$R" "$N"
  printf '  %s║%s  %s☠ L4XXYHOST%s  %s/  NIGHTFALL THEME VAULT%s                         %s║%s
' "$R" "$N" "$M$B" "$N" "$D" "$N" "$R" "$N"
  printf '  %s║%s  %sMADE BY L4XXY%s  %s•  PREMIUM PANEL THEMES%s                      %s║%s
' "$R" "$N" "$Y$B" "$N" "$D" "$N" "$R" "$N"
  printf '  %s╚══════════════════════════════════════════════════════════════════════╝%s
' "$R" "$N"
  printf '  %sHOST%s %s%s%s   %sUSER%s %s%s%s   %sTIME%s %s%s%s
' "$D" "$N" "$W" "$(hostname)" "$N" "$D" "$N" "$W" "$(whoami)" "$N" "$D" "$N" "$W" "$(date +'%H:%M')" "$N"
}

show_gallery(){
  header
  printf '
  %s╭─ AVAILABLE THEMES ───────────────────────────────────────────────────╮%s
' "$P" "$N"
  local i name status
  for ((i=0;i<${#names[@]};i++)); do
    name="${names[$i]}"
    if is_installed "$name"; then status="${G}● INSTALLED${N}"; else status="${D}○ AVAILABLE${N}"; fi
    printf '  %s%02d%s  %-25s %b
' "$C$B" "$((i+1))" "$N" "$name" "$status"
  done
  printf '  %s╰────────────────────────────────────────────────────────────────────╯%s
' "$P" "$N"
  printf '
  %s[i]%s Install  %s[r]%s Remove  %s[0]%s Back
' "$Y$B" "$N" "$Y$B" "$N" "$R$B" "$N"
}

while true; do
  show_gallery
  read -r -p "$(printf '  %sL4XXYHOST%s %s›%s Select theme number/action: ' "$C$B" "$N" "$M" "$N")" choice
  case "$choice" in
    0) exit 0 ;;
    i|I|r|R)
      echo -e "
  ${Y}Select a theme by its number first, then choose Install or Remove from its detail screen.${N}"
      pause
      ;;
    *)
      if [[ "$choice" =~ ^([1-9]|1[0-9]|20)$ ]]; then
        name="${names[$((choice-1))]}"
        header
        printf '
  %sSELECTED THEME%s  %s%s%s
' "$D" "$N" "$W$B" "$name" "$N"
        if is_installed "$name"; then
          printf '  %sSTATUS%s  %s● INSTALLED%s
' "$D" "$N" "$G" "$N"
        else
          printf '  %sSTATUS%s  %s○ NOT INSTALLED%s
' "$D" "$N" "$Y" "$N"
        fi
        printf '
  %s[1]%s Install / Apply   %s[2]%s Uninstall   %s[0]%s Back
' "$G$B" "$N" "$R$B" "$N" "$Y$B" "$N"
        read -r -p "  Action: " action
        case "$action" in
          1)
            if ! panel_ready; then
              echo -e "
  ${R}Pterodactyl Panel not found at $PANEL_DIR. Install Panel first.${N}"
            elif ! command -v blueprint >/dev/null 2>&1; then
              echo -e "
  ${Y}Blueprint CLI not found. Install Blueprint Framework first.${N}"
            else
              package="$PANEL_DIR/$name.blueprint"
              bundled_package="$ROOT/thame/UI/$name.blueprint"
              if [[ ! -f "$package" && -f "$bundled_package" ]]; then
                if unzip -tq "$bundled_package" >/dev/null 2>&1; then
                  cp -- "$bundled_package" "$package"
                  echo -e "  ${G}Using bundled theme package: $bundled_package${N}"
                else
                  echo -e "  ${R}Bundled theme package failed ZIP integrity check: $bundled_package${N}"
                fi
              fi
              if [[ ! -f "$package" ]]; then
                echo -e "
  ${Y}Package missing: $package${N}"
                echo -e "  ${D}Checking common upload folders (/root, /home, /tmp)...${N}"
                found="$(find /root /home /tmp -type f -name "$name.blueprint" -print -quit 2>/dev/null || true)"
                if [[ -n "$found" ]] && unzip -tq "$found" >/dev/null 2>&1; then
                  cp -- "$found" "$package"
                  echo -e "  ${G}Found and verified package: $found${N}"
                else
                  echo -e "  ${Y}Upload the official $name.blueprint file using SFTP to /root/$name.blueprint, then retry.${N}"
                  read -r -p "  Package file path (blank to cancel): " source_file
                  if [[ -n "$source_file" && -f "$source_file" ]] && unzip -tq "$source_file" >/dev/null 2>&1; then
                    cp -- "$source_file" "$package"
                    echo -e "  ${G}Package copied and ZIP integrity verified.${N}"
                  else
                    echo -e "  ${R}No valid package supplied. Install cancelled.${N}"
                  fi
                fi
              fi
              if [[ -f "$package" ]]; then
                (cd "$PANEL_DIR" && blueprint -install "$name")
              else
                echo -e "  ${Y}Install cancelled: package unavailable.${N}"
              fi
            fi
            pause
            ;;
          2)
            if ! panel_ready; then
              echo -e "
  ${R}Pterodactyl Panel not found. Install Panel first.${N}"
            elif ! command -v blueprint >/dev/null 2>&1; then
              echo -e "
  ${Y}Blueprint CLI not found.${N}"
            elif ! is_installed "$name"; then
              echo -e "
  ${Y}Theme is not installed.${N}"
            else
              read -r -p "Type REMOVE to uninstall $name: " confirm
              if [[ "$confirm" == "REMOVE" ]]; then
                # The typed REMOVE confirmation is the safety gate; skip Blueprint's duplicate prompt.
                USER_CONFIRMED_REMOVAL=yes blueprint -remove "$name"
              else
                echo "Cancelled."
              fi
            fi
            pause
            ;;
          0) ;;
          *) echo -e "
  ${R}Invalid action.${N}"; sleep 1 ;;
        esac
      else
        echo -e "
  ${R}Invalid choice. Enter 1-20 or 0.${N}"
        sleep 1
      fi
      ;;
  esac
done
