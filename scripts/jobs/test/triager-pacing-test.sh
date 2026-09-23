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
# Disable the shared cooldown gate here so BOTH iterations reach the projector and this
# test isolates the WARNING-LATCH dedup (the gate has its own coverage below); with the
# gate on and a frozen clock the second tick would be gate-skipped instead.
for iteration in 1 2; do
  env GARDEN_TEST=1 GARDEN="$HOST" GARDEN_STATE="$TEMPORARY_ROOT/state" \
      JOURNAL_REMOTE="$JOURNAL_REMOTE" JOURNAL_BRANCH=journal2 \
      GARDEN_REPOS="$REPOSITORIES" GARDEN_WATCH_REF="$REF" \
      GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_CALLS="$HANDLER_CALLS" \
      GARDEN_DECISION_APPEND="$DECISION_STUB" DECISIONS="$DECISIONS" \
      GARDEN_TRIAGE_PACE_NOW="$NOW" GARDEN_TRIAGE_PACE_PROJECTOR="$FALLBACK_PROJECTOR" \
      GARDEN_TRIAGE_PACE_COOLDOWN=0 \
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

# The shared cooldown gate collapses a herd of concurrent per-repo ticks onto the ONE
# shared pace clone: only the FIRST tick within the window performs the refresh (touches
# the projector/clone); every other tick inside the window skips it cleanly and keeps the
# fixed timer cadence. A frozen clock keeps the gate from expiring, so ticks 2+ are gated.
# A FALLBACK projector keeps triager_pace_schedule from writing a per-slug marker, so the
# top paced-defer never short-circuits and every tick actually reaches the gate.
GATE_STATE="$TEMPORARY_ROOT/gate-state"
GATE_PROJECTOR_CALLS="$TEMPORARY_ROOT/gate-projector-calls"
GATE_PROJECTOR="$TEMPORARY_ROOT/gate-projector"
cat > "$GATE_PROJECTOR" <<EOF
#!/bin/bash
echo call >> "$GATE_PROJECTOR_CALLS"
printf '%s\n' '{"status":"fallback","role":"triager","wake_after_seconds":120,"floor_seconds":120,"ceiling_seconds":3600,"reason":"missing-pace-calibration"}'
EOF
chmod +x "$GATE_PROJECTOR"
GATE_OUTPUT="$TEMPORARY_ROOT/gate-output"
for iteration in 1 2 3; do
  env GARDEN_TEST=1 GARDEN="$HOST" GARDEN_STATE="$GATE_STATE" \
      JOURNAL_REMOTE="$JOURNAL_REMOTE" JOURNAL_BRANCH=journal2 \
      GARDEN_REPOS="$REPOSITORIES" GARDEN_WATCH_REF="$REF" \
      GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_CALLS="$HANDLER_CALLS" \
      GARDEN_DECISION_APPEND="$DECISION_STUB" DECISIONS="$DECISIONS" \
      GARDEN_TRIAGE_PACE_NOW="$NOW" GARDEN_TRIAGE_PACE_PROJECTOR="$GATE_PROJECTOR" \
      GARDEN_TRIAGE_PACE_COOLDOWN=300 \
      "$JOBS/triager.sh" "$SLUG" >>"$GATE_OUTPUT" 2>&1
done
GATE_CALLS="$(awk 'END {print NR}' "$GATE_PROJECTOR_CALLS" 2>/dev/null || echo 0)"
GATE_SKIPS="$(grep -c 'pace refresh gated' "$GATE_OUTPUT" || true)"
if [ "$GATE_CALLS" -eq 1 ] && [ "$GATE_SKIPS" -ge 2 ]; then
  ok "shared cooldown gate lets one tick refresh and gate-skips the rest within the window"
else
  bad "gate did not collapse the herd (projector calls=$GATE_CALLS, gate-skips=$GATE_SKIPS): $(tr '\n' ' ' < "$GATE_OUTPUT")"
fi

# With the gate DISABLED (cooldown 0) every tick refreshes — the pre-gate behavior — so a
# deployment can turn the gate off entirely.
NOGATE_CALLS_FILE="$TEMPORARY_ROOT/nogate-projector-calls"
NOGATE_PROJECTOR="$TEMPORARY_ROOT/nogate-projector"
cat > "$NOGATE_PROJECTOR" <<EOF
#!/bin/bash
echo call >> "$NOGATE_CALLS_FILE"
printf '%s\n' '{"status":"fallback","role":"triager","wake_after_seconds":120,"floor_seconds":120,"ceiling_seconds":3600,"reason":"missing-pace-calibration"}'
EOF
chmod +x "$NOGATE_PROJECTOR"
NOGATE_STATE="$TEMPORARY_ROOT/nogate-state"
for iteration in 1 2; do
  env GARDEN_TEST=1 GARDEN="$HOST" GARDEN_STATE="$NOGATE_STATE" \
      JOURNAL_REMOTE="$JOURNAL_REMOTE" JOURNAL_BRANCH=journal2 \
      GARDEN_REPOS="$REPOSITORIES" GARDEN_WATCH_REF="$REF" \
      GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_CALLS="$HANDLER_CALLS" \
      GARDEN_DECISION_APPEND="$DECISION_STUB" DECISIONS="$DECISIONS" \
      GARDEN_TRIAGE_PACE_NOW="$NOW" GARDEN_TRIAGE_PACE_PROJECTOR="$NOGATE_PROJECTOR" \
      GARDEN_TRIAGE_PACE_COOLDOWN=0 \
      "$JOBS/triager.sh" "$SLUG" >/dev/null 2>&1
done
if [ "$(awk 'END {print NR}' "$NOGATE_CALLS_FILE" 2>/dev/null || echo 0)" -eq 2 ]; then
  ok "cooldown 0 disables the gate: every tick refreshes (pre-gate behavior)"
else
  bad "disabled gate did not refresh every tick: calls=$(awk 'END {print NR}' "$NOGATE_CALLS_FILE" 2>/dev/null || echo 0)"
fi

# Contention backoff: a PERSISTENTLY busy pacing clone must warn ONCE, then be skipped
# QUIETLY by every subsequent tick until the longer host-shared backoff expires, then
# RECOVER. The 30s refresh gate alone lets one tick per window re-hit the busy lock and
# re-warn; the contention backoff is what collapses that to a single warning + clean silence.
# A live lock holder makes tick 1's optional refresh fail soft (EX_TEMPFAIL), arming the
# backoff; ticks 2-3 at the same frozen clock are inside the window and skip before touching
# the lock; tick 4 past the window (clock advanced, lock released) retries and recovers.
CB_STATE="$TEMPORARY_ROOT/contention-backoff-state"
CB_PROJECTOR_CALLS="$TEMPORARY_ROOT/cb-projector-calls"
CB_PROJECTOR="$TEMPORARY_ROOT/cb-projector"
cat > "$CB_PROJECTOR" <<EOF
#!/bin/bash
echo call >> "$CB_PROJECTOR_CALLS"
printf '%s\n' '{"status":"paced","role":"triager","wake_after_seconds":600,"floor_seconds":120,"ceiling_seconds":3600,"reason":"contention-backoff-stub"}'
EOF
chmod +x "$CB_PROJECTOR"
mkdir -p "$CB_STATE/triager-pace"
CB_PACE_LOCK="$CB_STATE/triager-pace/journal.lock"
: > "$CB_PACE_LOCK"   # empty stamp → never reads as stale, so soft mode cannot reclaim it
( exec 9<>"$CB_PACE_LOCK"; flock -x 9; sleep 30 ) &
CB_HOLDER_PID=$!
sleep 1   # let the holder acquire the exclusive lock before tick 1 runs

cb_tick() { # <output-file> <now>
  timeout 45 env GARDEN_TEST=1 GARDEN="$HOST" GARDEN_STATE="$CB_STATE" \
      JOURNAL_REMOTE="$JOURNAL_REMOTE" JOURNAL_BRANCH=journal2 \
      GARDEN_REPOS="$REPOSITORIES" GARDEN_WATCH_REF="$REF" \
      GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_CALLS="$HANDLER_CALLS" \
      GARDEN_DECISION_APPEND="$DECISION_STUB" DECISIONS="$DECISIONS" \
      GARDEN_TRIAGE_PACE_NOW="$2" GARDEN_TRIAGE_PACE_PROJECTOR="$CB_PROJECTOR" \
      GARDEN_TRIAGE_PACE_COOLDOWN=30 GARDEN_TRIAGE_PACE_CONTENTION_COOLDOWN=300 \
      GARDEN_LOCK_SOFT_WAIT=2 \
      "$JOBS/triager.sh" "$SLUG" >"$1" 2>&1 || true
}

CB_TICK1="$TEMPORARY_ROOT/cb-tick1"
cb_tick "$CB_TICK1" "$NOW"
kill "$CB_HOLDER_PID" 2>/dev/null || true
wait "$CB_HOLDER_PID" 2>/dev/null || true

CB_SKIPS="$TEMPORARY_ROOT/cb-skips"
: > "$CB_SKIPS"
for iteration in 2 3; do
  CB_SKIP_OUT="$TEMPORARY_ROOT/cb-tick$iteration"
  cb_tick "$CB_SKIP_OUT" "$NOW"
  cat "$CB_SKIP_OUT" >> "$CB_SKIPS"
done

# Sample the projector-call count BEFORE the recovery tick: ticks 1-3 must never reach the
# projector (tick 1 fails at the lock, ticks 2-3 skip under backoff before touching it).
CB_CALLS_BEFORE_RECOVERY="$(awk 'END {print NR}' "$CB_PROJECTOR_CALLS" 2>/dev/null || echo 0)"

CB_TICK4="$TEMPORARY_ROOT/cb-tick4"
cb_tick "$CB_TICK4" "$((NOW + 301))"

CB_WARN1="$(grep -c 'triager pacing unavailable' "$CB_TICK1" || true)"
CB_SKIP_WARNS="$(grep -c 'triager pacing unavailable' "$CB_SKIPS" || true)"
CB_SKIP_MSGS="$(grep -c 'contention backoff' "$CB_SKIPS" || true)"
CB_SKIP_LOCK="$(grep -c 'abandoning this OPTIONAL refresh' "$CB_SKIPS" || true)"
if [ "$CB_WARN1" -ge 1 ] && [ "$CB_CALLS_BEFORE_RECOVERY" -eq 0 ] \
   && [ "$CB_SKIP_WARNS" -eq 0 ] && [ "$CB_SKIP_MSGS" -ge 2 ] && [ "$CB_SKIP_LOCK" -eq 0 ]; then
  ok "a soft pacing-clone lock failure warns once, then ticks skip the refresh quietly under contention backoff"
else
  bad "contention backoff did not suppress the repeated warnings (tick1 warns=$CB_WARN1, projector-calls=$CB_CALLS_BEFORE_RECOVERY, skip-warns=$CB_SKIP_WARNS, skip-msgs=$CB_SKIP_MSGS, skip-lock=$CB_SKIP_LOCK): $(tr '\n' ' ' < "$CB_SKIPS")"
fi

CB_CALLS_AFTER_RECOVERY="$(awk 'END {print NR}' "$CB_PROJECTOR_CALLS" 2>/dev/null || echo 0)"
if [ "$CB_CALLS_AFTER_RECOVERY" -eq 1 ] \
   && grep -q 'triager pacing inputs recovered' "$CB_TICK4" \
   && [ -r "$CB_STATE/triager/pace/$SLUG" ]; then
  ok "a tick past the contention window retries the refresh and recovers"
else
  bad "contention backoff did not recover after expiry (projector-calls=$CB_CALLS_AFTER_RECOVERY): $(tr '\n' ' ' < "$CB_TICK4")"
fi

# --- no-op churn guard: an UNCHANGED pacing decision is not re-recorded ----------
# Every paced tick used to append a `triager-pacing:current-cadence` decision, and each
# decision is a journal COMMIT: 12,125 of the journal's 12,267 decision commits over
# 2026-09-20..23 (78% of ALL journal traffic) were this one no-op, driving the journal
# to 146k commits and wedging every consumer clone's capped fetch. A repeated, unchanged
# decision must now be suppressed; a CHANGED one must still be recorded.
NC_STATE="$TEMPORARY_ROOT/nochurn-state"
NC_DECISIONS="$TEMPORARY_ROOT/nochurn-decisions"
NC_PROJECTOR="$TEMPORARY_ROOT/nochurn-projector"
NC_WAKE_FILE="$TEMPORARY_ROOT/nochurn-wake"
printf '120\n' > "$NC_WAKE_FILE"
cat > "$NC_PROJECTOR" <<'EOF'
#!/bin/bash
wake="$(cat "$NC_WAKE_FILE")"
printf '{"status":"paced","role":"triager","wake_after_seconds":%s,"floor_seconds":120,"ceiling_seconds":3600,"reason":"calibrated"}\n' "$wake"
EOF
chmod +x "$NC_PROJECTOR"

nc_tick() { # <output-file> <now>
  timeout 45 env GARDEN_TEST=1 GARDEN="$HOST" GARDEN_STATE="$NC_STATE" \
      JOURNAL_REMOTE="$JOURNAL_REMOTE" JOURNAL_BRANCH=journal2 \
      GARDEN_REPOS="$REPOSITORIES" GARDEN_WATCH_REF="$REF" \
      GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_CALLS="$HANDLER_CALLS" \
      GARDEN_DECISION_APPEND="$DECISION_STUB" DECISIONS="$NC_DECISIONS" \
      NC_WAKE_FILE="$NC_WAKE_FILE" \
      GARDEN_TRIAGE_PACE_NOW="$2" GARDEN_TRIAGE_PACE_PROJECTOR="$NC_PROJECTOR" \
      GARDEN_TRIAGE_PACE_COOLDOWN=0 \
      "$JOBS/triager.sh" "$SLUG" >"$1" 2>&1 || true
}

: > "$NC_DECISIONS"
# Three consecutive ticks at an unchanged cadence (wake == floor -> current-cadence).
nc_tick "$TEMPORARY_ROOT/nc-tick1" "$NOW"
nc_tick "$TEMPORARY_ROOT/nc-tick2" "$((NOW + 200))"
nc_tick "$TEMPORARY_ROOT/nc-tick3" "$((NOW + 400))"
NC_CURRENT="$(grep -c -- '--decision current-cadence' "$NC_DECISIONS" || true)"
if [ "$NC_CURRENT" -eq 1 ] && [ -r "$NC_STATE/triager/pace/$SLUG" ]; then
  ok "an unchanged pacing decision is recorded once, not on every tick"
else
  bad "no-op pacing churn not suppressed (current-cadence records=$NC_CURRENT, want 1): $(tr '\n' ' ' < "$NC_DECISIONS")"
fi

# A CHANGED decision must still be recorded: raise the projected wake above the floor
# so the branch flips to defer-wake.
printf '900\n' > "$NC_WAKE_FILE"
nc_tick "$TEMPORARY_ROOT/nc-tick4" "$((NOW + 600))"
NC_DEFER="$(grep -c -- '--decision defer-wake' "$NC_DECISIONS" || true)"
if [ "$NC_DEFER" -eq 1 ]; then
  ok "a CHANGED pacing decision is still recorded through the churn guard"
else
  bad "changed pacing decision was suppressed (defer-wake records=$NC_DEFER, want 1): $(tr '\n' ' ' < "$NC_DECISIONS")"
fi

# --- no-op churn guard: the FAIL-OPEN branch is not re-recorded per tick -----------
# When the projector cannot pace (status != paced) the tick fails open to the fixed
# timer cadence. That branch used to record a `triager-pacing:current-cadence` /
# `fail-open-skipped` decision on EVERY tick — 28 such journal commits in ~80 min on
# one repo after the paced fix deployed, the same churn on the other branch. A
# repeated fail-open with an unchanged (status,reason) must now be recorded once; a
# reason CHANGE must produce a second record.
FO_STATE="$TEMPORARY_ROOT/failopen-state"
FO_DECISIONS="$TEMPORARY_ROOT/failopen-decisions"
FO_PROJECTOR="$TEMPORARY_ROOT/failopen-projector"
FO_REASON_FILE="$TEMPORARY_ROOT/failopen-reason"
printf 'missing-role-cost-samples\n' > "$FO_REASON_FILE"
cat > "$FO_PROJECTOR" <<'EOF'
#!/bin/bash
reason="$(cat "$FO_REASON_FILE")"
printf '{"status":"fallback","role":"triager","wake_after_seconds":120,"floor_seconds":120,"ceiling_seconds":3600,"reason":"%s"}\n' "$reason"
EOF
chmod +x "$FO_PROJECTOR"

fo_tick() { # <output-file> <now>
  timeout 45 env GARDEN_TEST=1 GARDEN="$HOST" GARDEN_STATE="$FO_STATE" \
      JOURNAL_REMOTE="$JOURNAL_REMOTE" JOURNAL_BRANCH=journal2 \
      GARDEN_REPOS="$REPOSITORIES" GARDEN_WATCH_REF="$REF" \
      GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_CALLS="$HANDLER_CALLS" \
      GARDEN_DECISION_APPEND="$DECISION_STUB" DECISIONS="$FO_DECISIONS" \
      FO_REASON_FILE="$FO_REASON_FILE" \
      GARDEN_TRIAGE_PACE_NOW="$2" GARDEN_TRIAGE_PACE_PROJECTOR="$FO_PROJECTOR" \
      GARDEN_TRIAGE_PACE_COOLDOWN=0 \
      "$JOBS/triager.sh" "$SLUG" >"$1" 2>&1 || true
}

: > "$FO_DECISIONS"
# Three consecutive fail-open ticks with an UNCHANGED reason.
fo_tick "$TEMPORARY_ROOT/fo-tick1" "$NOW"
fo_tick "$TEMPORARY_ROOT/fo-tick2" "$((NOW + 200))"
fo_tick "$TEMPORARY_ROOT/fo-tick3" "$((NOW + 400))"
FO_SKIPPED="$(grep -c -- '--outcome fail-open-skipped' "$FO_DECISIONS" || true)"
if [ "$FO_SKIPPED" -eq 1 ] && [ -r "$FO_STATE/triager/pace/failopen-$SLUG" ]; then
  ok "an unchanged fail-open decision is recorded once, not on every tick"
else
  bad "fail-open churn not suppressed (fail-open-skipped records=$FO_SKIPPED, want 1): $(tr '\n' ' ' < "$FO_DECISIONS")"
fi

# A reason CHANGE must still be recorded: flip the projector's fallback reason.
printf 'stale-live-pace-input\n' > "$FO_REASON_FILE"
fo_tick "$TEMPORARY_ROOT/fo-tick4" "$((NOW + 600))"
FO_SKIPPED_AFTER="$(grep -c -- '--outcome fail-open-skipped' "$FO_DECISIONS" || true)"
FO_NEW_REASON="$(grep -c -- '--reason stale-live-pace-input' "$FO_DECISIONS" || true)"
if [ "$FO_SKIPPED_AFTER" -eq 2 ] && [ "$FO_NEW_REASON" -eq 1 ]; then
  ok "a CHANGED fail-open reason is still recorded through the churn guard"
else
  bad "changed fail-open reason was suppressed (fail-open-skipped records=$FO_SKIPPED_AFTER want 2, new-reason=$FO_NEW_REASON want 1): $(tr '\n' ' ' < "$FO_DECISIONS")"
fi

echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
