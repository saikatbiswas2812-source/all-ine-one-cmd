#!/usr/bin/env bash
set -u

# ==========================================
# 🔐 BASIC PROTECTION
# ==========================================
# ==========================================
# 🎨 COLORS
# ==========================================
R="\e[31m"; G="\e[32m"; Y="\e[33m"
B="\e[34m"; M="\e[35m"; C="\e[36m"
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
    echo -e "${Y}[!] ${ACTION^} is temporarily disabled for ${NAME%.blueprint}.${N}"
    echo -e "${D}Third-party Blueprint packages have not yet passed source, checksum, and compatibility review.${N}"
    echo -e "${G}[i] No files, panel data, or database records were changed.${N}"
    return 2
}

get_title() { printf '✦ L4XXYHOST  /  EXTENSION MARKETPLACE'; }

# ==========================================
# 📋 MENU
# ==========================================
show_menu() {
    clear
    local total=${#names[@]} installed=0 count=0 i num clean_name status select_mark left right left_status right_status
    for clean_name in "${names[@]}"; do
        clean_name="${clean_name%.blueprint}"
        is_installed "$clean_name" && ((installed+=1))
    done

    echo -e "\n  ${M}╭────────────────────────────────────────────────────────╮${N}"
    echo -e "  ${M}│${N}                                                        ${M}│${N}"
    echo -e "  ${M}│${N}   ${BM}██╗     ██╗  ██╗  ██╗  ██╗  ██╗${N}                 ${M}│${N}"
    echo -e "  ${M}│${N}   ${BM}██║     ██║  ██║  ╚██╗██╔╝  ██║${N}                 ${M}│${N}"
    echo -e "  ${M}│${N}   ${BM}██║     ███████║   ╚███╔╝   ██║${N}                 ${M}│${N}"
    echo -e "  ${M}│${N}   ${BM}██║     ╚════██║   ██╔██╗   ╚═╝${N}                 ${M}│${N}"
    echo -e "  ${M}│${N}   ${BM}███████╗     ██║  ██╔╝ ██╗  ██╗${N}                 ${M}│${N}"
    echo -e "  ${M}│${N}   ${BM}╚══════╝     ╚═╝  ╚═╝  ╚═╝  ╚═╝${N}                 ${M}│${N}"
    printf "  ${M}│${N}   ${BY}%-44s${M}│${N}\n" "MADE BY L4XXY • EXTENSION MARKETPLACE"
    echo -e "   ${D}HOST${N} ${W}$(hostname)${N}  ${D}USER${N} ${W}$(whoami)${N}  ${D}TIME${N} ${W}$(date +'%H:%M')${N}"
    echo -e "\n  ${C}╭──────────────╮  ╭──────────────╮  ╭──────────────╮${N}"
    printf "  ${C}│${N} ${BC}TOTAL${N} ${BW}%-3s${N} ${C}│${N}  ${C}│${N} ${BG}INSTALLED${N} ${BG}%-2s${N} ${C}│${N}  ${C}│${N} ${BY}SELECTED${N} ${BM}%-2s${N} ${C}│${N}\n" "$total" "$installed" "${#selected_indices[@]}"
    echo -e "  ${C}╰──────────────╯  ╰──────────────╯  ╰──────────────╯${N}"
    echo -e "\n  ${M}╭────────────────────────────────────────────────────────╮${N}"
    echo -e "  ${M}│${N}  ${BM}✦ BROWSE EXTENSIONS${N}                                  ${M}│${N}"
    echo -e "  ${M}╰────────────────────────────────────────────────────────╯\n"

    for ((i=0; i<total; i+=2)); do
        left="${names[$i]%.blueprint}"
        is_installed "$left" && left_status="${BG}●${N}" || left_status="${R}○${N}"
        is_selected "$i" && select_mark="${BY}◆${N}" || select_mark="${D}◇${N}"
        printf "   %b ${BC}%02d${N}  %-22.22s %b" "$select_mark" "$((i+1))" "$left" "$left_status"
        if (( i+1 < total )); then
            right="${names[$((i+1))]%.blueprint}"
            is_installed "$right" && right_status="${BG}●${N}" || right_status="${R}○${N}"
            is_selected "$((i+1))" && select_mark="${BY}◆${N}" || select_mark="${D}◇${N}"
            printf "     %b ${BC}%02d${N}  %-22.22s %b" "$select_mark" "$((i+2))" "$right" "$right_status"
        fi
        printf "\n"
    done

    echo -e "\n  ${D}  ────────────────────────────────────────────────────${N}"
    echo -e "   ${BG}●${N} Installed  ${R}○${N} Available  ${BY}◆${N} Selected"
    echo -e "   ${Y}Install/Remove locked pending audit${N}"
    echo -e "\n  ${C}╭────────────────────────────────────────────────────────╮${N}"
    echo -e "  ${C}│${N} ${BG}[i]${N} INSTALL  ${BR}[r]${N} REMOVE  ${BM}[a]${N} ALL  ${BC}[c]${N} CLEAR  ${R}[0]${N} BACK ${C}│${N}"
    echo -e "  ${C}╰────────────────────────────────────────────────────────╯${N}"
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
