#!/bin/bash
# Hermetic coverage for the weekly, append-only cybernetic decision ledger.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TEMPORARY_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/garden-decision-ledger.XXXXXX")"
trap 'rm -rf "$TEMPORARY_ROOT"' EXIT
PASS=0
FAIL=0
ok() { echo "PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "FAIL: $*"; FAIL=$((FAIL + 1)); }
GIT_ID=(-c user.name=test -c user.email=test@example.invalid)
REMOTE="$TEMPORARY_ROOT/journal.git"
SEED="$TEMPORARY_ROOT/seed"
git init -q --bare "$REMOTE"
git init -q "$SEED"
git -C "$SEED" checkout -qb journal2
mkdir -p "$SEED"/jobs/{plan,todo,doin,tada} "$SEED/budget/decisions" \
  "$SEED"/inbox/maintainer/{unread,read} "$SEED/config" "$SEED/hosts" "$SEED/usage"
touch "$SEED"/jobs/{plan,todo,doin,tada}/.gitkeep \
  "$SEED/budget/decisions/.gitkeep" \
  "$SEED"/inbox/maintainer/{unread,read}/.gitkeep
git -C "$SEED" add -A
git -C "$SEED" "${GIT_ID[@]}" commit -qm seed
git -C "$SEED" remote add origin "$REMOTE"
git -C "$SEED" push -qu origin journal2

append_at() { # clone-name ISO decision
  local clone_name="$1" instant="$2" decision="$3" epoch
  epoch="$(date -u -d "$instant" +%s)"
  env GARDEN=boundary-host GARDEN_STATE="$TEMPORARY_ROOT/state" \
    JOURNAL_REMOTE="$REMOTE" GARDEN_DECISION_CLONE="$TEMPORARY_ROOT/$clone_name" \
    GARDEN_DECISION_NOW_EPOCH="$epoch" GARDEN_DECISION_ATTEMPTS=8 \
    "$JOBS/decision-append.sh" \
      --loop fixture --input-json '{"sensor":"fixture","value":7}' \
      --decision "$decision" --from-json 1 --to-json 2 \
      --reason "fixture reason" --outcome applied --outcome-detail "fixture applied"
}

# On the 2026 spring DST-transition Sunday, Pacific midnight is 08:00 UTC.
# One second before belongs to the prior Sunday; the exact boundary rotates.
append_at before 2026-03-08T07:59:59Z before-boundary
append_at after 2026-03-08T08:00:00Z at-boundary
git -C "$SEED" pull -q --rebase
OLD="$SEED/budget/decisions/2026-03-01-boundary-host.jsonl"
NEW="$SEED/budget/decisions/2026-03-08-boundary-host.jsonl"
if [ -f "$OLD" ] && [ -f "$NEW" ]; then
  ok "Sunday 00:00 America/Los_Angeles rotates at the DST-aware UTC boundary"
else
  bad "weekly boundary produced the wrong ledger paths"
fi

if [ "$(wc -l < "$OLD")" -eq 2 ] && [ "$(wc -l < "$NEW")" -eq 2 ] \
   && [ "$(jq -r '.decision' "$NEW" | head -1)" = rotate-ledger ] \
   && [ "$(jq -r '.decision' "$NEW" | tail -1)" = at-boundary ]; then
  ok "each new ledger starts with one rotation row before its first decision"
else
  bad "rotation row was absent, duplicated, or out of order"
fi

EXPECTED_PRIOR='budget/decisions/2026-03-01-boundary-host.jsonl'
if jq -e --arg prior "$EXPECTED_PRIOR" \
  'select(.decision == "rotate-ledger" and .input.prior_ledger == $prior and .from == $prior and .outcome == "applied")' \
  "$NEW" >/dev/null; then
  ok "rotation records the prior ledger path and rotation outcome"
else
  bad "rotation provenance is incomplete"
fi

if jq -e -s '
    all(.[];
      (keys | sort) == (["decision","from","input","loop","outcome","outcome_detail","reason","to","ts"] | sort)
      and (.input | type) == "object"
      and (.outcome == "applied" or .outcome == "fail-open-skipped" or .outcome == "no-op" or .outcome == "superseded"))
  ' "$OLD" "$NEW" >/dev/null; then
  ok "every row has the fixed decision shape and closed outcome vocabulary"
else
  bad "a row violates the fixed decision shape"
fi

# Two writers starting from independent stale clones converge through the journal
# CAS.  The winner creates the rotation row; the loser re-syncs and appends only
# its own decision, so rotation remains first and unique.
SAME_EPOCH="$(date -u -d 2026-03-09T12:00:00Z +%s)"
for writer in one two; do
  env GARDEN=parallel-host GARDEN_STATE="$TEMPORARY_ROOT/state" \
    JOURNAL_REMOTE="$REMOTE" GARDEN_DECISION_CLONE="$TEMPORARY_ROOT/parallel-$writer" \
    GARDEN_DECISION_NOW_EPOCH="$SAME_EPOCH" GARDEN_DECISION_ATTEMPTS=8 \
    GARDEN_BACKOFF_MAX=0 "$JOBS/decision-append.sh" \
      --loop fixture --input-json "{\"writer\":\"$writer\"}" \
      --decision "$writer" --reason parallel --outcome applied &
done
wait
git -C "$SEED" pull -q --rebase
PARALLEL="$SEED/budget/decisions/2026-03-08-parallel-host.jsonl"
if [ "$(wc -l < "$PARALLEL")" -eq 3 ] \
   && [ "$(jq -r 'select(.decision == "rotate-ledger") | .decision' "$PARALLEL" | wc -l)" -eq 1 ] \
   && [ "$(jq -r '.decision' "$PARALLEL" | tail -n +2 | sort | paste -sd, -)" = one,two ]; then
  ok "concurrent stale writers preserve both appends with one first-row rotation"
else
  bad "CAS retry lost/duplicated a concurrent append"
fi

# The current plan-queue actuators emit their applied decision after their own
# board CAS succeeds.  This verifies the instrumentation as well as the writer.
PLAN_BODY="$TEMPORARY_ROOT/plan-body"
printf '# planned work\n' > "$PLAN_BODY"
ACTUATOR_EPOCH="$(date -u -d 2026-03-10T12:00:00Z +%s)"
ACTUATOR_ENV=(env GARDEN_TEST=1 GARDEN=actuator-host GARDEN_STATE="$TEMPORARY_ROOT/actuator-state"
  JOURNAL_REMOTE="$REMOTE" GARDEN_PRODUCER_CLONE="$TEMPORARY_ROOT/actuator-producer"
  GARDEN_DECISION_CLONE="$TEMPORARY_ROOT/actuator-decisions"
  GARDEN_DECISION_NOW_EPOCH="$ACTUATOR_EPOCH")
"${ACTUATOR_ENV[@]}" "$JOBS/post-plan.sh" --deferred --priority high instrumented-plan "$PLAN_BODY" >/dev/null
"${ACTUATOR_ENV[@]}" "$JOBS/promote-plan.sh" instrumented-plan >/dev/null
git -C "$SEED" pull -q --rebase
ACTUATOR="$SEED/budget/decisions/2026-03-08-actuator-host.jsonl"
if jq -e -s '
    any(.[]; .loop == "plan-queue" and .decision == "park-plan"
      and .input.base == "instrumented-plan" and .input.gate == "deferred"
      and .outcome == "applied")
    and any(.[]; .loop == "plan-queue" and .decision == "promote-plan"
      and .input.base == "instrumented-plan"
      and .from == "jobs/plan/instrumented-plan.md"
      and .to == "jobs/todo/instrumented-plan.md" and .outcome == "applied")
  ' "$ACTUATOR" >/dev/null; then
  ok "plan parking and promotion emit durable applied decisions"
else
  bad "plan-queue actuator decisions are missing or malformed"
fi

# The universal claim gate records a high-water decline before candidate
# selection, including the paying provider/host provenance.
printf '%s\n' 'anthropic:claim-host anthropic claim-host weekly-tokens 1 usage-panel 2026-03-10' \
  > "$SEED/config/budget-pools"
git -C "$SEED" add config/budget-pools
git -C "$SEED" "${GIT_ID[@]}" commit -qm 'configure claim budget'
git -C "$SEED" push -q
CLAIM_USAGE_LEDGER="$TEMPORARY_ROOT/claim-usage-ledger"
printf '%s\t900\n' "$((ACTUATOR_EPOCH - 3600))" > "$CLAIM_USAGE_LEDGER"
claim_probe="$(env GARDEN=claim-host GARDEN_STATE="$TEMPORARY_ROOT/claim-state" \
  GARDEN_USAGE_NOW="$ACTUATOR_EPOCH" GARDEN_CCUSAGE_LOGDIR="$TEMPORARY_ROOT/no-claim-session-logs" \
  GARDEN_USAGE_LEDGER="$CLAIM_USAGE_LEDGER" GARDEN_BUDGET_POOLS_FILE="$SEED/config/budget-pools" \
  bash -c 'source "$1/common.sh"; pool_admits anthropic:claim-host; printf "rc=%s\n" "$?"' _ "$JOBS")"
claim_result=0
claim_output="$(env GARDEN_TEST=1 GARDEN=claim-host GARDEN_STATE="$TEMPORARY_ROOT/claim-state" \
  GARDEN_WORKER_KIND=gardener \
  JOURNAL_REMOTE="$REMOTE" GARDEN_WORKER_CLONE="$TEMPORARY_ROOT/claim-worker" \
  GARDEN_DECISION_CLONE="$TEMPORARY_ROOT/claim-decisions" \
  GARDEN_DECISION_NOW_EPOCH="$ACTUATOR_EPOCH" GARDEN_USAGE_NOW="$ACTUATOR_EPOCH" \
  GARDEN_CCUSAGE_LOGDIR="$TEMPORARY_ROOT/no-claim-session-logs" \
  GARDEN_USAGE_LEDGER="$CLAIM_USAGE_LEDGER" GARDEN_BUDGET_POOLS_FILE="$SEED/config/budget-pools" \
  GARDEN_NO_MAINTAINER_ALERT=1 \
  "$JOBS/claim-job.sh" 1 2>&1)" || claim_result=$?
git -C "$SEED" pull -q --rebase
CLAIM_LEDGER="$SEED/budget/decisions/2026-03-08-claim-host.jsonl"
if [ "$claim_result" -eq 3 ] && jq -e '
  select(.loop == "claim-admission" and .decision == "decline-claim"
    and .input.pool == "anthropic:claim-host" and .input.status == "backoff"
    and .input.provider == "anthropic" and .outcome == "applied")
  ' "$CLAIM_LEDGER" >/dev/null; then
  ok "high-water claim decline records its pool input and applied outcome"
else
  bad "claim backoff was not durably attributable (rc=$claim_result probe=$(printf '%s' "$claim_probe" | tr '\n' ';') log=$(printf '%s' "$claim_output" | tr '\n' ';'))"
fi

# An unavailable journal is an observability failure, never an actuator failure.
if env GARDEN=fail-open-host GARDEN_STATE="$TEMPORARY_ROOT/fail-state" \
  JOURNAL_REMOTE="$TEMPORARY_ROOT/absent.git" GARDEN_FETCH_ATTEMPTS=1 \
  GARDEN_FETCH_BACKOFF_MAX=0 GARDEN_DECISION_ATTEMPTS=1 \
  "$JOBS/decision-append.sh" --loop fixture --input-json '{}' \
    --decision unavailable --reason offline --outcome fail-open-skipped >/dev/null 2>&1; then
  ok "ledger transport failure exits successfully (actuation stays fail-open)"
else
  bad "ledger transport failure escaped into the actuator"
fi

echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
