#!/bin/bash
# GARDEN_FETCH_CMD injection: fail a bounded number of calls, then really fetch.
set -eu

count=0
[ ! -f "$GARDEN_NUDGE_FETCH_FAIL_COUNT" ] || count="$(cat "$GARDEN_NUDGE_FETCH_FAIL_COUNT")"
count=$((count + 1))
printf '%s\n' "$count" > "$GARDEN_NUDGE_FETCH_FAIL_COUNT"
if [ "$count" -le "${GARDEN_NUDGE_FAIL_UNTIL:-1}" ]; then
  printf '%s\n' 'injected journal sync failure' >&2
  exit 1
fi
exec "$GARDEN_NUDGE_REAL_GIT" -C "$GARDEN_FETCH_DIR" fetch -q origin "${JOURNAL_BRANCH:-journal2}"
