#!/bin/bash
# mechanic-health-controller-test.sh — routine controller cycles stay no-LLM.

set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/mechanic-health-controller-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)
bare="$TR/journal.git"; root="$TR/root"; state="$TR/state"; seed="$TR/seed"
now="$(date -u -d '2026-11-08T12:00:00Z' +%s)"

git init -q "$root"; git -C "$root" checkout -q -b main2
mkdir -p "$root/scripts"; cp -a "$JOBS/../." "$root/scripts/"
git -C "$root" "${git_id[@]}" add -A
git -C "$root" "${git_id[@]}" commit -q -m root

seed_journal() { # $1=unit failures
  local failed="$1"
  rm -rf "$bare" "$seed" "$state"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b journal2
  mkdir -p "$seed"/{schedules,jobs/todo,jobs/doin,jobs/plan,jobs/tada/2026/11/08,fleet/health,deploy/roll,deploy/roll-completed,sysop-log/test-target,hosts,inbox/maintainer/unread}
  touch "$seed/jobs/todo/.gitkeep" "$seed/jobs/doin/.gitkeep" "$seed/jobs/plan/.gitkeep" "$seed/inbox/maintainer/unread/.gitkeep"
  cat >"$seed/schedules/oros-health-checkup.md" <<'EOF'
cadence: 24h
last_dispatched: 2026-11-08T11:30:00Z
job_basename_prefix: oros-health-checkup
---
local check
EOF
  cat >"$seed/schedules/oros-health-watch.md" <<'EOF'
cadence: 3h
last_dispatched: 2026-11-08T08:30:00Z
job_basename_prefix: oros-health-watch
handler-timeout: 3600
---
---
role: mechanic
requires: host=test-leader
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---

role_brief: [roles/mechanic/AGENT.md](roles/mechanic/AGENT.md)
target_host: test-target
trigger: schedule/oros-health-watch
mode: controller
evidence: confirm this cycle local run completed, then use the host-repair diagnosis order and operation ladder
recurrence_budget: 15 minutes
EOF
  cat >"$seed/jobs/tada/2026/11/08/oros-health-checkup-20261108-083000.md" <<'EOF'
- Verdict: healthy
EOF
  cat >"$seed/fleet/health/test-target" <<EOF
host: test-target
deployed_sha: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
roll_status: deployed
unit_failures: $failed
unit_total: 20
at: 2026-11-08T11:55:00Z
EOF
  printf '%s\n' aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa >"$seed/deploy/roll/test-target"
  touch "$seed/deploy/roll-completed/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  cat >"$seed/sysop-log/test-target/20261108T113000Z-good.md" <<'EOF'
op: drain
outcome: accepted-and-applied
at: 2026-11-08T11:30:00Z
EOF
  printf 'monks: 3\n' >"$seed/hosts/test-target"
  git -C "$seed" "${git_id[@]}" add -A
  git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin journal2
}

run_tick() {
  env GARDEN=test-leader GARDEN_ROOT="$root" GARDEN_STATE="$state" \
    GARDEN_MAIN_BRANCH=main2 JOURNAL_REMOTE="$bare" JOURNAL_BRANCH=journal2 \
    GARDEN_SCHEDULER_CLONE="$state/scheduler/journal" \
    GARDEN_BUDGET_LEVEL_ENABLED=0 GARDEN_WORKER_DEROTATE_ENABLED=0 \
    GARDEN_SCHEDULER_NOW="$now" \
    "$root/scripts/jobs/scheduler.sh" >"$TR/tick.log" 2>&1
}

peek() { rm -rf "$TR/peek"; git clone -q --branch journal2 "$bare" "$TR/peek"; }

seed_journal 0
run_tick
peek
test "$(find "$TR/peek/jobs/todo" -type f ! -name .gitkeep | wc -l)" -eq 0
grep -qx -- '- Disposition: routine-closed' "$TR/peek/projects/garden/controller-health/test-target.md"
grep -q 'closed deterministic controller cycle' "$TR/tick.log"
grep -qx 'last_dispatched: 2026-11-08T12:00:00Z' "$TR/peek/schedules/oros-health-watch.md"
printf 'PASS: healthy controller cycle wrote a bounded disposition and dispatched no worker\n'

# A second due cycle also closes in the scheduler.  It replaces, rather than
# appends to, the disposition and therefore cannot grow without bound.
rm -rf "$TR/mutate"
git clone -q --branch journal2 "$bare" "$TR/mutate"
printf '%s\n' '- Verdict: healthy' >"$TR/mutate/jobs/tada/2026/11/08/oros-health-checkup-20261108-120000.md"
git -C "$TR/mutate" "${git_id[@]}" add -A
git -C "$TR/mutate" "${git_id[@]}" commit -q -m 'complete next paired check'
git -C "$TR/mutate" push -q
now=$((now + 10800))
run_tick
peek
test "$(find "$TR/peek/jobs/todo" -type f ! -name .gitkeep | wc -l)" -eq 0
test "$(grep -c '^# Controller health:' "$TR/peek/projects/garden/controller-health/test-target.md")" -eq 1
printf 'PASS: repeated routine cycle neither queued nor requeued work\n'

# The normal scheduler ordering sees this cycle's paired local check queued.
# That is an observable waiting disposition, not a reason to mint a second LLM
# diagnostic on the leader.
rm -rf "$TR/mutate"
git clone -q --branch journal2 "$bare" "$TR/mutate"
printf 'local mechanic pending\n' >"$TR/mutate/jobs/todo/oros-health-checkup-20261108-150000.md"
git -C "$TR/mutate" "${git_id[@]}" add -A
git -C "$TR/mutate" "${git_id[@]}" commit -q -m 'paired check pending'
git -C "$TR/mutate" push -q
now=$((now + 10800))
run_tick
peek
test "$(find "$TR/peek/jobs/todo" -type f -name 'oros-health-watch-*.md' | wc -l)" -eq 0
grep -qx -- '- Disposition: awaiting-paired-check' "$TR/peek/projects/garden/controller-health/test-target.md"
printf 'PASS: pending paired check closes visibly without a controller worker\n'

# A failed unit is not routine.  Preserve the deterministic disposition and
# dispatch exactly one mechanic job for diagnosis/attested repair.
now="$(date -u -d '2026-11-08T12:00:00Z' +%s)"
seed_journal 1
run_tick
peek
test "$(find "$TR/peek/jobs/todo" -type f ! -name .gitkeep | wc -l)" -eq 1
grep -qx -- '- Disposition: mechanic-required' "$TR/peek/projects/garden/controller-health/test-target.md"
job="$(find "$TR/peek/jobs/todo" -type f ! -name .gitkeep | head -1)"
grep -q 'unit-failures' "$job"
printf 'PASS: non-routine evidence alone deferred to a mechanic worker\n'

# While that escalation is still live, the next non-routine cycle records the
# owner and closes instead of piling a second mechanic behind it.
rm -rf "$TR/mutate"
git clone -q --branch journal2 "$bare" "$TR/mutate"
printf '%s\n' '- Verdict: healthy' >"$TR/mutate/jobs/tada/2026/11/08/oros-health-checkup-20261108-120000.md"
git -C "$TR/mutate" "${git_id[@]}" add -A
git -C "$TR/mutate" "${git_id[@]}" commit -q -m 'complete paired check'
git -C "$TR/mutate" push -q
now=$((now + 10800))
run_tick
peek
test "$(find "$TR/peek/jobs/todo" -type f -name 'oros-health-watch-*.md' | wc -l)" -eq 1
grep -q -- '- Escalation: deferred to live oros-health-watch-20261108-120000' "$TR/peek/projects/garden/controller-health/test-target.md"
grep -qx 'last_dispatched: 2026-11-08T15:00:00Z' "$TR/peek/schedules/oros-health-watch.md"
printf 'PASS: live escalation owner suppresses a duplicate mechanic dispatch\n'

# A paired local check queued for more than two cycles means the target is not
# claiming its checks.  That is not routine "pending"; escalate once.
now="$(date -u -d '2026-11-08T12:00:00Z' +%s)"
seed_journal 0
rm -rf "$TR/mutate"
git clone -q --branch journal2 "$bare" "$TR/mutate"
rm "$TR/mutate/jobs/tada/2026/11/08/oros-health-checkup-20261108-083000.md"
printf 'local pending\n' >"$TR/mutate/jobs/todo/oros-health-checkup-20261108-083000.md"
printf 'local stuck\n' >"$TR/mutate/jobs/todo/oros-health-checkup-20261105-103515.md"
git -C "$TR/mutate" "${git_id[@]}" add -A
git -C "$TR/mutate" "${git_id[@]}" commit -q -m 'paired backlog'
git -C "$TR/mutate" push -q
run_tick
peek
test "$(find "$TR/peek/jobs/todo" -type f -name 'oros-health-watch-*.md' | wc -l)" -eq 1
grep -qx -- '- Reason: paired-check-backlog' "$TR/peek/projects/garden/controller-health/test-target.md"
grep -q -- '- Live paired checks: count=2 oldest=oros-health-checkup-20261105-103515' "$TR/peek/projects/garden/controller-health/test-target.md"
printf 'PASS: stale paired-check backlog escalates instead of reading as pending\n'

# A prior pair that vanished from the board is settled evidence, not "pending".
now="$(date -u -d '2026-11-08T12:00:00Z' +%s)"
seed_journal 0
rm -rf "$TR/mutate"
git clone -q --branch journal2 "$bare" "$TR/mutate"
rm "$TR/mutate/jobs/tada/2026/11/08/oros-health-checkup-20261108-083000.md"
git -C "$TR/mutate" "${git_id[@]}" add -A
git -C "$TR/mutate" "${git_id[@]}" commit -q -m 'paired check vanished'
git -C "$TR/mutate" push -q
run_tick
peek
test "$(find "$TR/peek/jobs/todo" -type f -name 'oros-health-watch-*.md' | wc -l)" -eq 1
grep -qx -- '- Reason: paired-missing' "$TR/peek/projects/garden/controller-health/test-target.md"
printf 'PASS: vanished paired check escalates instead of waiting forever\n'
