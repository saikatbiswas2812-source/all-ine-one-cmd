#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
C_CYAN=$'\033[1;36m'; C_PURPLE=$'\033[1;35m'; C_GREEN=$'\033[1;32m'
C_RED=$'\033[1;31m'; C_GRAY=$'\033[0;90m'; C_WHITE=$'\033[1;37m'; NC=$'\033[0m'

pause(){ read -r -p "Press Enter to return..." _; }
run_local(){
  local rel="$1" file="$ROOT/$1"
  if [[ -f "$file" ]]; then
    bash "$file"
  else
    printf "\n%s[!] Module unavailable: %s%s\n" "$C_RED" "$rel" "$NC"
    pause
  fi
}

metrics(){
  CPU="$(top -bn1 2>/dev/null | awk -F'[, ]+' '/Cpu\(s\)/ {for(i=1;i<=NF;i++) if($i ~ /id/) {v=$(i-1); printf "%d",100-v; exit}}' || true)"
  RAM="$(free 2>/dev/null | awk '/Mem:/ {if($2>0) printf "%d",($3/$2)*100}' || true)"
  DISK="$(df -h / 2>/dev/null | awk 'NR==2 {print $5}')"
  UP="$(uptime -p 2>/dev/null | sed 's/^up //' || true)"
  CPU="${CPU:-?}"; RAM="${RAM:-?}"; DISK="${DISK:-?}"; UP="${UP:-unknown}"
}

while true; do
  metrics
  clear
  printf "%s\n" "${C_PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
  printf "%s\n" "${C_PURPLE}║${NC}  ${C_CYAN}L4XXYHOST${NC}  ${C_GRAY}SERVER CONTROL CENTER${NC}                      ${C_PURPLE}║${NC}"
  printf "%s\n" "${C_PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
  printf "  Host: %s  Uptime: %s\n" "$(hostname)" "$UP"
  printf "  CPU: %s%%   RAM: %s%%   Root disk: %s\n\n" "$CPU" "$RAM" "$DISK"
  printf "%sDEPLOYMENT%s\n" "$C_CYAN" "$NC"
  printf "  %s1%s  VPS setup\n  %s2%s  Panel installers\n  %s3%s  Wings management\n" "$C_WHITE" "$NC" "$C_WHITE" "$NC" "$C_WHITE" "$NC"
  printf "\n%sTOOLS%s\n" "$C_PURPLE" "$NC"
  printf "  %s4%s  Toolbox\n  %s5%s  Themes and extensions\n  %s6%s  Extras\n" "$C_WHITE" "$NC" "$C_WHITE" "$NC" "$C_WHITE" "$NC"
  printf "\n  %s0%s  Exit\n\n" "$C_RED" "$NC"
  read -r -p "L4xxyHost > " choice
  case "$choice" in
    1) run_local "setup vm/menu.sh" ;;
    2) run_local "panel/1.sh" ;;
    3) run_local "wings/run.sh" ;;
    4) run_local "toolbox/run.sh" ;;
    5) run_local "thame/run.sh" ;;
    6) run_local "Extras/run.sh" ;;
    0|q|quit|exit) echo "Goodbye from L4xxyHost."; exit 0 ;;
    *) printf "%sInvalid option.%s\n" "$C_RED" "$NC"; sleep 1 ;;
  esac
done
