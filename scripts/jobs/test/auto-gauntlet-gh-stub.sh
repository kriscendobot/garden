#!/bin/bash
set -euo pipefail
# Every invocation is recorded when GARDEN_GH_CALL_LOG is set, so a test can assert
# on what the hook did NOT do — notably that it never re-drafted a PR it had no
# business touching, which no amount of board inspection can show.
if [ -n "${GARDEN_GH_CALL_LOG:-}" ]; then printf '%s\n' "$*" >>"$GARDEN_GH_CALL_LOG"; fi
if [ "${1:-}" = pr ] && [ "${2:-}" = view ]; then
  if [ -n "${FAKE_PR_VIEW_ERROR:-}" ]; then
    printf '%s\n' "$FAKE_PR_VIEW_ERROR" >&2
    exit "${FAKE_PR_VIEW_STATUS:-1}"
  fi
  printf '%s\n' "${FAKE_PR_JSON:?}"
  exit 0
fi
exit 64
