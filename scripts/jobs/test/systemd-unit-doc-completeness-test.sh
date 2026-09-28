#!/bin/bash
# Fail when a shipped or rendered Garden systemd unit is absent from the operator inventory.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"
DOC="$ROOT/context/operations/systemd-units.md"
SYSTEMD="$ROOT/scripts/systemd"

fail=0
while IFS= read -r unit; do
  if ! grep -Fq "\`$unit\`" "$DOC"; then
    printf 'FAIL: systemd unit source is not documented: %s\n' "$unit" >&2
    fail=1
  fi
done < <(find "$SYSTEMD" -maxdepth 1 -type f \
  \( -name 'garden-*.service' -o -name 'garden-*.timer' -o -name 'garden-*.service.in' \) \
  -printf '%f\n' | LC_ALL=C sort)

# install-units.sh renders one service template for every registry kind. Source
# common.sh so this check follows the registry instead of copying its current set.
# shellcheck source=../common.sh
# ROOT is resolved at runtime from this file.
# shellcheck disable=SC1091
source "$ROOT/scripts/jobs/common.sh"
while IFS= read -r kind; do
  unit="$(worker_kind_field "$kind" unit).service"
  if ! grep -Fq "\`$unit\`" "$DOC"; then
    printf 'FAIL: rendered worker unit is not documented: %s\n' "$unit" >&2
    fail=1
  fi
done < <(worker_kinds)

if [ "$fail" -ne 0 ]; then
  exit 1
fi

printf 'PASS: all shipped and rendered Garden systemd units are documented\n'
