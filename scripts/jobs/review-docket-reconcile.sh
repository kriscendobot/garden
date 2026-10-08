#!/bin/bash
# Leader-only periodic recovery for missed review, terminal, head, and CI events.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"
export GARDEN_TAG="review-docket-reconcile"
fleet_draining && exit 0
is_main_host || { log "not the leader host; skipping review-docket reconcile"; exit 0; }
api_cooldown_active && exit 0
exec "$HERE/review-docket.sh" reconcile
