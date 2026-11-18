#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
UI="$SCRIPT_DIR/UI.sh"

if [[ ! -f "$UI" ]]; then
  printf 'L4xxyHost: dashboard not found: %s\n' "$UI" >&2
  exit 1
fi

exec bash "$UI"
