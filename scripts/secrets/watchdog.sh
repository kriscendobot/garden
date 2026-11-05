#!/bin/bash
# Value-free age and unused-secret reminders. Never changes key material.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$HERE/lib.sh"
# shellcheck source=../jobs/common.sh
source "$HERE/../jobs/common.sh"
: "${GARDEN_SECRET_IDLE_DAYS:=30}"
now="$(date +%s)"

ledger="${GARDEN_SECRET_WATCHDOG_CLONE:-$GARDEN_STATE/secret-watchdog/journal}"
ledger_ready=0
if ensure_clone "$ledger" >/dev/null 2>&1 && sync_clone "$ledger" >/dev/null 2>&1; then ledger_ready=1; fi

while IFS=$'\t' read -r kind _ _ _ consumer _ _ default_max; do
  case "$kind" in ''|'#'*) continue;; esac
  if ! secret_available "$kind"; then
    alert_maintainer_clear "secret-age-$kind-$GARDEN" "secret age reminder cleared for $kind on $GARDEN"
    alert_maintainer_clear "secret-idle-$kind-$GARDEN" "secret idle reminder cleared for $kind on $GARDEN"
    alert_maintainer_clear "secret-unconsumed-$kind-$GARDEN" "unconsumed reminder cleared for $kind on $GARDEN"
    continue
  fi
  case "$consumer" in
    harness|direct) alert_maintainer_clear "secret-unconsumed-$kind-$GARDEN" "registered consumer is present for $kind on $GARDEN" ;;
    *)
      alert_maintainer_edge "secret-unconsumed-$kind-$GARDEN" "$consumer" \
        "$kind key on $GARDEN is installed but has no registered harness or direct consumer; revoke it at the provider before removing the host copy."
      continue ;;
  esac
  path="$(secret_path "$kind")"; placed="$(stat -c %Y "$path")"
  age=$(( (now - placed) / 86400 )); max="${GARDEN_SECRET_MAX_AGE_DAYS:-$default_max}"
  if [ "$age" -gt "$max" ]; then
    alert_maintainer_edge "secret-age-$kind-$GARDEN" "$placed:$age:$max" \
      "$kind key on $GARDEN was placed $(date -u -d "@$placed" +%F) and is $age days old (policy $max); rotate at the provider, then replace it with scripts/secrets/set-key.sh."
  else
    alert_maintainer_clear "secret-age-$kind-$GARDEN" "secret age is within policy for $kind on $GARDEN"
  fi
  [ "$ledger_ready" -eq 1 ] || continue
  newest="$(find "$ledger/outbound/$kind" -type f -name '*.json' -printf '%T@\n' 2>/dev/null | sort -nr | head -1 | cut -d. -f1)"
  idle=$(( (now - ${newest:-placed}) / 86400 ))
  if [ "$idle" -gt "$GARDEN_SECRET_IDLE_DAYS" ]; then
    alert_maintainer_edge "secret-idle-$kind-$GARDEN" "${newest:-none}:$idle:$consumer" \
      "$kind key on $GARDEN has no accepted outbound use for $idle days; revoke it at the provider before scripts/secrets/set-key.sh $kind --remove."
  else
    alert_maintainer_clear "secret-idle-$kind-$GARDEN" "secret use is current for $kind on $GARDEN"
  fi
done < "$GARDEN_SECRET_REGISTRY"
