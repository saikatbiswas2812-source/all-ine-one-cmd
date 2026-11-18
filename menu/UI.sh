#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
NC=$'\033[0m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
RED=$'\033[38;5;196m'
DARK=$'\033[38;5;124m'
PALE=$'\033[38;5;203m'
WHITE=$'\033[38;5;255m'
MUTED=$'\033[38;5;245m'
GOLD=$'\033[38;5;220m'
GREEN=$'\033[38;5;82m'
CYAN=$'\033[38;5;81m'

metrics() {
  CPU="$(top -bn1 2>/dev/null | awk -F'[, ]+' '/Cpu\(s\)/ {for(i=1;i<=NF;i++) if($i ~ /id/) {v=$(i-1); printf "%d",100-v; exit}}' || true)"
  RAM="$(free 2>/dev/null | awk '/Mem:/ {if($2>0) printf "%d",($3/$2)*100}' || true)"
  DISK="$(df -h / 2>/dev/null | awk 'NR==2 {print $5}' || true)"
  UP="$(uptime -p 2>/dev/null | sed 's/^up //' || true)"
  CPU="${CPU:-?}"; RAM="${RAM:-?}"; DISK="${DISK:-?}"; UP="${UP:-unknown}"
}

launch_themes() {
  local file="$ROOT/thame/run.sh"
  if [[ -f "$file" ]]; then
    bash "$file"
  else
    printf '\n  %s[!] Theme & Extension module is missing.%s\n' "$RED" "$NC"
    read -r -p "  Press Enter to return..." _
  fi
}

while true; do
  metrics
  clear
  printf '\n'
  printf '  %s╔══════════════════════════════════════════════════════════════════════╗%s\n' "$DARK" "$NC"
  printf '  %s║%s  %sL4XXYHOST%s  %s// NIGHTFALL COMMAND DECK%s                           %s║%s\n' "$DARK" "$NC" "$PALE$BOLD" "$NC" "$MUTED" "$NC" "$DARK" "$NC"
  printf '  %s║%s  %sMADE BY L4XXY%s  %s•  RED HORROR EDITION  •  EST. 2026%s             %s║%s\n' "$DARK" "$NC" "$GOLD$BOLD" "$NC" "$MUTED" "$NC" "$DARK" "$NC"
  printf '  %s╚══════════════════════════════════════════════════════════════════════╝%s\n' "$DARK" "$NC"
  printf '\n'
  printf '  %s┌─ SYSTEM STATUS ─────────────────────────────────────────────────────┐%s\n' "$RED" "$NC"
  printf '  %s│%s  %s● ONLINE%s    %sHOST%s %-18s  %sUPTIME%s %s\n' "$RED" "$NC" "$GREEN$BOLD" "$NC" "$MUTED" "$NC" "$(hostname)" "$MUTED" "$NC" "$UP"
  printf '  %s│%s  %sCPU%s %-5s  %sRAM%s %-5s  %sDISK%s %-6s                         %s│%s\n' "$RED" "$NC" "$PALE" "$NC" "${CPU}%" "$PALE" "$NC" "${RAM}%" "$GOLD" "$NC" "$DISK" "$RED" "$NC"
  printf '  %s└────────────────────────────────────────────────────────────────────┘%s\n' "$RED" "$NC"
  printf '\n'
  printf '  %s╭────────────────────── MAIN ACCESS ──────────────────────────────────╮%s\n' "$DARK" "$NC"
  printf '  %s│%s                                                                      %s│%s\n' "$DARK" "$NC" "$DARK" "$NC"
  printf '  %s│%s   %s[ 01 ]%s   %sTHEME & EXTENSION STUDIO%s                            %s│%s\n' "$DARK" "$NC" "$PALE$BOLD" "$NC" "$WHITE$BOLD" "$NC" "$DARK" "$NC"
  printf '  %s│%s            %sBlueprint  /  Themes  /  Extensions  /  Add-ons%s        %s│%s\n' "$DARK" "$NC" "$MUTED" "$NC" "$DARK" "$NC"
  printf '  %s│%s                                                                      %s│%s\n' "$DARK" "$NC" "$DARK" "$NC"
  printf '  %s│%s   %s[ 00 ]%s   %sEXIT CONTROL CENTER%s                                 %s│%s\n' "$DARK" "$NC" "$RED$BOLD" "$NC" "$MUTED" "$NC" "$DARK" "$NC"
  printf '  %s╰────────────────────────────────────────────────────────────────────╯%s\n' "$DARK" "$NC"
  printf '\n'
  printf '  %sL4XXYHOST%s %s»%s ' "$PALE$BOLD" "$NC" "$RED" "$NC"
  read -r choice || choice=0
  case "$choice" in
    1|01) launch_themes ;;
    0|00|q|quit|exit)
      printf '\n  %s[ SESSION CLOSED ]%s  %sMade by L4XXY.%s\n' "$RED$BOLD" "$NC" "$GOLD" "$NC"
      exit 0
      ;;
    *)
      printf '\n  %s[!] Invalid option. Enter 1 or 0.%s\n' "$RED" "$NC"
      sleep 1
      ;;
  esac
done
