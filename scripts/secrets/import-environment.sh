#!/bin/bash
# One-release migration bridge: import only the registry's six legacy variables.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$HERE/lib.sh"
replace=0
case "${1:-}" in --replace) replace=1; shift;; esac
[ "$#" -eq 0 ] || { echo "usage: import-environment.sh [--replace]" >&2; exit 2; }
while IFS=$'\t' read -r kind env_name _; do
  case "$kind" in ''|'#'*) continue;; esac
  [ -n "${!env_name:-}" ] || { echo "$kind: legacy environment absent; skipped"; continue; }
  target="$(secret_path "$kind")"
  if { [ -e "$target" ] || [ -L "$target" ]; } && [ "$replace" -ne 1 ]; then
    echo "$kind: file already present; use --replace to overwrite" >&2
    continue
  fi
  printf '%s' "${!env_name}" | "$HERE/set-key.sh" "$kind" --stdin --authorized-by "maintainer:environment-import"
done < "$GARDEN_SECRET_REGISTRY"
