#!/bin/bash
# ci-watcher-test.sh — validate the CI-status watcher on throwaway fixtures, with
# no GitHub. The open-PR SOURCE and the check-rollup PROBE are stubbed
# deterministically; the bot-author gate, the head-pushable gate, the is-bot-repo
# gate, the RED→shepherd mapping, the idempotency, and the deterministic basename
# all run for real against a throwaway journal.
#
# Asserts:
#   A. a bot-authored open PR with a COMPLETED-RED rollup → exactly one
#      <slug>-pr<N>-shepherd job (no maintainer comment)
#   B. re-poll of the same red PR → idempotent (still exactly one, no duplicate)
#   C. a PR authored by a NON-bot → no shepherd (author gate)
#   D. a bot PR with GREEN CI → no shepherd
#   E. a bot PR with QUEUED/IN-PROGRESS CI → no shepherd (back off, no thrash)
#   F. a bot PR whose head branch is NOT bot-pushable → no shepherd
#   G. a NON-bot repo slug → the watcher exits at the is-bot-repo gate, no shepherd
#   H. a repo with several PRs of mixed state → exactly the red bot PRs get one each
#   I. a bot PR untouched beyond GARDEN_CI_ACTIVITY_WINDOW → skipped before its rollup
#      read (activity-bound), while a fresh red PR in the same tick still shepherds
#   J. a run of unreadable rollup reads with no success yet → the circuit-breaker
#      aborts the tick before the tail red PR, so no shepherd is posted (rate-limit)
#   K. an early successful read disarms the circuit-breaker → later unreadable reads
#      do NOT abort ("zero successful reads so far this tick" clause)
#   L. the ci-rollup handler routes its `gh pr view` read through common.sh's
#      canonical gh_pr_view_retry: a TRANSIENT stderr (TLS-handshake timeout, and a
#      throttle now that the canonical absorber owns it) is retried up to
#      GARDEN_GH_API_ATTEMPTS, while a DEFINITIVE 404 is not retried (single attempt);
#      every EXHAUSTED failure path still falls through to exit 1 (watcher skips,
#      never guesses); and a single transient blip that RECOVERS on retry yields the
#      REAL verdict (RED→0 shepherd trigger, GREEN→10), NOT a skip — the whole point
#      of the retry (endojs-endo-but-for-bots#377's one-off TLS timeout must not drop
#      a red PR for the tick)
#
# Usage: ci-watcher-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-ciw-test
SLUG=endojs-endo-but-for-bots
REPO=endojs/endo-but-for-bots
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet GARDEN_*/JOURNAL_* so a live gardener running this test cannot
# splice the real journal under the fixture (the run-test.sh isolation rationale).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|CI_)' || true) 2>/dev/null || true

rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=test -c user.email=test@localhost)

seed_bare() {  # seed_bare <bare-path>
  local bare="$1" seed; seed="$(mktemp -d "$TR/seed.XXXXXX")"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada work comment-repos
    for d in jobs/todo jobs/doin jobs/tada work comment-repos; do touch "$d/.gitkeep"; done )
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"; git -C "$seed" push -q -u origin "$BRANCH"
  rm -rf "$seed"
}

# --- deterministic stubs ----------------------------------------------------
SRCSTUB="$TR/pr-source-stub.sh"
cat > "$SRCSTUB" <<'EOF'
#!/bin/bash
# emit the fixture verbatim (ignores repo/bot); the watcher applies the gates.
cat "${CI_FIXTURE:?set CI_FIXTURE}"
EOF
chmod +x "$SRCSTUB"

# rollup probe: map a PR number to an exit code via CI_ROLLUP_MAP="57=0 58=10 …".
# Exit codes mirror ci-rollup-gh.sh: 0 RED, 10 green, 11 none, 12 pending.
ROLLUPSTUB="$TR/rollup-stub.sh"
cat > "$ROLLUPSTUB" <<'EOF'
#!/bin/bash
pr="$2"
for kv in $CI_ROLLUP_MAP; do
  [ "${kv%%=*}" = "$pr" ] && exit "${kv##*=}"
done
exit 11   # default: no checks reported
EOF
chmod +x "$ROLLUPSTUB"

board_has() {  # board_has <bare> <base>  -> 0 if job present in todo/doin/tada
  local v; v="$(mktemp -d "$TR/bv.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  local rc=1 s
  for s in todo doin tada; do [ -e "$v/jobs/$s/$2.md" ] && rc=0; done
  rm -rf "$v"; return $rc
}
todo_count() {  # todo_count <bare>  -> non-gitkeep entries in jobs/todo
  local v n; v="$(mktemp -d "$TR/tc.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  n=$(ls -1 "$v/jobs/todo" | grep -vxc '.gitkeep' || true); rm -rf "$v"; printf '%s' "$n"
}

# Timestamps computed against the real clock so the activity-window assertions hold
# regardless of the absolute date the suite runs on. FRESH_TS is also prline's default
# updated_at: a fixed literal here would age past the watcher's default 3-day
# GARDEN_CI_ACTIVITY_WINDOW (§ Gate 3) as the calendar advances, silently skipping the
# very red PRs cases A/B/H assert get shepherded.
FRESH_TS="$(date -u -d '-1 hour'  +%Y-%m-%dT%H:%M:%SZ)"
STALE_TS="$(date -u -d '-30 days' +%Y-%m-%dT%H:%M:%SZ)"

# fixture line: number \t author \t head_repo \t updated_at
prline() { printf '%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "${4:-$FRESH_TS}"; }

run_ci() {  # run_ci <state> <bare> <fixture> <rollup-map> [slug]
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_BOT_LOGIN=kriscendobot \
      GARDEN_CI_PR_SOURCE="$SRCSTUB" CI_FIXTURE="$3" \
      GARDEN_CI_ROLLUP="$ROLLUPSTUB" CI_ROLLUP_MAP="$4" \
      GARDEN_CI_POST="$JOBS/post-job.sh" \
      "$JOBS/ci-watcher.sh" "${5:-$SLUG}" >/dev/null 2>&1
}

# Like run_ci but threads extra KEY=VAL env (activity window / abort threshold) through.
run_ci_env() {  # run_ci_env <state> <bare> <fixture> <rollup-map> <slug> [KEY=VAL ...]
  local state="$1" bare="$2" fix="$3" map="$4" slug="$5"; shift 5
  env "$@" GARDEN_STATE="$state" JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_BOT_LOGIN=kriscendobot \
      GARDEN_CI_PR_SOURCE="$SRCSTUB" CI_FIXTURE="$fix" \
      GARDEN_CI_ROLLUP="$ROLLUPSTUB" CI_ROLLUP_MAP="$map" \
      GARDEN_CI_POST="$JOBS/post-job.sh" \
      "$JOBS/ci-watcher.sh" "$slug" >/dev/null 2>&1
}

# ============================================================================
hr; echo "A — bot PR + completed-red CI → exactly one shepherd job"; hr
BARE_A="$TR/a.git"; seed_bare "$BARE_A"
FIX_A="$TR/fix-a.tsv"; prline 58 kriscendobot "$REPO" > "$FIX_A"
run_ci "$TR/state-a" "$BARE_A" "$FIX_A" "58=0"
board_has "$BARE_A" "$SLUG-pr58-shepherd" && ok "shepherd job posted ($SLUG-pr58-shepherd)" || bad "shepherd job missing"
[ "$(todo_count "$BARE_A")" -eq 1 ] && ok "exactly one job posted" || bad "expected one job, got $(todo_count "$BARE_A")"

# ============================================================================
hr; echo "B — re-poll the same red PR → idempotent (no duplicate)"; hr
run_ci "$TR/state-a" "$BARE_A" "$FIX_A" "58=0"
[ "$(todo_count "$BARE_A")" -eq 1 ] && ok "still exactly one shepherd job on re-poll" || bad "job duplicated ($(todo_count "$BARE_A"))"

# ============================================================================
hr; echo "C — PR authored by a NON-bot → no shepherd (author gate)"; hr
BARE_C="$TR/c.git"; seed_bare "$BARE_C"
FIX_C="$TR/fix-c.tsv"; prline 60 0xpatrickdev "$REPO" > "$FIX_C"
run_ci "$TR/state-c" "$BARE_C" "$FIX_C" "60=0"
[ "$(todo_count "$BARE_C")" -eq 0 ] && ok "no shepherd for a non-bot-authored red PR" || bad "posted a shepherd for a foreign PR"

# ============================================================================
hr; echo "D — bot PR with GREEN CI → no shepherd"; hr
BARE_D="$TR/d.git"; seed_bare "$BARE_D"
FIX_D="$TR/fix-d.tsv"; prline 61 kriscendobot "$REPO" > "$FIX_D"
run_ci "$TR/state-d" "$BARE_D" "$FIX_D" "61=10"
[ "$(todo_count "$BARE_D")" -eq 0 ] && ok "no shepherd for a green PR" || bad "posted a shepherd for green CI"

# ============================================================================
hr; echo "E — bot PR with QUEUED/IN-PROGRESS CI → no shepherd (back off)"; hr
BARE_E="$TR/e.git"; seed_bare "$BARE_E"
FIX_E="$TR/fix-e.tsv"; prline 62 kriscendobot "$REPO" > "$FIX_E"
run_ci "$TR/state-e" "$BARE_E" "$FIX_E" "62=12"
[ "$(todo_count "$BARE_E")" -eq 0 ] && ok "no shepherd while CI is still settling (no premature/flaky dispatch)" || bad "posted a shepherd for in-progress CI"

# ============================================================================
hr; echo "F — bot PR whose head is NOT bot-pushable → no shepherd"; hr
BARE_F="$TR/f.git"; seed_bare "$BARE_F"
FIX_F="$TR/fix-f.tsv"; prline 63 kriscendobot "somerando/endo-but-for-bots" > "$FIX_F"
run_ci "$TR/state-f" "$BARE_F" "$FIX_F" "63=0"
[ "$(todo_count "$BARE_F")" -eq 0 ] && ok "no shepherd when the head branch is not bot-pushable" || bad "posted a shepherd for an un-pushable head"

# ============================================================================
hr; echo "G — a NON-bot repo slug → watcher exits at the is-bot-repo gate"; hr
BARE_G="$TR/g.git"; seed_bare "$BARE_G"
FIX_G="$TR/fix-g.tsv"; prline 1 kriscendobot "kriskowal/garden" > "$FIX_G"
run_ci "$TR/state-g" "$BARE_G" "$FIX_G" "1=0" kriskowal-garden
[ "$(todo_count "$BARE_G")" -eq 0 ] && ok "no shepherd on a non-bot repo (never autonomously drive upstream)" || bad "posted a shepherd on a non-bot repo"

# ============================================================================
hr; echo "H — mixed PR set → exactly the red bot PRs each get one shepherd"; hr
BARE_H="$TR/h.git"; seed_bare "$BARE_H"
FIX_H="$TR/fix-h.tsv"
{ prline 70 kriscendobot "$REPO"              # red bot → shepherd
  prline 71 kriscendobot "$REPO"              # green bot → none
  prline 72 kriscendobot "$REPO"              # pending bot → none
  prline 73 someone-else "$REPO"              # red foreign → none (author gate)
  prline 74 kriscendobot "$REPO"; } > "$FIX_H"   # red bot → shepherd
run_ci "$TR/state-h" "$BARE_H" "$FIX_H" "70=0 71=10 72=12 73=0 74=0"
board_has "$BARE_H" "$SLUG-pr70-shepherd" && ok "red bot PR #70 shepherded" || bad "#70 not shepherded"
board_has "$BARE_H" "$SLUG-pr74-shepherd" && ok "red bot PR #74 shepherded" || bad "#74 not shepherded"
board_has "$BARE_H" "$SLUG-pr71-shepherd" && bad "green #71 wrongly shepherded" || ok "green #71 not shepherded"
board_has "$BARE_H" "$SLUG-pr72-shepherd" && bad "pending #72 wrongly shepherded" || ok "pending #72 not shepherded"
board_has "$BARE_H" "$SLUG-pr73-shepherd" && bad "foreign #73 wrongly shepherded" || ok "foreign #73 not shepherded"
[ "$(todo_count "$BARE_H")" -eq 2 ] && ok "exactly two shepherd jobs for two red bot PRs" || bad "expected two jobs, got $(todo_count "$BARE_H")"

# ============================================================================
hr; echo "I — activity window skips a PR untouched beyond the window"; hr
BARE_I="$TR/i.git"; seed_bare "$BARE_I"
FIX_I="$TR/fix-i.tsv"
{ prline 90 kriscendobot "$REPO" "$FRESH_TS"     # fresh red → shepherd
  prline 91 kriscendobot "$REPO" "$STALE_TS"; } > "$FIX_I"   # stale red → skipped
run_ci_env "$TR/state-i" "$BARE_I" "$FIX_I" "90=0 91=0" "$SLUG" GARDEN_CI_ACTIVITY_WINDOW="3 days"
board_has "$BARE_I" "$SLUG-pr90-shepherd" && ok "fresh red PR #90 shepherded" || bad "#90 not shepherded"
board_has "$BARE_I" "$SLUG-pr91-shepherd" && bad "stale #91 wrongly shepherded (read despite being beyond the window)" || ok "stale #91 skipped before its rollup read"

# ============================================================================
hr; echo "J — unreadable-read cascade trips the circuit-breaker (abort the tail)"; hr
BARE_J="$TR/j.git"; seed_bare "$BARE_J"
FIX_J="$TR/fix-j.tsv"
{ prline 80 kriscendobot "$REPO" "$FRESH_TS"
  prline 81 kriscendobot "$REPO" "$FRESH_TS"
  prline 82 kriscendobot "$REPO" "$FRESH_TS"
  prline 83 kriscendobot "$REPO" "$FRESH_TS"
  prline 84 kriscendobot "$REPO" "$FRESH_TS"; } > "$FIX_J"   # #84 is RED but never reached
# rc=1 is not 0/10/11/12 → the *) unreadable fallthrough. Threshold 3 → abort at #82.
run_ci_env "$TR/state-j" "$BARE_J" "$FIX_J" "80=1 81=1 82=1 83=1 84=0" "$SLUG" \
  GARDEN_CI_ACTIVITY_WINDOW="3 days" GARDEN_CI_UNREADABLE_ABORT_THRESHOLD=3
[ "$(todo_count "$BARE_J")" -eq 0 ] && ok "cascade aborted before tail red #84 → no shepherd posted" || bad "posted a shepherd despite the rate-limit abort ($(todo_count "$BARE_J"))"

# ============================================================================
hr; echo "K — an early success disarms the breaker (no abort on later unreadables)"; hr
BARE_K="$TR/k.git"; seed_bare "$BARE_K"
FIX_K="$TR/fix-k.tsv"
{ prline 85 kriscendobot "$REPO" "$FRESH_TS"     # red success → reads_ok=1, shepherd
  prline 86 kriscendobot "$REPO" "$FRESH_TS"     # unreadable
  prline 87 kriscendobot "$REPO" "$FRESH_TS"     # unreadable
  prline 88 kriscendobot "$REPO" "$FRESH_TS"     # unreadable (>=threshold, but reads_ok>0)
  prline 89 kriscendobot "$REPO" "$FRESH_TS"; } > "$FIX_K"   # red success → shepherd, proves no abort
run_ci_env "$TR/state-k" "$BARE_K" "$FIX_K" "85=0 86=1 87=1 88=1 89=0" "$SLUG" \
  GARDEN_CI_ACTIVITY_WINDOW="3 days" GARDEN_CI_UNREADABLE_ABORT_THRESHOLD=3
board_has "$BARE_K" "$SLUG-pr85-shepherd" && ok "leading red #85 shepherded" || bad "#85 not shepherded"
board_has "$BARE_K" "$SLUG-pr89-shepherd" && ok "trailing red #89 still shepherded (breaker never armed after a success)" || bad "#89 not shepherded — breaker wrongly aborted after a successful read"

# ============================================================================
hr; echo "L — ci-rollup handler routes through gh_pr_view_retry (transient retried, definitive not)"; hr
# Stub the handler's gh binary (the GARDEN_GH seam gh_pr_view_retry honors): count
# invocations, emit a configured stderr, always fail. A transient signature (in
# GARDEN_TRANSIENT_GH_API_SIGNATURES) must retry to GARDEN_GH_API_ATTEMPTS; a
# definitive one must not retry at all. Backoff is pinned tiny so the loop is instant.
GHSTUB="$TR/gh-stub.sh"
cat > "$GHSTUB" <<'EOF'
#!/bin/bash
c="${GH_STUB_COUNT:?}"; n=$(( $(cat "$c" 2>/dev/null || echo 0) + 1 )); echo "$n" > "$c"
printf '%s\n' "$GH_STUB_STDERR" >&2
exit 1
EOF
chmod +x "$GHSTUB"
CNT="$TR/gh-count"
ROLLUP="$JOBS/handlers/ci-rollup-gh.sh"

# Transient TLS-handshake timeout → retried up to GARDEN_GH_API_ATTEMPTS (3), then
# falls through to exit 1 (the read never fabricates a green; the watcher skips).
: > "$CNT"; rc=0
env GARDEN_GH="$GHSTUB" GH_STUB_COUNT="$CNT" \
    GH_STUB_STDERR="Get \"https://api.github.com\": net/http: TLS handshake timeout" \
    GARDEN_GH_API_ATTEMPTS=3 GARDEN_BACKOFF_BASE_MS=1 GARDEN_BACKOFF_CAP_MS=2 \
    "$ROLLUP" "$REPO" 999 >/dev/null 2>&1 || rc=$?
[ "$(cat "$CNT")" -eq 3 ] && ok "transient TLS error retried to the budget (3 attempts)" || bad "expected 3 attempts, got $(cat "$CNT")"
[ "$rc" -eq 1 ] && ok "exhausted transient retry budget falls through to exit 1" || bad "expected exit 1 after retries, got $rc"

# Throttle (secondary rate limit) → now a TRANSIENT signature under the canonical
# absorber, so it is retried to the budget too (the old bespoke rate-limit exclusion
# is gone; a bounded, jittered budget cannot deepen a cooldown). Still exits 1.
: > "$CNT"; rc=0
env GARDEN_GH="$GHSTUB" GH_STUB_COUNT="$CNT" \
    GH_STUB_STDERR="You have exceeded a secondary rate limit (https://api.github.com)" \
    GARDEN_GH_API_ATTEMPTS=3 GARDEN_BACKOFF_BASE_MS=1 GARDEN_BACKOFF_CAP_MS=2 \
    "$ROLLUP" "$REPO" 999 >/dev/null 2>&1 || rc=$?
[ "$(cat "$CNT")" -eq 3 ] && ok "throttle retried to the budget under the canonical absorber (3 attempts)" || bad "expected 3 attempts, got $(cat "$CNT")"
[ "$rc" -eq 1 ] && ok "exhausted throttle retry budget falls through to exit 1" || bad "expected exit 1 after retries, got $rc"

# A definitive error (a real 404, matching NO transient signature) is NOT retried:
# exactly one attempt, then exit 1 fast + loud.
: > "$CNT"; rc=0
env GARDEN_GH="$GHSTUB" GH_STUB_COUNT="$CNT" \
    GH_STUB_STDERR="GraphQL: Could not resolve to a PullRequest (not found)" \
    GARDEN_GH_API_ATTEMPTS=3 GARDEN_BACKOFF_BASE_MS=1 GARDEN_BACKOFF_CAP_MS=2 \
    "$ROLLUP" "$REPO" 999 >/dev/null 2>&1 || rc=$?
[ "$(cat "$CNT")" -eq 1 ] && ok "definitive 404 NOT retried (single attempt)" || bad "expected 1 attempt, got $(cat "$CNT")"
[ "$rc" -eq 1 ] && ok "definitive error falls through to exit 1 immediately" || bad "expected exit 1, got $rc"

# A single transient blip that RECOVERS on retry is the whole point of the retry:
# the read must yield the REAL verdict, NOT a skip. Without the retry, one
# net/http TLS-handshake timeout (exactly what was logged for
# endojs-endo-but-for-bots#377) would exit 1 and drop the PR's CI verdict for the
# whole tick, missing the red-CI shepherd trigger. This stub fails GH_STUB_FAIL_TIMES
# times with a transient stderr, then succeeds emitting the configured rollup JSON.
RECOVER="$TR/gh-stub-recover.sh"
cat > "$RECOVER" <<'EOF'
#!/bin/bash
c="${GH_STUB_COUNT:?}"; n=$(( $(cat "$c" 2>/dev/null || echo 0) + 1 )); echo "$n" > "$c"
if [ "$n" -le "${GH_STUB_FAIL_TIMES:-1}" ]; then
  printf '%s\n' "$GH_STUB_STDERR" >&2
  exit 1
fi
printf '%s' "$GH_STUB_STDOUT"
exit 0
EOF
chmod +x "$RECOVER"

# Fail once (transient TLS timeout), then succeed with a COMPLETED-RED rollup:
# exactly 2 attempts (one retry), and the handler returns the RED verdict (exit 0,
# the shepherd trigger) — recovered, not skipped.
: > "$CNT"; rc=0
env GARDEN_GH="$RECOVER" GH_STUB_COUNT="$CNT" GH_STUB_FAIL_TIMES=1 \
    GH_STUB_STDERR="Get \"https://api.github.com\": net/http: TLS handshake timeout" \
    GH_STUB_STDOUT='{"state":"OPEN","statusCheckRollup":[{"status":"COMPLETED","conclusion":"FAILURE"}]}' \
    GARDEN_GH_API_ATTEMPTS=3 GARDEN_BACKOFF_BASE_MS=1 GARDEN_BACKOFF_CAP_MS=2 \
    "$ROLLUP" "$REPO" 999 >/dev/null 2>&1 || rc=$?
[ "$(cat "$CNT")" -eq 2 ] && ok "one transient blip then success → exactly 2 attempts (retried once, recovered)" || bad "expected 2 attempts, got $(cat "$CNT")"
[ "$rc" -eq 0 ] && ok "recovered read yields the REAL red verdict (exit 0 → shepherd), not a skip" || bad "expected exit 0 (RED) after recovery, got $rc"

# Same recovery, but the settled state is GREEN: proves the handler returns the
# ACTUAL parsed verdict (exit 10), not merely "some success". A skip would be exit 1.
: > "$CNT"; rc=0
env GARDEN_GH="$RECOVER" GH_STUB_COUNT="$CNT" GH_STUB_FAIL_TIMES=1 \
    GH_STUB_STDERR="Get \"https://api.github.com\": net/http: TLS handshake timeout" \
    GH_STUB_STDOUT='{"state":"OPEN","statusCheckRollup":[{"status":"COMPLETED","conclusion":"SUCCESS"}]}' \
    GARDEN_GH_API_ATTEMPTS=3 GARDEN_BACKOFF_BASE_MS=1 GARDEN_BACKOFF_CAP_MS=2 \
    "$ROLLUP" "$REPO" 999 >/dev/null 2>&1 || rc=$?
[ "$(cat "$CNT")" -eq 2 ] && ok "green recovery also retries exactly once (2 attempts)" || bad "expected 2 attempts, got $(cat "$CNT")"
[ "$rc" -eq 10 ] && ok "recovered read yields the REAL green verdict (exit 10), not a skip" || bad "expected exit 10 (GREEN) after recovery, got $rc"

# ============================================================================
hr
echo "TOTAL: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
