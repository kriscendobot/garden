#!/bin/bash
# Fixture for classify-foreign-content-test.sh. Kept in-repo because /tmp is
# noexec. Captures the request body to CLASSIFY_TEST_REQUEST and answers with
# the canned response in CLASSIFY_TEST_RESPONSE (or fails with
# CLASSIFY_TEST_RC when set nonzero).
set -euo pipefail
: "${CLASSIFY_TEST_REQUEST:?}"
: "${CLASSIFY_TEST_RESPONSE:?}"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --data-binary)
      cp "${2#@}" "$CLASSIFY_TEST_REQUEST"
      shift 2
      ;;
    *) shift ;;
  esac
done
rc="${CLASSIFY_TEST_RC:-0}"
[ "$rc" -eq 0 ] || exit "$rc"
cat "$CLASSIFY_TEST_RESPONSE"
