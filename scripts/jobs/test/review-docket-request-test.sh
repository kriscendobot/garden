#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
REQUEST="$ROOT/scripts/jobs/review-docket-request.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-review-docket-request-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

fail() { echo "review-docket-request-test: FAIL: $*" >&2; exit 1; }

cat > "$TR/core.sh" <<'CORE'
#!/bin/bash
set -euo pipefail
[ "$1" = upsert ]
[ "$2" = https://github.com/example/repo/pull/42 ]
jq -e '. == {schema:1, ask:"decide", source:"test-source", summary:"Test summary", arc:"alpha", milestone:"M1", unblocks:[{"kind":"job","ref":"next"}]}' "$3" >/dev/null
exit "${CORE_RC:?}"
CORE
chmod +x "$TR/core.sh"

run_request() {
  GARDEN_REVIEW_DOCKET_REQUEST_CORE="$TR/core.sh" CORE_RC="$1" \
    "$REQUEST" --url https://github.com/example/repo/pull/42 --ask decide \
      --source test-source --summary 'Test summary' --arc alpha --milestone M1 \
      --unblocks-json '[{"kind":"job","ref":"next"}]'
}

run_request 0 >"$TR/accepted.out" 2>"$TR/accepted.err" \
  || fail 'accepted intake did not return success'
[ ! -s "$TR/accepted.err" ] || fail 'accepted intake unexpectedly logged a deferral'

run_request 76 >"$TR/spooled.out" 2>"$TR/spooled.err" \
  || fail 'default spooled rc did not normalize to success'
grep -q 'durably spooled for deferred delivery (rc=76); accepting request' "$TR/spooled.err" \
  || fail 'default spooled rc did not log the deferred intake'

GARDEN_REVIEW_DOCKET_SPOOLED_RC=42 run_request 42 >"$TR/configured.out" 2>"$TR/configured.err" \
  || fail 'configured spooled rc did not normalize to success'
grep -q 'durably spooled for deferred delivery (rc=42); accepting request' "$TR/configured.err" \
  || fail 'configured spooled rc did not log the deferred intake'

rc=0
run_request 7 >"$TR/hard.out" 2>"$TR/hard.err" || rc=$?
[ "$rc" -eq 7 ] || fail "hard failure returned $rc instead of 7"
[ ! -s "$TR/hard.err" ] || fail 'hard failure was incorrectly logged as a deferral'

echo 'PASS: review-docket request accepts immediate and durably spooled intake and preserves hard failures'
