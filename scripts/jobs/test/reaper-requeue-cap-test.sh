#!/bin/bash
# reaper-requeue-cap-test.sh — validate the reaper's per-tick requeue cap that
# STAGGERS a burst (kriskowal 2026-07-28): a restart cycle can orphan dozens of
# claims within minutes of each other, so a single tick must NOT dump the whole
# burst into todo/ at once (the pool re-claims them together and the herd re-forms).
# The cap bounds how many AGE-EXPIRED claims one tick requeues, draining a large
# backlog over successive ticks — oldest-first, nothing dropped, and NEVER reaping a
# claim earlier than the age floor already requires.
#
# Subtests (all hermetic; no systemd, no network — a local bare journal):
#   1. DRAIN      — a stale set LARGER than the cap drains across successive ticks,
#                   OLDEST FIRST (deterministic, independent of basename order), each
#                   tick moving exactly `cap`, with NONE dropped and a below-floor
#                   young claim never touched. The no-silent-caps log line is asserted.
#   2. INVARIANT  — the cap only ever DELAYS: with a cap far larger than the backlog
#                   the floor still governs, and a claim younger than the age floor is
#                   NEVER requeued — the cap can only remove items from the already-
#                   floored reap set, never reap one earlier than today's code would.
#   3. REAP-NOW   — a reap-now-hinted claim (known-dead, TTL-bypassing) is EXEMPT from
#                   the cap: it is requeued this tick ON TOP of the capped age-expired
#                   selection, without consuming the age-expired budget.
#
# Usage: reaper-requeue-cap-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-reaper-cap-test
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Hermetic baseline: scrub any fleet GARDEN_*/JOURNAL_* the caller exported.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true

rm -rf "$TR"; mkdir -p "$TR"
BARE="$TR/journal.git"
git_id=(-c user.name=test -c user.email=test@localhost)

git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan work \
           inbox/maintainer/unread inbox/maintainer/read
  for d in jobs/todo jobs/doin jobs/tada jobs/plan work \
           inbox/maintainer/unread inbox/maintainer/read; do touch "$d/.gitkeep"; done )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: board structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$TR/state"
export GARDEN_POST_ATTEMPTS=50 GARDEN_REAP_PUSH_ATTEMPTS=50
# Never doom during this test — we exercise the cap/defer decision, not doom.
export GARDEN_REAP_DOOM_THRESHOLD=99 GARDEN_REAP_OVERRUN_THRESHOLD=99
# The handler wall the reaper's floor derives from: floor = 2400+60+30 = 2490s.
export GARDEN_HANDLER_TIMEOUT=2400 GARDEN_HANDLER_KILL_AFTER=60 GARDEN_REAP_SAFETY_SLACK=30
# TTL 3600 > floor 2490, so the reap threshold is 3600: only claims older than
# 3600s are stale. Aged fixtures use 4000s+; the below-floor young one uses 3000s.
export GARDEN_CLAIM_TTL=3600

V="$TR/verify"
resync() { rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"; }
ts_ago() { date -u -d "@$(( $(date -u +%s) - $1 ))" +%FT%TZ; }
# board_set <todo|doin|plan> — the sorted, space-joined base names in that category.
board_set() {
  ls -1 "$V/jobs/$1" 2>/dev/null | grep -v -x '.gitkeep' | sed 's/\.md$//' | sort \
    | tr '\n' ' ' | sed 's/ *$//'
}

# place_claim <base> <age-seconds> [reapnow] — a stale claim in doin/<base>.md aged
# `age` seconds. The optional third arg `reapnow` stamps the gardener reap-now hint.
place_claim() {
  local base="$1" age="$2" opt="${3:-}" wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  {
    printf '# %s\n\nthe original work body for %s\n\n' "$base" "$base"
    [ "$opt" = reapnow ] && printf -- '<!-- garden-reap-now -->\n\n'
    printf -- '---\nclaim:\n  host: testhost\n  gardener: 7\n  claimed_at: %s\n' "$(ts_ago "$age")"
  } > "$wt/jobs/doin/$base.md"
  printf 'worktree_dir: %s\n' "$TR/nonexistent-wt-$base" > "$wt/work/$base"
  git -C "$wt" add "jobs/doin/$base.md" "work/$base"
  git -C "$wt" "${git_id[@]}" commit -q -m "place $base"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}

# clear_board — reset jobs/{todo,doin,plan} to empty between subtests.
clear_board() {
  local wt; wt="$(mktemp -d "$TR/clear.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  ( cd "$wt"
    git rm -q -r --ignore-unmatch jobs/todo jobs/doin jobs/plan work >/dev/null 2>&1 || true
    mkdir -p jobs/todo jobs/doin jobs/plan work
    for d in jobs/todo jobs/doin jobs/plan work; do touch "$d/.gitkeep"; done
    git add -A
    git "${git_id[@]}" commit -q -m "clear board" >/dev/null 2>&1 || true
    git push -q origin "HEAD:$BRANCH" )
  rm -rf "$wt"
}

run_reaper() { "$JOBS/reaper.sh" >"$TR/reap.log" 2>&1 || { echo "  (reaper.sh rc=$? — see below)"; sed 's/^/    /' "$TR/reap.log"; }; }

# ============================================================================
hr; echo "SUBTEST 1 — DRAIN: a burst larger than the cap drains oldest-first across ticks"; hr
export GARDEN_REAP_MAX_PER_TICK=3
# Seven aged claims (all past the 3600s threshold) whose basename order is
# DELIBERATELY UNCORRELATED with age, so a correct oldest-first sort is
# distinguishable from an accidental basename sort. Plus one below-floor young
# claim that must NEVER be reaped.
#   base     age    oldest-first rank
#   bravo    4600   1
#   foxtrot  4500   2
#   delta    4400   3
#   golf     4300   4
#   alpha    4200   5
#   echo     4100   6
#   charlie  4000   7
place_claim alpha   4200
place_claim bravo   4600
place_claim charlie 4000
place_claim delta   4400
place_claim echo    4100
place_claim foxtrot 4500
place_claim golf    4300
place_claim young   3000    # below the 3600s floor — never eligible

# --- tick 1: the 3 oldest (bravo, foxtrot, delta) requeue; 4 defer; young held ---
run_reaper; resync
t1_ok=1
[ "$(board_set todo)" = "bravo delta foxtrot" ] || { t1_ok=0; echo "    tick1 todo=[$(board_set todo)] expected [bravo delta foxtrot]"; }
[ "$(board_set doin)" = "alpha charlie echo golf young" ] || { t1_ok=0; echo "    tick1 doin=[$(board_set doin)] expected [alpha charlie echo golf young]"; }
grep -qi 'requeue cap: 7 age-expired' "$TR/reap.log" || { t1_ok=0; echo "    tick1 no 'requeue cap: 7 age-expired' log"; }
grep -qi 'deferring 4 younger' "$TR/reap.log"         || { t1_ok=0; echo "    tick1 no 'deferring 4 younger' log (silent cap!)"; }
[ "$t1_ok" -eq 1 ] \
  && ok "tick 1: 3 oldest (bravo,foxtrot,delta) requeued, 4 deferred (logged), young held below the floor" \
  || bad "tick1 drain"

# --- tick 2: the next 3 oldest (golf, alpha, echo) requeue; charlie defers ---
run_reaper; resync
t2_ok=1
[ "$(board_set todo)" = "alpha bravo delta echo foxtrot golf" ] || { t2_ok=0; echo "    tick2 todo=[$(board_set todo)]"; }
[ "$(board_set doin)" = "charlie young" ] || { t2_ok=0; echo "    tick2 doin=[$(board_set doin)] expected [charlie young]"; }
[ "$t2_ok" -eq 1 ] \
  && ok "tick 2: next 3 oldest (golf,alpha,echo) requeued; charlie still deferred; young held" \
  || bad "tick2 drain"

# --- tick 3: the last aged claim (charlie) requeues; only young remains ---
run_reaper; resync
t3_ok=1
[ "$(board_set todo)" = "alpha bravo charlie delta echo foxtrot golf" ] || { t3_ok=0; echo "    tick3 todo=[$(board_set todo)]"; }
[ "$(board_set doin)" = "young" ] || { t3_ok=0; echo "    tick3 doin=[$(board_set doin)] expected [young]"; }
# NONE dropped: all 7 aged accounted for in todo, none vanished.
naged="$(board_set todo | tr ' ' '\n' | grep -cvx young || true)"
[ "$naged" -eq 7 ] || { t3_ok=0; echo "    only $naged/7 aged claims survived the drain (some dropped!)"; }
[ "$t3_ok" -eq 1 ] \
  && ok "tick 3: last aged (charlie) requeued; all 7 drained none-dropped; young NEVER reaped (below floor)" \
  || bad "tick3 drain"

# ============================================================================
hr; echo "SUBTEST 2 — INVARIANT: the cap only delays; the floor still governs (never reap earlier)"; hr
clear_board
# A cap far larger than the backlog: the cap never engages, so reaping is governed
# purely by the age floor. The old claim reaps; the below-floor young one does not —
# proving the cap layer can only ever remove from the already-floored set, never add.
export GARDEN_REAP_MAX_PER_TICK=99
place_claim keep-old   5000
place_claim keep-young 3000    # below the 3600s floor
run_reaper; resync
inv_ok=1
[ "$(board_set todo)" = "keep-old" ]   || { inv_ok=0; echo "    todo=[$(board_set todo)] expected [keep-old]"; }
[ "$(board_set doin)" = "keep-young" ] || { inv_ok=0; echo "    doin=[$(board_set doin)] expected [keep-young]"; }
# The cap did not engage (no deferral), yet the young claim is still held — by the
# floor, exactly as today's code requires — so no claim was reaped earlier than before.
grep -qi 'requeue cap:.*deferring' "$TR/reap.log" && { inv_ok=0; echo "    cap deferred with a 99 cap — should not engage"; }
[ "$inv_ok" -eq 1 ] \
  && ok "with a huge cap the floor governs: 'keep-old' reaped, below-floor 'keep-young' still held (never reaped earlier)" \
  || bad "invariant"

# ============================================================================
hr; echo "SUBTEST 3 — REAP-NOW: a reap-now hint is cap-exempt (requeued on top of the cap)"; hr
clear_board
export GARDEN_REAP_MAX_PER_TICK=2
# Four aged claims plus one reap-now-hinted claim (age 100 — below the floor, but the
# hint bypasses the TTL by design). The cap keeps the 2 OLDEST aged (r4=5300, r3=5200);
# r1/r2 defer. The reap-now claim is requeued THIS tick regardless, WITHOUT consuming
# the age-expired budget (still exactly 2 aged reaped).
place_claim r1 5000
place_claim r2 5100
place_claim r3 5200
place_claim r4 5300
place_claim urgent 100 reapnow
run_reaper; resync
rn_ok=1
[ "$(board_set todo)" = "r3 r4 urgent" ] || { rn_ok=0; echo "    todo=[$(board_set todo)] expected [r3 r4 urgent]"; }
[ "$(board_set doin)" = "r1 r2" ]        || { rn_ok=0; echo "    doin=[$(board_set doin)] expected [r1 r2]"; }
grep -qi 'reap-now-hinted claim(s) requeued this tick (cap-exempt' "$TR/reap.log" \
  || { rn_ok=0; echo "    no cap-exempt reap-now log line"; }
grep -qi 'deferring 2 younger' "$TR/reap.log" || { rn_ok=0; echo "    aged cap did not defer the expected 2 (reap-now consumed the budget?)"; }
[ "$rn_ok" -eq 1 ] \
  && ok "reap-now 'urgent' requeued this tick on TOP of the 2-oldest aged cap (r3,r4); r1,r2 deferred — hint is cap-exempt" \
  || bad "reap-now exempt"

# ============================================================================
hr
echo "RESULTS: $PASS passed, $FAIL failed"
hr
[ "$FAIL" -eq 0 ]
