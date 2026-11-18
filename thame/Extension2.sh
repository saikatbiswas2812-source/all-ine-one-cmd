#!/usr/bin/env bash
set -u

# L4xxyHost Extension Marketplace — responsive, paginated, read-only catalogue.
R=$'\033[31m'; G=$'\033[32m'; Y=$'\033[33m'; C=$'\033[36m'
M=$'\033[35m'; W=$'\033[97m'; D=$'\033[90m'; N=$'\033[0m'
BR=$'\033[1;31m'; BG=$'\033[1;32m'; BY=$'\033[1;33m'
BM=$'\033[1;35m'; BC=$'\033[1;36m'; BW=$'\033[1;97m'

selected_indices=()
page=0
page_size=20
name_width=22

names=(
"adminauditlogs.blueprint" "huxregister.blueprint" "loader.blueprint"
"lyrdyannounce.blueprint" "mclogs.blueprint" "mcplugins.blueprint"
"mctools.blueprint" "minecraftplayermanager.blueprint" "playerlisting.blueprint"
"resourcealerts.blueprint" "resourcemanager.blueprint" "serverbackgrounds.blueprint"
"serversplitter.blueprint" "simplefavicons.blueprint" "snowflakes.blueprint"
"sociallogin.blueprint" "startupchanger.blueprint" "subdomains.blueprint"
"tawkto.blueprint" "versionchanger.blueprint" "pteromonaco.blueprint"
"urldownloader.blueprint" "consolelogs.blueprint" "laravellogs.blueprint"
"vanillatweaks.blueprint" "modrinthbrowser.blueprint" "nopagination.blueprint"
"activitypurges.blueprint" "redirect.blueprint" "simplefooters.blueprint"
"paneladdressoverride.blueprint" "shownodeids.blueprint" "votifiertester.blueprint"
"sidebar.blueprint" "translations.blueprint" "monacoeditor.blueprint"
"minecraftpluginmanager.blueprint" "subdomainmanager.blueprint" "serverimporter.blueprint"
"pstatistics.blueprint" "pullfiles.blueprint" "serverpropsmanager.blueprint"
"motdmaker.blueprint" "servericonimporter.blueprint" "sagaautosuspension.blueprint"
"sagaminecraftmodpackinstaller.blueprint" "blueannoucements.blueprint" "trashbin.blueprint"
"eggchanger.blueprint" "mysqlautobackup.blueprint" "configeditor.blueprint"
"customserversort.blueprint" "databaseimportexport.blueprint" "minecraftmodmanager.blueprint"
"serverid.blueprint" "stats.blueprint" "vminfo.blueprint" "customcss.blueprint"
"autobackups.blueprint" "node.blueprint" "mcp.blueprint" "mcplayer.blueprint"
"pterodactylramburst.blueprint" "pterodactylpanelban.blueprint" "pterodactylcpuburst.blueprint"
)

term_cols() {
  local cols
  cols=$(tput cols 2>/dev/null || printf '100')
  [[ "$cols" =~ ^[0-9]+$ ]] || cols=100
  (( cols < 60 )) && cols=60
  (( cols > 110 )) && cols=110
  printf '%s' "$cols"
}

is_installed() {
  [[ -d "/var/www/pterodactyl/storage/extensions/${1%.blueprint}" ]]
}

is_selected() {
  local target=$1 item
  for item in " ${selected_indices[*]} "; do
    [[ "$item" -eq "$target" ]] && return 0
  done
  return 1
}

toggle_selected() {
  local target=$1 item
  if is_selected "$target"; then
    local next=()
    for item in " ${selected_indices[@]} "; do
      [[ "$item" -eq "$target" ]] || next+=("$item")
    done
    selected_indices=(" ${next[@]} ")
  else
    selected_indices+=("$target")
  fi
}

run_blueprint() {
  local name=$1 action=$2
  printf '\n%b[LOCKED]%b %s is disabled until its upstream source, checksum and panel compatibility are verified.\n' "$Y" "$N" " ${name%.blueprint}"
  printf '%bNo panel files, configuration or database records were changed.%b\n' "$D" "$N"
  return 2
}

draw_header() {
  local width=$1 inner=$((width - 4))
  local title="L4XXYHOST  /  EXTENSION MARKETPLACE"
  local subtitle="MADE BY L4XXY  •  BLUEPRINT ADD-ON CATALOGUE"
  printf '\n  %b+%*s+%b\n' "$M" "$inner" '' "$N"
  printf '  %b|%b %b%-*s%b %b|\n' "$M" "$N" "$BM" "$((inner - 2))" "$title" "$N" "$M"
  printf '  %b|%b %b%-*s%b %b|\n' "$M" "$N" "$BY" "$((inner - 2))" "$subtitle" "$N" "$M"
  printf '  %b+%*s+%b\n' "$M" "$inner" '' "$N"
}

show_item() {
  local index=$1 number=$((index + 1)) name=" ${names[$index]%.blueprint}" mark status
  if is_selected "$index"; then mark=" ${BY}◆${N}"; else mark=" ${D}◇${N}"; fi
  if is_installed "$name"; then status=" ${BG}●${N}"; else status=" ${R}○${N}"; fi
  printf '  %b %b%02d%b %-*.*s %b\n' "$mark" "$BC" "$number" "$N" "$name_width" "$name_width" "$name" "$status"
}

show_menu() {
  local width inner total installed=0 start end i pages left_count li ri
  width=$(term_cols); inner=$((width - 4)); total=${#names[@]}
  for ((i=0; i<total; i++)); do
    is_installed " ${names[$i]}" && ((installed+=1))
  done
  pages=$(((total + page_size - 1) / page_size))
  (( page >= pages )) && page=$((pages - 1))
  start=$((page * page_size)); end=$((start + page_size))
  (( end > total )) && end=$total
  name_width=$(((inner - 24) / 2))
  (( name_width < 12 )) && name_width=12
  (( name_width > 27 )) && name_width=27

  clear
  draw_header "$width"
  printf '  %bHOST%b %-18.18s  %bUSER%b %-10.10s  %bTIME%b %s\n' "$D" "$N" "$(hostname)" "$D" "$N" "$(whoami)" "$D" "$N" "$(date +'%H:%M')"
  printf '\n  %bTOTAL%b %s    %bINSTALLED%b %s    %bSELECTED%b %s\n' "$BC" "$N" "$total" "$BG" "$N" "$installed" "$BY" "$N" " ${#selected_indices[@]}"
  printf '  %b+%*s+%b\n' "$C" "$inner" '' "$N"
  printf '  %b|%b %bBROWSE EXTENSIONS%b  %bPage %d/%d — showing %d-%d of %d%b\n' "$C" "$N" "$BM" "$N" "$D" "$((page+1))" "$pages" "$((start+1))" "$end" "$total" "$N"
  printf '  %b+%*s+%b\n' "$C" "$inner" '' "$N"
  printf '\n'

  left_count=$(((end - start + 1) / 2))
  for ((i=0; i<left_count; i++)); do
    li=$((start + i)); ri=$((start + left_count + i))
    (( li < end )) && show_item "$li"
    (( ri < end )) && show_item "$ri"
  done

  printf '\n  %b●%b Installed   %b○%b Not detected   %b◆%b Selected   %bInstall/remove are locked pending audit.%b\n' "$G" "$N" "$R" "$N" "$Y" "$N" "$D" "$N"
  printf '\n  %b[n]%b Next page  %b[p]%b Previous  %b[a]%b Select page  %b[c]%b Clear selection\n' "$BC" "$N" "$BC" "$N" "$BC" "$N" "$BC" "$N"
  printf '  %b[i]%b Install locked  %b[r]%b Remove locked  %b[0]%b Back to Theme Studio\n\n' "$BG" "$N" "$BR" "$N" "$R" "$N"
}

while true; do
  show_menu
  read -r -p "$(printf '  %bL4XXYHOST ›%b ' "$BC" "$N")" choice || choice=0
  case "$choice" in
    0) printf '\n%bReturning to Theme Studio...%b\n' "$M" "$N"; exit 0 ;;
    n|N) (( (page + 1) * page_size < ${#names[@]} )) && ((page+=1)) ;;
    p|P) (( page > 0 )) && ((page-=1)) ;;
    c|C) selected_indices=() ;;
    a|A)
      local_start=$((page * page_size))
      local_end=$((local_start + page_size))
      (( local_end > ${#names[@]} )) && local_end=${#names[@]}
      for ((i=local_start; i<local_end; i++)); do is_selected "$i" || selected_indices+=("$i"); done
      ;;
    i|I|r|R)
      if [[ ${#selected_indices[@]} -eq 0 ]]; then
        printf '%bNothing selected.%b\n' "$R" "$N"; sleep 1; continue
      fi
      action=install; [[ "$choice" =~ ^[rR]$ ]] && action=remove
      for idx in " ${selected_indices[@]} "; do run_blueprint " ${names[$idx]}" "$action" || true; done
      selected_indices=()
      read -r -p "Press Enter to return..." _
      ;;
    *)
      for val in $choice; do
        if [[ "$val" =~ ^[0-9]+$ ]] && (( val >= 1 && val <= ${#names[@]} )); then
          toggle_selected "$((val - 1))"
        else
          printf '%bInvalid selection: %s%b\n' "$R" "$val" "$N"
        fi
      done
      ;;
  esac
done
