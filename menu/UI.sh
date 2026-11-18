#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
NC=$'\033[0m'; BOLD=$'\033[1m'; DIM=$'\033[2m'
WHITE=$'\033[38;5;255m'; MUTED=$'\033[38;5;245m'
PURPLE=$'\033[38;5;160m'; PINK=$'\033[38;5;196m'
CYAN=$'\033[38;5;203m'; GREEN=$'\033[38;5;120m'
RED=$'\033[38;5;196m'; GOLD=$'\033[38;5;220m'
BG=$'\033[48;5;235m'

metrics(){
  CPU="$(top -bn1 2>/dev/null | awk -F'[, ]+' '/Cpu\(s\)/ {for(i=1;i<=NF;i++) if($i ~ /id/) {v=$(i-1); printf "%d",100-v; exit}}' || true)"
  RAM="$(free 2>/dev/null | awk '/Mem:/ {if($2>0) printf "%d",($3/$2)*100}' || true)"
  DISK="$(df -h / 2>/dev/null | awk 'NR==2 {print $5}' || true)"
  UP="$(uptime -p 2>/dev/null | sed 's/^up //' || true)"
  CPU="${CPU:-?}"; RAM="${RAM:-?}"; DISK="${DISK:-?}"; UP="${UP:-unknown}"
}
pause(){ printf '\n  %sPress Enter to return...%s' "$MUTED" "$NC"; read -r _; }
launch_themes(){
  local file="$ROOT/thame/run.sh"
  if [[ -f "$file" ]]; then bash "$file"; else
    printf '\n  %s[!] Themes & Extensions module is missing.%s\n' "$RED" "$NC"
    pause
  fi
}

while true; do
  metrics
  clear
  printf '\n'
  printf '  %s╭──────────────────────────────────────────────────────────────────────────────╮%s\n' "$PURPLE" "$NC"
  printf '  %s│%s                                                                              %s│%s\n' "$PURPLE" "$NC" "$PURPLE" "$NC"
  printf '  %s│%s   %s██╗     ██╗  ██╗██╗  ██╗██╗   ██╗██╗   ██╗██╗  ██╗ ██████╗ ███████╗████████╗%s %s│%s\n' "$PURPLE" "$NC" "$PINK$BOLD" "$NC" "$PURPLE" "$NC"
  printf '  %s│%s   %s██║     ██║  ██║╚██╗██╔╝╚██╗ ██╔╝╚██╗ ██╔╝██║  ██║██╔═══██╗██╔════╝╚══██╔══╝%s %s│%s\n' "$PURPLE" "$NC" "$PINK$BOLD" "$NC" "$PURPLE" "$NC"
  printf '  %s│%s   %s██║     ███████║ ╚███╔╝  ╚████╔╝  ╚████╔╝ ███████║██║   ██║███████╗   ██║   %s %s│%s\n' "$PURPLE" "$NC" "$PINK$BOLD" "$NC" "$PURPLE" "$NC"
  printf '  %s│%s   %s██║     ██╔══██║ ██╔██╗   ╚██╔╝    ╚██╔╝  ██╔══██║██║   ██║╚════██║   ██║   %s %s│%s\n' "$PURPLE" "$NC" "$PINK$BOLD" "$NC" "$PURPLE" "$NC"
  printf '  %s│%s   %s███████╗██║  ██║██╔╝ ██╗   ██║      ██║   ██║  ██║╚██████╔╝███████║   ██║   %s %s│%s\n' "$PURPLE" "$NC" "$PINK$BOLD" "$NC" "$PURPLE" "$NC"
  printf '  %s│%s   %s╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   %s %s│%s\n' "$PURPLE" "$NC" "$PINK$BOLD" "$NC" "$PURPLE" "$NC"
  printf '  %s│%s                                                                              %s│%s\n' "$PURPLE" "$NC" "$PURPLE" "$NC"
  printf '  %s│%s       %sP R E M I U M   S E R V E R   C O N T R O L   S U I T E%s              %s│%s\n' "$PURPLE" "$NC" "$CYAN$BOLD" "$NC" "$PURPLE" "$NC"
  printf '  %s│%s       %s✦  MADE BY L4XXY  •  THEME STUDIO  •  EST. 2026%s                     %s│%s\n' "$PURPLE" "$NC" "$GOLD$BOLD" "$NC" "$PURPLE" "$NC"
  printf '  %s│%s                                                                              %s│%s\n' "$PURPLE" "$NC" "$PURPLE" "$NC"
  printf '  %s╰──────────────────────────────────────────────────────────────────────────────╯%s\n' "$PURPLE" "$NC"
  printf '\n'
  printf '  %s╭───────────────╮%s  %s╭───────────────╮%s  %s╭───────────────╮%s  %s╭────────────────╮%s\n' "$GREEN" "$NC" "$CYAN" "$NC" "$PINK" "$NC" "$GOLD" "$NC"
  printf '  %s│%s  %s● ONLINE%s   %s│%s  %sCPU  %s%%%s   %s│%s  %sRAM  %s%%%s   %s│%s  %sDISK  %s%s%s   %s│%s\n' "$GREEN" "$NC" "$GREEN$BOLD" "$NC" "$GREEN" "$NC" "$CYAN" "$CPU" "$NC" "$CYAN" "$NC" "$PINK" "$RAM" "$NC" "$PINK" "$NC" "$GOLD" "$DISK" "$NC" "$GOLD" "$NC"
  printf '  %s╰───────────────╯%s  %s╰───────────────╯%s  %s╰───────────────╯%s  %s╰────────────────╯%s\n' "$GREEN" "$NC" "$CYAN" "$NC" "$PINK" "$NC" "$GOLD" "$NC"
  printf '  %s↳ HOST%s  %s%s%s     %s↳ UPTIME%s  %s%s%s\n\n' "$PURPLE" "$NC" "$WHITE" "$(hostname)" "$NC" "$PURPLE" "$NC" "$WHITE" "$UP" "$NC"
  printf '  %s╭──────────────────────────────────────────────────────────────────────────────╮%s\n' "$PINK" "$NC"
  printf '  %s│%s   %s✧  THEME & EXTENSION CENTER%s                                             %s│%s\n' "$PINK" "$NC" "$PINK$BOLD" "$NC" "$PINK" "$NC"
  printf '  %s│%s      %sBlueprint  ·  Themes  ·  Extensions  ·  Add-ons%s                     %s│%s\n' "$PINK" "$NC" "$MUTED" "$NC" "$PINK" "$NC"
  printf '  %s╰──────────────────────────────────────────────────────────────────────────────╯%s\n' "$PINK" "$NC"
  printf '\n'
  printf '  %s╭──────────────────────────────────────────────────────────────────────────────╮%s\n' "$PURPLE" "$NC"
  printf '  %s│%s   %s[ 1 ]%s   %s✦  LAUNCH THEME & EXTENSION CENTER%s                            %s│%s\n' "$PURPLE" "$NC" "$CYAN$BOLD" "$NC" "$WHITE$BOLD" "$NC" "$PURPLE" "$NC"
  printf '  %s│%s                                                                              %s│%s\n' "$PURPLE" "$NC" "$PURPLE" "$NC"
  printf '  %s│%s   %s[ 0 ]%s   %sEXIT CONTROL CENTER%s                                           %s│%s\n' "$PURPLE" "$NC" "$RED$BOLD" "$NC" "$MUTED" "$NC" "$PURPLE" "$NC"
  printf '  %s╰──────────────────────────────────────────────────────────────────────────────╯%s\n' "$PURPLE" "$NC"
  printf '\n'
  read -r -p "$(printf '  %sL4XXYHOST%s %s›%s ' "$CYAN$BOLD" "$NC" "$PINK" "$NC")" choice
  case "$choice" in
    1) launch_themes ;;
    0|q|quit|exit) printf '\n  %s✦ Thank you for choosing L4xxyHost. Made with pride by L4xxy.%s\n' "$GOLD" "$NC"; exit 0 ;;
    *) printf '\n  %sInvalid option. Choose 1 or 0.%s\n' "$RED" "$NC"; sleep 1 ;;
  esac
done
