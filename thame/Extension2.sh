#!/usr/bin/env bash
set -u

# ==========================================
# 🔐 BASIC PROTECTION
# ==========================================
# ==========================================
# 🎨 COLORS
# ==========================================
R="\e[31m"; G="\e[32m"; Y="\e[33m"
B="\e[31m"; M="\e[91m"; C="\e[36m"
W="\e[97m"; N="\e[0m"; D="\e[90m"
BR="\e[1;31m"; BG="\e[1;32m"; BY="\e[1;33m"
BM="\e[1;35m"; BC="\e[1;36m"; BW="\e[1;97m"

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
        if [[ ! -f "$panel/$NAME" ]]; then
            echo -e "${Y}[!] Package missing: $panel/$NAME${N}"
            echo -e "${D}Upload a verified .blueprint package into the Panel directory first.${N}"
            return 2
        fi
        (cd "$panel" && blueprint -install "$slug")
    else
        if ! is_installed "$slug"; then
            echo -e "${Y}[!] $slug is not installed.${N}"
            return 2
        fi
        read -r -p "Type REMOVE to uninstall $slug: " confirm
        [[ "$confirm" == "REMOVE" ]] || { echo "Cancelled."; return 2; }
        blueprint -remove "$slug"
    fi
}

get_title() { printf '✦ L4XXYHOST  /  EXTENSION MARKETPLACE'; }

# ==========================================
# 📋 MENU
# ==========================================
show_menu() {
    clear
    local total=${#names[@]} installed=0 i clean_name cols left right left_status right_status select_mark
    cols=$(tput cols 2>/dev/null || printf '80')
    [[ "$cols" =~ ^[0-9]+$ ]] || cols=80
    (( cols < 52 )) && cols=52

    for clean_name in "${names[@]}"; do
        clean_name="${clean_name%.blueprint}"
        is_installed "$clean_name" && ((installed+=1))
    done

    # Premium graphite / violet control-room layout.
    printf "\n  ${BM}◆  L4XXY${N}  ${BW}EXTENSION STUDIO${N}  ${D}/  ADD-ON MARKETPLACE${N}\n"
    printf "  ${D}MADE BY${N} ${BY}L4XXY${N}  ${D}•  SECURE PACKAGE CATALOGUE${N}\n"
    printf "  ${M}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}\n"
    printf "  ${D}HOST${N} ${W}%-14.14s${N}  ${D}USER${N} ${W}%-8.8s${N}  ${D}TIME${N} ${W}%s${N}\n" "$(hostname)" "$(whoami)" "$(date +'%H:%M')"

    printf "\n  ${BC}CATALOGUE${N}  ${BW}%02d${N}     ${BG}INSTALLED${N}  ${BG}%02d${N}     ${BM}SELECTED${N}  ${BY}%02d${N}\n" "$total" "$installed" "${#selected_indices[@]}"
    printf "  ${M}────────────────────────────────────────────────────────────────${N}\n"
    printf "  ${BW}✦  EXTENSION LIBRARY${N}  ${D}Choose add-ons by number${N}\n\n"

    if (( cols >= 96 )); then
        for ((i=0; i<total; i+=2)); do
            left="${names[$i]%.blueprint}"
            is_installed "$left" && left_status="${BG}●${N}" || left_status="${D}○${N}"
            is_selected "$i" && select_mark="${BY}◆${N}" || select_mark="${D}◇${N}"
            printf "  %b ${BC}%02d${N}  %-19.19s %b" "$select_mark" "$((i+1))" "$left" "$left_status"
            if (( i+1 < total )); then
                right="${names[$((i+1))]%.blueprint}"
                is_installed "$right" && right_status="${BG}●${N}" || right_status="${D}○${N}"
                is_selected "$((i+1))" && select_mark="${BY}◆${N}" || select_mark="${D}◇${N}"
                printf "    %b ${BC}%02d${N}  %-19.19s %b" "$select_mark" "$((i+2))" "$right" "$right_status"
            fi
            printf "\n"
        done
    else
        for ((i=0; i<total; i++)); do
            left="${names[$i]%.blueprint}"
            is_installed "$left" && left_status="${BG}●${N}" || left_status="${D}○${N}"
            is_selected "$i" && select_mark="${BY}◆${N}" || select_mark="${D}◇${N}"
            printf "  %b ${BC}%02d${N}  %-26.26s %b\n" "$select_mark" "$((i+1))" "$left" "$left_status"
        done
    fi

    printf "\n  ${M}────────────────────────────────────────────────────────────────${N}\n"
    printf "  ${BG}●${N} Installed   ${D}○${N} Available   ${BY}◆${N} Selected\n"
    printf "  ${Y}Install / Remove available when Panel, Blueprint and a verified package are present.${N}\n"
    printf "\n  ${BM}[i]${N} Install   ${BM}[r]${N} Remove   ${BC}[a]${N} Select all   ${BC}[c]${N} Clear   ${BR}[0]${N} Back\n"
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
