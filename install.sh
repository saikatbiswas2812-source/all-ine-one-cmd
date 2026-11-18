#!/usr/bin/env bash
set -Eeuo pipefail

REPO="https://github.com/saikatbiswas2812-source/all-ine-one-cmd.git"
BRANCH="main"
INSTALL_DIR="${L4XXYHOST_DIR:-${HOME}/L4xxyHost}"

say() { printf '\n\033[1;36m[L4XXYHOST]\033[0m %s\n' "$*"; }
fail() { printf '\n\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; exit 1; }

say "Starting L4xxyHost setup..."

if ! command -v git >/dev/null 2>&1; then
  say "Git is missing; installing it..."
  if [[ "${EUID}" -eq 0 ]]; then
    apt-get update
    apt-get install -y git
  elif command -v sudo >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y git
  else
    fail "Git is required. Install git and run this command again."
  fi
fi

if [[ -d "$INSTALL_DIR/.git" ]]; then
  say "Existing L4xxyHost installation found. Updating..."
  git -C "$INSTALL_DIR" fetch origin "$BRANCH"
  git -C "$INSTALL_DIR" pull --ff-only origin "$BRANCH"
elif [[ -e "$INSTALL_DIR" ]]; then
  fail "$INSTALL_DIR already exists but is not a Git repository. Move it or set L4XXYHOST_DIR to another path."
else
  say "Downloading L4xxyHost from GitHub..."
  mkdir -p "$(dirname "$INSTALL_DIR")"
  git clone --branch "$BRANCH" --depth 1 "$REPO" "$INSTALL_DIR"
fi

[[ -f "$INSTALL_DIR/menu/run.sh" ]] || fail "Dashboard launcher is missing from the downloaded repository."
[[ -f "$INSTALL_DIR/menu/UI.sh" ]] || fail "Dashboard UI is missing from the downloaded repository."

say "Checking dashboard scripts..."
bash -n "$INSTALL_DIR/menu/run.sh"
bash -n "$INSTALL_DIR/menu/UI.sh"

say "Launching L4xxyHost..."
exec bash "$INSTALL_DIR/menu/run.sh"
