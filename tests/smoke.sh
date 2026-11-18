#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
failed=0
checked=0

while IFS= read -r -d '' file; do
  checked=$((checked + 1))
  if bash -n "$file"; then
    printf '[PASS] %s\n' "${file#"$ROOT"/}"
  else
    printf '[FAIL] %s\n' "${file#"$ROOT"/}"
    failed=1
  fi
done < <(find "$ROOT" -type f -name '*.sh' -print0)

for required in menu/run.sh menu/UI.sh thame/run.sh thame/thames.sh thame/Extension2.sh install.sh; do
  if [[ ! -s "$ROOT/$required" ]]; then
    printf '[FAIL] Missing required entrypoint: %s\n' "$required"
    failed=1
  fi
done

if grep -nE 'bash[[:space:]]+<\([[:space:]]*curl|curl[^|]*\|[[:space:]]*(sudo[[:space:]]+)?bash' \
  "$ROOT/menu/run.sh" "$ROOT/menu/UI.sh" "$ROOT/thame/run.sh" "$ROOT/thame/thames.sh" "$ROOT/thame/Extension2.sh"; then
  printf '[FAIL] Remote script execution found in interactive entrypoints.\n'
  failed=1
else
  printf '[PASS] No curl-to-bash execution in interactive entrypoints.\n'
fi

if grep -q 'Hyper V1' "$ROOT/thame/run.sh"; then
  printf '[FAIL] Removed Hyper V1 option is still present.\n'
  failed=1
else
  printf '[PASS] Hyper V1 option is absent.\n'
fi

# Exercise parent -> child -> parent navigation with scripted input.
run_navigation_test() {
  local label="$1" input="$2" logfile="$3"
  if printf '%b' "$input" | TERM=xterm bash "$ROOT/thame/run.sh" >"$logfile" 2>&1; then
    printf '[PASS] %s navigation\n' "$label"
  else
    printf '[FAIL] %s navigation\n' "$label"
    cat "$logfile"
    failed=1
  fi
}
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
run_navigation_test "Theme gallery" '2\n0\n\n0\n' "$tmpdir/theme.log"
run_navigation_test "Extension marketplace" '3\n0\n\n0\n' "$tmpdir/extensions.log"
run_navigation_test "Blueprint framework submenu" '1\n0\n0\n' "$tmpdir/blueprint.log"


# Verify every catalogue entry has a bundled, structurally valid Blueprint archive.
if ! command -v unzip >/dev/null 2>&1; then
  printf '[FAIL] unzip is required to validate bundled Blueprint packages.\\n'
  failed=1
else
  mapfile -t theme_packages < <(sed -n '/^names=(/,/^)/p' "$ROOT/thame/thames.sh" | grep -oE '"[^"]+"' | tr -d '"')
  mapfile -t extension_packages < <(sed -n '/^names=(/,/^)/p' "$ROOT/thame/Extension2.sh" | grep -oE '"[^"]+\.blueprint"' | tr -d '"')
  declare -A seen_theme=() seen_extension=()
  for name in "${theme_packages[@]}"; do
    package="$ROOT/thame/UI/$name.blueprint"
    if [[ -n "${seen_theme[$name]:-}" ]]; then
      printf '[FAIL] Duplicate theme catalogue entry: %s\\n' "$name"
      failed=1
    fi
    seen_theme["$name"]=1
    if [[ ! -s "$package" ]] || ! unzip -tq "$package" >/dev/null 2>&1; then
      printf '[FAIL] Missing or invalid theme package: %s\\n' "$package"
      failed=1
    fi
  done
  for name in "${extension_packages[@]}"; do
    package="$ROOT/thame/Extension/$name"
    if [[ -n "${seen_extension[$name]:-}" ]]; then
      printf '[FAIL] Duplicate extension catalogue entry: %s\\n' "$name"
      failed=1
    fi
    seen_extension["$name"]=1
    if [[ ! -s "$package" ]] || ! unzip -tq "$package" >/dev/null 2>&1; then
      printf '[FAIL] Missing or invalid extension package: %s\\n' "$package"
      failed=1
    fi
  done
  printf '[INFO] Validated %d theme packages and %d extension packages.\\n' "${#theme_packages[@]}" "${#extension_packages[@]}"
fi

printf '\nChecked %d shell scripts.\n' "$checked"
exit "$failed"
