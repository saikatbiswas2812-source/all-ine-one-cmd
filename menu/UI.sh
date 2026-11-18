#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
NC=$'\033[0m'; BOLD=$'\033[1m'
RED=$'\033[38;5;196m'; DARKRED=$'\033[38;5;88m'
PALE=$'\033[38;5;203m'; WHITE=$'\033[38;5;255m'
MUTED=$'\033[38;5;245m'; GREY=$'\033[38;5;238m'
GOLD=$'\033[38;5;220m'; GREEN=$'\033[38;5;82m'

metrics() {
  CPU="$(top -bn1 2>/dev/null | awk -F'[, ]+' '/Cpu\(s\)/ {for(i=1;i<=NF;i++) if($i ~ /id/) {v=$(i-1); printf "%d",100-v; exit}}' || true)"
  RAM="$(free 2>/dev/null | awk '/Mem:/ {if($2>0) printf "%d",($3/$2)*100}' || true)"
  DISK="$(df -h / 2>/dev/null | awk 'NR==2 {print $5}' || true)"
  UP="$(uptime -p 2>/dev/null | sed 's/^up //' || true)"
  CPU="${CPU:-?}"; RAM="${RAM:-?}"; DISK="${DISK:-?}"; UP="${UP:-unknown}"
}
pause() { printf '\n  %sPress Enter to return...%s' "$MUTED" "$NC"; read -r _ || true; }
launch_themes() {
  local file="$ROOT/thame/run.sh"
  if [[ -f "$file" ]]; then bash "$file"
  else printf '\n  %s[!] Theme & Extension module is missing.%s\n' "$RED" "$NC"; pause
  fi
}
get_width() {
  local cols
  cols="$(tput cols 2>/dev/null || printf '80')"
  [[ "$cols" =~ ^[0-9]+$ ]] || cols=80
  (( cols < 58 )) && cols=58
  (( cols > 92 )) && cols=92
  printf '%s' "$cols"
}
line() {
  local width=$1 char=$2
  printf '  %s' "$DARKRED"
  printf '%*s' "$((width - 4))" '' | tr ' ' "$char"
  printf '%s\n' "$NC"
}

while true; do
  metrics
  clear
  WIDTH="$(get_width)"
  INNER=$((WIDTH - 4))
  printf '\n'
  printf '  ${RED}╔'; printf '%*s' "$((INNER - 2))" '' | tr ' ' '═'; printf '╗${NC}\n'
  printf '  ${RED}║${NC}  ${PALE}☠  L4XXYHOST${NC}  ${WHITE}NIGHTFALL CONTROL${NC}  ${MUTED}// PRIVATE SERVER COMMAND${NC}%*s${RED}║${NC}\n' "$((INNER - 48))" ''
  printf '  ${RED}╠'; printf '%*s' "$((INNER - 2))" '' | tr ' ' '─'; printf '╣${NC}\n'
  printf '  ${RED}║${NC}  ${GOLD}MADE BY L4XXY${NC}  ${MUTED}•  EST. 2026  •  AUTHORIZED ACCESS ONLY${NC}%*s${RED}║${NC}\n' "$((INNER - 52))" ''
  printf '  ${RED}╚'; printf '%*s' "$((INNER - 2))" '' | tr ' ' '═'; printf '╝${NC}\n'

  printf '\n  ${PALE}▰ SYSTEM STATUS${NC}   ${GREEN}● ONLINE${NC}   ${MUTED}NODE${NC} ${WHITE}%s${NC}\n' "$(hostname)"
  printf '  ${MUTED}CPU${NC} ${PALE}%s%%${NC}   ${MUTED}RAM${NC} ${PALE}%s%%${NC}   ${MUTED}DISK${NC} ${GOLD}%s${NC}   ${MUTED}UPTIME${NC} ${WHITE}%s${NC}\n' "$CPU" "$RAM" "$DISK" "$UP"
  line "$WIDTH" '━'
  printf '  ${RED}✦ OPERATIONS${NC}  ${MUTED}// SELECT YOUR DESTINATION${NC}\n\n'

  printf '  ${DARKRED}╭'; printf '%*s' "$((INNER - 2))" '' | tr ' ' '─'; printf '╮${NC}\n'
  printf '  ${DARKRED}│${NC}  ${PALE}01${NC}  ${WHITE}THEME & EXTENSION CENTER${NC}%*s${DARKRED}│${NC}\n' "$((INNER - 33))" ''
  printf '  ${DARKRED}│${NC}      ${MUTED}Blueprint  •  Themes  •  Extensions  •  Add-ons${NC}%*s${DARKRED}│${NC}\n' "$((INNER - 55))" ''
  printf '  ${DARKRED}╰'; printf '%*s' "$((INNER - 2))" '' | tr ' ' '─'; printf '╯${NC}\n'

  printf '\n  ${GREY}╭'; printf '%*s' "$((INNER - 2))" '' | tr ' ' '─'; printf '╮${NC}\n'
  printf '  ${GREY}│${NC}  ${RED}[ 1 ]${NC}  ${WHITE}ENTER THE RED ROOM${NC}%*s${GREY}│${NC}\n' "$((INNER - 29))" ''
  printf '  ${GREY}│${NC}  ${RED}[ 0 ]${NC}  ${MUTED}EXIT CONTROL CENTER${NC}%*s${GREY}│${NC}\n' "$((INNER - 30))" ''
  printf '  ${GREY}╰'; printf '%*s' "$((INNER - 2))" '' | tr ' ' '─'; printf '╯${NC}\n'

  printf '\n  ${PALE}L4XXYHOST${NC} ${RED}›${NC} '
  read -r choice || choice=0
  case "$choice" in
    1) launch_themes ;;
    0|q|quit|exit)
      printf '\n  ${RED}☠ SESSION TERMINATED. THANK YOU FOR USING L4XXYHOST.${NC}\n'
      exit 0
      ;;
    *)
      printf '\n  ${RED}[!] Invalid selection. Choose 1 or 0.${NC}\n'
      sleep 1
      ;;
  esac
done
