#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# L4xxyHost Nightfall red horror terminal palette
RED="\\033[38;5;196m"
GREEN="\033[38;5;120m"
YELLOW="\033[38;5;221m"
CYAN="\\033[38;5;203m"
MAGENTA="\\033[38;5;196m"
PURPLE="\\033[38;5;124m"
WHITE="\033[1;37m"
MUTED="\033[38;5;245m"
BOLD="\033[1m"
RESET="\033[0m"

draw_box() {
    echo -e "${PURPLE}╭──────────────────────────────────────────────────────────────────────╮${RESET}"
    echo -e "${PURPLE}│${RESET}                                                                      ${PURPLE}│${RESET}"
    echo -e "${PURPLE}│${RESET}   ${MAGENTA}${BOLD}✦ L4XXYHOST${RESET}   ${MUTED}/${RESET}   ${CYAN}${BOLD}THEME & EXTENSION STUDIO${RESET}                  ${PURPLE}│${RESET}"
    echo -e "${PURPLE}│${RESET}   ${YELLOW}MADE BY L4XXY${RESET}  ${MUTED}•  PREMIUM SERVER CUSTOMIZATION${RESET}             ${PURPLE}│${RESET}"
    echo -e "${PURPLE}│${RESET}                                                                      ${PURPLE}│${RESET}"
    echo -e "${PURPLE}╰──────────────────────────────────────────────────────────────────────╯${RESET}"
}

pause() {
    echo ""
    read -p "   Press Enter to continue..." dummy
}

install_blueprint() {
    local panel="/var/www/pterodactyl" major
    [[ -f "$panel/artisan" ]] || { status_msg ERROR "Pterodactyl Panel not found at $panel."; return 1; }
    [[ "$EUID" -eq 0 ]] || { status_msg ERROR "Run L4XXYHOST as root to install Blueprint."; return 1; }
    for cmd in curl wget unzip npm node; do
        command -v "$cmd" >/dev/null 2>&1 || { status_msg ERROR "Missing required command: $cmd"; return 1; }
    done
    major="$(node -p 'process.versions.node.split(".")[0]' 2>/dev/null || true)"
    [[ "$major" == "22" ]] || { status_msg ERROR "Official Blueprint guide specifies Node.js 22.x; detected $(node -v 2>/dev/null || echo unknown). Switch to Node 22.x first."; return 1; }

    if [[ ! -f "$panel/blueprint.sh" ]]; then
        status_msg INFO "Downloading official Blueprint release..."
        wget -q --show-progress "https://github.com/BlueprintFramework/framework/releases/latest/download/release.zip" -O "$panel/release.zip" || { status_msg ERROR "Blueprint download failed."; return 1; }
        unzip -oq "$panel/release.zip" -d "$panel" || { status_msg ERROR "Blueprint extraction failed."; return 1; }
    fi
    if ! command -v yarn >/dev/null 2>&1; then npm install --global yarn || return 1; fi
    if [[ ! -f "$panel/.blueprintrc" ]]; then
        printf '%s\n' 'WEBUSER="www-data";' 'OWNERSHIP="www-data:www-data";' 'USERSHELL="/bin/bash";' > "$panel/.blueprintrc"
    fi
    chown www-data:www-data "$panel/.blueprintrc"
    chmod +x "$panel/blueprint.sh"
    status_msg INFO "Installing Blueprint dependencies..."
    (cd "$panel" && yarn install) || return 1
    status_msg INFO "Running official Blueprint installer..."
    (cd "$panel" && bash ./blueprint.sh) || return 1
    command -v blueprint >/dev/null 2>&1 && status_msg OK "Blueprint CLI is installed." || { status_msg ERROR "Blueprint CLI was not detected after installation."; return 1; }
}

status_msg() {
    local type="$1"
    local msg="$2"
    case "$type" in
        INFO)  echo -e "${CYAN}[INFO]${RESET} $msg" ;;
        OK)    echo -e "${GREEN}[OK]${RESET} $msg" ;;
        ERROR) echo -e "${RED}[ERROR]${RESET} $msg" ;;
        *)     echo "$msg" ;;
    esac
}

while true; do
    clear

    # Check install every loop (fix)
    if command -v blueprint >/dev/null 2>&1; then
        status="${GREEN}● ONLINE${RESET}"
        installed=true
    else
        status="${RED}● OFFLINE${RESET}"
        installed=false
    fi

    draw_box
    echo ""
    echo -e "   ${GREEN}●${RESET} Blueprint Status : $status"
    echo -e "   ${MUTED}──────────────────────────────────────────────────────────────────────${RESET}"
    echo -e "   ${CYAN}${BOLD}01  FRAMEWORK${RESET}"
    echo -e "   ${YELLOW}[1]${RESET}  Blueprint Framework"
    echo ""
    echo -e "   ${MAGENTA}${BOLD}02  CUSTOMIZATION${RESET}"
    echo -e "   ${YELLOW}[2]${RESET}  Premium Themes"
    echo -e "   ${YELLOW}[3]${RESET}  Extensions & Add-ons"
    echo ""
    echo -e "   ${MUTED}──────────────────────────────────────────────────────────────────────${RESET}"
    echo -e "   ${RED}[0]${RESET}  Back to L4xxyHost"
    echo ""

    read -r -p "$(echo -e "   ${CYAN}${BOLD}L4XXYHOST ${MAGENTA}›${RESET} ")" main

    case $main in
        1)
            while true; do
                clear

                # Re-check inside submenu (important fix)
                if command -v blueprint >/dev/null 2>&1; then
                    status="${GREEN}● ONLINE${RESET}"
                    installed=true
                else
                    status="${RED}● OFFLINE${RESET}"
                    installed=false
                fi

                draw_box
                echo ""
                echo -e "   ${CYAN}${BOLD}BLUEPRINT FRAMEWORK${RESET}   ${MUTED}•  MANAGEMENT CONSOLE${RESET}"
                echo -e "   Framework status : $status"
                echo -e "   ${MUTED}──────────────────────────────────────────────────────────────────────${RESET}"
                echo ""

                if [ "$installed" = false ]; then
                    echo -e "   ${YELLOW}[1] Install  ${RESET}"
                    echo -e "   ${RED}[0] Back${RESET}"
                else
                    echo -e "   ${YELLOW}[1] Reinstall  ${RESET}"
                    echo -e "   ${YELLOW}[2] Update  ${RESET}"
                    echo -e "   ${CYAN}[3] Info${RESET}"
                    echo -e "   ${CYAN}[4] Version${RESET}"
                    echo -e "   ${RED}[5] Uninstall${RESET}"
                    echo -e "   ${RED}[0] Back${RESET}"
                fi

                echo ""
                read -p "   ➤ Select : " bp

                case $bp in
                    1)
                        install_blueprint
                        pause
                        ;;
                    2)
                        if command -v blueprint >/dev/null 2>&1; then
                            blueprint -update
                        else
                            echo -e "${RED}Blueprint CLI is not installed.${RESET}"
                        fi
                        pause
                        ;;
                    3)
                        blueprint -info
                        pause
                        ;;
                    4)
                        blueprint -version
                        pause
                        ;;
                    5)
                        if command -v blueprint >/dev/null 2>&1; then
                            echo -e "${YELLOW}This removes Blueprint framework files. Back up the Panel first.${RESET}"
                            read -r -p "Type REMOVE BLUEPRINT to confirm: " confirm
                            [[ "$confirm" == "REMOVE BLUEPRINT" ]] && blueprint -uninstall || echo "Cancelled."
                        else
                            echo -e "${RED}Blueprint CLI is not installed.${RESET}"
                        fi
                        pause
                        ;;
                    0)
                        break
                        ;;
                    *)
                        echo -e "${RED}Invalid option${RESET}"
                        sleep 1
                        ;;
                esac
            done
            ;;

        2)
            clear
            draw_box
            echo ""
            echo -e "${CYAN}Launching L4xxyHost Theme Gallery...${RESET}"
            bash "$ROOT/thame/thames.sh"
            pause
            ;;

        3)
            clear
            draw_box
            echo ""
            echo -e "${CYAN}Launching L4xxyHost Extensions...${RESET}"
            bash "$ROOT/thame/Extension2.sh"
            pause
            ;;


        0)
            clear
            echo -e "${RED}Exiting...${RESET}"
            exit
            ;;

        *)
            echo -e "${RED}Invalid option${RESET}"
            sleep 1
            ;;
    esac
done
