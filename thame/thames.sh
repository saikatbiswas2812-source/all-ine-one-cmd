#!/usr/bin/env bash
set -Eeuo pipefail

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

pause(){ printf '\n  %sPress Enter to continue...%s' "$D" "$N"; read -r _ || true; }
panel_ready(){ [[ -f "$PANEL_DIR/artisan" ]]; }
is_installed(){ [[ -d "$PANEL_DIR/storage/extensions/$1" ]]; }

header(){
  clear
  printf '\n  %s╔══════════════════════════════════════════════════════════════════════╗%s\n' "$R" "$N"
  printf '  %s║%s  %s☠ L4XXYHOST%s  %s/  NIGHTFALL THEME VAULT%s                         %s║%s\n' "$R" "$N" "$M$B" "$N" "$D" "$N" "$R" "$N"
  printf '  %s║%s  %sMADE BY L4XXY%s  %s•  PREMIUM PANEL THEMES%s                      %s║%s\n' "$R" "$N" "$Y$B" "$N" "$D" "$N" "$R" "$N"
  printf '  %s╚══════════════════════════════════════════════════════════════════════╝%s\n' "$R" "$N"
  printf '  %sHOST%s %s%s%s   %sUSER%s %s%s%s   %sTIME%s %s%s%s\n' "$D" "$N" "$W" "$(hostname)" "$N" "$D" "$N" "$W" "$(whoami)" "$N" "$D" "$N" "$W" "$(date +'%H:%M')" "$N"
}

show_gallery(){
  header
  printf '\n  %s╭─ AVAILABLE THEMES ───────────────────────────────────────────────────╮%s\n' "$P" "$N"
  local i name status
  for ((i=0;i<${#names[@]};i++)); do
    name="${names[$i]}"
    if is_installed "$name"; then status="${G}● INSTALLED${N}"; else status="${D}○ AVAILABLE${N}"; fi
    printf '  %s%02d%s  %-25s %b\n' "$C$B" "$((i+1))" "$N" "$name" "$status"
  done
  printf '  %s╰────────────────────────────────────────────────────────────────────╯%s\n' "$P" "$N"
  printf '\n  %s[i]%s Install  %s[r]%s Remove  %s[0]%s Back\n' "$Y$B" "$N" "$Y$B" "$N" "$R$B" "$N"
}

while true; do
  show_gallery
  read -r -p "$(printf '  %sL4XXYHOST%s %s›%s Select theme number/action: ' "$C$B" "$N" "$M" "$N")" choice
  case "$choice" in
    0) exit 0 ;;
    i|I|r|R)
      echo -e "\n  ${Y}Select a theme by its number first, then choose Install or Remove from its detail screen.${N}"
      pause
      ;;
    *)
      if [[ "$choice" =~ ^([1-9]|1[0-9]|20)$ ]]; then
        name="${names[$((choice-1))]}"
        header
        printf '\n  %sSELECTED THEME%s  %s%s%s\n' "$D" "$N" "$W$B" "$name" "$N"
        if is_installed "$name"; then
          printf '  %sSTATUS%s  %s● INSTALLED%s\n' "$D" "$N" "$G" "$N"
        else
          printf '  %sSTATUS%s  %s○ NOT INSTALLED%s\n' "$D" "$N" "$Y" "$N"
        fi
        printf '\n  %s[1]%s Install / Apply   %s[2]%s Uninstall   %s[0]%s Back\n' "$G$B" "$N" "$R$B" "$N" "$Y$B" "$N"
        read -r -p "  Action: " action
        case "$action" in
          1)
            if ! panel_ready; then
              echo -e "\n  ${R}Pterodactyl Panel not found at $PANEL_DIR. Install Panel first.${N}"
            elif ! command -v blueprint >/dev/null 2>&1; then
              echo -e "\n  ${Y}Blueprint CLI not found. Install Blueprint Framework first.${N}"
            elif [[ ! -f "$PANEL_DIR/$name.blueprint" ]]; then
              echo -e "\n  ${Y}Package missing: $PANEL_DIR/$name.blueprint${N}"
              echo -e "  ${D}Place a trusted, verified .blueprint package there, then retry.${N}"
            else
              (cd "$PANEL_DIR" && blueprint -install "$name")
            fi
            pause
            ;;
          2)
            if ! panel_ready; then
              echo -e "\n  ${R}Pterodactyl Panel not found. Install Panel first.${N}"
            elif ! command -v blueprint >/dev/null 2>&1; then
              echo -e "\n  ${Y}Blueprint CLI not found.${N}"
            elif ! is_installed "$name"; then
              echo -e "\n  ${Y}Theme is not installed.${N}"
            else
              read -r -p "Type REMOVE to uninstall $name: " confirm
              [[ "$confirm" == "REMOVE" ]] && blueprint -remove "$name" || echo "Cancelled."
            fi
            pause
            ;;
          0) ;;
          *) echo -e "\n  ${R}Invalid action.${N}"; sleep 1 ;;
        esac
      else
        echo -e "\n  ${R}Invalid choice. Enter 1-20 or 0.${N}"
        sleep 1
      fi
      ;;
  esac
done
