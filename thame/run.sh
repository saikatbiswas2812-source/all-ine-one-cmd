#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# L4xxyHost premium purple / rose terminal palette
RED="\033[38;5;203m"
GREEN="\033[38;5;120m"
YELLOW="\033[38;5;221m"
CYAN="\033[38;5;81m"
MAGENTA="\033[38;5;213m"
PURPLE="\033[38;5;141m"
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
                    echo -e "   ${GREEN}[1] Install${RESET}"
                    echo -e "   ${RED}[0] Back${RESET}"
                else
                    echo -e "   ${GREEN}[1] Reinstall${RESET}"
                    echo -e "   ${GREEN}[2] Update${RESET}"
                    echo -e "   ${GREEN}[3] Info${RESET}"
                    echo -e "   ${GREEN}[4] Version${RESET}"
                    echo -e "   ${RED}[5] Uninstall${RESET}"
                    echo -e "   ${RED}[0] Back${RESET}"
                fi

                echo ""
                read -p "   ➤ Select : " bp

                case $bp in
                    1)
                        echo -e "${YELLOW}Blueprint install/reinstall is temporarily disabled pending package verification.${RESET}"
                        echo -e "${MUTED}No remote installer will be executed from this menu.${RESET}"
                        pause
                        ;;
                    2)
                        echo -e "${YELLOW}Blueprint updates are temporarily disabled pending upstream package verification.${RESET}"
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
                        echo -e "${RED}Blueprint uninstall is disabled to protect panel files, extensions, and database data.${RESET}"
                        echo -e "${MUTED}No files, services, or databases were changed.${RESET}"
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
