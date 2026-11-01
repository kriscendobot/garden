#!/bin/bash
# unblock-post-loop-deadline-test.sh — the wall-clock deadline on unblock.sh's
# push-CAS retry loops (improve-unblock-post-loop-deadline).
#
# unblock.sh pushes through two loops: hold_failed (flip a plan whose blocker
# declined to gate=blocked-failed) and promote-plan.sh --unblock (plan → todo).
# Both ran up to GARDEN_POST_ATTEMPTS (50) attempts with no wall-clock bound, so
# a journal that fetches but cannot be pushed to kept the tick, and the producer
# clone lock promote-plan.sh holds, busy for tens of minutes. Both now check
# post_deadline_exceeded (common.sh) at the top of each attempt and exit
# GARDEN_OFFLINE_RC once GARDEN_POST_DEADLINE_SECS has passed; unblock.sh ends
# its tick on that rc instead of trying every remaining plan against the same
# remote.
#
# Asserts:
#   1. Hold path, deadline already blown: rc=75, plan left gate=blocked.
#   2. Hold path, unreachable push remote with a 50-attempt budget: rc=75
#      within seconds, deadline logged, plan left gate=blocked.
#   3. Promote path, unreachable push remote: rc=75 within seconds, the plan
#      stays parked, and the tick stops at the first plan (the second blocked
#      plan is never attempted).
#   4. The producer clone is free afterwards: a normal post goes through.
#   5. Healthy journal: the hold lands and both promotions land.
#
# Hermetic: a throwaway bare journal; no real garden, journal, or network.
#
# Usage: unblock-post-loop-deadline-test.sh

# shellcheck disable=SC2015,SC2046
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/unblock-post-loop-deadline-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

# Scrub any ambient fleet GARDEN_*/JOURNAL_* so a live gardener invoking this test
# cannot splice the real journal under it (the run-test.sh isolation rationale).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true

# --- throwaway journal ------------------------------------------------------
# blocker-declined completed with the declined marker (→ hold path);
# blocker-done completed cleanly (→ promote path).
BARE="$TR/journal.git"; git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
( cd "$SEED" || exit 1
  mkdir -p jobs/plan jobs/todo jobs/doin jobs/tada/2026/11/01 jobs/index
  touch jobs/plan/.gitkeep jobs/todo/.gitkeep jobs/doin/.gitkeep jobs/index/.gitkeep
  printf -- '---\norchestration-failed: true\n---\nrefused to merge\n' \
    > jobs/tada/2026/11/01/blocker-declined.md
  printf -- '---\n---\nmerged\n' > jobs/tada/2026/11/01/blocker-done.md
  printf -- '---\ngate: blocked\nblocked_on: blocker-declined\n---\nheld work\n' \
    > jobs/plan/held-plan.md
  printf -- '---\ngate: blocked\nblocked_on: blocker-done\n---\nfirst work\n' \
    > jobs/plan/promo-a.md
  printf -- '---\ngate: blocked\nblocked_on: blocker-done\n---\nsecond work\n' \
    > jobs/plan/promo-b.md
  git add -A
  git -c user.name=test -c user.email=test@localhost commit -q -m seed
  git remote add origin "$BARE"
  git push -q -u origin journal2 )

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
       GARDEN_STATE="$TR/state" GARDEN_PRODUCER_CLONE="$TR/state/producer/journal" \
       GARDEN_UNBLOCK_CLONE="$TR/state/unblock/journal" \
       GARDEN=idhost GARDEN_ROLE=gardener GARDEN_NO_MAINTAINER_ALERT=1

# A push remote that cannot be reached: fetches still work, every push fails
# with a connectivity error.
cat > "$TR/push-unreachable.sh" <<'EOF'
#!/bin/sh
echo "fatal: unable to access 'https://github.com/x/garden.git/': Could not resolve host: github.com" >&2
exit 128
EOF
chmod +x "$TR/push-unreachable.sh"

tree()      { git -C "$BARE" ls-tree -r --name-only journal2; }
has_todo()  { tree | grep -qx "jobs/todo/$1.md"; }
has_plan()  { tree | grep -qx "jobs/plan/$1.md"; }
plan_gate_of() { git -C "$BARE" show "journal2:jobs/plan/$1.md" 2>/dev/null | sed -n 's/^gate: *//p'; }

echo "================================================================"
echo "UNBLOCK POST-LOOP WALL-CLOCK DEADLINE"
echo "================================================================"

# The hold path runs first (held-plan sorts before promo-*), so cases 1-2 exit
# there; case 3 isolates the promote path by withdrawing held-plan's edge.

# --- 1: hold path, deadline already blown ----------------------------------
GARDEN_POST_DEADLINE_SECS=0 "$JOBS/unblock.sh" > "$TR/c1.out" 2>&1
rc=$?
[ "$rc" -eq 75 ] && ok "1a unblock.sh hold bailed with GARDEN_OFFLINE_RC (75)" \
                 || { cat "$TR/c1.out"; bad "1a unblock.sh rc was $rc, expected 75"; }
[ "$(plan_gate_of held-plan)" = blocked ] && ok "1b held-plan left gate=blocked" \
                                          || bad "1b held-plan gate is '$(plan_gate_of held-plan)'"

# --- 2: hold path, unreachable push remote ---------------------------------
start=$SECONDS
GARDEN_PUSH_CMD="$TR/push-unreachable.sh" GARDEN_POST_ATTEMPTS=50 GARDEN_POST_DEADLINE_SECS=1 \
  "$JOBS/unblock.sh" > "$TR/c2.out" 2>&1
rc=$?
elapsed=$((SECONDS - start))
[ "$rc" -eq 75 ] && ok "2a unreachable hold gave up with rc=75" \
                 || { cat "$TR/c2.out"; bad "2a unreachable hold rc was $rc, expected 75"; }
[ "$elapsed" -lt 30 ] && ok "2b gave up in ${elapsed}s, not the whole 50-attempt budget" \
                      || bad "2b unreachable hold took ${elapsed}s"
grep -q "hold of 'held-plan' exceeded .* wall-clock deadline" "$TR/c2.out" \
  && ok "2c the deadline give-up was logged" || { cat "$TR/c2.out"; bad "2c no deadline log"; }
[ "$(plan_gate_of held-plan)" = blocked ] && ok "2d held-plan left gate=blocked" \
                                          || bad "2d held-plan gate is '$(plan_gate_of held-plan)'"

# --- 3: promote path, unreachable push remote ------------------------------
# Park held-plan out of the scan (gate=deferred) so the tick reaches promo-a.
W="$TR/work"; git clone -q -b journal2 "$BARE" "$W"
sed -i 's/^gate: blocked$/gate: deferred/' "$W/jobs/plan/held-plan.md"
git -C "$W" -c user.name=test -c user.email=test@localhost commit -qam "defer held-plan"
git -C "$W" push -q origin journal2
start=$SECONDS
GARDEN_PUSH_CMD="$TR/push-unreachable.sh" GARDEN_POST_ATTEMPTS=50 GARDEN_POST_DEADLINE_SECS=1 \
  "$JOBS/unblock.sh" > "$TR/c3.out" 2>&1
rc=$?
elapsed=$((SECONDS - start))
[ "$rc" -eq 75 ] && ok "3a unreachable promotion ended the tick with rc=75" \
                 || { cat "$TR/c3.out"; bad "3a unreachable promotion rc was $rc, expected 75"; }
[ "$elapsed" -lt 30 ] && ok "3b gave up in ${elapsed}s, not the whole 50-attempt budget" \
                      || bad "3b unreachable promotion took ${elapsed}s"
{ has_plan promo-a && has_plan promo-b && ! has_todo promo-a && ! has_todo promo-b; } \
  && ok "3c both plans stay parked" || bad "3c a plan moved despite the unreachable remote"
[ "$(grep -c "hit an unreachable journal" "$TR/c3.out")" -eq 1 ] \
  && ok "3d the tick stopped after the first unreachable promotion" \
  || { cat "$TR/c3.out"; bad "3d the tick did not stop at the first unreachable promotion"; }

# --- 4: the producer clone is free afterwards -------------------------------
bf="$TR/body"; printf 'producer clone is free again\n' > "$bf"
"$JOBS/post-job.sh" after-unreachable "$bf" >/dev/null 2>&1
rc=$?
{ [ "$rc" -eq 0 ] && has_todo after-unreachable; } \
  && ok "4 the next producer posted through the released clone" \
  || bad "4 the next producer could not post (rc=$rc)"

# --- 5: healthy journal: hold and promotions land ---------------------------
git -C "$W" pull -q origin journal2
sed -i 's/^gate: deferred$/gate: blocked/' "$W/jobs/plan/held-plan.md"
git -C "$W" -c user.name=test -c user.email=test@localhost commit -qam "re-block held-plan"
git -C "$W" push -q origin journal2
"$JOBS/unblock.sh" > "$TR/c5.out" 2>&1
rc=$?
[ "$rc" -eq 0 ] && ok "5a healthy unblock tick rc=0" \
                || { cat "$TR/c5.out"; bad "5a healthy unblock rc was $rc"; }
[ "$(plan_gate_of held-plan)" = blocked-failed ] && ok "5b held-plan held (gate=blocked-failed)" \
                                                 || bad "5b held-plan gate is '$(plan_gate_of held-plan)'"
{ has_todo promo-a && has_todo promo-b; } && ok "5c both blocked plans promoted to todo" \
                                          || bad "5c promotions did not land"

echo "----------------------------------------------------------------"
echo "unblock post-loop wall-clock deadline: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
