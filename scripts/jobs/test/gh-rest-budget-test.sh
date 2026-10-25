#!/bin/bash
# gh-rest-budget-test.sh — guard the host-wide REST core admission budget
# (common.sh _gh_rest_budget_* / gh_rest_budget_defer, wired into _gh_api_admit).
#
# Regression: admission learned of GitHub's primary REST quota only from a refusal,
# so every low-priority sweep spent from the same bucket until the comment watcher
# ran it dry (2026-10-24 14:27:38) and the whole host then sat out a blind hour.
# The budget samples `gh api rate_limit`, charges admitted REST attempts against
# the sample, defers low-priority watcher ticks at the reserve, latches a sampled
# zero until the sampled reset, and falls back to the refusal latch whenever the
# metadata is unavailable. GraphQL stays unmetered.
#
# Usage: gh-rest-budget-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
export GARDEN_BACKOFF_BASE_MS=0 GARDEN_BACKOFF_CAP_MS=0 GARDEN_API_COOLDOWN_SECS=300

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-restbudget.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
export GARDEN_API_COOLDOWN_DIR="$TR/gh-api-cooldown"
CALLS="$TR/calls"

# Stub gh: `api rate_limit` prints $RL_OUT (or fails when RL_FAIL=1); any other
# call fails with the primary-quota refusal when API_PRIMARY=1, else prints {}.
cat >"$TR/gh" <<'STUB'
#!/bin/bash
printf '%s\n' "$*" >>"$CALLS"
if [ "${2:-}" = rate_limit ]; then
  [ "${RL_FAIL:-0}" = 1 ] && { echo "gh: HTTP 502" >&2; exit 1; }
  printf '%s\n' "$RL_OUT"; exit 0
fi
if [ "${API_PRIMARY:-0}" = 1 ]; then
  echo "gh: API rate limit exceeded for user ID 1. (HTTP 403)" >&2; exit 1
fi
echo '{}'
STUB
chmod +x "$TR/gh"
export GARDEN_GH="$TR/gh" CALLS

# shellcheck source=../common.sh
source "$JOBS/common.sh"

reset_state() {
  rm -rf "$GARDEN_API_COOLDOWN_DIR"; : >"$CALLS"
  export RL_FAIL=0 API_PRIMARY=0
}
calls_matching() { grep -c -- "$1" "$CALLS" 2>/dev/null || true; }
field() { sed -n '1p' "$GARDEN_API_COOLDOWN_DIR/rest-budget" | awk -v i="$1" '{print $i}'; }
now() { date +%s; }

# ============================================================================
hr; echo "SUBTEST 1 — off by default under GARDEN_TEST: no rate_limit call, no state"; hr
reset_state; unset GARDEN_GH_REST_BUDGET
export RL_OUT="5000 100 $(( $(now) + 600 ))"
gh_rest_budget_defer t && bad "defer fired while the budget is disabled" || ok "disabled budget never defers"
gh_api_retry "repos/o/r/pulls" >/dev/null || bad "REST call refused with the budget disabled"
[ "$(calls_matching rate_limit)" = 0 ] && ok "no rate_limit sample while disabled" || bad "rate_limit sampled while disabled"
[ ! -e "$GARDEN_API_COOLDOWN_DIR/rest-budget" ] && ok "no budget state while disabled" || bad "budget state written while disabled"

export GARDEN_GH_REST_BUDGET=1

# ============================================================================
hr; echo "SUBTEST 2 — healthy sample: admitted REST calls are charged; refresh throttled"; hr
reset_state; export RL_OUT="5000 4000 $(( $(now) + 600 ))"
gh_rest_budget_defer t && bad "deferred with 4000/5000 left" || ok "4000/5000 left → proceed"
[ "$(field 2)" = 4000 ] && ok "sample recorded (estimate 4000)" || bad "estimate $(field 2), want 4000"
out="$(gh_api_retry "repos/o/r/pulls")" && [ "$out" = '{}' ] && ok "REST call admitted" || bad "REST call not admitted"
gh_api_retry "repos/o/r/issues" >/dev/null
[ "$(field 2)" = 3998 ] && ok "two admitted calls charged (3998)" || bad "estimate $(field 2), want 3998"
[ "$(calls_matching rate_limit)" = 1 ] && ok "sample not refreshed inside the refresh interval" \
  || bad "rate_limit called $(calls_matching rate_limit) times, want 1"
gh_api_retry graphql -f query='{viewer{login}}' >/dev/null
[ "$(field 2)" = 3998 ] && ok "GraphQL call not charged to the REST budget" || bad "GraphQL charged: $(field 2)"
gh_read_retry rest "pr list" pr list -R o/r >/dev/null
[ "$(field 2)" = 3997 ] && ok "gh_read_retry rest read charged" || bad "estimate $(field 2), want 3997"

# ============================================================================
hr; echo "SUBTEST 3 — at the reserve: low-priority ticks defer, normal calls proceed"; hr
reset_state; export RL_OUT="5000 400 $(( $(now) + 600 ))"
log_out="$(gh_rest_budget_defer low-watcher 2>&1)" && ok "400/5000 (≤10% reserve) → defer" || bad "did not defer at the reserve"
grep -q "low-watcher deferring" <<<"$log_out" && ok "first deferral in the window logs" || bad "no deferral line: $log_out"
# A healthy deferral is info, not warning: it must stay out of `journalctl -p
# warning` (syslog prefixes <0>..<4>), which feeds the mentor failure digest.
grep -q '^<6>' <<<"$log_out" && ! grep -qE '^<[0-4]>|WARN' <<<"$log_out" \
  && ok "first deferral logs at info severity (not in journalctl -p warning)" || bad "deferral not info-severity: $log_out"
log_out="$(gh_rest_budget_defer low-watcher 2>&1)" && ok "second tick defers too" || bad "second tick did not defer"
[ -z "$log_out" ] && ok "later deferrals in the same window are silent" || bad "repeat deferral logged: $log_out"
gh_api_retry "repos/o/r/pulls" >/dev/null && ok "normal-priority call still admitted inside the reserve" || bad "normal call refused at the reserve"
GARDEN_GH_REST_LOW_RESERVE=100 gh_rest_budget_defer t 2>/dev/null && bad "absolute reserve 100 deferred at ~399" \
  || ok "absolute reserve honored"

# ============================================================================
hr; echo "SUBTEST 4 — sampled zero latches until the sampled reset, without a doomed call"; hr
reset_state; export RL_OUT="5000 0 $(( $(now) + 600 ))"
rc=0; err="$(gh_api_retry "repos/o/r/pulls" 2>&1 >/dev/null)" || rc=$?
[ "$rc" = 75 ] && ok "REST call refused (rc 75) on a sampled zero" || bad "rc=$rc, want 75"
[ "$(grep -vc rate_limit "$CALLS" || true)" = 0 ] && ok "no REST request issued" || bad "a doomed REST request was issued"
is_gh_primary_rate_limit_text "$err" && ok "refusal names the primary quota for callers" || bad "refusal text: $err"
api_primary_quota_cooldown_active rest && ok "primary-quota latch open" || bad "no primary-quota latch"
exp="$(sed -n '1p' "$GARDEN_API_COOLDOWN_MARKER")"; left=$((exp - $(now)))
[ "$left" -gt 590 ] && [ "$left" -le 616 ] && ok "latch ends at the sampled reset + slack (${left}s)" || bad "latch ${left}s, want ~615"
grep -q "gh-api:rest-budget:primary-quota" "$GARDEN_API_COOLDOWN_MARKER" && ok "latch tagged rest-budget" || bad "latch tag: $(sed -n 2p "$GARDEN_API_COOLDOWN_MARKER")"

# ============================================================================
hr; echo "SUBTEST 5 — a refusal with metadata latches to the sampled reset"; hr
reset_state; export RL_OUT="5000 3000 $(( $(now) + 300 ))"
gh_rest_budget_defer t || true
export API_PRIMARY=1
gh_api_retry "repos/o/r/pulls" >/dev/null 2>&1 && bad "refused call reported success" || ok "primary refusal fails the call"
exp="$(sed -n '1p' "$GARDEN_API_COOLDOWN_MARKER")"; left=$((exp - $(now)))
[ "$left" -gt 290 ] && [ "$left" -le 316 ] && ok "refusal latch ends at the sampled reset (${left}s), not a blind hour" || bad "latch ${left}s, want ~315"
r="$(api_primary_quota_secs)"; [ "$r" = 3600 ] && ok "unscoped api_primary_quota_secs keeps the blind hour" || bad "unscoped got $r"

# ============================================================================
hr; echo "SUBTEST 6 — metadata unavailable: no deferral, blind-hour refusal latch"; hr
reset_state; export RL_FAIL=1
gh_rest_budget_defer t && bad "deferred without metadata" || ok "failed sample → proceed"
gh_api_retry "repos/o/r/pulls" >/dev/null && ok "REST call admitted without metadata" || bad "REST call refused without metadata"
gh_api_retry "repos/o/r/issues" >/dev/null
[ "$(calls_matching rate_limit)" = 1 ] && ok "failed sample retried only once per refresh interval" \
  || bad "rate_limit called $(calls_matching rate_limit) times"
export API_PRIMARY=1
gh_api_retry "repos/o/r/pulls" >/dev/null 2>&1 || true
exp="$(sed -n '1p' "$GARDEN_API_COOLDOWN_MARKER")"; left=$((exp - $(now)))
[ "$left" -gt 3590 ] && ok "refusal latch falls back to the blind hour (${left}s)" || bad "latch ${left}s, want ~3600"

# ============================================================================
hr; echo "SUBTEST 7 — a passed reset is not usable metadata; edge refresh picks up the new window"; hr
reset_state; export RL_OUT="5000 0 $(( $(now) - 5 ))"
gh_rest_budget_defer t && bad "deferred on a stale window" || ok "reset in the past → proceed"
gh_api_retry "repos/o/r/pulls" >/dev/null && ok "no latch from a past window's zero" || bad "latched on a past window"
# Age the attempt past the edge interval; the next admission resamples.
read -r l e t s a m < "$GARDEN_API_COOLDOWN_DIR/rest-budget"
printf '%s %s %s %s %s %s\n' "$l" "$e" "$t" "$s" "$((a - 30))" "$m" >"$GARDEN_API_COOLDOWN_DIR/rest-budget"
export RL_OUT="5000 4999 $(( $(now) + 3600 ))"
gh_api_retry "repos/o/r/pulls" >/dev/null
[ "$(field 2)" = 4998 ] && ok "edge refresh adopted the new window and charged it" || bad "estimate $(field 2), want 4998"

hr
echo "gh-rest-budget-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
