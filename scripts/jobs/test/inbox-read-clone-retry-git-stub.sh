#!/bin/bash
# Fail the first N clone invocations, then delegate to the real git. Used by
# run-test.sh to exercise inbox-read.sh's cold-clone retry without a network.
set -euo pipefail

if [ "${1:-}" = clone ]; then
  count=0
  [ ! -f "$GARDEN_INBOX_RETRY_COUNT" ] || count="$(cat "$GARDEN_INBOX_RETRY_COUNT")"
  count=$((count + 1))
  printf '%s\n' "$count" > "$GARDEN_INBOX_RETRY_COUNT"
  if [ "$count" -le "$GARDEN_INBOX_RETRY_FAILS" ]; then
    echo "fatal: injected transient clone failure $count" >&2
    exit 128
  fi
fi

exec "$GARDEN_INBOX_RETRY_REAL_GIT" "$@"
