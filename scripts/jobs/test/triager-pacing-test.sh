#!/bin/bash
# Deterministic coverage for cost projection, fail-open cadence, and event preemption.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=test-tmpdir.sh
source "$HERE/test-tmpdir.sh"
TEMPORARY_ROOT="$(mktemp -d "$(garden_test_exec_tmpdir)/garden-triager-pacing.XXXXXX")"
trap 'rm -rf "$TEMPORARY_ROOT"' EXIT
PASS=0
FAIL=0
ok() { echo "PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "FAIL: $*"; FAIL=$((FAIL + 1)); }
GIT_ID=(-c user.name=test -c user.email=test@example.invalid)
NOW="$(date -u -d 2026-09-17T12:00:00Z +%s)"
HOST=pace-host
SLUG=kriscendobot-pace
REF=main

make_pace_inputs() { # directory [sampled-at]
  local directory="$1" sampled_at="${2:-$NOW}" anchor
  mkdir -p "$directory/config" "$directory/budget/live" "$directory/usage"
  anchor="$(env GARDEN="$HOST" GARDEN_USAGE_NOW="$NOW" bash -c \
    'source "'$JOBS'/common.sh"; meter_week_anchor_epoch "$GARDEN_USAGE_NOW"')"
  printf 'anthropic:%s\tanthropic\t%s\tweekly-tokens\t1000000\tmanual-fit\t2026-09-01\n' \
    "$HOST" "$HOST" > "$directory/config/budget-pools"
  {
    printf 'pool: anthropic:%s\n' "$HOST"
    printf 'host: %s\n' "$HOST"
    printf 'window_start_epoch: %s\n' "$anchor"
    printf 'spend: 500000\ncap: 1000000\nstatus: ok\n'
    printf 'sampled_at_epoch: %s\n' "$sampled_at"
  } > "$directory/budget/live/$HOST"
  printf '%s\n' \
    '{"ts":"2026-09-17T11:00:00Z","base":"pace-a","role":"triager","input_tokens":100000,"output_tokens":0,"cache_creation_tokens":0}' \
    '{"ts":"2026-09-17T11:10:00Z","base":"pace-b","role":"triager","input_tokens":200000,"output_tokens":0,"cache_creation_tokens":0}' \
    '{"ts":"2026-09-17T11:20:00Z","base":"pace-c","role":"triager","input_tokens":300000,"output_tokens":0,"cache_creation_tokens":0}' \
    > "$directory/usage/pace.jsonl"
}

INPUTS="$TEMPORARY_ROOT/inputs"
make_pace_inputs "$INPUTS"
PROJECTION="$(env GARDEN="$HOST" GARDEN_TRIAGE_PACE_NOW="$NOW" \
  GARDEN_TRIAGE_PACE_FLOOR_SECONDS=120 GARDEN_TRIAGE_PACE_CEILING_SECONDS=3600 \
  GARDEN_TRIAGE_PACE_SNAPSHOT_MAX_AGE_SECONDS=7200 \
  "$JOBS/triager-pace.sh" "$INPUTS" triager)"
if jq -e '
    .status == "paced"
    and .estimated_cost_tokens == 200000
    and .sample_count == 3
    and .wake_after_seconds == 3600
    and .unclamped_wake_after_seconds > .ceiling_seconds
    and .reset_epoch > 0
    and .allowed_pace_tokens_per_second > 0
  ' <<<"$PROJECTION" >/dev/null; then
  ok "projection uses the trailing per-role median, sustainable pace, reset, and ceiling clamp"
else
  bad "projection was not the deterministic median/pace result: $PROJECTION"
fi

EMPTY="$TEMPORARY_ROOT/empty"
mkdir -p "$EMPTY"
FALLBACK="$(env GARDEN="$HOST" GARDEN_TRIAGE_PACE_NOW="$NOW" \
  "$JOBS/triager-pace.sh" "$EMPTY" triager)"
if jq -e '.status == "fallback" and .wake_after_seconds == 120 and .reason == "missing-cost-ledger"' \
    <<<"$FALLBACK" >/dev/null; then
  ok "absent cost inputs fail open to the current cadence"
else
  bad "absent-input fallback was wrong: $FALLBACK"
fi

STALE="$TEMPORARY_ROOT/stale"
make_pace_inputs "$STALE" "$((NOW - 1801))"
STALE_RESULT="$(env GARDEN="$HOST" GARDEN_TRIAGE_PACE_NOW="$NOW" \
  GARDEN_TRIAGE_PACE_SNAPSHOT_MAX_AGE_SECONDS=1800 \
  "$JOBS/triager-pace.sh" "$STALE" triager)"
if jq -e '.status == "fallback" and .wake_after_seconds == 120 and .reason == "stale-live-pace-input"' \
    <<<"$STALE_RESULT" >/dev/null; then
  ok "stale pace telemetry fails open to the current cadence"
else
  bad "stale-input fallback was wrong: $STALE_RESULT"
fi

# A real watched ref change must bypass a future marker.  The normal timer tick
# performs the lightweight remote-ref probe, sees the new commit, and invokes the
# handler in that same process without waiting for next_wake_epoch.
JOURNAL_REMOTE="$TEMPORARY_ROOT/journal.git"
JOURNAL_SEED="$TEMPORARY_ROOT/journal-seed"
git init -q --bare "$JOURNAL_REMOTE"
git init -q "$JOURNAL_SEED"
git -C "$JOURNAL_SEED" checkout -qb journal2
mkdir -p "$JOURNAL_SEED"/{cursors/activity,config,usage,budget/live,jobs/todo,jobs/doin,jobs/tada,inbox/maintainer/unread,inbox/maintainer/read}
make_pace_inputs "$JOURNAL_SEED"

SOURCE="$TEMPORARY_ROOT/source"
REPOSITORIES="$TEMPORARY_ROOT/repositories"
mkdir -p "$SOURCE" "$REPOSITORIES"
git init -q "$SOURCE"
git -C "$SOURCE" checkout -qb "$REF"
printf 'one\n' > "$SOURCE/value"
git -C "$SOURCE" add value
git -C "$SOURCE" "${GIT_ID[@]}" commit -qm one
OLD_SHA="$(git -C "$SOURCE" rev-parse HEAD)"
printf 'last_sha: %s\nref: %s\nlast_polled_at: 2026-09-17T11:00:00Z\n' \
  "$OLD_SHA" "$REF" > "$JOURNAL_SEED/cursors/activity/$SLUG"
git -C "$JOURNAL_SEED" add -A
git -C "$JOURNAL_SEED" "${GIT_ID[@]}" commit -qm seed
git -C "$JOURNAL_SEED" remote add origin "$JOURNAL_REMOTE"
git -C "$JOURNAL_SEED" push -qu origin journal2

WATCHED_BARE="$REPOSITORIES/$SLUG.git"
git init -q --bare "$WATCHED_BARE"
git -C "$WATCHED_BARE" remote add origin "$SOURCE"
git -C "$WATCHED_BARE" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
git -C "$WATCHED_BARE" fetch -q origin

PACE_STATE="$TEMPORARY_ROOT/state/triager/pace"
mkdir -p "$PACE_STATE"
{
  printf 'next_wake_epoch: %s\n' "$((NOW + 3500))"
  printf 'expected_sha: %s\n' "$OLD_SHA"
  printf 'ref: %s\nrole: triager\n' "$REF"
} > "$PACE_STATE/$SLUG"

printf 'two\n' > "$SOURCE/value"
git -C "$SOURCE" add value
git -C "$SOURCE" "${GIT_ID[@]}" commit -qm two
NEW_SHA="$(git -C "$SOURCE" rev-parse HEAD)"

HANDLER_CALLS="$TEMPORARY_ROOT/handler-calls"
HANDLER="$TEMPORARY_ROOT/handler"
cat > "$HANDLER" <<'EOF'
#!/bin/bash
printf '%s\t%s\t%s\n' "$1" "$2" "$3" >> "$HANDLER_CALLS"
EOF
chmod +x "$HANDLER"
DECISIONS="$TEMPORARY_ROOT/decisions"
DECISION_STUB="$TEMPORARY_ROOT/decision-stub"
cat > "$DECISION_STUB" <<'EOF'
#!/bin/bash
printf '%s\n' "$*" >> "$DECISIONS"
EOF
chmod +x "$DECISION_STUB"

TRIAGER_OUTPUT="$TEMPORARY_ROOT/triager-output"
if env GARDEN_TEST=1 GARDEN="$HOST" GARDEN_STATE="$TEMPORARY_ROOT/state" \
    JOURNAL_REMOTE="$JOURNAL_REMOTE" JOURNAL_BRANCH=journal2 \
    GARDEN_REPOS="$REPOSITORIES" GARDEN_WATCH_REF="$REF" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_CALLS="$HANDLER_CALLS" \
    GARDEN_DECISION_APPEND="$DECISION_STUB" DECISIONS="$DECISIONS" \
    GARDEN_TRIAGE_PACE_NOW="$NOW" \
    "$JOBS/triager.sh" "$SLUG" >"$TRIAGER_OUTPUT" 2>&1; then
  if [ "$(awk 'END {print NR}' "$HANDLER_CALLS")" -eq 1 ] \
     && [ "$(awk -F'\t' 'NR == 1 {print $3}' "$HANDLER_CALLS")" = "$NEW_SHA" ] \
     && grep -q 'preempts cost-aware wake' "$TRIAGER_OUTPUT" \
     && grep -q -- '--decision event-preempted-wake' "$DECISIONS"; then
    ok "a watched event preempts a future paced wake and is triaged immediately"
  else
    bad "event did not preempt cleanly (output: $(tr '\n' ' ' < "$TRIAGER_OUTPUT"))"
  fi
else
  bad "event-preemption triager run failed: $(tr '\n' ' ' < "$TRIAGER_OUTPUT")"
fi

unlink "$PACE_STATE/$SLUG" 2>/dev/null || true
FALLBACK_PROJECTOR="$TEMPORARY_ROOT/fallback-projector"
cat > "$FALLBACK_PROJECTOR" <<'EOF'
#!/bin/bash
printf '%s\n' '{"status":"fallback","role":"triager","wake_after_seconds":120,"floor_seconds":120,"ceiling_seconds":3600,"reason":"missing-pace-calibration"}'
EOF
chmod +x "$FALLBACK_PROJECTOR"
FALLBACK_OUTPUT="$TEMPORARY_ROOT/fallback-output"
for iteration in 1 2; do
  env GARDEN_TEST=1 GARDEN="$HOST" GARDEN_STATE="$TEMPORARY_ROOT/state" \
      JOURNAL_REMOTE="$JOURNAL_REMOTE" JOURNAL_BRANCH=journal2 \
      GARDEN_REPOS="$REPOSITORIES" GARDEN_WATCH_REF="$REF" \
      GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_CALLS="$HANDLER_CALLS" \
      GARDEN_DECISION_APPEND="$DECISION_STUB" DECISIONS="$DECISIONS" \
      GARDEN_TRIAGE_PACE_NOW="$NOW" GARDEN_TRIAGE_PACE_PROJECTOR="$FALLBACK_PROJECTOR" \
      "$JOBS/triager.sh" "$SLUG" >>"$FALLBACK_OUTPUT" 2>&1
done
if [ "$(grep -c 'triager pacing unavailable.*using the current timer cadence' "$FALLBACK_OUTPUT")" -eq 1 ]; then
  ok "repeated missing pace inputs emit one deduplicated fail-open warning"
else
  bad "fallback warning was not deduplicated: $(tr '\n' ' ' < "$FALLBACK_OUTPUT")"
fi

# A LIVE holder of the pacing clone's lock must make the nonessential refresh fail
# FAST and OPEN — one short bounded wait, then the existing pacing warning latch —
# never the default 3×60s wait ladder followed by a FATAL die merely to schedule a
# next wake. Hold the lock for the whole run and assert the tick takes the soft path.
CONTEND_STATE="$TEMPORARY_ROOT/contend-state"
mkdir -p "$CONTEND_STATE/triager-pace"
PACE_CLONE_LOCK="$CONTEND_STATE/triager-pace/journal.lock"
: > "$PACE_CLONE_LOCK"   # empty stamp → never reads as stale, so soft mode cannot reclaim it
( exec 9<>"$PACE_CLONE_LOCK"; flock -x 9; sleep 40 ) &
HOLDER_PID=$!
sleep 1   # let the holder acquire the exclusive lock before the tick runs
CONTEND_OUTPUT="$TEMPORARY_ROOT/contend-output"
if timeout 45 env GARDEN_TEST=1 GARDEN="$HOST" GARDEN_STATE="$CONTEND_STATE" \
    JOURNAL_REMOTE="$JOURNAL_REMOTE" JOURNAL_BRANCH=journal2 \
    GARDEN_REPOS="$REPOSITORIES" GARDEN_WATCH_REF="$REF" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_CALLS="$HANDLER_CALLS" \
    GARDEN_DECISION_APPEND="$DECISION_STUB" DECISIONS="$DECISIONS" \
    GARDEN_TRIAGE_PACE_NOW="$NOW" GARDEN_TRIAGE_PACE_PROJECTOR="$FALLBACK_PROJECTOR" \
    GARDEN_LOCK_SOFT_WAIT=2 \
    "$JOBS/triager.sh" "$SLUG" >"$CONTEND_OUTPUT" 2>&1; then
  if grep -q 'abandoning this OPTIONAL refresh' "$CONTEND_OUTPUT" \
     && grep -q 'triager pacing unavailable.*using the current timer cadence' "$CONTEND_OUTPUT" \
     && ! grep -qi 'FATAL' "$CONTEND_OUTPUT" \
     && ! grep -q 'cannot acquire clone lock' "$CONTEND_OUTPUT"; then
    ok "a live pacing-clone lock holder makes the refresh fail fast and open (soft wait, no FATAL, no 3×60s ladder)"
  else
    bad "pacing refresh did not fail fast/open under lock contention: $(tr '\n' ' ' < "$CONTEND_OUTPUT")"
  fi
else
  bad "pacing refresh under lock contention did not complete within the fail-fast bound: $(tr '\n' ' ' < "$CONTEND_OUTPUT")"
fi
kill "$HOLDER_PID" 2>/dev/null || true
wait "$HOLDER_PID" 2>/dev/null || true

echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
