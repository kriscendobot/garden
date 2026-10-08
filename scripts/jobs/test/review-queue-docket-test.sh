#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TEST_ROOT="$(mktemp -d "$ROOT/.review-queue-docket-test.XXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT
mkdir -p "$TEST_ROOT/bin" "$TEST_ROOT/state"

export GARDEN_REVIEW_QUEUE_ROWS="$TEST_ROOT/rows.json"
export GARDEN_DOCKET_SPY_LOG="$TEST_ROOT/docket.log"
: > "$GARDEN_DOCKET_SPY_LOG"
cat > "$TEST_ROOT/bin/gh" <<'EOF'
#!/bin/bash
set -euo pipefail
case "$1 $2" in
  'search prs') cat "$GARDEN_REVIEW_QUEUE_ROWS" ;;
  'repo view') printf 'false\n' ;;
  'api repos/example/repo/pulls/42') printf 'main\n' ;;
  *) echo "unexpected gh call: $*" >&2; exit 1 ;;
esac
EOF
chmod +x "$TEST_ROOT/bin/gh"

printf '%s\n' '[{"number":42,"repository":{"nameWithOwner":"example/repo"},"title":"Review | this `head`","url":"https://github.com/example/repo/pull/42","author":{"login":"alice"},"isDraft":false,"updatedAt":"2026-10-08T00:00:00Z"}]' > "$GARDEN_REVIEW_QUEUE_ROWS"
PATH="$TEST_ROOT/bin:$PATH" GARDEN_REVIEW_QUEUE_ONESHOT=1 \
  GARDEN_REVIEW_QUEUE_DOCKET="$ROOT/scripts/jobs/test/review-docket-request-spy.sh" \
  "$ROOT/skills/review-queue-poll/review-queue-poll.sh" "$TEST_ROOT/state" 1 >/dev/null
[ "$(wc -l < "$GARDEN_DOCKET_SPY_LOG")" -eq 1 ]
grep -q 'native-review-request-example-repo-pr42' "$GARDEN_DOCKET_SPY_LOG"

# An unchanged poll and a requested-reviewer REMOVE are not new intake and do
# not attempt retirement.
PATH="$TEST_ROOT/bin:$PATH" GARDEN_REVIEW_QUEUE_ONESHOT=1 \
  GARDEN_REVIEW_QUEUE_DOCKET="$ROOT/scripts/jobs/test/review-docket-request-spy.sh" \
  "$ROOT/skills/review-queue-poll/review-queue-poll.sh" "$TEST_ROOT/state" 1 >/dev/null
printf '[]\n' > "$GARDEN_REVIEW_QUEUE_ROWS"
PATH="$TEST_ROOT/bin:$PATH" GARDEN_REVIEW_QUEUE_ONESHOT=1 \
  GARDEN_REVIEW_QUEUE_DOCKET="$ROOT/scripts/jobs/test/review-docket-request-spy.sh" \
  "$ROOT/skills/review-queue-poll/review-queue-poll.sh" "$TEST_ROOT/state" 1 >/dev/null
[ "$(wc -l < "$GARDEN_DOCKET_SPY_LOG")" -eq 1 ]

# A failed ADD remains absent from current.json so the next successful poll
# retries it instead of silently treating the request as already imported.
rm -rf "$TEST_ROOT/state-retry"
mkdir -p "$TEST_ROOT/state-retry"
printf '%s\n' '[{"number":42,"repository":{"nameWithOwner":"example/repo"},"title":"retry me","url":"https://github.com/example/repo/pull/42","author":{"login":"alice"},"isDraft":false,"updatedAt":"2026-10-08T00:00:00Z"}]' > "$GARDEN_REVIEW_QUEUE_ROWS"
PATH="$TEST_ROOT/bin:$PATH" GARDEN_REVIEW_QUEUE_ONESHOT=1 GARDEN_REVIEW_QUEUE_DOCKET=/bin/false \
  "$ROOT/skills/review-queue-poll/review-queue-poll.sh" "$TEST_ROOT/state-retry" 1 >/dev/null 2>&1
[ "$(jq length "$TEST_ROOT/state-retry/current.json")" -eq 0 ]
PATH="$TEST_ROOT/bin:$PATH" GARDEN_REVIEW_QUEUE_ONESHOT=1 \
  GARDEN_REVIEW_QUEUE_DOCKET="$ROOT/scripts/jobs/test/review-docket-request-spy.sh" \
  "$ROOT/skills/review-queue-poll/review-queue-poll.sh" "$TEST_ROOT/state-retry" 1 >/dev/null
[ "$(wc -l < "$GARDEN_DOCKET_SPY_LOG")" -eq 2 ]

echo 'review-queue-docket-test: PASS'
