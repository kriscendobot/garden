#!/bin/bash
# issue-inbox-tick-bounds-test.sh — lock down the issue-inbox watcher's TICK
# BOUNDING (the 900s-SIGKILL fix).
#
# Live failure: the source fetch was already bounded, yet the watcher was SIGKILLed
# at the unit's 900s TimeoutStartSec — a DEGRADED journal made the OTHER blocking
# stages (config/maintainer/cursor journal reads, the post/message pushes, the verify
# re-fetch, the cursor advance) each burn their bounded retry budget, and their SUM
# in one tick crossed 900s. The fix adds (1) an overall tick BUDGET checked at every
# stage boundary that exits CLEANLY with a diagnostic and RETAINS the cursor, and
# (2) a per-stage `timeout` on every blocking external call so no single wedged stage
# runs away.
#
# Cases:
#   A. BUDGET ALREADY SPENT (GARDEN_ISSUE_TICK_BUDGET_SECS=0): a pending trusted issue
#      → the tick exits 0 CLEANLY (never SIGKILLed), dispatches NOTHING, logs the
#      deadline diagnostic, raises a throttled maintainer signal, and does NOT advance
#      the cursor (the interaction re-polls next tick).
#   B. PER-STAGE BOUND FIRES: a post stage that would sleep 30s is killed at the 2s
#      per-stage timeout → the tick finishes FAST (proving the bound fired), the post
#      is treated as LOST, the cursor is NOT advanced, and the tick still exits 0.
#   C. HEALTHY PATH UNAFFECTED: normal budget + instant stubs → the issue is posted
#      and the cursor advances (the bounding wrapper is transparent when nothing is
#      slow).
#   D. CURSOR TIMEOUT ALIGNMENT: cursor-get.sh holds the host-shared cursor-IO lock
#      with its OWN bounded wait (GARDEN_CURSOR_LOCK_WAIT). The blanket per-stage
#      timeout used to be SHORTER, so a wedged peer got the helper SIGKILLed at the
#      stage limit with rc=124 (a NOISY "cursor read failed … rc=124" WARN each tick)
#      before it could return its clean rc=75 temporary-unavailable skip. With the
#      cursor stages bounded by the LARGER GARDEN_ISSUE_CURSOR_TIMEOUT_SECS, a wedged
#      lock now resolves to the helper's own quiet rc=75 skip. The test FORCES the
#      wedge (holds the lock) with a short lock wait + a blanket bound below it and a
#      cursor bound above it, and asserts the quiet-skip path, not the rc=124 WARN.
#
# Hermetic: throwaway bare journal2, deterministic stubs, no GitHub/claude/network.
# Usage: issue-inbox-tick-bounds-test.sh
set -euo pipefail
export GARDEN_TEST=1
export GARDEN_EXPLICIT_ADDRESS_REQUIRED=0
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-iitb-test
REPO=kriskowal/garden
SLUG=kriskowal-garden
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }
reported=0
report_result() { hr; echo "RESULT: $PASS passed, $FAIL failed"; hr; reported=1; }
trap 'rc=$?; if [ "$reported" -eq 0 ]; then hr; echo "RESULT: $PASS passed, $FAIL failed (ABORTED, rc=$rc)"; hr; fi' EXIT

rm -rf "$TR"; mkdir -p "$TR"
export GARDEN_API_COOLDOWN_SECS=0
git_id=(-c user.name=test -c user.email=test@localhost)

seed_bare() {  # seed_bare <bare-path>
  local bare="$1" seed; seed="$(mktemp -d "$TR/seed.XXXXXX")"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada cursors entries inboxes
    for d in jobs/todo jobs/doin jobs/tada cursors entries inboxes; do touch "$d/.gitkeep"; done )
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"; git -C "$seed" push -q -u origin "$BRANCH"
  rm -rf "$seed"
}

# --- deterministic stubs ----------------------------------------------------
SRCSTUB="$TR/source-stub.sh"
cat > "$SRCSTUB" <<'EOF'
#!/bin/bash
cat "${IIW_FIXTURE:?set IIW_FIXTURE}"
EOF
REACTSTUB="$TR/react-stub.sh"
cat > "$REACTSTUB" <<'EOF'
#!/bin/bash
printf 'REACT %s %s\n' "$2" "$3" >> "${IIW_REACTLOG:-/dev/null}"; exit 0
EOF
MSGSTUB="$TR/msg-stub.sh"
cat > "$MSGSTUB" <<'EOF'
#!/bin/bash
printf 'MSG %s\n' "$1" >> "${IIW_MSGLOG:?set IIW_MSGLOG}"; exit 0
EOF
ALERTSTUB="$TR/alert-stub.sh"
cat > "$ALERTSTUB" <<'EOF'
#!/bin/bash
printf 'ALERT %s\n' "$1" >> "${IIW_ALERTLOG:?set IIW_ALERTLOG}"; exit 0
EOF
# A post stub that LANDS the job on the board (writes the real jobs/todo/<base>.md via
# a plain file drop in a throwaway clone it pushes), so verify_posted confirms — used
# by the healthy-path case. Kept simple: post-stub-land pushes a job file.
POSTLAND="$TR/post-land.sh"
cat > "$POSTLAND" <<EOF
#!/bin/bash
# \$1 = basename, \$2 = body-file; land jobs/todo/\$1.md on the bare so verify_posted holds.
set -e
printf 'POST %s\n' "\$1" >> "\${IIW_POSTLOG:?set IIW_POSTLOG}"
c="\$(mktemp -d)"
git clone -q --single-branch --branch "$BRANCH" "\$IIW_BARE" "\$c"
mkdir -p "\$c/jobs/todo"
cp "\$2" "\$c/jobs/todo/\$1.md"
git -C "\$c" ${git_id[*]} add -A
git -C "\$c" ${git_id[*]} commit -q -m "land \$1"
git -C "\$c" push -q origin "HEAD:$BRANCH"
rm -rf "\$c"
exit 0
EOF
# A post stub that SLEEPS 30s before doing anything, then writes a LATE sentinel — used
# by the per-stage-bound case: the 2s stage timeout must kill it before the sentinel.
POSTSLOW="$TR/post-slow.sh"
cat > "$POSTSLOW" <<'EOF'
#!/bin/bash
sleep 30
printf 'LATE %s\n' "$1" >> "${IIW_SENTINEL:?set IIW_SENTINEL}"
exit 0
EOF
chmod +x "$SRCSTUB" "$REACTSTUB" "$MSGSTUB" "$ALERTSTUB" "$POSTLAND" "$POSTSLOW"

ALLOW="$TR/allowlist"; printf 'kriskowal\n' > "$ALLOW"

cursor_seen() {  # cursor_seen <state-dir> <bare>
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
    "$JOBS/cursor-get.sh" "issues/$SLUG" | sed -n 's/^last_seen:[[:space:]]*//p' | head -1
}

row() { printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$@"; }

# ============================================================================
hr; echo "A — budget already spent → clean exit, no dispatch, diagnostic, cursor held"; hr
BARE_A="$TR/a.git"; seed_bare "$BARE_A"
FIX_A="$TR/fix-a.tsv"; PL_A="$TR/post-a.log"; ML_A="$TR/msg-a.log"; ERR_A="$TR/err-a.log"
AL_A="$TR/alert-a.log"; : >"$PL_A"; : >"$ML_A"; : >"$AL_A"
row issue 2026-09-21T10:00:00Z 900 40 kriskowal kriskowal open - - \
  https://github.com/kriskowal/garden/issues/40 'a pending issue' > "$FIX_A"
set +e
env GARDEN_STATE="$TR/state-a" JOURNAL_REMOTE="$BARE_A" JOURNAL_BRANCH="$BRANCH" \
    GARDEN=budgethost GARDEN_GARDEN_REPO="$REPO" GARDEN_MAINTAINERS_ALLOWLIST="$ALLOW" \
    GARDEN_ISSUE_TICK_BUDGET_SECS=0 \
    GARDEN_ALERT_CMD="$ALERTSTUB" IIW_ALERTLOG="$AL_A" \
    IIW_FIXTURE="$FIX_A" IIW_POSTLOG="$PL_A" IIW_MSGLOG="$ML_A" IIW_REACTLOG="$TR/react-a.log" \
    GARDEN_ISSUE_SOURCE="$SRCSTUB" GARDEN_ISSUE_REACTJI="$REACTSTUB" \
    GARDEN_ISSUE_POST="$POSTLAND" GARDEN_ISSUE_MSG="$MSGSTUB" \
    "$JOBS/issue-inbox-watcher.sh" >/dev/null 2>"$ERR_A"
rc_a=$?
set -e
[ "$rc_a" -eq 0 ] && ok "tick exited 0 (clean, not a SIGKILL/failure)" || bad "tick exited $rc_a"
[ ! -s "$PL_A" ] && [ ! -s "$ML_A" ] && ok "nothing dispatched when the budget was already spent" || bad "dispatched over budget (post=$(cat "$PL_A") msg=$(cat "$ML_A"))"
grep -qi 'tick budget .* exhausted before the batch' "$ERR_A" && ok "the deadline diagnostic is logged (before the batch)" || bad "no deadline diagnostic: $(tail -3 "$ERR_A")"
grep -q 'ALERT issue-inbox-tick-deadline' "$AL_A" && ok "a throttled maintainer signal was raised" || bad "no maintainer signal (alert=$(cat "$AL_A"))"
[ -z "$(cursor_seen "$TR/state-a" "$BARE_A")" ] && ok "cursor NOT advanced (interaction re-polls next tick)" || bad "cursor advanced over budget ($(cursor_seen "$TR/state-a" "$BARE_A"))"

# ============================================================================
hr; echo "B — per-stage bound fires: a 30s post is killed at the 2s stage timeout"; hr
BARE_B="$TR/b.git"; seed_bare "$BARE_B"
FIX_B="$TR/fix-b.tsv"; ML_B="$TR/msg-b.log"; ERR_B="$TR/err-b.log"; SENT_B="$TR/sentinel-b.log"
: >"$ML_B"; : >"$SENT_B"
row issue 2026-09-21T11:00:00Z 901 41 kriskowal kriskowal open - - \
  https://github.com/kriskowal/garden/issues/41 'an issue whose post will hang' > "$FIX_B"
t0=$(date +%s)
set +e
env GARDEN_STATE="$TR/state-b" JOURNAL_REMOTE="$BARE_B" JOURNAL_BRANCH="$BRANCH" \
    GARDEN=stagehost GARDEN_GARDEN_REPO="$REPO" GARDEN_MAINTAINERS_ALLOWLIST="$ALLOW" \
    GARDEN_NO_MAINTAINER_ALERT=1 \
    GARDEN_ISSUE_STAGE_TIMEOUT_SECS=2 GARDEN_ISSUE_KILL_AFTER=2s \
    IIW_FIXTURE="$FIX_B" IIW_POSTLOG="$TR/post-b.log" IIW_MSGLOG="$ML_B" \
    IIW_REACTLOG="$TR/react-b.log" IIW_SENTINEL="$SENT_B" \
    GARDEN_ISSUE_SOURCE="$SRCSTUB" GARDEN_ISSUE_REACTJI="$REACTSTUB" \
    GARDEN_ISSUE_POST="$POSTSLOW" GARDEN_ISSUE_MSG="$MSGSTUB" \
    "$JOBS/issue-inbox-watcher.sh" >/dev/null 2>"$ERR_B"
rc_b=$?
set -e
elapsed=$(( $(date +%s) - t0 ))
[ "$rc_b" -eq 0 ] && ok "tick exited 0 despite a hung post stage" || bad "tick exited $rc_b"
[ "$elapsed" -lt 20 ] && ok "tick finished fast (${elapsed}s « the 30s hang) — the per-stage bound fired" || bad "tick took ${elapsed}s (bound did not fire)"
[ ! -s "$SENT_B" ] && ok "the slow post was KILLED before it could complete (no LATE sentinel)" || bad "post ran to completion (sentinel=$(cat "$SENT_B"))"
grep -qi 'POST LOST' "$ERR_B" && ok "the killed post is treated as LOST" || bad "no POST LOST log: $(tail -3 "$ERR_B")"
[ -z "$(cursor_seen "$TR/state-b" "$BARE_B")" ] && ok "cursor NOT advanced past the lost post" || bad "cursor advanced past a killed post ($(cursor_seen "$TR/state-b" "$BARE_B"))"

# ============================================================================
hr; echo "C — healthy path unaffected: instant stubs → post + cursor advance"; hr
BARE_C="$TR/c.git"; seed_bare "$BARE_C"
FIX_C="$TR/fix-c.tsv"; PL_C="$TR/post-c.log"; ML_C="$TR/msg-c.log"; ERR_C="$TR/err-c.log"
: >"$PL_C"; : >"$ML_C"
row issue 2026-09-21T12:00:00Z 902 42 kriskowal kriskowal open - - \
  https://github.com/kriskowal/garden/issues/42 'a normal issue' > "$FIX_C"
set +e
env GARDEN_STATE="$TR/state-c" JOURNAL_REMOTE="$BARE_C" JOURNAL_BRANCH="$BRANCH" \
    GARDEN=okhost GARDEN_GARDEN_REPO="$REPO" GARDEN_MAINTAINERS_ALLOWLIST="$ALLOW" \
    GARDEN_NO_MAINTAINER_ALERT=1 IIW_BARE="$BARE_C" \
    IIW_FIXTURE="$FIX_C" IIW_POSTLOG="$PL_C" IIW_MSGLOG="$ML_C" IIW_REACTLOG="$TR/react-c.log" \
    GARDEN_ISSUE_SOURCE="$SRCSTUB" GARDEN_ISSUE_REACTJI="$REACTSTUB" \
    GARDEN_ISSUE_POST="$POSTLAND" GARDEN_ISSUE_MSG="$MSGSTUB" \
    "$JOBS/issue-inbox-watcher.sh" >/dev/null 2>"$ERR_C"
rc_c=$?
set -e
[ "$rc_c" -eq 0 ] && ok "healthy tick exited 0" || bad "tick exited $rc_c"
grep -q "POST issue-$SLUG-42" "$PL_C" && ok "the issue was posted (wrapper is transparent)" || bad "issue not posted (post=$(cat "$PL_C"); err=$(tail -3 "$ERR_C"))"
[ "$(cursor_seen "$TR/state-c" "$BARE_C")" = 2026-09-21T12:00:00Z ] && ok "cursor advanced past the dispatched issue" || bad "cursor not advanced ($(cursor_seen "$TR/state-c" "$BARE_C"))"

# ============================================================================
hr; echo "D — cursor stage timeout ALIGNS with the helper's own bounded lock wait"; hr
# Live failure: cursor-get.sh (and cursor-set.sh) hold the host-shared cursor-IO lock
# with an INTERNAL bounded wait (GARDEN_CURSOR_LOCK_WAIT). A wedged peer holding the
# lock made the helper block for that wait — but the BLANKET per-stage timeout, being
# SHORTER, SIGKILLed the helper first with rc=124, which the read side logs as a NOISY
# "cursor read failed … (rc=124)" WARN every tick, and the helper never reached its
# clean rc=75 temporary-unavailable skip. The fix wraps the cursor stages in a LARGER
# CURSOR_STAGE_TIMEOUT (GARDEN_ISSUE_CURSOR_TIMEOUT_SECS ≥ lock wait + grace).
#
# Here we FORCE the wedge: the test itself holds the cursor-IO lock, sets a SHORT lock
# wait (3s) and — critically — a blanket stage timeout (1s) SHORTER than that wait (the
# old guillotine) alongside a cursor timeout (10s) LONGER than it. Post-fix the helper
# rides its OWN 3s lock wait to a clean rc=75 quiet skip; pre-fix the blanket 1s bound
# would kill it at 1s → rc=124 → the loud WARN. Assertions key off exactly that split.
BARE_D="$TR/d.git"; seed_bare "$BARE_D"
FIX_D="$TR/fix-d.tsv"; PL_D="$TR/post-d.log"; ML_D="$TR/msg-d.log"; ERR_D="$TR/err-d.log"
: >"$PL_D"; : >"$ML_D"
row issue 2026-09-21T13:00:00Z 903 43 kriskowal kriskowal open - - \
  https://github.com/kriskowal/garden/issues/43 'an issue behind a wedged cursor lock' > "$FIX_D"
# Hold the host-shared cursor-IO lock the way a wedged peer would: flock the same file
# cursor_io_lock opens ($GARDEN_STATE/cursors/journal.cursor-io.lock).
CDIR_D="$TR/state-d/cursors/journal"; LOCKF_D="${CDIR_D}.cursor-io.lock"
mkdir -p "$(dirname "$LOCKF_D")"; : >"$LOCKF_D"
flock -x "$LOCKF_D" -c 'sleep 20' &
HOLDER_D=$!
# Wait until the holder actually owns the lock (a non-blocking probe fails while held).
for _ in 1 2 3 4 5 6 7 8 9 10; do
  if flock -n "$LOCKF_D" true 2>/dev/null; then sleep 0.2; else break; fi
done
t0=$(date +%s)
set +e
env GARDEN_STATE="$TR/state-d" JOURNAL_REMOTE="$BARE_D" JOURNAL_BRANCH="$BRANCH" \
    GARDEN=cursorhost GARDEN_GARDEN_REPO="$REPO" GARDEN_MAINTAINERS_ALLOWLIST="$ALLOW" \
    GARDEN_NO_MAINTAINER_ALERT=1 \
    GARDEN_CURSOR_LOCK_WAIT=3 \
    GARDEN_ISSUE_STAGE_TIMEOUT_SECS=1 GARDEN_ISSUE_CURSOR_TIMEOUT_SECS=10 GARDEN_ISSUE_KILL_AFTER=2s \
    IIW_FIXTURE="$FIX_D" IIW_POSTLOG="$PL_D" IIW_MSGLOG="$ML_D" IIW_REACTLOG="$TR/react-d.log" \
    GARDEN_ISSUE_SOURCE="$SRCSTUB" GARDEN_ISSUE_REACTJI="$REACTSTUB" \
    GARDEN_ISSUE_POST="$POSTLAND" GARDEN_ISSUE_MSG="$MSGSTUB" \
    "$JOBS/issue-inbox-watcher.sh" >/dev/null 2>"$ERR_D"
rc_d=$?
set -e
elapsed_d=$(( $(date +%s) - t0 ))
kill "$HOLDER_D" 2>/dev/null || true; wait "$HOLDER_D" 2>/dev/null || true
[ "$rc_d" -eq 0 ] && ok "tick exited 0 (quiet skip, not a crash)" || bad "tick exited $rc_d (err=$(tail -3 "$ERR_D"))"
grep -qi 'cursor-IO lock .* busy' "$ERR_D" \
  && ok "cursor-get reached its OWN bounded-wait skip (logged the busy lock)" \
  || bad "cursor-get did NOT reach its bounded wait — guillotined early? (err=$(tail -3 "$ERR_D"))"
grep -qi 'cursor read failed .*rc=124' "$ERR_D" \
  && bad "the blanket bound guillotined cursor-get (rc=124 WARN) — timeout NOT aligned" \
  || ok "no rc=124 guillotine WARN — the cursor stage outlives the helper's lock wait"
[ -z "$(cursor_seen "$TR/state-d" "$BARE_D")" ] \
  && ok "cursor NOT advanced (the tick skipped cleanly, re-polls next tick)" \
  || bad "cursor advanced despite the wedged lock ($(cursor_seen "$TR/state-d" "$BARE_D"))"
[ ! -s "$PL_D" ] && ok "nothing dispatched behind the wedged cursor lock" || bad "dispatched despite the skip (post=$(cat "$PL_D"))"

# ============================================================================
report_result
[ "$FAIL" -eq 0 ]
