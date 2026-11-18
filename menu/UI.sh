#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
NC=$'\033[0m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
WHITE=$'\033[38;5;255m'
MUTED=$'\033[38;5;245m'
PURPLE=$'\033[38;5;141m'
PINK=$'\033[38;5;213m'
CYAN=$'\033[38;5;81m'
GREEN=$'\033[38;5;120m'
RED=$'\033[38;5;203m'
GOLD=$'\033[38;5;221m'

pause(){ printf '\n%sPress Enter to return to L4xxyHost...%s' "$MUTED" "$NC"; read -r _; }

metrics(){
  CPU="$(top -bn1 2>/dev/null | awk -F'[, ]+' '/Cpu\(s\)/ {for(i=1;i<=NF;i++) if($i ~ /id/) {v=$(i-1); printf "%d",100-v; exit}}' || true)"
  RAM="$(free 2>/dev/null | awk '/Mem:/ {if($2>0) printf "%d",($3/$2)*100}' || true)"
  DISK="$(df -h / 2>/dev/null | awk 'NR==2 {print $5}' || true)"
  UP="$(uptime -p 2>/dev/null | sed 's/^up //' || true)"
  CPU="${CPU:-?}"; RAM="${RAM:-?}"; DISK="${DISK:-?}"; UP="${UP:-unknown}"
}

launch_themes(){
  local file="$ROOT/thame/run.sh"
  if [[ -f "$file" ]]; then
    bash "$file"
  else
    printf '\n%sTheme & Extensions module is missing.%s\n' "$RED" "$NC"
    pause
  fi
}

while true; do
  metrics
  clear
  printf '\n'
  printf '  %s╭──────────────────────────────────────────────────────────────╮%s\n' "$PURPLE" "$NC"
  printf '  %s│%s                                                              %s│%s\n' "$PURPLE" "$NC" "$PURPLE" "$NC"
  printf '  %s│%s   %s✦ L4XXYHOST%s  %s／%s  %sCONTROL CENTER%s                         %s│%s\n' "$PURPLE" "$NC" "$PINK" "$NC" "$MUTED" "$NC" "$CYAN$BOLD" "$NC" "$PURPLE" "$NC"
  printf '  %s│%s   %sTHEME STUDIO%s                                                %s│%s\n' "$PURPLE" "$NC" "$MUTED" "$NC" "$PURPLE" "$NC"
  printf '  %s│%s                                                              %s│%s\n' "$PURPLE" "$NC" "$PURPLE" "$NC"
  printf '  %s╰──────────────────────────────────────────────────────────────╯%s\n' "$PURPLE" "$NC"
  printf '\n  %s●%s  %s%s%s   %s│%s   %s%s%s   %s│%s   %s%s%s\n' "$GREEN" "$NC" "$WHITE" "$(hostname)" "$NC" "$MUTED" "$NC" "$CYAN" "CPU ${CPU}%" "$NC" "$MUTED" "$NC" "$PINK" "RAM ${RAM}%" "$NC"
  printf '  %s↗%s  Uptime: %s%s%s   %s│%s   Root disk: %s%s%s\n\n' "$GOLD" "$NC" "$WHITE" "$UP" "$NC" "$MUTED" "$NC" "$WHITE" "$DISK" "$NC"
  printf '  %s╭─────────────────────────── ✦ ────────────────────────────────╮%s\n' "$PINK" "$NC"
  printf '  %s│%s  %sDESIGN & CUSTOMIZATION%s                                      %s│%s\n' "$PINK" "$NC" "$PINK$BOLD" "$NC" "$PINK" "$NC"
  printf '  %s╰──────────────────────────────────────────────────────────────╯%s\n' "$PINK" "$NC"
  printf '\n'
  printf '     %s╭────────────────────────────────────────────────────────╮%s\n' "$PURPLE" "$NC"
  printf '     %s│%s                                                        %s│%s\n' "$PURPLE" "$NC" "$PURPLE" "$NC"
  printf '     %s│%s   %s[ 1 ]%s   %s✧  THEMES & EXTENSIONS%s                   %s│%s\n' "$PURPLE" "$NC" "$CYAN$BOLD" "$NC" "$WHITE$BOLD" "$NC" "$PURPLE" "$NC"
  printf '     %s│%s           %sBlueprint • Themes • Add-ons%s               %s│%s\n' "$PURPLE" "$NC" "$MUTED" "$NC" "$PURPLE" "$NC"
  printf '     %s│%s                                                        %s│%s\n' "$PURPLE" "$NC" "$PURPLE" "$NC"
  printf '     %s╰────────────────────────────────────────────────────────╯%s\n' "$PURPLE" "$NC"
  printf '\n     %s[ 0 ]%s  Exit\n\n' "$RED$BOLD" "$NC"
  read -r -p "$(printf '  %sL4xxyHost%s %s›%s ' "$CYAN$BOLD" "$NC" "$PINK" "$NC")" choice
  case "$choice" in
    1) launch_themes ;;
    0|q|quit|exit) printf '\n  %sThanks for using L4xxyHost. Stay legendary. ✦%s\n' "$PINK" "$NC"; exit 0 ;;
    *) printf '\n  %sInvalid option. Choose 1 or 0.%s\n' "$RED" "$NC"; sleep 1 ;;
  esac
done
