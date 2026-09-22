#!/bin/bash
# retry-narrowing-test.sh — bounded, backed-off ordinary retry policy.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=test-tmpdir.sh
source "$HERE/test-tmpdir.sh"
TEMPORARY_ROOT="$(mktemp -d "$(garden_test_exec_tmpdir)/.garden-retry-narrowing.XXXXXX")"
trap 'rm -rf "$TEMPORARY_ROOT"' EXIT
PASS=0
FAIL=0
ok() { echo "PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "FAIL: $*"; FAIL=$((FAIL + 1)); }

mapfile -t ambient_variables < <(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true)
[ "${#ambient_variables[@]}" -eq 0 ] || unset "${ambient_variables[@]}"
# The scrub above matches (and unsets) GARDEN_TEST too, but that is the positive
# test-context sentinel (common.sh § GARDEN_TEST), not fleet state — re-establish
# it so the claim-job.sh subprocess spawned below sees it. Its hermetic-fixture
# escape hatch keys off GARDEN_TEST=1; without it the fail-closed budget gate
# refuses this fixture's unrecognized inference source with rc=3 and no claim lands.
export GARDEN_TEST=1

REMOTE="$TEMPORARY_ROOT/journal.git"
SEED="$TEMPORARY_ROOT/seed"
BRANCH=journal2
GIT_ID=(-c user.name=test -c user.email=test@example.invalid)
git init -q --bare "$REMOTE"
git init -q "$SEED"
git -C "$SEED" checkout -qb "$BRANCH"
mkdir -p "$SEED"/jobs/{todo,doin,tada,plan} "$SEED/work" \
  "$SEED"/inbox/maintainer/{unread,read} "$SEED/budget/decisions"
touch "$SEED"/jobs/{todo,doin,tada,plan}/.gitkeep "$SEED/work/.gitkeep" \
  "$SEED"/inbox/maintainer/{unread,read}/.gitkeep "$SEED/budget/decisions/.gitkeep"
git -C "$SEED" add -A
git -C "$SEED" "${GIT_ID[@]}" commit -qm seed
git -C "$SEED" remote add origin "$REMOTE"
git -C "$SEED" push -qu origin "$BRANCH"

export JOURNAL_REMOTE="$REMOTE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=retry-host GARDEN_STATE="$TEMPORARY_ROOT/state"
export GARDEN_REAPER_CLONE="$TEMPORARY_ROOT/reaper"
export GARDEN_DECISION_CLONE="$TEMPORARY_ROOT/decisions"
export GARDEN_REAP_PUSH_ATTEMPTS=8 GARDEN_POST_ATTEMPTS=8
export GARDEN_REAP_PLAIN_RETRY_BACKOFF_SECONDS=300
export GARDEN_REAP_DOOM_THRESHOLD=99 GARDEN_REAP_OVERRUN_THRESHOLD=99
export GARDEN_CLAIM_TTL=3600 GARDEN_HANDLER_TIMEOUT=1
export GARDEN_HANDLER_KILL_AFTER=1 GARDEN_REAP_SAFETY_SLACK=1
export GARDEN_PROGRESS_DOOM=off GARDEN_NO_MAINTAINER_ALERT=1

NOW="$(date -u -d 2026-09-17T12:00:00Z +%s)"
NOT_BEFORE="$(date -u -d "@$((NOW + 300))" +%FT%TZ)"

edit_board() { # shell command executed in a fresh journal clone
  local command="$1" edit
  edit="$(mktemp -d "$TEMPORARY_ROOT/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$REMOTE" "$edit"
  (cd "$edit" && bash -c "$command")
  git -C "$edit" add -A
  git -C "$edit" "${GIT_ID[@]}" commit -qm fixture
  git -C "$edit" push -q origin "HEAD:$BRANCH"
  rm -rf "$edit"
}

snapshot() {
  rm -rf "$TEMPORARY_ROOT/verify"
  git clone -q --single-branch --branch "$BRANCH" "$REMOTE" "$TEMPORARY_ROOT/verify"
}

run_reaper() {
  GARDEN_REAPER_NOW="$1" "$JOBS/reaper.sh" >"$TEMPORARY_ROOT/reaper.log" 2>&1
  snapshot
}

# First plain exit: one retry is scheduled, but it is not claimable early.
edit_board 'cat > jobs/doin/plain.md <<EOF
# plain

plain work

<!-- garden-reap-now -->

---
claim:
  host: retry-host
  gardener: 1
  claimed_at: 2026-09-17T11:59:50Z
EOF
printf "worktree_dir: /nonexistent/plain\n" > work/plain'
run_reaper "$NOW"
PLAIN="$TEMPORARY_ROOT/verify/jobs/todo/plain.md"
if [ -f "$PLAIN" ] \
   && grep -qx '<!-- garden-reaped: 1 -->' "$PLAIN" \
   && grep -qx "<!-- garden-plain-retry-not-before: $NOT_BEFORE -->" "$PLAIN"; then
  ok "first plain exit records retry_count=1 and a future not-before"
else
  bad "first plain exit did not produce the bounded backed-off retry"
fi

claim_result=0
env GARDEN=retry-host GARDEN_STATE="$TEMPORARY_ROOT/claim-state" \
  GARDEN_WORKER_CLONE="$TEMPORARY_ROOT/claim" GARDEN_CLAIM_NOW="$((NOW + 299))" \
  GARDEN_NO_MAINTAINER_ALERT=1 "$JOBS/claim-job.sh" 1 \
  >"$TEMPORARY_ROOT/claim-before.log" 2>&1 || claim_result=$?
snapshot
if [ "$claim_result" -eq 3 ] && [ -f "$TEMPORARY_ROOT/verify/jobs/todo/plain.md" ] \
   && grep -q 'sole plain-exit retry back-off' "$TEMPORARY_ROOT/claim-before.log"; then
  ok "claim gate refuses the sole retry before its recorded deadline"
else
  bad "plain retry was claimable before not-before (rc=$claim_result)"
fi

claim_result=0
env GARDEN=retry-host GARDEN_STATE="$TEMPORARY_ROOT/claim-state" \
  GARDEN_WORKER_CLONE="$TEMPORARY_ROOT/claim" GARDEN_CLAIM_NOW="$((NOW + 300))" \
  GARDEN_NO_MAINTAINER_ALERT=1 "$JOBS/claim-job.sh" 1 \
  >"$TEMPORARY_ROOT/claim-at.log" 2>&1 || claim_result=$?
snapshot
if [ "$claim_result" -eq 0 ] && [ -f "$TEMPORARY_ROOT/verify/jobs/doin/plain.md" ]; then
  ok "plain retry becomes claimable exactly at not-before"
else
  bad "plain retry did not open at not-before (rc=$claim_result)"
fi

# The retry also exits plainly: no third attempt; it is held split-eligible.
edit_board 'awk '\''
  { line[NR]=$0 }
  END {
    cut=0
    for (i=1; i<NR; i++) if (line[i]=="---" && line[i+1]=="claim:") cut=i
    for (i=1; i<=NR; i++) {
      if (cut>0 && i==cut) print "<!-- garden-terminal-handler-failure -->"
      print line[i]
    }
  }
'\'' jobs/doin/plain.md > jobs/doin/plain.next
mv jobs/doin/plain.next jobs/doin/plain.md'
run_reaper "$((NOW + 301))"
PLAIN_PLAN="$TEMPORARY_ROOT/verify/jobs/plan/plain.md"
if [ -f "$PLAIN_PLAN" ] && grep -qx 'split_eligible: true' "$PLAIN_PLAN" \
   && grep -qx 'split_reason: repeated-plain-exit' "$PLAIN_PLAN" \
   && [ ! -e "$TEMPORARY_ROOT/verify/jobs/todo/plain.md" ]; then
  ok "second plain exit suppresses further retry and becomes split-eligible"
else
  bad "second plain exit was not terminalized as split-eligible"
fi

# One non-productive wall hit is conclusive even when both legacy thresholds are
# high. It is re-posted under the SAME base as a decomposition-only orchestrator,
# not parked for a human and not retried as the original implementation job.
edit_board 'cat > jobs/doin/wall.md <<EOF
# wall

wall work

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->

---
claim:
  host: retry-host
  gardener: 1
  claimed_at: 2026-09-17T11:59:50Z
EOF
printf "worktree_dir: /nonexistent/wall\n" > work/wall'
run_reaper "$((NOW + 302))"
WALL_TODO="$TEMPORARY_ROOT/verify/jobs/todo/wall.md"
if [ -f "$WALL_TODO" ] && [ ! -e "$TEMPORARY_ROOT/verify/jobs/plan/wall.md" ] \
   && grep -qx 'role: orchestrator' "$WALL_TODO" \
   && grep -qx 'split_eligible: true' "$WALL_TODO" \
   && grep -qx 'split_reason: deadline-overrun' "$WALL_TODO" \
   && grep -qx 'split_orchestration: wall-split' "$WALL_TODO" \
   && grep -q 'at least two self-contained child jobs' "$WALL_TODO" \
   && grep -q 'split-indivisible-reason:' "$WALL_TODO" \
   && grep -q 'handler-timeout:.*strictly greater than 1' "$WALL_TODO" \
   && grep -q 'GARDEN-JOB-HANDED-OFF: wall-split' "$WALL_TODO"; then
  ok "first ordinary wall hit re-posts the same base for deliberate orchestration decomposition"
else
  bad "wall hit did not take the same-base orchestration split path"
fi

# Productive work resets the plain counter and receives no artificial delay.
edit_board 'cat > jobs/doin/productive.md <<EOF
# productive

productive work

<!-- garden-reaped: 1 -->
<!-- garden-productive-cycle -->
<!-- garden-reap-now -->

---
claim:
  host: retry-host
  gardener: 1
  claimed_at: 2026-09-17T11:59:50Z
EOF
printf "worktree_dir: /nonexistent/productive\n" > work/productive'
run_reaper "$((NOW + 303))"
PRODUCTIVE="$TEMPORARY_ROOT/verify/jobs/todo/productive.md"
if [ -f "$PRODUCTIVE" ] && grep -qx '<!-- garden-reaped: 0 -->' "$PRODUCTIVE" \
   && ! grep -q 'garden-plain-retry-not-before' "$PRODUCTIVE"; then
  ok "productive cycle resets retry history without adding a plain-exit back-off"
else
  bad "productive-cycle reset regressed"
fi

# A quota retry remains held to its provider reset and does not consume or reset
# the already-recorded plain retry count.
RESET_AT=2026-09-17T13:00:00Z
RESET_EPOCH="$(date -u -d "$RESET_AT" +%s)"
edit_board 'cat > jobs/doin/quota.md <<EOF
# quota

quota work

<!-- garden-reaped: 1 -->
<!-- garden-provider-quota-backoff: type=weekly reset-at=2026-09-17T13:00:00Z -->

---
claim:
  host: retry-host
  gardener: 1
  claimed_at: 2026-09-17T11:00:00Z
EOF
printf "worktree_dir: /nonexistent/quota\n" > work/quota'
run_reaper "$((RESET_EPOCH - 1))"
if [ -f "$TEMPORARY_ROOT/verify/jobs/doin/quota.md" ]; then
  ok "quota recovery stays behind its existing reset back-off"
else
  bad "quota claim escaped before its reset"
fi
run_reaper "$RESET_EPOCH"
QUOTA="$TEMPORARY_ROOT/verify/jobs/todo/quota.md"
if [ -f "$QUOTA" ] && grep -qx '<!-- garden-reaped: 1 -->' "$QUOTA" \
   && ! grep -q 'garden-plain-retry-not-before\|garden-provider-quota-backoff' "$QUOTA"; then
  ok "quota reset releases work without spending or refreshing the plain retry"
else
  bad "quota recovery changed the plain retry budget or retained its hold"
fi

# A gauntlet wall hit bypasses BOTH high generic thresholds on its first failure,
# parks for the driver immediately, and never acquires the ordinary split route.
edit_board 'cat > jobs/doin/stage.md <<EOF
---
gauntlet: example-gauntlet
---
# stage

stage work

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->

---
claim:
  host: retry-host
  gardener: 1
  claimed_at: 2026-09-17T12:59:59Z
EOF
printf "worktree_dir: /nonexistent/stage\n" > work/stage'
run_reaper "$((RESET_EPOCH + 1))"
STAGE_PLAN="$TEMPORARY_ROOT/verify/jobs/plan/stage.md"
if [ -f "$STAGE_PLAN" ] && grep -qx 'doom_signature: deadline-overrun' "$STAGE_PLAN" \
   && grep -qx 'gauntlet: example-gauntlet' "$STAGE_PLAN" \
   && ! grep -q '^split_eligible:' "$STAGE_PLAN" \
   && [ ! -e "$TEMPORARY_ROOT/verify/jobs/todo/stage.md" ]; then
  ok "gauntlet stage bypasses generic retry/split and hands its first wall hit to the driver"
else
  bad "gauntlet stage did not remain exclusively under driver retry ownership"
fi

# The retryable counterpart also hands off on the FIRST failure even though the
# generic threshold is 99. The transient classification tells gauntlet.sh (and
# only gauntlet.sh) to spend one max_stage_retries attempt.
edit_board 'cat > jobs/doin/stage-transient.md <<EOF
---
gauntlet: example-gauntlet
---
# transient stage

stage work

<!-- garden-reap-now -->

---
claim:
  host: retry-host
  gardener: 1
  claimed_at: 2026-09-17T12:59:59Z
EOF
printf "worktree_dir: /nonexistent/stage-transient\n" > work/stage-transient'
run_reaper "$((RESET_EPOCH + 2))"
TRANSIENT_STAGE_PLAN="$TEMPORARY_ROOT/verify/jobs/plan/stage-transient.md"
if [ -f "$TRANSIENT_STAGE_PLAN" ] \
   && grep -qx 'doom_signature: requeue-exhausted' "$TRANSIENT_STAGE_PLAN" \
   && grep -qx 'failure_classification: transient' "$TRANSIENT_STAGE_PLAN" \
   && ! grep -q '^split_eligible:' "$TRANSIENT_STAGE_PLAN" \
   && [ ! -e "$TEMPORARY_ROOT/verify/jobs/todo/stage-transient.md" ]; then
  ok "transient gauntlet failure bypasses generic retry and is handed to max_stage_retries"
else
  bad "transient gauntlet failure spent or escaped the driver's exclusive retry budget"
fi

snapshot
LEDGER="$(find "$TEMPORARY_ROOT/verify/budget/decisions" -maxdepth 1 -name '*-retry-host.jsonl' -print -quit)"
if [ -n "$LEDGER" ] && jq -e -s '
  any(.[]; .loop == "reaper" and .decision == "schedule-plain-retry"
    and .input.base == "plain" and .input.retry_count == "1"
    and .input.not_before == "2026-09-17T12:05:00Z")
  and any(.[]; .loop == "reaper" and .decision == "mark-split-eligible"
    and .input.base == "plain" and .input.split_reason == "repeated-plain-exit")
  and any(.[]; .loop == "reaper" and .decision == "route-split-orchestration"
    and .input.base == "wall" and .input.split_reason == "deadline-overrun"
    and .input.orchestration == "wall-split" and .to == "jobs/todo/wall.md")
  and any(.[]; .loop == "reaper" and .decision == "release-quota-retry"
    and .input.base == "quota" and .input.reset_at == "2026-09-17T13:00:00Z")
  and any(.[]; .loop == "reaper" and .decision == "handoff-gauntlet-stage"
    and .input.base == "stage" and .input.gauntlet == "example-gauntlet"
    and (.input.split_eligible | not))
  and any(.[]; .loop == "reaper" and .decision == "handoff-gauntlet-stage"
    and .input.base == "stage-transient" and .input.signature == "requeue-exhausted"
    and .input.gauntlet == "example-gauntlet" and (.input.split_eligible | not))
' "$LEDGER" >/dev/null; then
  ok "retry, suppression, quota recovery, and gauntlet decisions are durable"
else
  bad "retry policy decision ledger rows are missing or malformed"
fi

# Completion-time enforcement: a split-routed handler cannot merely say it is
# done. It must hand off to the exact durable orchestration. Two children prove a
# divisible disposition; one child additionally needs a concrete reason and a
# strictly larger timeout recorded on both the orchestration and child.
edit_board 'mkdir -p jobs/orch jobs/plan
cat > jobs/orch/wall-split.md <<EOF
---
order: serial
children: wall-a wall-b
on-child-failure: halt
state: pending
---
divisible wall split
EOF
for child in wall-a wall-b; do
  cat > "jobs/plan/$child.md" <<EOF
---
gate: orchestrated
orchestrated_by: wall-split
---
child work
EOF
done'
snapshot
printf '%s\n' 'split posted' '<<<GARDEN-JOB-HANDED-OFF: wall-split>>>' > "$TEMPORARY_ROOT/wall-report"
if "$JOBS/assert-overrun-split-posted.sh" wall \
  "$TEMPORARY_ROOT/verify/jobs/todo/wall.md" "$TEMPORARY_ROOT/wall-report"; then
  ok "completion gate accepts a durable divisible split orchestration"
else
  bad "completion gate rejected a valid divisible split orchestration"
fi

edit_board 'cat > jobs/orch/leaf-split.md <<EOF
---
order: serial
children: leaf-expanded-window
on-child-failure: halt
state: pending
---
split-indivisible-reason: "one atomic build: partitioning is impossible # indivisible"
split-indivisible-handler-timeout: 2
EOF
cat > jobs/plan/leaf-expanded-window.md <<EOF
---
gate: orchestrated
orchestrated_by: leaf-split
handler-timeout: 2
split-indivisible-reason: "one atomic build: partitioning is impossible # indivisible"
---
run the atomic build
EOF'
cat > "$TEMPORARY_ROOT/leaf-job.md" <<EOF
---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_handler_timeout: 1
split_orchestration: leaf-split
---
EOF
printf '%s\n' 'leaf split posted' '<<<GARDEN-JOB-HANDED-OFF: leaf-split>>>' > "$TEMPORARY_ROOT/leaf-report"
if "$JOBS/assert-overrun-split-posted.sh" leaf \
  "$TEMPORARY_ROOT/leaf-job.md" "$TEMPORARY_ROOT/leaf-report"; then
  ok "completion gate accepts one indivisible child with a recorded reason and larger timeout"
else
  bad "completion gate rejected a valid indivisible larger-timeout child"
fi
if "$JOBS/promote-plan.sh" leaf-expanded-window >/dev/null 2>&1; then
  snapshot
  promoted_leaf="$TEMPORARY_ROOT/verify/jobs/todo/leaf-expanded-window.md"
  if grep -Fqx "split-indivisible-reason: 'one atomic build: partitioning is impossible # indivisible'" \
    "$promoted_leaf"; then
    ok "plan-to-todo promotion preserves an indivisible child's reason as a quoted scalar"
  else
    bad "plan-to-todo promotion dropped or malformed the indivisible child's reason"
  fi
  if "$JOBS/assert-overrun-split-posted.sh" leaf \
    "$TEMPORARY_ROOT/leaf-job.md" "$TEMPORARY_ROOT/leaf-report"; then
    ok "completion gate accepts the indivisible handoff after its child is promoted"
  else
    bad "completion gate rejected the indivisible handoff after child promotion"
  fi
else
  bad "could not promote the expanded-window child for the regression check"
fi
sed -i 's/split_source_handler_timeout: 1/split_source_handler_timeout: 2/' "$TEMPORARY_ROOT/leaf-job.md"
if "$JOBS/assert-overrun-split-posted.sh" leaf \
  "$TEMPORARY_ROOT/leaf-job.md" "$TEMPORARY_ROOT/leaf-report" >/dev/null 2>&1; then
  bad "completion gate accepted an indivisible child whose timeout was not larger"
else
  ok "completion gate rejects an indivisible child without a strictly larger timeout"
fi

echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
