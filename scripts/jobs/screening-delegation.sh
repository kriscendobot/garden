#!/bin/bash
# Fresh journal read for the conductor's --screened-delegated-merge boundaries.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"
command="${1:?scope|merge}"; shift
journal="${GARDEN_SCREEN_DELEGATION_CLONE:-$GARDEN_STATE/screening-delegation/journal}"
ensure_clone "$journal"
sync_clone "$journal"
rc=0
python3 "$HERE/screening/policy.py" "$command" "$journal" "$@" || rc=$?
clone_unlock "$journal"
exit "$rc"
