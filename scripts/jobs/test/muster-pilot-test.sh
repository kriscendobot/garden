#!/bin/bash
# muster-pilot-test.sh -- hermetic coverage for advisory TypeSafe muster labels.

set -euo pipefail
export GARDEN_TEST=1

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"
PILOT="$ROOT/scripts/jobs/muster-pilot.sh"
TEST_DIRECTORY="$(mktemp -d /tmp/garden-muster-pilot-test.XXXXXX)"
trap 'rm -rf "$TEST_DIRECTORY"' EXIT

PASS=0
FAIL=0
ok() { printf '  PASS: %s\n' "$*"; PASS=$((PASS + 1)); }
bad() { printf '  FAIL: %s\n' "$*"; FAIL=$((FAIL + 1)); }

messages="$TEST_DIRECTORY/messages.json"
jq -n '[
  {id:"approval-one.md", body:"Please approve example/repo pull request 7."},
  {id:"completion-two.md", body:"Work completed successfully."}
]' > "$messages"

fallback="$(env -u TYPESAFE_API_KEY "$PILOT" --messages-file "$messages")"
if grep -q 'continue muster with regular inference' <<<"$fallback"; then
  ok "missing credentials preserve the regular-inference fallback"
else
  bad "missing credentials did not identify the fallback"
fi

fake_curl="$HERE/muster-pilot-fake-curl.sh"

request="$TEST_DIRECTORY/request.json"
output="$(TYPESAFE_API_KEY=synthetic-test-key \
  MUSTER_TEST_REQUEST="$request" \
  GARDEN_MUSTER_PILOT_CURL="$fake_curl" \
  "$PILOT" --messages-file "$messages")"

if jq -e '
  .state.records[0].id == "approval-one.md" and
  (.questions | length == 6) and
  .questions.message_0_compaction.criteria.collapse_repeat and
  .questions.message_1_pattern.criteria.deploy_gap
' "$request" >/dev/null; then
  ok "request carries the batch and bounded compaction/classification questions"
else
  bad "request shape is incomplete"
fi

if grep -q 'approval_wait' <<<"$output" \
  && grep -q 'archive_if_verified_handled' <<<"$output" \
  && grep -q '123 input / 45 output tokens' <<<"$output"; then
  ok "typed answers and metered usage render for liaison review"
else
  bad "typed answer report is incomplete"
fi

if jq -e '.state.safety | contains("untrusted data")' "$request" >/dev/null; then
  ok "request preserves the untrusted-input boundary"
else
  bad "request omits the untrusted-input boundary"
fi

printf 'muster-pilot: %d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
