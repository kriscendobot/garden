#!/bin/bash
# Fixture for classify-foreign-content-test.sh. Kept in-repo because /tmp is
# noexec. Captures the request body to CLASSIFY_TEST_REQUEST and answers with
# the canned response in CLASSIFY_TEST_RESPONSE. HTTP and curl-result sequences
# let the harness prove retry classification without touching the network.
set -euo pipefail
: "${CLASSIFY_TEST_REQUEST:?}"
: "${CLASSIFY_TEST_RESPONSE:?}"
output=""
write_out=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --data-binary)
      cp "${2#@}" "$CLASSIFY_TEST_REQUEST"
      shift 2
      ;;
    --output)
      output="$2"
      shift 2
      ;;
    --write-out)
      write_out="$2"
      shift 2
      ;;
    *) shift ;;
  esac
done

attempt=1
if [ -n "${CLASSIFY_TEST_ATTEMPT_FILE:-}" ]; then
  if [ -r "$CLASSIFY_TEST_ATTEMPT_FILE" ]; then
    attempt=$(( $(cat "$CLASSIFY_TEST_ATTEMPT_FILE") + 1 ))
  fi
  printf '%s\n' "$attempt" >"$CLASSIFY_TEST_ATTEMPT_FILE"
fi

sequence_item() { # comma-separated sequence, attempt; repeats the final item
  local sequence="$1" index="$2" item=""
  IFS=',' read -r -a items <<<"$sequence"
  if [ "$index" -gt "${#items[@]}" ]; then
    index="${#items[@]}"
  fi
  item="${items[$((index - 1))]}"
  printf '%s' "$item"
}

status="$(sequence_item "${CLASSIFY_TEST_HTTP_SEQUENCE:-${CLASSIFY_TEST_HTTP_STATUS:-200}}" "$attempt")"
rc="$(sequence_item "${CLASSIFY_TEST_RC_SEQUENCE:-${CLASSIFY_TEST_RC:-0}}" "$attempt")"
if [ -n "$output" ]; then
  cp "$CLASSIFY_TEST_RESPONSE" "$output"
else
  cat "$CLASSIFY_TEST_RESPONSE"
fi
[ -z "$write_out" ] || printf '%s' "$status"
exit "$rc"
