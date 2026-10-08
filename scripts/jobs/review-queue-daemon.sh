#!/bin/bash
# Resolve garden state for the legacy self-contained review queue poller.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"
exec "$GARDEN_ROOT/skills/review-queue-poll/review-queue-poll.sh" \
  "$GARDEN_STATE/review-queue" "${GARDEN_REVIEW_QUEUE_CADENCE:-120}"
