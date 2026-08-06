#!/bin/bash
# gh-api-retry-test.sh — regression guard for the bounded read-only gh-api retry
# helper (common.sh gh_api_retry + _gh_api_stderr_is_transient).
#
# Regression: every read-only gh handler in the watcher fleet issued a SINGLE bare
# `gh api … --jq … || die`. One transient GitHub blip (a 5xx / 429 / DNS-TLS-reset)
# on that call escalated an otherwise self-healing tick into a FATAL + nonzero exit
# and marked the systemd unit Failed even though the next probe would have
# succeeded — observed on mirror-pr-state for endojs/endo#3137 at 2026-06-29
# 15:26:06, which self-healed one tick later. gh_api_retry wraps the call in a
# bounded full-jitter retry loop so a transient blip is absorbed, WITHOUT weakening
# the "never guess a state" discipline: a definitive 404 is not retried (fast +
# loud), an exhausted transient still fails (nonzero, empty), only a clean success
# prints.
#
# SUBTEST 1 drives the pure classifier _gh_api_stderr_is_transient directly.
# SUBTEST 2 drives gh_api_retry end-to-end against a stub `gh` on PATH that is
# scripted (via a counter file) to fail-then-succeed, fail-always-transient, or
# fail-definitively, asserting the retry count, the returned payload, the exit
# code, and that stdout stays empty on every failure path.
# SUBTEST 3 drives the `gh pr view` sibling gh_pr_view_retry the same way (the
# `gh pr view` transport ci-rollup-gh.sh reads through), asserting a stubbed
# transient-then-success `gh pr view` returns a SETTLED payload rather than
# skipping, and that the never-guess discipline holds on every failure path.
#
# Usage: gh-api-retry-test.sh
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (a live gardener running this test as a board job would
# otherwise splice its own GARDEN_*/JOURNAL_* state underneath the fixture; see
# run-test.sh § hermetic baseline).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

# Keep the retries instant: a zero backoff window means the loop spins with no real
# sleep, so the test is fast and clock-independent.
export GARDEN_BACKOFF_BASE_MS=0 GARDEN_BACKOFF_CAP_MS=0

# shellcheck source=../common.sh
source "$JOBS/common.sh"

# ============================================================================
hr; echo "SUBTEST 1 — _gh_api_stderr_is_transient: 5xx/429/network transient, 4xx definitive"; hr
assert_transient()   { if _gh_api_stderr_is_transient "$1"; then ok "transient: $2"; else bad "NOT transient (expected transient): $2 [$1]"; fi; }
assert_definitive()  { if _gh_api_stderr_is_transient "$1"; then bad "transient (expected definitive): $2 [$1]"; else ok "definitive: $2"; fi; }
assert_transient  "gh: Server Error (HTTP 503)"                 "503 gateway/overload"
assert_transient  "gh: Bad Gateway (HTTP 502)"                 "502 bad gateway"
assert_transient  "gh: (HTTP 429)"                             "429 throttle"
assert_transient  "You have exceeded a secondary rate limit"  "secondary rate limit (a 403 variant)"
assert_transient  "API rate limit exceeded for user"          "rate limit text"
# `grep -q` used to close its input pipe after matching this first line. With
# pipefail active, printf then hit EPIPE while writing the multi-megabyte tail and
# the classifier falsely returned definitive. Keep the signature first so this
# catches exactly that broken-pipe regression rather than merely testing size.
shopt -qo pipefail || bad "pipefail is not active for the large-stderr regression"
large_tail="$(dd if=/dev/zero bs=1M count=3 2>/dev/null | tr '\0' x)"
assert_transient "gh: API rate limit exceeded for user ID 279080640 (HTTP 403)
$large_tail" "first-line rate limit in a multi-megabyte stderr blob under pipefail"
unset large_tail
assert_transient  "fatal: unable to access: Could not resolve host: api.github.com" "DNS failure (shared offline set)"
assert_transient  "curl 56 Recv failure: Connection reset by peer" "connection reset (shared offline set)"
# Go net/http transport wording `gh` emits (distinct from git's curl/SSH set). The
# #3137 crash signature below must NEVER regress to definitive again.
assert_transient  'Get "https://api.github.com/repos/endojs/endo/pulls/3137": dial tcp 140.82.116.5:443: i/o timeout' "Go i/o timeout — exact endojs/endo#3137 crash signature"
assert_transient  "dial tcp 140.82.116.5:443: i/o timeout"   "bare dial-tcp i/o timeout"
assert_transient  "context deadline exceeded"                "Go context deadline exceeded"
assert_transient  "net/http: TLS handshake timeout"          "Go TLS handshake timeout"
assert_transient  "dial tcp: lookup api.github.com: no such host" "Go DNS no such host"
assert_transient  "dial tcp: lookup api.github.com: server misbehaving" "Go resolver server misbehaving"
assert_transient  "Post \"https://api.github.com/graphql\": EOF" "Go bare EOF (word-bounded)"
assert_definitive "gh: Not Found for GEOFFREY (HTTP 404)"     "EOF mid-word (GEOFFREY) must NOT match \\bEOF\\b"
assert_definitive "gh: Not Found (HTTP 404)"                  "404 — a deleted/transferred resource"
assert_definitive "gh: Not Found (HTTP 422)"                  "422 — unprocessable"
assert_definitive "gh: Bad credentials (HTTP 401)"            "401 — auth, will not self-heal"
assert_definitive ""                                          "no stderr at all → not provably transient"
is_gh_primary_rate_limit_text "gh: API rate limit exceeded for user ID 279080640 (HTTP 403)" \
  && ok "primary-quota predicate matches GitHub's user-specific 403" \
  || bad "primary-quota predicate missed GitHub's user-specific 403"
is_gh_primary_rate_limit_text "x-ratelimit-remaining: 0" \
  && ok "primary-quota predicate matches an exhausted remaining-quota header" \
  || bad "primary-quota predicate missed x-ratelimit-remaining: 0"
for nonprimary in "You have exceeded a secondary rate limit" "abuse detection mechanism" "gh: (HTTP 429)"; do
  if is_gh_primary_rate_limit_text "$nonprimary"; then
    bad "primary-quota predicate swallowed transient throttle: $nonprimary"
  else
    ok "primary-quota predicate excludes transient throttle: $nonprimary"
  fi
done

# ============================================================================
hr; echo "SUBTEST 2 — gh_api_retry: retry transient, return payload, never guess on failure"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-ghretry.XXXXXX")"; trap 'rm -rf "$TR"' EXIT

# Shadow `gh` with a shell FUNCTION rather than a PATH stub: a function takes
# precedence over the fleet wrapper on PATH, is inherited by gh_api_retry's
# command-substitution subshell, and needs no executable file (so the test runs
# even where /tmp is mounted noexec). It models `gh api`, driven by env the test
# sets per case, and records each invocation so the retry COUNT can be asserted.
gh() {
  echo x >> "$GH_STUB_CALLS"
  local n; n="$(wc -l < "$GH_STUB_CALLS")"
  case "${GH_STUB_MODE:-succeed}" in
    succeed)
      printf '%s\n' "${GH_STUB_PAYLOAD:-OK}"; return 0 ;;
    flaky)
      # Transient blip until the Nth call, then succeed with the payload. The
      # transient stderr defaults to a 503 but can be overridden per case (e.g. the
      # `gh pr view` TLS-handshake-timeout wording) — both are transient signatures.
      if [ "$n" -lt "${GH_STUB_SUCCEED_ON:-2}" ]; then
        echo "${GH_STUB_TRANSIENT_STDERR:-gh: Server Error (HTTP 503)}" >&2; return 1
      fi
      printf '%s\n' "${GH_STUB_PAYLOAD:-OK}"; return 0 ;;
    transient-always)
      echo "${GH_STUB_TRANSIENT_STDERR:-gh: Server Error (HTTP 503)}" >&2; return 1 ;;
    primary-always)
      echo "gh: API rate limit exceeded for user ID 279080640 (HTTP 403)" >&2; return 1 ;;
    definitive)
      echo "gh: Not Found (HTTP 404)" >&2; return 22 ;;
  esac
}
ok "gh shadowed by a test function (no PATH/exec dependency)"

export GH_STUB_CALLS="$TR/calls" GARDEN_GH_API_ATTEMPTS=4

# (a) clean success on the first try → payload returned, exactly one call.
: > "$GH_STUB_CALLS"; set +e
out="$(GH_STUB_MODE=succeed GH_STUB_PAYLOAD='open	true' gh_api_retry "repos/o/r/pulls/1" --jq '.x')"; rc=$?
set -e
n=$(wc -l < "$GH_STUB_CALLS")
{ [ "$rc" -eq 0 ] && [ "$out" = "open	true" ] && [ "$n" -eq 1 ]; } \
  && ok "success: payload returned, exit 0, single call (no needless retry)" \
  || bad "success path wrong (rc=$rc out='$out' calls=$n)"

# (b) transient-then-success: 503 twice, succeed on the 3rd → payload returned,
#     exactly 3 calls (the blip was absorbed, the caller never saw a failure).
: > "$GH_STUB_CALLS"; set +e
out="$(GH_STUB_MODE=flaky GH_STUB_SUCCEED_ON=3 GH_STUB_PAYLOAD=HEALED gh_api_retry "repos/o/r/pulls/2")"; rc=$?
set -e
n=$(wc -l < "$GH_STUB_CALLS")
{ [ "$rc" -eq 0 ] && [ "$out" = "HEALED" ] && [ "$n" -eq 3 ]; } \
  && ok "transient blip absorbed: retried to success, payload returned (3 calls)" \
  || bad "flaky path wrong (rc=$rc out='$out' calls=$n)"

# (c) transient-always: every attempt is a 503 → fails after exactly
#     GARDEN_GH_API_ATTEMPTS calls, nonzero, EMPTY stdout (caller's `|| die` fires;
#     it never acts on a guessed state).
: > "$GH_STUB_CALLS"; set +e
out="$(GH_STUB_MODE=transient-always gh_api_retry "repos/o/r/pulls/3" 2>/dev/null)"; rc=$?
set -e
n=$(wc -l < "$GH_STUB_CALLS")
{ [ "$rc" -ne 0 ] && [ -z "$out" ] && [ "$n" -eq 4 ]; } \
  && ok "exhausted transient: nonzero + empty after exactly 4 attempts (loud, no guess)" \
  || bad "exhaustion path wrong (rc=$rc out='$out' calls=$n want 4)"

# (c2) primary quota exhaustion cannot recover inside this retry window: fail
#      immediately after ONE request even though the generic text is also in the
#      transient signature set.
: > "$GH_STUB_CALLS"; set +e
out="$(GH_STUB_MODE=primary-always gh_api_retry "repos/o/r/pulls/primary" 2>/dev/null)"; rc=$?
set -e
n=$(wc -l < "$GH_STUB_CALLS")
{ [ "$rc" -ne 0 ] && [ -z "$out" ] && [ "$n" -eq 1 ]; } \
  && ok "primary quota: gh api fails immediately after exactly one attempt" \
  || bad "primary quota retried unexpectedly (rc=$rc out='$out' calls=$n want 1)"

# (c3) secondary throttling remains transient and can recover inside the budget.
: > "$GH_STUB_CALLS"; set +e
out="$(GH_STUB_MODE=flaky GH_STUB_SUCCEED_ON=2 GH_STUB_PAYLOAD=RECOVERED \
       GH_STUB_TRANSIENT_STDERR='You have exceeded a secondary rate limit' \
       gh_api_retry "repos/o/r/pulls/secondary")"; rc=$?
set -e
n=$(wc -l < "$GH_STUB_CALLS")
{ [ "$rc" -eq 0 ] && [ "$out" = RECOVERED ] && [ "$n" -eq 2 ]; } \
  && ok "secondary rate limit still retries and recovers" \
  || bad "secondary rate limit did not recover (rc=$rc out='$out' calls=$n want 2)"

# (d) definitive 404: NOT retried → fails after exactly ONE call, nonzero, empty
#     stdout. A definitive error fails fast-ish but loud; only transient errors get
#     retried.
: > "$GH_STUB_CALLS"; set +e
out="$(GH_STUB_MODE=definitive gh_api_retry "repos/o/r/pulls/4" 2>/dev/null)"; rc=$?
set -e
n=$(wc -l < "$GH_STUB_CALLS")
{ [ "$rc" -ne 0 ] && [ -z "$out" ] && [ "$n" -eq 1 ]; } \
  && ok "definitive 404: not retried — single call, nonzero, empty (fast + loud)" \
  || bad "definitive path wrong (rc=$rc out='$out' calls=$n want 1)"

# (e) the caller idiom `out="$(gh_api_retry …)" || die` still dies on a definitive
#     failure: assert the `|| <branch>` fires and the guard sees empty output.
: > "$GH_STUB_CALLS"
guarded() { local o; o="$(GH_STUB_MODE=definitive gh_api_retry "repos/o/r/pulls/5" 2>/dev/null)" || return 7; printf '%s' "$o"; }
set +e; guarded >/dev/null; grc=$?; set -e
[ "$grc" -eq 7 ] \
  && ok "caller's '|| die' branch fires on a definitive failure (state never guessed)" \
  || bad "caller guard did not fire on definitive failure (rc=$grc)"

# ============================================================================
hr; echo "SUBTEST 3 — gh_pr_view_retry: same retry loop over the \`gh pr view\` transport"; hr
# gh_pr_view_retry runs "${GARDEN_GH:-gh} pr view …" under the SAME
# _gh_api_stderr_is_transient + backoff loop. Shadow `gh` again (GARDEN_GH unset,
# so gh_bin resolves to the `gh` function) and reuse the mode-switch stub above —
# it is argument-agnostic, so `gh pr view …` hits the same fail/succeed logic. The
# per-case call count proves whether a blip was retried, and the payload proves a
# recovered read returns the SETTLED verdict, not a skip.
export GARDEN_GH_API_ATTEMPTS=4
unset GARDEN_GH 2>/dev/null || true   # gh_bin → the `gh` function shadow above

# (a) clean success on the first try → payload returned, exactly one call.
: > "$GH_STUB_CALLS"; set +e
out="$(GH_STUB_MODE=succeed GH_STUB_PAYLOAD='{"state":"OPEN"}' gh_pr_view_retry 999 -R o/r --json state)"; rc=$?
set -e
n=$(wc -l < "$GH_STUB_CALLS")
{ [ "$rc" -eq 0 ] && [ "$out" = '{"state":"OPEN"}' ] && [ "$n" -eq 1 ]; } \
  && ok "pr view success: payload returned, exit 0, single call (no needless retry)" \
  || bad "pr view success path wrong (rc=$rc out='$out' calls=$n)"

# (b) transient-then-success: a TLS-handshake timeout twice, then the settled JSON
#     on the 3rd → payload returned, exactly 3 calls. This is the job's core case:
#     a stubbed transient-then-success `gh pr view` yields a SETTLED verdict, never a skip.
: > "$GH_STUB_CALLS"; set +e
out="$(GH_STUB_MODE=flaky GH_STUB_SUCCEED_ON=3 GH_STUB_PAYLOAD='{"state":"OPEN","settled":true}' \
       GH_STUB_TRANSIENT_STDERR='net/http: TLS handshake timeout' gh_pr_view_retry 999 --json state)"; rc=$?
set -e
n=$(wc -l < "$GH_STUB_CALLS")
{ [ "$rc" -eq 0 ] && [ "$out" = '{"state":"OPEN","settled":true}' ] && [ "$n" -eq 3 ]; } \
  && ok "pr view transient TLS blip absorbed: retried to a settled verdict (3 calls), not a skip" \
  || bad "pr view flaky path wrong (rc=$rc out='$out' calls=$n)"

# (c) transient-always: exhausts the budget → nonzero, EMPTY stdout after exactly
#     GARDEN_GH_API_ATTEMPTS calls (caller's `|| die` fires; never a guessed state).
: > "$GH_STUB_CALLS"; set +e
out="$(GH_STUB_MODE=transient-always gh_pr_view_retry 999 --json state 2>/dev/null)"; rc=$?
set -e
n=$(wc -l < "$GH_STUB_CALLS")
{ [ "$rc" -ne 0 ] && [ -z "$out" ] && [ "$n" -eq 4 ]; } \
  && ok "pr view exhausted transient: nonzero + empty after exactly 4 attempts (loud, no guess)" \
  || bad "pr view exhaustion path wrong (rc=$rc out='$out' calls=$n want 4)"

# (c2) primary quota is likewise one-shot on the gh-pr-view transport.
: > "$GH_STUB_CALLS"; set +e
out="$(GH_STUB_MODE=primary-always gh_pr_view_retry 999 --json state 2>/dev/null)"; rc=$?
set -e
n=$(wc -l < "$GH_STUB_CALLS")
{ [ "$rc" -ne 0 ] && [ -z "$out" ] && [ "$n" -eq 1 ]; } \
  && ok "pr view primary quota fails immediately after exactly one attempt" \
  || bad "pr view primary quota retried unexpectedly (rc=$rc out='$out' calls=$n want 1)"

# (c3) an HTTP 429 remains retryable and can recover.
: > "$GH_STUB_CALLS"; set +e
out="$(GH_STUB_MODE=flaky GH_STUB_SUCCEED_ON=2 GH_STUB_PAYLOAD='{"state":"OPEN"}' \
       GH_STUB_TRANSIENT_STDERR='gh: Too Many Requests (HTTP 429)' \
       gh_pr_view_retry 999 --json state)"; rc=$?
set -e
n=$(wc -l < "$GH_STUB_CALLS")
{ [ "$rc" -eq 0 ] && [ "$out" = '{"state":"OPEN"}' ] && [ "$n" -eq 2 ]; } \
  && ok "pr view HTTP 429 still retries and recovers" \
  || bad "pr view HTTP 429 did not recover (rc=$rc out='$out' calls=$n want 2)"

# (d) definitive error: NOT retried → single call, nonzero, empty stdout.
: > "$GH_STUB_CALLS"; set +e
out="$(GH_STUB_MODE=definitive gh_pr_view_retry 999 --json state 2>/dev/null)"; rc=$?
set -e
n=$(wc -l < "$GH_STUB_CALLS")
{ [ "$rc" -ne 0 ] && [ -z "$out" ] && [ "$n" -eq 1 ]; } \
  && ok "pr view definitive error: not retried — single call, nonzero, empty (fast + loud)" \
  || bad "pr view definitive path wrong (rc=$rc out='$out' calls=$n want 1)"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
