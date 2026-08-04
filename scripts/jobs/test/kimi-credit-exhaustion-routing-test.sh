#!/bin/bash
# Regression: exhausted Moonshot credits never create a fresh Kimi claim.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
export GARDEN_TEST=1
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
TR="$(mktemp -d "${TMPDIR:-/var/tmp}/garden-kimi-credit-route.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
PASS=0 FAIL=0
ok() { echo "PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "FAIL: $*"; FAIL=$((FAIL + 1)); }
id=(-c user.name=test -c user.email=test@localhost)
bare="$TR/journal.git"; seed="$TR/seed"; branch=journal2
git init -q --bare "$bare"
git init -q "$seed"; git -C "$seed" checkout -q -b "$branch"
mkdir -p "$seed"/{jobs/todo,jobs/plan,jobs/doin,jobs/tada,work,schedules,inbox/maintainer/unread}
for d in jobs/todo jobs/plan jobs/doin jobs/tada work inbox/maintainer/unread; do touch "$seed/$d/.gitkeep"; done
printf '%s\n' '---' 'role: builder' 'model: kimi-k3' '---' 'automatic queued Kimi work' > "$seed/jobs/todo/queued-kimi.md"
printf '%s\n' '---' 'gate: deferred' 'role: builder' 'tier: mentor' 'model: kimi-k3' '---' 'parked Kimi work' > "$seed/jobs/plan/parked-kimi.md"
printf '%s\n' '---' 'tier: mentat' 'dispatch: manual' '---' 'manual Fable work' > "$seed/jobs/todo/manual-mentat.md"
printf '%s\n' '---' 'role: builder' 'tier: mentor' 'model: kimi-k3' '---' 'stale Kimi claim' '<!-- garden-reap-now -->' '---' 'claim:' '  provider: moonshot' '  claimed_at: 2020-01-01T00:00:00Z' > "$seed/jobs/doin/live-kimi.md"
printf '%s\n' 'cadence: weekly' 'last_dispatched:' 'job_basename_prefix: kimi-schedule' '---' '---' 'role: assayer' 'model: kimi-k3' '---' 'old Kimi-pinned schedule' > "$seed/schedules/kimi-review.md"
git -C "$seed" "${id[@]}" add -A; git -C "$seed" "${id[@]}" commit -q -m seed
git -C "$seed" remote add origin "$bare"; git -C "$seed" push -q -u origin "$branch"

env GARDEN=testhost GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$branch" \
  GARDEN_PRODUCER_CLONE="$TR/state/producer/journal" "$JOBS/migrate-model-tier-routing.sh" >/dev/null
peek="$TR/peek"; git clone -q --branch "$branch" "$bare" "$peek"
for f in "$peek/jobs/todo/queued-kimi.md" "$peek/jobs/plan/parked-kimi.md"; do
  grep -qx 'tier: minion' "$f" && grep -qx 'model: gpt-5.6-terra' "$f" && ! grep -q '^model: kimi-k3$' "$f"
done && ok "CAS migration rewrites queued and parked Kimi work to minion/Codex" || bad "migration left a Kimi route"
grep -qx 'tier: mentat' "$peek/jobs/todo/manual-mentat.md" && grep -qx 'dispatch: manual' "$peek/jobs/todo/manual-mentat.md" \
  && ok "manual mentat job is preserved" || bad "manual mentat changed"
rm -rf "$peek"

env GARDEN=testhost GARDEN_STATE="$TR/reaper-state" JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$branch" \
  GARDEN_REAPER_CLONE="$TR/reaper-state/reaper/journal" GARDEN_NO_MAINTAINER_ALERT=1 \
  GARDEN_REAP_DOOM_THRESHOLD=9 "$JOBS/reaper.sh" >/dev/null
git clone -q --branch "$branch" "$bare" "$peek"
grep -qx 'tier: minion' "$peek/jobs/todo/live-kimi.md" && grep -qx 'model: gpt-5.6-terra' "$peek/jobs/todo/live-kimi.md" \
  && ok "exited Kimi claim safely requeues to minion/Codex" || bad "reaper did not reroute Kimi claim"
rm -rf "$peek"

# A minion tier is eligible to the cleric even if a stale concrete compatibility
# field disagrees: the durable tier wins claim eligibility.
env GARDEN=testhost GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$branch" \
  GARDEN_GARDENER_CLONE="$TR/state/cleric/journal" GARDEN_WORKER_KIND=cleric \
  "$JOBS/claim-job.sh" 7 > "$TR/claimed"
env GARDEN=testhost GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$branch" \
  GARDEN_GARDENER_CLONE="$TR/state/cleric/journal" GARDEN_WORKER_KIND=cleric \
  "$JOBS/claim-job.sh" 7 > "$TR/reclaimed"
[ "$(cat "$TR/reclaimed")" = live-kimi ] && ok "requeued Kimi work is claimable by a non-Kimi cleric" || bad "cleric did not claim requeued work"

# Scheduler is an independent producer: even a journal schedule that has not yet
# been migrated must normalize its tick before publishing todo work.
env GARDEN=testhost GARDEN_STATE="$TR/state2" JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$branch" \
  GARDEN_SCHEDULER_CLONE="$TR/state2/scheduler/journal" GARDEN_SCHEDULER_NOW=1780000000 \
  "$JOBS/scheduler.sh" >/dev/null
rm -rf "$peek"; git clone -q --branch "$branch" "$bare" "$peek"
sf="$(find "$peek/jobs/todo" -name 'kimi-schedule*' -type f | head -1)"
[ -n "$sf" ] && grep -qx 'tier: minion' "$sf" && grep -qx 'model: gpt-5.6-terra' "$sf" && ! grep -q '^model: kimi-k3$' "$sf" \
  && ok "schedule tick cannot acquire a Kimi pin" || bad "schedule tick retained Kimi"

echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
