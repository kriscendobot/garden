#!/bin/bash
# bulletin-parked-stub.sh — deterministic parked-PR query stand-in for tests.
# Stands in for the real `gh search prs --review-requested kriskowal` query
# (GARDEN_BULLETIN_PARKED_CMD). Records that it was invoked — so the bulletin's
# gh-query throttle can be asserted (the continuous loop must NOT hit the API every
# tick) — then emits a fixed set of parked-PR rows as TSV:
#   repo <TAB> number <TAB> url <TAB> updatedAt <TAB> title
# one per open, non-draft PR awaiting kriskowal's review.
set -euo pipefail
[ -n "${GARDEN_BULLETIN_PARKED_CALLS:-}" ] && echo "called" >> "$GARDEN_BULLETIN_PARKED_CALLS"
printf '%s\t%s\t%s\t%s\t%s\n' "endojs/endo-but-for-bots" "513" \
  "https://github.com/endojs/endo-but-for-bots/pull/513" "2026-06-23T00:00:00Z" "Fix the thing"
printf '%s\t%s\t%s\t%s\t%s\n' "kriskowal/garden" "474" \
  "https://github.com/kriskowal/garden/pull/474" "2026-06-25T12:00:00Z" "Address review"
