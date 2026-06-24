#!/bin/bash
# follow-up-stub.sh — deterministic follow-up handler for tests. For each REPORT
# block in the digest it emits the three autonomous action types directly,
# deriving names from the report base so re-processing never duplicates:
#   - a one-time job          fu-<base>-1
#   - a one-time future job   fu-<base>-2 (due in the past, so the scheduler fires it)
#   - a maintainer message    (a maintainer-judgment follow-up)
set -euo pipefail
digest="${1:?digest}"
JOBS="$(cd "$(dirname "$0")/.." && pwd)"
while IFS= read -r base; do
  [ -n "$base" ] || continue
  echo "weaver rebase follow-up for $base on endojs/endo-but-for-bots" | "$JOBS/post-job.sh" "fu-$base-1"
  echo "re-botany after rebase for $base" | "$JOBS/set-schedule-once.sh" "fu-$base-2" "2000-01-01T00:00:00Z"
  echo "confirm whether to continue $base before spending weaver effort" \
    | GARDEN_SENDER="liaison:follow-up" "$JOBS/inbox-send.sh" maintainer
done < <(sed -n 's/^===== REPORT \(.*\) =====$/\1/p' "$digest")
