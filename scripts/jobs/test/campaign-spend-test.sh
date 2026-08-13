#!/bin/bash
# campaign-spend-test.sh — validate strict campaign-ledger parsing while allowing
# well-formed engagements that do not carry token accounting.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true
command -v jq >/dev/null 2>&1 || { echo "campaign-spend-test: jq absent, skipping"; exit 0; }

TR="$(mktemp -d "${TMPDIR:-/tmp}/campaign-spend.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
D="$TR/journal"
mkdir -p "$D/jobs/orch" "$D/usage"
cat > "$D/jobs/orch/campaign.md" <<'EOF'
---
children: child
budget_tokens: 1000
created_at: 2026-08-13T00:00:00Z
---
EOF

run() {
  GARDEN_CAMPAIGN_NOW=2026-08-13T23:00:00Z \
    GARDEN_CAMPAIGN_CALIBRATION_CUTOFF=2026-08-13T00:00:00Z \
    "$JOBS/campaign-spend.sh" --dir "$D" campaign
}

# A provider engagement with no token fields is still a real, countable row.
printf '%s\n' \
  '{"ts":"2026-08-13T01:00:00Z","source":"none","provider":"openai","outcome":"tada"}' \
  > "$D/usage/child.jsonl"
snapshot="$(run)"
if [ "$(jq -r '.spend_tokens' <<<"$snapshot")" = 0 ] \
  && [ "$(jq -r '.engagements' <<<"$snapshot")" = 1 ] \
  && [ "$(jq -r '.unmetered' <<<"$snapshot")" = 1 ]; then
  ok "an unmetered engagement is counted and contributes zero tokens"
else
  bad "unmetered engagement summary is wrong: $snapshot"
fi

# Both ways of declaring missing accounting are unmetered. Even valid token
# values are excluded when source=none; cache reads never count toward spend.
printf '%s\n' \
  '{"ts":"2026-08-13T01:00:00Z","source":"none","outcome":"tada"}' \
  '{"ts":"2026-08-13T02:00:00Z","source":"result","input_tokens":10,"output_tokens":5,"cache_creation_tokens":2,"cache_read_tokens":99,"total_cost_usd":1.25}' \
  '{"ts":"2026-08-13T03:00:00Z","source":"result","input_tokens":null,"output_tokens":null,"cache_creation_tokens":null,"cache_read_tokens":null}' \
  '{"ts":"2026-08-13T04:00:00Z","source":"none","input_tokens":500,"output_tokens":500,"cache_creation_tokens":500,"cache_read_tokens":500,"total_cost_usd":2}' \
  > "$D/usage/child.jsonl"
snapshot="$(run)"
if [ "$(jq -r '.spend_tokens' <<<"$snapshot")" = 17 ] \
  && [ "$(jq -r '.engagements' <<<"$snapshot")" = 4 ] \
  && [ "$(jq -r '.unmetered' <<<"$snapshot")" = 3 ] \
  && [ "$(jq -r '.notional_usd' <<<"$snapshot")" = 3.25 ]; then
  ok "a mixed ledger sums only metered tokens and reports all unmetered rows"
else
  bad "mixed ledger summary is wrong: $snapshot"
fi

expect_failure() {  # <name> <row> <diagnostic-pattern>
  local name="$1" row="$2" pattern="$3" output
  printf '%s\n' "$row" > "$D/usage/child.jsonl"
  if output="$(run 2>&1)"; then
    bad "$name was accepted: $output"
  elif grep -q "$pattern" <<<"$output"; then
    ok "$name is rejected"
  else
    bad "$name failed without the expected diagnostic: $output"
  fi
}

expect_failure "invalid JSON" '{not-json' 'malformed JSON'
expect_failure "non-object JSON" '[]' 'malformed JSON'
expect_failure "missing timestamp" '{"source":"none"}' 'missing a string ts'
expect_failure "non-string timestamp" '{"ts":42,"source":"none"}' 'missing a string ts'
expect_failure "invalid timestamp" '{"ts":"not-a-time","source":"none"}' 'invalid ts'

for field in input_tokens output_tokens cache_creation_tokens cache_read_tokens; do
  expect_failure "$field negative" \
    "{\"ts\":\"2026-08-13T01:00:00Z\",\"source\":\"none\",\"$field\":-1}" \
    'invalid token or cost accounting'
  expect_failure "$field fractional" \
    "{\"ts\":\"2026-08-13T01:00:00Z\",\"source\":\"none\",\"$field\":1.5}" \
    'invalid token or cost accounting'
  expect_failure "$field non-number" \
    "{\"ts\":\"2026-08-13T01:00:00Z\",\"source\":\"none\",\"$field\":\"1\"}" \
    'invalid token or cost accounting'
done

expect_failure "negative total cost" \
  '{"ts":"2026-08-13T01:00:00Z","source":"none","total_cost_usd":-0.01}' \
  'invalid token or cost accounting'
expect_failure "non-number total cost" \
  '{"ts":"2026-08-13T01:00:00Z","source":"none","total_cost_usd":"free"}' \
  'invalid token or cost accounting'

echo "campaign-spend-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
