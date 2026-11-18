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

printf '\nChecked %d shell scripts.\n' "$checked"
exit "$failed"
