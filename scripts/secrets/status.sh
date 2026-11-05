#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$HERE/lib.sh"
now="$(date +%s)"
while IFS=$'\t' read -r kind _ _ _ _ _ _ max_age; do
  case "$kind" in ''|'#'*) continue;; esac
  path="$(secret_path "$kind")"
  if [ ! -e "$path" ]; then
    printf '%s\tabsent\tinvalid\tage_days=-\tmax_age_days=%s\n' "$kind" "$max_age"
    continue
  fi
  if secret_available "$kind"; then validity=valid; else validity=invalid; fi
  mtime="$(stat -c %Y "$path" 2>/dev/null || echo "$now")"
  printf '%s\tpresent\t%s\tage_days=%s\tmax_age_days=%s\n' "$kind" "$validity" "$(( (now - mtime) / 86400 ))" "${GARDEN_SECRET_MAX_AGE_DAYS:-$max_age}"
done < "$GARDEN_SECRET_REGISTRY"
