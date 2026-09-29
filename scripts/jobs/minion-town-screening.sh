#!/bin/bash
# minion-town-screening.sh — operator control for the minion.town PR-screening
# delegation (designs/minion-town-pr-screening.md,
# context/operations/minion-town-screening.md).
#
# Usage: minion-town-screening.sh seed|pause [reason-file]|resume|revoke <reason-file>|status
#   seed    write the #139 authorization entry and the delegation record (the arming
#           act; a no-op when already seeded, refused after a revocation)
#   pause   stop screening and delegated merges (paused_by: maintainer; never auto-resumed)
#   resume  return a paused delegation to active
#   revoke  permanent tombstone config/delegations/minion-town-pr-screening.revoked
#   status  print the verdict and record without writing
# Mirrors ironhorse-ratchet.sh: its own journal clone, CAS pushes, and no git in the
# deployed root.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
action="${1:?usage: minion-town-screening.sh seed|pause [reason-file]|resume|revoke <reason-file>|status}"; shift
case "$action" in
  seed|pause|resume|revoke|status) ;;
  *) die "unknown action: $action" ;;
esac
[ "$action" != revoke ] || [ -s "${1:-}" ] || die 'revoke needs a non-empty reason file'
journal="${GARDEN_SCREEN_CONTROL_CLONE:-$GARDEN_STATE/screening-control/journal}"
ensure_clone "$journal"
for attempt in $(seq 1 50); do
  sync_clone "$journal"
  if [ "$action" = status ]; then
    python3 "$HERE/screening/control.py" status "$journal"
    clone_unlock "$journal"; exit 0
  fi
  python3 "$HERE/screening/control.py" "$action" "$journal" "$@" || { clone_unlock "$journal"; exit 1; }
  for path in config/delegations entries/2026/09/29; do
    [ -e "$journal/$path" ] && git -C "$journal" add -A -- "$path"
  done
  result=0
  commit_and_push "$journal" "minion.town screening: $action" || result=$?
  if [ "$result" = 0 ] || [ "$result" = 2 ]; then
    clone_unlock "$journal"; exit 0
  fi
  backoff "$attempt"
done
die 'could not commit minion.town screening state'
