#!/bin/bash
# reaper-gauntlet-handoff-test.sh — validate the DEFERRED gauntlet-stage doom notice.
#
# When the reaper dooms a `gauntlet:` STAGE with sig `requeue-exhausted` +
# `failure_classification: transient`, the staged-gauntlet driver (gauntlet.sh) will
# consume that held plan entry and re-post the stage under its bounded stage-retry
# budget — so surfacing a maintainer doom notice the instant the reaper parks it floods
# the inbox with alerts for a self-healing retry. The reaper therefore DEFERS the notice
# through a bounded handoff spool and surfaces it only if the supervisor does not consume
# the plan entry in time.
#
# Subtests (all hermetic; a local bare journal, no systemd/network):
#   1. DEFER    — a doomed transient gauntlet stage is PARKED (as always) but its notice
#                 is DEFERRED (no maintainer message yet) and SPOOLED to the handoff dir.
#   2. CONSUMED — once the supervisor removes the held plan entry, the next reaper tick
#                 DROPS the deferred notice silently: no maintainer noise. (Self-heal.)
#   3. TIMEOUT  — if the plan entry is NEVER consumed, once the handoff bound elapses the
#                 next tick SURFACES the notice and clears the spool.
#   4. CONTROL  — a NON-transient gauntlet-stage doom (no reap-now proof) is surfaced
#                 IMMEDIATELY, never deferred (the supervisor would not retry it either).
#   5. NON-GAUNTLET — a transient doom that is NOT a gauntlet stage is surfaced
#                 IMMEDIATELY (the deferral is gauntlet-only).
#
# Usage: reaper-gauntlet-handoff-test.sh

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-reaper-gauntlet-handoff-test
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Hermetic baseline: scrub any fleet GARDEN_*/JOURNAL_* a live gardener may have
# exported, so ONLY the throwaway $TR settings are authoritative.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true

rm -rf "$TR"; mkdir -p "$TR"
BARE="$TR/journal.git"
git_id=(-c user.name=test -c user.email=test@localhost)

# --- seed the shared origin -------------------------------------------------
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
# Doom on the FIRST reap so the test is deterministic.
export GARDEN_REAP_DOOM_THRESHOLD=1
export GARDEN_CLAIM_TTL=3600
HANDOFF_SPOOL="$TR/state/reaper/gauntlet-handoff-spool"

V="$TR/verify"
resync() { rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"; }
count_unread() { resync; ls -1 "$V/inbox/maintainer/unread" 2>/dev/null | grep -v -x '.gitkeep' | grep -c . || true; }

# Place a STALE claim in doin/<base>.md (claimed_at long past the TTL). Optional
# frontmatter `gauntlet: <g>` marks it a gauntlet stage; an optional reap-now body
# marker makes its final doom cycle transient-classified.
# place_stale <base> [gauntlet-base] [reap-now]
place_stale() {
  local base="$1" gbase="${2:-}" reap_now="${3:-}" wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  {
    printf -- '---\n'
    printf 'role: gardener\n'
    if [ -n "$gbase" ]; then
      printf 'gauntlet: %s\n' "$gbase"
      printf 'gauntlet_stage: panel\n'
    fi
    printf -- '---\n'
    printf '# %s\n\nthe original work body for %s\n\n' "$base" "$base"
    [ "$reap_now" = reap-now ] && printf '<!-- garden-reap-now -->\n'
    printf -- '---\nclaim:\n  host: testhost\n  gardener: 7\n  claimed_at: 2020-01-01T00:00:00Z\n'
  } > "$wt/jobs/doin/$base.md"
  printf 'worktree_dir: %s\n' "$TR/nonexistent-wt-$base" > "$wt/work/$base"
  git -C "$wt" add "jobs/doin/$base.md" "work/$base"
  git -C "$wt" "${git_id[@]}" commit -q -m "place stale $base"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}

# Simulate the gauntlet supervisor CONSUMING a held plan entry (git rm plan/<base>.md).
consume_plan() {
  local base="$1" wt; wt="$(mktemp -d "$TR/consume.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  git -C "$wt" rm -q "jobs/plan/$base.md"
  git -C "$wt" "${git_id[@]}" commit -q -m "supervisor consumed plan/$base"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}

run_reaper() { "$JOBS/reaper.sh" >"$TR/reap.log" 2>&1 || { echo "  (reaper.sh rc=$? — see below)"; sed 's/^/    /' "$TR/reap.log"; }; }

# ============================================================================
hr; echo "SUBTEST 1 — DEFER: a transient gauntlet-stage doom is parked, notice deferred + spooled"; hr
place_stale mygauntlet-panel-1 mygauntlet reap-now
run_reaper
resync

defer_ok=1
plan_file="$V/jobs/plan/mygauntlet-panel-1.md"
[ -f "$plan_file" ] || { defer_ok=0; echo "    plan entry missing (reap did not park it)"; }
if [ -f "$plan_file" ]; then
  grep -q '^doom_signature: requeue-exhausted$' "$plan_file" || { defer_ok=0; echo "    wrong signature"; }
  grep -q '^failure_classification: transient$' "$plan_file" || { defer_ok=0; echo "    not classified transient"; }
fi
# NO maintainer notice yet — it was deferred.
[ "$(count_unread)" -eq 0 ] || { defer_ok=0; echo "    a maintainer notice was surfaced (should be deferred), found $(count_unread)"; }
# It was spooled to the handoff dir instead.
spool_file="$HANDOFF_SPOOL/doomed-mygauntlet-panel-1-requeue-exhausted.md"
[ -f "$spool_file" ] || { defer_ok=0; echo "    handoff spool entry $spool_file missing"; }
if [ -f "$spool_file" ]; then
  grep -q '^base: mygauntlet-panel-1$' "$spool_file" || { defer_ok=0; echo "    spool entry missing base"; }
  grep -q '^gauntlet: mygauntlet$'     "$spool_file" || { defer_ok=0; echo "    spool entry missing gauntlet base"; }
  grep -q '^deferred_at: '             "$spool_file" || { defer_ok=0; echo "    spool entry missing deferred_at"; }
  grep -q 'the original work body for mygauntlet-panel-1' "$spool_file" || { defer_ok=0; echo "    spool entry body not preserved"; }
fi
grep -qi 'deferring doom notice for gauntlet stage' "$TR/reap.log" || { defer_ok=0; echo "    deferral not logged"; }
[ "$defer_ok" -eq 1 ] \
  && ok "transient gauntlet stage: parked, notice DEFERRED (0 messages) + SPOOLED to the handoff dir" \
  || bad "defer: plan=[$(ls "$V/jobs/plan" 2>/dev/null)] unread=$(count_unread) spool=[$(ls "$HANDOFF_SPOOL" 2>/dev/null)]"

# ============================================================================
hr; echo "SUBTEST 2 — CONSUMED: the supervisor consumes the plan entry → deferred notice dropped silently"; hr
consume_plan mygauntlet-panel-1
run_reaper   # no new stale claims; drain resolves the spool
resync

consumed_ok=1
[ -f "$spool_file" ] && { consumed_ok=0; echo "    spool entry still present after consumption"; }
[ "$(count_unread)" -eq 0 ] || { consumed_ok=0; echo "    a notice surfaced despite self-heal, found $(count_unread)"; }
grep -qi 'consumed by the gauntlet supervisor' "$TR/reap.log" || { consumed_ok=0; echo "    self-heal drop not logged"; }
[ "$consumed_ok" -eq 1 ] \
  && ok "plan entry consumed by supervisor: deferred notice DROPPED silently (no maintainer noise)" \
  || bad "consumed: spool=[$(ls "$HANDOFF_SPOOL" 2>/dev/null)] unread=$(count_unread)"

# ============================================================================
hr; echo "SUBTEST 3 — TIMEOUT: an unconsumed plan entry surfaces the notice once the bound elapses"; hr
place_stale stuckgauntlet-panel-1 stuckgauntlet reap-now
run_reaper
resync
tspool="$HANDOFF_SPOOL/doomed-stuckgauntlet-panel-1-requeue-exhausted.md"
[ -f "$tspool" ] || bad "timeout-setup: expected a spooled handoff for stuckgauntlet-panel-1"
[ "$(count_unread)" -eq 0 ] || bad "timeout-setup: unexpected notice before the bound elapsed"
# Age the deferral past the bound WITHOUT consuming the plan entry (deterministic:
# rewrite deferred_at to the distant past so the drain sees it as expired).
if [ -f "$tspool" ]; then
  sed -i 's/^deferred_at: .*/deferred_at: 2020-01-01T00:00:00Z/' "$tspool"
fi
run_reaper   # plan still parked, deferral now expired → surface
resync

timeout_ok=1
[ -f "$tspool" ] && { timeout_ok=0; echo "    spool entry not cleared after surfacing"; }
notice="$V/inbox/maintainer/unread/doomed-stuckgauntlet-panel-1-requeue-exhausted.md"
[ -f "$notice" ] || { timeout_ok=0; echo "    deferred notice was not surfaced after the bound"; }
grep -qi 'still parked after' "$TR/reap.log" || { timeout_ok=0; echo "    timeout surface not logged"; }
[ "$timeout_ok" -eq 1 ] \
  && ok "plan entry never consumed: notice SURFACED once the handoff bound elapsed, spool cleared" \
  || bad "timeout: spool=[$(ls "$HANDOFF_SPOOL" 2>/dev/null)] unread=[$(ls "$V/inbox/maintainer/unread" 2>/dev/null)]"

# ============================================================================
hr; echo "SUBTEST 4 — CONTROL: a NON-transient gauntlet-stage doom surfaces immediately"; hr
# Same gauntlet-stage shape but NO reap-now proof → failure_classification is NOT
# transient, so the gauntlet would not retry it: surface immediately, never defer.
place_stale coldgauntlet-panel-1 coldgauntlet
run_reaper
resync

control_ok=1
cspool="$HANDOFF_SPOOL/doomed-coldgauntlet-panel-1-requeue-exhausted.md"
[ -f "$cspool" ] && { control_ok=0; echo "    a non-transient gauntlet doom was wrongly deferred/spooled"; }
[ -f "$V/inbox/maintainer/unread/doomed-coldgauntlet-panel-1-requeue-exhausted.md" ] \
  || { control_ok=0; echo "    non-transient gauntlet doom notice not surfaced immediately"; }
[ "$control_ok" -eq 1 ] \
  && ok "non-transient gauntlet stage: doom notice surfaced IMMEDIATELY (not deferred)" \
  || bad "control: spool=[$(ls "$HANDOFF_SPOOL" 2>/dev/null)] unread=[$(ls "$V/inbox/maintainer/unread" 2>/dev/null)]"

# ============================================================================
hr; echo "SUBTEST 5 — NON-GAUNTLET: a transient doom that is not a gauntlet stage surfaces immediately"; hr
place_stale plainjob "" reap-now
run_reaper
resync

plain_ok=1
pspool="$HANDOFF_SPOOL/doomed-plainjob-requeue-exhausted.md"
[ -f "$pspool" ] && { plain_ok=0; echo "    a non-gauntlet transient doom was wrongly deferred/spooled"; }
[ -f "$V/inbox/maintainer/unread/doomed-plainjob-requeue-exhausted.md" ] \
  || { plain_ok=0; echo "    non-gauntlet transient doom notice not surfaced immediately"; }
[ "$plain_ok" -eq 1 ] \
  && ok "non-gauntlet transient doom: surfaced IMMEDIATELY (deferral is gauntlet-only)" \
  || bad "non-gauntlet: spool=[$(ls "$HANDOFF_SPOOL" 2>/dev/null)] unread=[$(ls "$V/inbox/maintainer/unread" 2>/dev/null)]"

# ============================================================================
hr
echo "RESULTS: $PASS passed, $FAIL failed"
hr
[ "$FAIL" -eq 0 ]
