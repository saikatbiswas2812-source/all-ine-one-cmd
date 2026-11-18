#!/usr/bin/env bash
set -u

# ==========================================
# 🔐 BASIC PROTECTION
# ==========================================
# ==========================================
# 🎨 COLORS
# ==========================================
# L4XXYHOST signature palette — obsidian, ruby, frost and muted silver.
R=$'\033[38;5;196m'; G=$'\033[38;5;114m'; Y=$'\033[38;5;221m'
B=$'\033[38;5;203m'; M=$'\033[38;5;197m'; C=$'\033[38;5;159m'
W=$'\033[38;5;255m'; N=$'\033[0m'; D=$'\033[38;5;244m'
BR=$'\033[1;38;5;196m'; BG=$'\033[1;38;5;114m'; BY=$'\033[1;38;5;221m'
BM=$'\033[1;38;5;197m'; BC=$'\033[1;38;5;159m'; BW=$'\033[1;97m'
URL="https://github.com/nobita329/Nobita-Cloud/raw/refs/heads/main/thame/Extension"
selected_indices=()

trap 'echo -e "\n${R}[!] Force exit detected.${N}"; exit 1' SIGINT

# ==========================================
# 🧠 BLUEPRINT LIST
# ==========================================
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
"eggchanger.blueprint" "mysqlautobackup.blueprint" "configeditor.blueprint" "customserversort.blueprint" "databaseimportexport.blueprint"
"minecraftmodmanager.blueprint" "serverid.blueprint" "stats.blueprint" "vminfo.blueprint" "customcss.blueprint" "autobackups.blueprint" "node.blueprint" "mcp.blueprint"
"mcplayer.blueprint" "pterodactylramburst.blueprint"
"pterodactylpanelban.blueprint"
"pterodactylcpuburst.blueprint"
)

# ==========================================
# 🔍 HELPERS
# ==========================================
is_installed() {
    [[ -d "/var/www/pterodactyl/storage/extensions/${1%.blueprint}" ]] && return 0 || return 1
}

is_selected() {
    local index=$1
    [[ " ${selected_indices[*]} " =~ " $index " ]] && return 0 || return 1
}

run_blueprint() {
    local NAME="$1"
    local ACTION="$2"
    local panel="/var/www/pterodactyl"
    local slug="${NAME%.blueprint}"
    if [[ ! -f "$panel/artisan" ]]; then
        echo -e "${R}[!] Pterodactyl Panel is not installed. Install it first.${N}"
        return 2
    fi
    if ! command -v blueprint >/dev/null 2>&1; then
        echo -e "${Y}[!] Blueprint CLI is not installed. Install Blueprint Framework first.${N}"
        return 2
    fi
    if [[ "$ACTION" == "install" ]]; then
        bundled_package="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/Extension/$NAME"
        if [[ ! -f "$panel/$NAME" && -f "$bundled_package" ]]; then
            if unzip -tq "$bundled_package" >/dev/null 2>&1; then
                cp -- "$bundled_package" "$panel/$NAME"
                echo -e "${G}[+] Using bundled extension package: $bundled_package${N}"
            else
                echo -e "${R}[!] Bundled extension package failed ZIP integrity check.${N}"
                return 2
            fi
        fi
        if [[ ! -f "$panel/$NAME" ]]; then
            echo -e "${Y}[!] Package missing: $panel/$NAME${N}"
            echo -e "${D}Checking common upload folders (/root, /home, /tmp)...${N}"
            found="$(find /root /home /tmp -type f -name "$NAME" -print -quit 2>/dev/null || true)"
            if [[ -n "$found" ]] && unzip -tq "$found" >/dev/null 2>&1; then
                cp -- "$found" "$panel/$NAME"
                echo -e "${G}[+] Found and verified package: $found${N}"
            else
                echo -e "${Y}Upload the official $NAME file using SFTP to /root/$NAME, then retry.${N}"
                read -r -p "Package file path (blank to cancel): " source_file
                [[ -n "$source_file" && -f "$source_file" ]] || { echo "Cancelled."; return 2; }
                unzip -tq "$source_file" >/dev/null 2>&1 || { echo -e "${R}[!] Invalid Blueprint ZIP package.${N}"; return 2; }
                cp -- "$source_file" "$panel/$NAME"
            fi
        fi
        (cd "$panel" && blueprint -install "$slug")
    else
        if ! is_installed "$slug"; then
            echo -e "${Y}[!] $slug is not installed.${N}"
            return 2
        fi
        # Direct removal: skip both the marketplace and Blueprint confirmation prompts.
        USER_CONFIRMED_REMOVAL=yes blueprint -remove "$slug"
    fi
}

get_title() { printf 'L4XXYHOST / BLACK LABEL EXTENSION VAULT'; }

# Draw a compact, responsive marketplace. No external UI dependencies.
show_menu() {
    clear
    local total=${#names[@]} installed=0 i clean_name cols width inner colw
    local left right left_status right_status left_mark right_mark
    cols=$(tput cols 2>/dev/null || printf '80')
    [[ "$cols" =~ ^[0-9]+$ ]] || cols=80
    (( cols < 60 )) && cols=60
    width=$(( cols - 4 ))
    (( width > 104 )) && width=104
    inner=$(( width - 2 ))
    colw=$(( inner / 2 ))

    for clean_name in "${names[@]}"; do
        clean_name="${clean_name%.blueprint}"
        is_installed "$clean_name" && ((installed+=1))
    done

    printf '\n  %s╭%*s╮%s\n' "$M" "$inner" '' "$N" | sed "s/ /━/g"
    printf '  %s┃%s  %sL4XXYHOST%s  %s/ /%s  %sTHE EXTENSION VAULT%s%*s%s┃%s\n' "$M" "$N" "$BW" "$N" "$D" "$N" "$BM" "$N" "$((inner-39))" '' "$M" "$N"
    printf '  %s┃%s  %sBLACK LABEL%s  %s◆%s  %sBLUEPRINT ECOSYSTEM%s%*s%s┃%s\n' "$M" "$N" "$BY" "$N" "$M" "$N" "$D" "$N" "$((inner-43))" '' "$M" "$N"
    printf '  %s╰%*s╯%s\n' "$M" "$inner" '' "$N" | sed "s/ /━/g"

    printf '\n  %sSYSTEM%s  %s%s%s   %sOPERATOR%s  %s%s%s   %sTIME%s  %s%s%s\n' "$D" "$N" "$BW" "$(hostname)" "$N" "$D" "$N" "$BC" "$(whoami)" "$N" "$D" "$N" "$BW" "$(date +'%H:%M')" "$N"
    printf '\n  %s╭%*s╮%s\n' "$D" "$inner" '' "$N" | sed "s/ /─/g"
    printf '  %s│%s  %sLIBRARY %s%02d%s  %s│%s  %sINSTALLED %s%02d%s  %s│%s  %sSELECTED %s%02d%s  %s│%s\n' \
      "$D" "$N" "$BC" "$BW" "$total" "$N" "$D" "$N" "$BG" "$BW" "$installed" "$N" "$D" "$N" "$BY" "$BW" "${#selected_indices[@]}" "$N" "$D" "$N"
    printf '  %s╰%*s╯%s\n' "$D" "$inner" '' "$N" | sed "s/ /─/g"

    printf '\n  %s01%s  %sAVAILABLE EXTENSIONS%s  %s/  SELECT PACKAGES BY ID%s\n' "$BR" "$N" "$BW" "$N" "$D" "$N"
    printf '  %sChoose one or more packages. Installed items are marked in green.%s\n\n' "$D" "$N"

    for ((i=0; i<total; i+=2)); do
        left="${names[$i]%.blueprint}"
        is_installed "$left" && left_status="${BG}● INSTALLED${N}" || left_status="${D}○ AVAILABLE${N}"
        is_selected "$i" && left_mark="${BY}◆${N}" || left_mark="${D}›${N}"
        printf '  %b %s%02d%s  %-*.*s  %b' "$left_mark" "$BC" "$((i+1))" "$N" "$((colw-22))" "$((colw-22))" "$left" "$left_status"
        if (( i+1 < total )); then
            right="${names[$((i+1))]%.blueprint}"
            is_installed "$right" && right_status="${BG}● INSTALLED${N}" || right_status="${D}○ AVAILABLE${N}"
            is_selected "$((i+1))" && right_mark="${BY}◆${N}" || right_mark="${D}›${N}"
            printf '   %b %s%02d%s  %-*.*s  %b' "$right_mark" "$BC" "$((i+2))" "$N" "$((colw-22))" "$((colw-22))" "$right" "$right_status"
        fi
        printf '\n'
    done

    printf '\n  %s╭%*s╮%s\n' "$M" "$inner" '' "$N" | sed "s/ /━/g"
    printf '  %s┃%s  %b Installed%s   %b Available%s   %b Selected%s%*s%s┃%s\n' "$M" "$N" "$BG●" "$N" "$D○" "$N" "$BY◆" "$N" "$((inner-42))" '' "$M" "$N"
    printf '  %s╰%*s╯%s\n' "$M" "$inner" '' "$N" | sed "s/ /━/g"
    printf '\n  %s[I]%s INSTALL   %s[R]%s REMOVE   %s[A]%s SELECT ALL   %s[C]%s CLEAR   %s[0]%s BACK\n' "$BR" "$N" "$BR" "$N" "$BC" "$N" "$BC" "$N" "$D" "$N"
    printf '  %sL4XXYHOST%s %s›%s ' "$BC" "$N" "$BM" "$N"
}
# 🔁 MAIN LOOP
# ==========================================
while true; do
    show_menu
    read -r -p "$(echo -e "  ${BC}L4XXYHOST ${BM}›${N} Select IDs or action: ")" choice

    case $choice in
        0) echo -e "\n${M} Returning to Theme Studio...${N}"; exit 0 ;;
        c|C) selected_indices=() ;;
        a|A) 
            selected_indices=()
            for i in "${!names[@]}"; do
                selected_indices+=("$i")
            done
            ;;
        i|I|r|R)
            if [[ ${#selected_indices[@]} -eq 0 ]]; then
                echo -e "${R}Nothing selected!${N}"; sleep 1; continue
            fi
            action_type="install"
            [[ "$choice" =~ [rR] ]] && action_type="remove"
            
            for idx in "${selected_indices[@]}"; do
                run_blueprint "${names[$idx]}" "$action_type"
            done
            selected_indices=()
            echo ""
            read -p "Done. Press Enter to return..."
            ;;
        *)
            # Multi-select toggle logic (supports space-separated numbers like "1 4 12")
            for val in $choice; do
                if [[ "$val" =~ ^[0-9]+$ ]] && (( val >= 1 && val <= ${#names[@]} )); then
                    idx=$((val-1))
                    if is_selected "$idx"; then
                        # Remove from array
                        for i in "${!selected_indices[@]}"; do
                            if [[ ${selected_indices[i]} -eq $idx ]]; then
                                unset 'selected_indices[i]'
                            fi
                        done
                        selected_indices=("${selected_indices[@]}") # Re-index array
                    else
                        selected_indices+=("$idx")
                    fi
                else
                    echo -e "${R}Invalid option: $val${N}"; sleep 0.5
                fi
            done
            ;;
    esac
done
