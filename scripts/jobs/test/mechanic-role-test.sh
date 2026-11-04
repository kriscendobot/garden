#!/bin/bash
# mechanic-role-test.sh — the role is postable and its thin schedules are guarded.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/mechanic-role-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

mkdir -p "$TR/schedules"
make_schedule() {
  local name="$1" host="$2" mode="$3" evidence="$4"
  printf '%s\n' \
    'cadence: 3h' \
    'last_dispatched: 2026-11-04T00:00:00Z' \
    "job_basename_prefix: $name" \
    'handler-timeout: 3600' \
    '---' \
    '---' \
    'role: mechanic' \
    "requires: host=$host" \
    'handler-timeout: 3600' \
    'tier: mentor' \
    'fallback-tier: minion' \
    'dispatch: automatic' \
    '---' \
    '' \
    'role_brief: [roles/mechanic/AGENT.md](roles/mechanic/AGENT.md)' \
    'target_host: oros-studio-garden-ce242c49' \
    "trigger: schedule/$name" \
    "mode: $mode" \
    "evidence: $evidence" \
    'recurrence_budget: 15 minutes' > "$TR/schedules/$name.md"
}
make_schedule oros-health-checkup oros-studio-garden-ce242c49 local \
  'inspect locally, append one standard host-health record, and exit early for an active roll release or drain'
make_schedule oros-health-watch endolin-garden-ece02cb4 controller \
  'confirm this cycle local run completed, then use the host-repair diagnosis order and operation ladder'

"$JOBS/check-mechanic-role.sh" "$TR/schedules" >/dev/null
printf 'PASS: mechanic role, operation map, and thin schedule contract\n'

printf '%s\n' 'restart everything until healthy' >> "$TR/schedules/oros-health-watch.md"
if "$JOBS/check-mechanic-role.sh" "$TR/schedules" >/dev/null 2>&1; then
  printf 'FAIL: independent schedule repair policy was accepted\n' >&2
  exit 1
fi
printf 'PASS: independent schedule repair policy is rejected\n'

# Exercise the real producer path: a canonical role prompt must normalize to a
# postable mechanic job and retain the automatic mentor route.
git init -q --bare "$TR/journal.git"
git init -q "$TR/seed"
git -C "$TR/seed" checkout -q -b journal2
mkdir -p "$TR/seed/jobs"/{todo,doin,tada,plan,index}
touch "$TR/seed/jobs"/{todo,doin,tada,plan,index}/.gitkeep
git -C "$TR/seed" add -A
git -C "$TR/seed" -c user.name=test -c user.email=test@localhost commit -q -m seed
git -C "$TR/seed" remote add origin "$TR/journal.git"
git -C "$TR/seed" push -q -u origin journal2
printf '%s\n' '**Role: mechanic.** Repair the named host.' \
  | env GARDEN_TEST=1 GARDEN=test-host GARDEN_ROLE=gardener \
      GARDEN_STATE="$TR/state" GARDEN_PRODUCER_CLONE="$TR/state/producer/journal" \
      JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2 \
      "$JOBS/post-job.sh" mechanic-postable >/dev/null
posted="$(git --git-dir="$TR/journal.git" show journal2:jobs/todo/mechanic-postable.md)"
printf '%s\n' "$posted" | grep -qx 'role: mechanic'
printf '%s\n' "$posted" | grep -qx 'tier: mentor'
printf 'PASS: canonical mechanic prompt posts with role metadata at mentor tier\n'
