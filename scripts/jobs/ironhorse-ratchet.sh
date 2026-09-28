#!/bin/bash
# Revocable controls and one-step watcher transactions on journal2.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"
action="${1:?step|attest manifest|fail reason-file|status|seed|pause|resume|revoke reason-file}"; shift
journal="${GARDEN_RATCHET_CONTROL_CLONE:-$GARDEN_STATE/ratchet-control/journal}"
ensure_clone "$journal"
GARDEN_RATCHET_MODEL_TIER="$(model_dispatch_tier "$(worker_kind_field "${GARDEN_WORKER_KIND:-cleric}" provider)" "${GARDEN_JOB_MODEL:-unknown}" 2>/dev/null || true)"
export GARDEN_RATCHET_MODEL_TIER
for attempt in $(seq 1 50); do
  sync_clone "$journal"
  if [ "$action" = seed ]; then
    python3 "$HERE/ratchet/seed.py" "$journal"
  else
    outcome="$(python3 "$HERE/ratchet/driver.py" "$action" "$journal" "$@")"
    printf '%s\n' "$outcome"
  fi
  git -C "$journal" add -- config/delegations/ironhorse-test262-ratchet ratchets/ironhorse-test262-ratchet
  if [ -f "$journal/config/delegations/ironhorse-test262-ratchet.revoked" ]; then
    git -C "$journal" add -- config/delegations/ironhorse-test262-ratchet.revoked
  fi
  for notice in "$journal/inbox/maintainer/unread/ironhorse-ratchet-halted-"*.md; do
    [ -f "$notice" ] || continue
    git -C "$journal" add -- "${notice#"$journal/"}"
  done
  result=0
  commit_and_push "$journal" "ironhorse ratchet: $action" || result=$?
  if [ "$result" = 0 ] || [ "$result" = 2 ]; then
    clone_unlock "$journal"
    if [ "$action" = attest ] && jq -e '.action == "attested"' <<<"$outcome" >/dev/null; then
      "$HERE/ironhorse-ratchet.sh" conduct
    fi
    exit 0
  fi
  backoff "$attempt"
done
die 'could not commit Ironhorse ratchet state'
