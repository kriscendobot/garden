#!/bin/bash
# Inject a bounded number of clone or fetch failures, then delegate to real git.
set -eu

op="${1:-}"
if [ "$op" = clone ] && [ -n "${GARDEN_NUDGE_CLONE_FAIL_COUNT:-}" ]; then
  count=0
  [ ! -f "$GARDEN_NUDGE_CLONE_FAIL_COUNT" ] || count="$(cat "$GARDEN_NUDGE_CLONE_FAIL_COUNT")"
  count=$((count + 1))
  printf '%s\n' "$count" > "$GARDEN_NUDGE_CLONE_FAIL_COUNT"
  if [ "$count" -le "${GARDEN_NUDGE_FAIL_UNTIL:-1}" ]; then
    printf '%s\n' 'injected clone failure' >&2
    exit 1
  fi
fi

exec "$GARDEN_NUDGE_REAL_GIT" "$@"
