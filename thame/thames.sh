#!/usr/bin/env bash
set -Eeuo pipefail

[[ $EUID -eq 0 ]] || { echo "Run this module as root."; exit 1; }

# L4xxyHost premium terminal palette
R=$'\033[38;5;203m'; G=$'\033[38;5;120m'; Y=$'\033[38;5;221m'
C=$'\033[38;5;81m'; M=$'\033[38;5;213m'; P=$'\033[38;5;141m'
W=$'\033[1;37m'; D=$'\033[38;5;245m'; N=$'\033[0m'
BB=$'\033[1m'

URL="https://github.com/nobita329/Nobita-Cloud/raw/refs/heads/main/thame/UI"
PANEL_DIR="/var/www/pterodactyl"

names=(
  "nebula.blueprint" "euphoriatheme.blueprint"
  "BetterAdmin.blueprint" "abysspurple.blueprint"
  "amberabyss.blueprint" "catppuccindactyl.blueprint"
  "crimsonabyss.blueprint" "emeraldabyss.blueprint"
  "nightadmin.blueprint" "refreshtheme.blueprint"
  "slice.blueprint" "darkenate.blueprint"
  "recolor.blueprint" "bluetables.blueprint"
  "ultradarkadmin.blueprint" "xlpaneltheme.blueprint"
  "lememtheme.blueprint" "slate.blueprint"
  "kaelixprime.blueprint" "m3dactyl.blueprint"
)

pause(){ printf '\n  %sPress Enter to continue...%s' "$D" "$N"; read -r _; }
is_installed(){
  local slug="${1%.blueprint}"
  [[ -d "$PANEL_DIR/storage/extensions/$slug" ]]
}
draw_header(){
  clear
  printf '\n'
  printf '  %s╭────────────────────────────────────────────────────────────────────────────╮%s\n' "$P" "$N"
  printf '  %s│%s                                                                            %s│%s\n' "$P" "$N" "$P" "$N"
  printf '  %s│%s   %s✦ L4XXYHOST%s   %s/%s   %sTHEME GALLERY%s                               %s│%s\n' "$P" "$N" "$M$BB" "$N" "$D" "$N" "$C$BB" "$N" "$P" "$N"
  printf '  %s│%s   %sMADE BY L4XXY%s  %s•  PREMIUM BLUEPRINT CUSTOMIZATION%s                %s│%s\n' "$P" "$N" "$Y$BB" "$N" "$D" "$N" "$P" "$N"
  printf '  %s│%s                                                                            %s│%s\n' "$P" "$N" "$P" "$N"
  printf '  %s╰────────────────────────────────────────────────────────────────────────────╯%s\n' "$P" "$N"
  printf '\n  %sHOST%s  %s%s%s   %s│%s   %sUSER%s  %s%s%s   %s│%s   %sTIME%s  %s%s%s\n' "$D" "$N" "$W" "$(hostname)" "$N" "$D" "$N" "$D" "$N" "$W" "$(whoami)" "$N" "$D" "$N" "$D" "$N" "$W" "$(date +'%H:%M')" "$N"
  printf '\n  %s╭────────────────────────────── ✦ ──────────────────────────────────────────╮%s\n' "$M" "$N"
  printf '  %s│%s   %sSELECT YOUR PANEL EXPERIENCE%s                                         %s│%s\n' "$M" "$N" "$M$BB" "$N" "$M" "$N"
  printf '  %s╰──────────────────────────────────────────────────────────────────────────╯%s\n\n' "$M" "$N"
}
show_menu(){
  draw_header
  local i name status left right
  for ((i=0; i<${#names[@]}; i+=2)); do
    left="${names[$i]%.blueprint}"
    if is_installed "$left"; then status="${G}● INSTALLED${N}"; else status="${D}○ AVAILABLE${N}"; fi
    printf '  %s%02d%s  %-23s %b' "$C$BB" "$((i+1))" "$N" "$left" "$status"
    if (( i+1 < ${#names[@]} )); then
      right="${names[$((i+1))]%.blueprint}"
      if is_installed "$right"; then status="${G}● INSTALLED${N}"; else status="${D}○ AVAILABLE${N}"; fi
      printf '     %s%02d%s  %-23s %b' "$C$BB" "$((i+2))" "$N" "$right" "$status"
    fi
    printf '\n'
  done
  printf '\n  %s╭──────────────────────────────────────────────────────────────────────────╮%s\n' "$P" "$N"
  printf '  %s│%s   %s[ 0 ]%s  BACK TO THEME STUDIO                                          %s│%s\n' "$P" "$N" "$R$BB" "$N" "$P" "$N"
  printf '  %s╰──────────────────────────────────────────────────────────────────────────╯%s\n\n' "$P" "$N"
}

while true; do
  show_menu
  read -r -p "$(printf '  %sL4XXYHOST%s %s›%s Choose a theme: ' "$C$BB" "$N" "$M" "$N")" opt
  [[ "$opt" == "0" ]] && { printf '\n  %sReturning to Theme Studio...%s\n' "$M" "$N"; exit 0; }
  [[ "$opt" =~ ^([1-9]|1[0-9]|20)$ ]] || { printf '\n  %sInvalid choice. Enter a number from 1 to 20.%s\n' "$R" "$N"; sleep 1; continue; }

  NAME="${names[$((opt-1))]}"
  clean_name="${NAME%.blueprint}"
  draw_header
  if is_installed "$clean_name"; then cur_status="${G}● INSTALLED${N}"; else cur_status="${Y}○ NOT INSTALLED${N}"; fi
  printf '  %sSELECTED THEME%s  %s%s%s\n' "$D" "$N" "$W$BB" "$clean_name" "$N"
  printf '  %sCURRENT STATUS%s  %b\n\n' "$D" "$N" "$cur_status"
  printf '  %s╭──────────────────────────────────────────────────────────────────────────╮%s\n' "$P" "$N"
  printf '  %s│%s   %s[ 1 ]%s  INSTALL / APPLY THEME  [LOCKED]                                         %s│%s\n' "$P" "$N" "$G$BB" "$N" "$P" "$N"
  printf '  %s│%s   %s[ 2 ]%s  UNINSTALL THEME  [LOCKED]                                               %s│%s\n' "$P" "$N" "$R$BB" "$N" "$P" "$N"
  printf '  %s│%s   %s[ 0 ]%s  BACK                                                        %s│%s\n' "$P" "$N" "$Y$BB" "$N" "$P" "$N"
  printf '  %s╰──────────────────────────────────────────────────────────────────────────╯%s\n\n' "$P" "$N"
  read -r -p "$(printf '  %sL4XXYHOST%s %s›%s Select action: ' "$C$BB" "$N" "$M" "$N")" action

  case "$action" in
    1)
      printf '\n  %sTheme installation is temporarily disabled.%s\n' "$Y" "$N"
      printf '  %sThird-party Blueprint packages need source, checksum, and compatibility review first.%s\n' "$D" "$N"
      printf '  %sNo files or panel data were changed.%s\n' "$G" "$N"
      ;;
    2)
      printf '\n  %sTheme removal is temporarily disabled to protect panel data.%s\n' "$Y" "$N"
      printf '  %sNo files or panel data were changed.%s\n' "$G" "$N"
      ;;
    0) exit 0 ;;
    *) printf '\n  %sInvalid action.%s\n' "$R" "$N" ;;
  esac
  pause
done
