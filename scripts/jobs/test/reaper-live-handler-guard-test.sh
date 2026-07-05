#!/bin/bash
# reaper-live-handler-guard-test.sh — validate the reaper's two-writers-in-one-
# worktree guard (data-corruption class). The reaper must never requeue a claim
# whose handler could still be alive:
#
#   1. FLOOR      — with GARDEN_CLAIM_TTL misconfigured BELOW the handler wall, a
#                   claim younger than the handler's MAXIMUM lifetime (the default
#                   GARDEN_HANDLER_TIMEOUT + kill-after + slack) is NOT reaped, even
#                   though its age already exceeds the (too-low) GARDEN_CLAIM_TTL.
#                   Past that safe floor it IS reaped. This is the invariant
#                   re-derived at reap time so a bad TTL cannot requeue a live handler.
#   2. HEADER     — a job carrying a longer `handler-timeout:` header raises the
#                   floor accordingly: a claim past the default wall but within the
#                   declared budget is still NOT reaped.
#   3. LIVE-GUARD — a claim past the floor whose handler subtree is STILL ALIVE on
#                   this host is DEFERRED (left in doin, not requeued) and the live
#                   process is KILLED — so a re-claim can never re-enter the worktree
#                   under a second live writer.
#
# Usage: reaper-live-handler-guard-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-reaper-live-guard-test
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
# Never poison during this test — we exercise the requeue/defer decision, not poison.
export GARDEN_REAP_POISON_THRESHOLD=99 GARDEN_REAP_OVERRUN_THRESHOLD=99
# The handler wall the reaper's floor derives from.
export GARDEN_HANDLER_TIMEOUT=2400 GARDEN_HANDLER_KILL_AFTER=60 GARDEN_REAP_SAFETY_SLACK=30
# The safe floor is therefore 2400+60+30 = 2490s, regardless of GARDEN_CLAIM_TTL.

V="$TR/verify"
resync() { rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"; }
ts_ago() { date -u -d "@$(( $(date -u +%s) - $1 ))" +%FT%TZ; }

# place_claim <base> <age-seconds> [handler-timeout-header]
place_claim() {
  local base="$1" age="$2" hdr="${3:-}" wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  {
    printf '# %s\n\n' "$base"
    [ -n "$hdr" ] && printf 'handler-timeout: %s\n\n' "$hdr"
    printf 'the original work body for %s\n\n' "$base"
    printf -- '---\nclaim:\n  host: testhost\n  gardener: 7\n  claimed_at: %s\n' "$(ts_ago "$age")"
  } > "$wt/jobs/doin/$base.md"
  printf 'worktree_dir: %s\n' "$TR/nonexistent-wt-$base" > "$wt/work/$base"
  git -C "$wt" add "jobs/doin/$base.md" "work/$base"
  git -C "$wt" "${git_id[@]}" commit -q -m "place claim $base"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}
run_reaper() { "$JOBS/reaper.sh" >"$TR/reap.log" 2>&1 || { echo "  (reaper.sh rc=$? — see below)"; sed 's/^/    /' "$TR/reap.log"; }; }

# ============================================================================
hr; echo "SUBTEST 1 — FLOOR: a bad-low GARDEN_CLAIM_TTL cannot reap a still-live handler"; hr
export GARDEN_CLAIM_TTL=600     # MISCONFIGURED: below the 2490s safe floor
# 'young' aged 700s: past TTL(600) but below the floor(2490) — handler could still be alive.
# 'old'   aged 3000s: past the floor — handler is guaranteed dead.
place_claim young 700
place_claim old 3000
run_reaper
resync
floor_ok=1
[ -f "$V/jobs/doin/young.md" ] || { floor_ok=0; echo "    young was reaped out of doin below the floor"; }
[ -f "$V/jobs/todo/young.md" ] && { floor_ok=0; echo "    young leaked into todo below the floor"; }
[ -f "$V/jobs/todo/old.md" ]   || { floor_ok=0; echo "    old was NOT requeued past the floor"; }
[ -f "$V/jobs/doin/old.md" ]   && { floor_ok=0; echo "    old still stuck in doin past the floor"; }
[ "$floor_ok" -eq 1 ] \
  && ok "below the safe floor 'young' stays in doin; past it 'old' is requeued (bad TTL cannot double-write)" \
  || bad "floor: doin=[$(ls "$V/jobs/doin" 2>/dev/null)] todo=[$(ls "$V/jobs/todo" 2>/dev/null)]"

# ============================================================================
hr; echo "SUBTEST 2 — HEADER: a longer handler-timeout raises the floor above TTL"; hr
export GARDEN_CLAIM_TTL=3600    # correctly configured for the default wall
# Both aged 3610s (just past TTL). 'plain' has the default floor 2490 < TTL, so at
# age 3610 ≥ TTL it IS reaped. 'longjob' declares handler-timeout:3539 (the max a
# 3600s claim can hold), raising its floor to 3539+60+30 = 3629 > 3610, so it is
# NOT reaped yet — the reaper respects the job's own declared handler budget.
place_claim plain 3610
place_claim longjob 3610 3539
run_reaper
resync
hdr_ok=1
[ -f "$V/jobs/todo/plain.md" ]   || { hdr_ok=0; echo "    plain (default floor) was NOT reaped at age 3610 ≥ TTL"; }
[ -f "$V/jobs/doin/longjob.md" ] || { hdr_ok=0; echo "    longjob reaped before its declared budget elapsed"; }
[ -f "$V/jobs/todo/longjob.md" ] && { hdr_ok=0; echo "    longjob requeued before its declared budget"; }
[ "$hdr_ok" -eq 1 ] \
  && ok "at the same age past TTL, 'plain' is reaped but 'longjob' (handler-timeout:3539) is held (floor tracks the declared budget)" \
  || bad "header: doin=[$(ls "$V/jobs/doin" 2>/dev/null)] todo=[$(ls "$V/jobs/todo" 2>/dev/null)]"

# ============================================================================
hr; echo "SUBTEST 3 — LIVE-GUARD: a live handler past the floor is killed + deferred"; hr
export GARDEN_CLAIM_TTL=600     # low again so age alone would reap
# A fake handler process whose argv carries the doin job file — exactly what the
# reaper's liveness probe keys on. The trailing `:` defeats bash's single-command
# exec optimization, so this process KEEPS the job-file path in its own argv (a
# bare `sleep` would exec away and drop it). It outlives the reaper's kill grace;
# the reaper must SIGTERM/SIGKILL it and DEFER the requeue.
place_claim live 3000          # past the floor, so age would ordinarily reap it
FAKE_DOIN="$TR/fleet/jobs/doin/live.md"
bash -c 'sleep 120; :' handler "$FAKE_DOIN" &
FAKE_PID=$!
# ensure the process is up and visible in ps before the reaper scans
for _ in 1 2 3 4 5; do kill -0 "$FAKE_PID" 2>/dev/null && break; sleep 0.2; done
run_reaper
resync
guard_ok=1
[ -f "$V/jobs/doin/live.md" ] || { guard_ok=0; echo "    'live' was requeued despite a live handler (DOUBLE-WRITE HOLE)"; }
[ -f "$V/jobs/todo/live.md" ] && { guard_ok=0; echo "    'live' leaked into todo despite a live handler"; }
# the fake handler must have been killed by the guard
if kill -0 "$FAKE_PID" 2>/dev/null; then
  guard_ok=0; echo "    the live handler process ($FAKE_PID) survived the guard"
  kill -KILL "$FAKE_PID" 2>/dev/null || true
fi
grep -qi 'LIVE handler subtree is still running' "$TR/reap.log" || { guard_ok=0; echo "    reaper did not log the live-handler anomaly"; }
[ "$guard_ok" -eq 1 ] \
  && ok "'live' deferred in doin (not requeued) and its live handler killed — no second writer possible" \
  || bad "live-guard: doin=[$(ls "$V/jobs/doin" 2>/dev/null)] todo=[$(ls "$V/jobs/todo" 2>/dev/null)]"
wait "$FAKE_PID" 2>/dev/null || true

hr
echo "RESULTS: $PASS passed, $FAIL failed"
hr
[ "$FAIL" -eq 0 ]
