#!/bin/bash
# Fresh journal read for handler admission and both conductor boundaries.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"
command="${1:?active|job|scope|merge}"; shift
journal="${GARDEN_RATCHET_CLONE:-$GARDEN_STATE/ratchet-delegation/journal}"
ensure_clone "$journal"
sync_clone "$journal"
python3 "$HERE/ratchet/policy.py" "$command" "$journal" "$@"
