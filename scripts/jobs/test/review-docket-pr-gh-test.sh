#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
HANDLER="$ROOT/scripts/jobs/handlers/review-docket-pr-gh.sh"
TEST_ROOT="$(mktemp -d "$ROOT/.review-docket-pr-gh-test.XXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT
fail() { echo "review-docket-pr-gh-test: FAIL: $*" >&2; exit 1; }

cat > "$TEST_ROOT/gh" <<'EOF'
#!/bin/bash
printf '%s\n' "$*" >> "$TEST_ROOT/calls"
if [ "$1 $2" = 'pr view' ]; then
  if printf ' %s' "$*" | grep -q 'statusCheckRollup'; then
    echo 'GraphQL: Resource not accessible by personal access token (repository.pullRequest.statusCheckRollup)' >&2
    exit 1
  fi
  cat <<'JSON'
{"headRefOid":"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa","state":"OPEN","latestReviews":[{"id":"R1","state":"CHANGES_REQUESTED","author":{"login":"kriskowal"},"submittedAt":"2026-10-16T13:00:00Z"}],"mergedAt":null,"closedAt":null}
JSON
  exit 0
fi
if [ "$1" = api ] && [[ "$2" == repos/example/repo/actions/runs\?head_sha=* ]]; then
  cat <<'JSON'
{"workflow_runs":[{"name":"test","status":"completed","conclusion":"success"}]}
JSON
  exit 0
fi
exit 99
EOF
chmod +x "$TEST_ROOT/gh"
export TEST_ROOT GARDEN_GH="$TEST_ROOT/gh"

out="$($HANDLER https://github.com/example/repo/pull/167)" \
  || fail 'GraphQL 403 did not fall back to the Actions runs endpoint'
[ "$(printf '%s' "$out" | jq -r .head_oid)" = aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa ] \
  || fail 'fallback lost the trusted head OID'
[ "$(printf '%s' "$out" | jq -r .state)" = OPEN ] \
  || fail 'fallback lost the trusted PR state'
[ "$(printf '%s' "$out" | jq -r '.reviews[0] | [.id,.state,.author,.submitted_at] | join("|")')" \
    = 'R1|CHANGES_REQUESTED|kriskowal|2026-10-16T13:00:00Z' ] \
  || fail 'fallback lost trusted review metadata'
[ "$(printf '%s' "$out" | jq -r .ci.state)" = green ] \
  || fail 'fallback did not derive green CI from the Actions run'
grep -q '^api repos/example/repo/actions/runs?head_sha=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa&per_page=100$' "$TEST_ROOT/calls" \
  || fail 'fallback did not query Actions runs for the preserved head'
[ "$(grep -c '^pr view ' "$TEST_ROOT/calls")" -eq 2 ] \
  || fail 'fallback did not isolate the forbidden rollup from the metadata read'

echo 'review-docket-pr-gh-test: PASS'
