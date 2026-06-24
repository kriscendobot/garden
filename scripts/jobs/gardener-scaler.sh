#!/bin/bash
# gardener-scaler.sh — reconcile this host's gardener pool to journal state.
#
# Usage: gardener-scaler.sh
#
# The journal's hosts/<host> file declares how many concurrent gardeners this
# host should run (its local concurrency limit). This timer-driven service —
# the sibling of repo-watcher, but for worker count rather than the watch set —
# syncs the journal and scales the local garden-gardener@N pool to match,
# starting missing instances and stopping extras. Absent or unparsable → 0.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="gardener-scaler"

DIR="${GARDEN_SCALER_CLONE:-$GARDEN_STATE/gardener-scaler/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

host="$GARDEN_HOST"
want=0
f="$DIR/hosts/$host"
if [ -f "$f" ]; then
  v="$(sed -n 's/^gardeners:[[:space:]]*//p' "$f" | head -1)"
  [[ "$v" =~ ^[0-9]+$ ]] && want="$v"
fi
log "host '$host' desired gardeners: $want"

# delegate the actual enable/disable to the installer's scale path (which uses
# the same mockable unit_ctl), keeping one place that knows how to scale.
"$HERE/install-units.sh" scale "$want"
