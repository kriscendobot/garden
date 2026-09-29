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

# gh_api_retry latches primary-quota refusals into the host-shared cooldown dir;
# keep this suite's latches in a private dir (never the checkout's .garden-state).
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-ghretry.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
export GARDEN_API_COOLDOWN_DIR="$TR/gh-api-cooldown"
clear_latches() { rm -f "$GARDEN_API_COOLDOWN_DIR"/marker "$GARDEN_API_COOLDOWN_DIR"/marker-graphql; }

# shellcheck source=../common.sh
source "$JOBS/common.sh"

# ============================================================================
hr; echo "SUBTEST 1 — _gh_api_stderr_is_transient: 5xx/429/401/network transient, other 4xx definitive"; hr
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
# Go net/http2 server-side stream reset. The garden-ci-watcher crash signature below
# (kriscendobot/minion.town, 2026-08-14 08:04:32) must NEVER regress to definitive again.
assert_transient  "stream error: stream ID 1; CANCEL; received from peer" "Go http2 stream reset — exact minion.town ci-watcher crash signature"
assert_transient  "http2: server sent GOAWAY and closed the connection" "Go http2 GOAWAY"
assert_transient  "http2: client connection lost"           "Go http2 client connection lost"
assert_transient  "stream error: stream ID 7; INTERNAL_ERROR; received from peer" "Go http2 INTERNAL_ERROR stream reset"
# Go encoding/json truncated/empty response body. The garden-ci-watcher crash signature
# below (kriscendobot/minion.town) must NEVER regress to definitive again.
assert_transient  "unexpected end of JSON input"             "truncated/empty response body"
assert_definitive "gh: Not Found for GEOFFREY (HTTP 404)"     "EOF mid-word (GEOFFREY) must NOT match \\bEOF\\b"
assert_definitive "gh: Not Found (HTTP 404)"                  "404 — a deleted/transferred resource"
assert_definitive "gh: Not Found (HTTP 422)"                  "422 — unprocessable"
assert_transient  "gh: Bad credentials (HTTP 401)"            "401 — transient token rotation"
assert_definitive ""                                          "no stderr at all → not provably transient"
is_gh_primary_rate_limit_text "gh: API rate limit exceeded for user ID 279080640 (HTTP 403)" \
  && ok "primary-quota predicate matches GitHub's user-specific 403" \
  || bad "primary-quota predicate missed GitHub's user-specific 403"
is_gh_primary_rate_limit_text "gh: API rate limit already exceeded for user ID 279080640." \
  && ok "primary-quota predicate matches GitHub's 'already exceeded' wording" \
  || bad "primary-quota predicate missed GitHub's 'already exceeded' wording"
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

# (c401a) a spurious 401 on the first attempt followed by success is absorbed.
# The recovered payload is clean stdout and the call count proves one retry.
: > "$GH_STUB_CALLS"; set +e
out="$(GH_STUB_MODE=flaky GH_STUB_SUCCEED_ON=2 GH_STUB_PAYLOAD=AUTH_HEALED \
       GH_STUB_TRANSIENT_STDERR='gh: Bad credentials (HTTP 401)' \
       gh_api_retry "repos/o/r/issues/comments?since=2026-08-14T07:59:00Z")"; rc=$?
set -e
n=$(wc -l < "$GH_STUB_CALLS")
{ [ "$rc" -eq 0 ] && [ "$out" = AUTH_HEALED ] && [ "$n" -eq 2 ]; } \
  && ok "spurious 401 absorbed: one retry returns clean payload" \
  || bad "flaky 401 path wrong (rc=$rc out='$out' calls=$n want 2)"

# (c401b) a genuinely dead credential remains loud after the bounded budget:
# exactly GARDEN_GH_API_ATTEMPTS calls, nonzero, and EMPTY stdout.
: > "$GH_STUB_CALLS"; set +e
out="$(GH_STUB_MODE=transient-always \
       GH_STUB_TRANSIENT_STDERR='gh: Bad credentials (HTTP 401)' \
       gh_api_retry "repos/o/r/issues/comments?since=2026-08-14T07:59:00Z" 2>/dev/null)"; rc=$?
set -e
n=$(wc -l < "$GH_STUB_CALLS")
{ [ "$rc" -ne 0 ] && [ -z "$out" ] && [ "$n" -eq "$GARDEN_GH_API_ATTEMPTS" ]; } \
  && ok "persistent 401: nonzero + empty after exactly $GARDEN_GH_API_ATTEMPTS attempts" \
  || bad "persistent 401 path wrong (rc=$rc out='$out' calls=$n want $GARDEN_GH_API_ATTEMPTS)"

# (c2) gh's client-side primary-quota preflight cannot recover inside this retry
#      window: through the real GARDEN_GH seam, fail immediately after ONE request
#      even though the generic text is also in the transient signature set. Keep
#      the warning, and prove the generic transient-retry branch was never entered.
: > "$GH_STUB_CALLS"; set +e
out="$(GARDEN_GH="$HERE/gh-api-primary-rate-limit-stub.sh" \
       gh_api_retry "repos/o/r/pulls/primary" 2>"$TR/primary.err")"; rc=$?
set -e
n=$(wc -l < "$GH_STUB_CALLS")
primary_warns=$(grep -c 'RATE LIMITED by GitHub primary quota' "$TR/primary.err" || true)
transient_blips=$(grep -c 'transient blip' "$TR/primary.err" || true)
{ [ "$rc" -ne 0 ] && [ -z "$out" ] && [ "$n" -eq 1 ] && \
  [ "$primary_warns" -eq 1 ] && [ "$transient_blips" -eq 0 ]; } \
  && ok "gh client-side primary quota: one attempt, primary-quota WARN, no transient retry" \
  || bad "gh client-side primary quota fast-fail wrong (rc=$rc out='$out' calls=$n primary-warns=$primary_warns transient-blips=$transient_blips)"
# ... and the refusal latched the host-wide marker for the primary-quota window.
if [ -f "$GARDEN_API_COOLDOWN_DIR/marker" ] && grep -q 'gh-api:repos/o/r/pulls/primary:primary-quota' "$GARDEN_API_COOLDOWN_DIR/marker"; then
  ok "primary-quota refusal latched the host-wide gh-api cooldown"
else
  bad "primary-quota refusal did not latch the host-wide marker"
fi
clear_latches

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

# (c4) a Go net/http2 server-side stream reset is transient and recovers inside the
#      budget — the exact garden-ci-watcher failure (kriscendobot/minion.town,
#      2026-08-14) that used to crash the caller as definitive after 0 retries.
: > "$GH_STUB_CALLS"; set +e
out="$(GH_STUB_MODE=flaky GH_STUB_SUCCEED_ON=2 GH_STUB_PAYLOAD=RECOVERED \
       GH_STUB_TRANSIENT_STDERR='stream error: stream ID 1; CANCEL; received from peer' \
       gh_api_retry "repos/kriscendobot/minion.town/pulls")"; rc=$?
set -e
n=$(wc -l < "$GH_STUB_CALLS")
{ [ "$rc" -eq 0 ] && [ "$out" = RECOVERED ] && [ "$n" -eq 2 ]; } \
  && ok "http2 stream reset still retries and recovers (minion.town ci-watcher case)" \
  || bad "http2 stream reset did not recover (rc=$rc out='$out' calls=$n want 2)"

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

# ============================================================================
hr; echo "SUBTEST 4 — gh_api_retry single-flight admission under the cooldown lock"; hr
# The 2026-09-29 19:35:34-35 race: concurrent sources each passed their cooldown
# check, then each issued its own request into an exhausted primary quota. Every
# attempt is now admitted under the cooldown flock and the latch is written before
# release, so N concurrent callers make exactly ONE request.
PRIMARY_STUB="$HERE/gh-api-primary-rate-limit-stub.sh"
run_concurrent() {  # run_concurrent <n> <tag> [env…] — N callers in separate processes
  local n="$1" tag="$2" i; shift 2
  for i in $(seq 1 "$n"); do
    env "$@" GARDEN_GH="$PRIMARY_STUB" GH_STUB_CALLS="$GH_STUB_CALLS" GH_STUB_SLEEP=0.3 \
      bash -c 'source "$1"; gh_api_retry "repos/o/r/issues/comments?caller=$2"; echo "rc=$?" >"$3"' \
      _ "$JOBS/common.sh" "$i" "$TR/$tag.rc.$i" 2>"$TR/$tag.err.$i" &
  done
  wait
}

# (a) N concurrent callers against a primary-quota stub: one gh invocation, the
#     marker latched, every other caller refused without a request (rc 75).
clear_latches; : > "$GH_STUB_CALLS"
run_concurrent 6 sf
n=$(wc -l < "$GH_STUB_CALLS")
refused=$(cat "$TR"/sf.err.* | grep -c 'NOT ISSUED: host-shared gh-api cooldown live' || true)
rc75=$(cat "$TR"/sf.rc.* | grep -c '^rc=75$' || true)
nonzero=$(cat "$TR"/sf.rc.* | grep -vc '^rc=0$' || true)
[ "$n" -eq 1 ] && ok "6 concurrent callers: exactly one gh request" \
  || bad "6 concurrent callers made $n gh requests (want 1)"
{ [ "$refused" -eq 5 ] && [ "$rc75" -eq 5 ] && [ "$nonzero" -eq 6 ]; } \
  && ok "the other 5 were refused at admission (distinct log line, rc 75), none succeeded" \
  || bad "admission refusals wrong (refused=$refused rc75=$rc75 nonzero=$nonzero)"
grep -q 'primary-quota' "$GARDEN_API_COOLDOWN_DIR/marker" 2>/dev/null \
  && ok "the primary-quota latch is recorded in the host-wide marker" \
  || bad "no primary-quota latch after the concurrent refusal"
# A refusal behind a primary-quota latch names it so callers classify it as primary.
if is_gh_primary_rate_limit_text "$(cat "$TR"/sf.err.*)" && _gh_api_stderr_is_transient "$(cat "$TR"/sf.err.*)"; then
  ok "admission refusal text classifies as primary-quota (and transient) for callers"
else
  bad "admission refusal text is not classifiable by callers"
fi

# (b) a live latch refuses even a would-succeed call, and a GraphQL latch does not
#     silence a REST call (separate buckets), while a REST latch refuses GraphQL.
clear_latches; : > "$GH_STUB_CALLS"
start_api_cooldown "t:graphql" 600 graphql
set +e
out="$(GH_STUB_MODE=succeed GH_STUB_PAYLOAD=REST_OK gh_api_retry "repos/o/r/pulls/9" 2>/dev/null)"; rc=$?
gq="$(GH_STUB_MODE=succeed gh_api_retry graphql -f query=x 2>"$TR/gq.err")"; gqrc=$?
set -e
n=$(wc -l < "$GH_STUB_CALLS")
{ [ "$rc" -eq 0 ] && [ "$out" = REST_OK ] && [ "$gqrc" -eq 75 ] && [ -z "$gq" ] && [ "$n" -eq 1 ]; } \
  && ok "GraphQL latch: REST call admitted, GraphQL call refused without a request" \
  || bad "GraphQL-scope admission wrong (rest rc=$rc out='$out' gql rc=$gqrc calls=$n)"
clear_latches; : > "$GH_STUB_CALLS"
set +e
GARDEN_GH="$PRIMARY_STUB" gh_api_retry graphql -f query=x >/dev/null 2>&1
set -e
{ [ -f "$GARDEN_API_COOLDOWN_DIR/marker-graphql" ] && [ ! -e "$GARDEN_API_COOLDOWN_DIR/marker" ]; } \
  && ok "a GraphQL primary refusal latches only the GraphQL marker" \
  || bad "GraphQL primary refusal latched the wrong marker"
clear_latches; start_api_cooldown "t:rest" 600
set +e; GH_STUB_MODE=succeed gh_api_retry graphql -f query=x >/dev/null 2>&1; gqrc=$?; set -e
[ "$gqrc" -eq 75 ] && ok "host-wide latch refuses a GraphQL call too" \
  || bad "host-wide latch did not refuse GraphQL (rc=$gqrc)"

# (c) GARDEN_API_COOLDOWN_SECS=0 disables admission: the old behavior, every caller
#     makes its own request and nothing is latched.
clear_latches; : > "$GH_STUB_CALLS"
run_concurrent 4 off GARDEN_API_COOLDOWN_SECS=0
n=$(wc -l < "$GH_STUB_CALLS")
{ [ "$n" -eq 4 ] && [ ! -e "$GARDEN_API_COOLDOWN_DIR/marker" ]; } \
  && ok "GARDEN_API_COOLDOWN_SECS=0: no lock, no latch, 4 requests (old behavior)" \
  || bad "disable hatch not honored (calls=$n marker=$([ -e "$GARDEN_API_COOLDOWN_DIR/marker" ] && echo yes || echo no))"

# (d) a transient failure releases the lock before its backoff: while caller A
#     sleeps between attempts, caller B is admitted and completes.
clear_latches
set +e
( GARDEN_BACKOFF_BASE_MS=3000 GARDEN_BACKOFF_CAP_MS=3000 GARDEN_GH_API_ATTEMPTS=2 \
  GH_STUB_CALLS="$TR/slow.calls" GH_STUB_MODE=transient-always \
  gh_api_retry "repos/o/r/pulls/slow" >/dev/null 2>&1 ) &
slow=$!
sleep 0.3
: > "$TR/fast.calls"
t0=$(date +%s)
out="$(GH_STUB_CALLS="$TR/fast.calls" GH_STUB_MODE=succeed GH_STUB_PAYLOAD=FAST \
       GARDEN_GH_API_ADMISSION_WAIT_SECS=30 gh_api_retry "repos/o/r/pulls/fast" 2>/dev/null)"; rc=$?
t1=$(date +%s)
wait "$slow"
set -e
{ [ "$rc" -eq 0 ] && [ "$out" = FAST ] && [ $((t1 - t0)) -le 1 ]; } \
  && ok "the lock is not held across a transient backoff sleep" \
  || bad "a sibling waited on a backing-off caller (rc=$rc out='$out' waited=$((t1 - t0))s)"

# (e) a nested gh_api_retry inside an admitted gh child passes through instead of
#     deadlocking on its parent's lock.
clear_latches
set +e
nested="$(timeout 20 bash -c '
  source "$1"
  gh() { case "$2" in */outer) gh_api_retry repos/o/r/inner ;; *) printf INNER ;; esac; }
  gh_api_retry repos/o/r/outer' _ "$JOBS/common.sh" 2>/dev/null)"; rc=$?
set -e
{ [ "$rc" -eq 0 ] && [ "$nested" = INNER ]; } \
  && ok "nested gh_api_retry inside an admitted request passes through (no deadlock)" \
  || bad "nested gh_api_retry deadlocked or failed (rc=$rc out='$nested')"

# (f) a lock held past GARDEN_GH_API_ADMISSION_WAIT_SECS: the caller proceeds
#     unserialized (logged) rather than stalling its tick.
clear_latches; mkdir -p "$GARDEN_API_COOLDOWN_DIR"
( exec 7>>"$GARDEN_API_COOLDOWN_DIR/marker.lock"; flock 7; sleep 4 ) &
holder=$!
sleep 0.3
set +e
out="$(GH_STUB_MODE=succeed GH_STUB_PAYLOAD=LATE GARDEN_GH_API_ADMISSION_WAIT_SECS=1 \
       gh_api_retry "repos/o/r/pulls/busy" 2>"$TR/busy.err")"; rc=$?
set -e
kill "$holder" 2>/dev/null || true; wait "$holder" 2>/dev/null || true
{ [ "$rc" -eq 0 ] && [ "$out" = LATE ] && grep -q 'admission lock busy' "$TR/busy.err"; } \
  && ok "bounded admission wait: proceeds unserialized with a WARN" \
  || bad "bounded admission wait wrong (rc=$rc out='$out')"
clear_latches

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
