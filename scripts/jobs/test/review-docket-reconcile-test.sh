#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TEST_ROOT="$(mktemp -d "$ROOT/.review-docket-reconcile-test.XXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT

fail() { echo "review-docket-reconcile-test: FAIL: $*" >&2; exit 1; }

ln -s "$ROOT/scripts/jobs/review-docket-reconcile.sh" "$TEST_ROOT/review-docket-reconcile.sh"
cat > "$TEST_ROOT/common.sh" <<'EOF'
GARDEN_OFFLINE_RC="${GARDEN_OFFLINE_RC:-75}"
fleet_draining() { return 1; }
is_main_host() { return 0; }
api_cooldown_active() { return 1; }
log() { printf '%s\n' "$*" >&2; }
EOF
cat > "$TEST_ROOT/review-docket.sh" <<'EOF'
#!/bin/bash
[ "${1:-}" = reconcile ] || exit 99
echo "bounded reconcile will retry on its next tick (rc=${STUB_RC:-0})" >&2
exit "${STUB_RC:-0}"
EOF
chmod +x "$TEST_ROOT/review-docket.sh"

run() {
  local rc=0
  STUB_RC="$1" GARDEN_OFFLINE_RC="${2:-75}" \
    "$TEST_ROOT/review-docket-reconcile.sh" >"$TEST_ROOT/out" 2>"$TEST_ROOT/err" || rc=$?
  printf '%s\n' "$rc"
}

[ "$(run 0)" -eq 0 ] || fail 'a successful reconcile did not exit cleanly'
[ "$(run 75)" -eq 0 ] || fail 'GARDEN_OFFLINE_RC did not normalize to a clean timer exit'
grep -q 'bounded reconcile will retry on its next tick (rc=75)' "$TEST_ROOT/err" \
  || fail 'normalization discarded the reconcile retry log'
grep -q 'review-docket reconcile deferred (rc=75); the next timer tick will retry' "$TEST_ROOT/err" \
  || fail 'normalization did not log the timer retry'
[ "$(run 64 64)" -eq 0 ] || fail 'a custom GARDEN_OFFLINE_RC did not normalize cleanly'
[ "$(run 1)" -eq 1 ] || fail 'a non-transient reconcile failure was swallowed'

echo 'review-docket-reconcile-test: PASS'
