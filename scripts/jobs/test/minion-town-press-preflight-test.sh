#!/bin/bash
# minion-town-press-preflight-test.sh — coverage for the deterministic PARK gate
# minion-town-press-preflight.sh (kriscendobot/garden#58, kriskowal 2026-08-23:
# "if we see there are no next steps twice, or we have spent half our weekly token
#  budget on the press, just park the scheduled press").
#
# The gate decides, in plain code:
#   exit 0 = work present → dispatch a fresh press tick
#   exit 2 = PARKED       → advance the clock only, dispatch nothing
# It parks ONLY on a positively-observed condition (BUDGET: half the weekly quota
# spent on the press over the trailing window; or IDLE: the two most-recent press
# ticks both marked `press-status: no-next-step`). Everything ambiguous fails OPEN.
#
# Hermetic: a throwaway bare journal stands in for origin/journal2 (the gate's
# ensure_clone/sync_clone clone from it); usage ledgers and tada reports are
# seeded fixtures; alerts are captured through GARDEN_ALERT_CMD. No systemd, no
# live journal, no GitHub.
#
# Usage: minion-town-press-preflight-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PRE="$JOBS/minion-town-press-preflight.sh"
RESUME="$JOBS/resume-minion-town-press.sh"
PREFIX=minion-town-agenda-review
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet GARDEN_*/JOURNAL_* so a live gardener running this test cannot
# splice the real journal under the fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-minion-town-press-preflight-test
rm -rf "$TR"; mkdir -p "$TR"
BARE="$TR/journal.git"
BRANCH=journal2
ALERTLOG="$TR/alerts.log"
ALERTCMD="$TR/alert-cmd.sh"
printf '#!/bin/bash\nprintf "%%s\\t%%s\\n" "$1" "$2" >> "%s"\n' "$ALERTLOG" > "$ALERTCMD"
chmod +x "$ALERTCMD"
git_id=(-c user.name=test -c user.email=test@localhost)

# --- seed the bare origin fresh (empty board) --------------------------------
reset_bare() {
  rm -rf "$BARE" "$TR/seed" "$TR/state" "$ALERTLOG"
  git init -q --bare "$BARE"
  local SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
  ( cd "$SEED"
    mkdir -p schedules jobs/tada usage
    touch schedules/.gitkeep jobs/tada/.gitkeep usage/.gitkeep
    printf 'cadence: 2h\nlast_dispatched: 2026-08-23T00:00:00Z\njob_basename_prefix: %s\npreflight: minion-town-press-preflight.sh\n---\npress body\n' "$PREFIX" > "schedules/$PREFIX.md" )
  git -C "$SEED" add -A
  git -C "$SEED" "${git_id[@]}" commit -q -m seed
  git -C "$SEED" remote add origin "$BARE"
  git -C "$SEED" push -q -u origin "$BRANCH"
}

# Commit an arbitrary file into the bare journal at <relpath> with <content>.
seed_file() {  # seed_file <relpath> <content>
  local rel="$1" body="$2" wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  mkdir -p "$wt/$(dirname "$rel")"
  printf '%s' "$body" > "$wt/$rel"
  git -C "$wt" add -A; git -C "$wt" "${git_id[@]}" commit -q -m "seed $rel"
  git -C "$wt" push -q origin "$BRANCH"
  rm -rf "$wt"
}

# A press tada report carrying (or omitting) the machine-readable status marker.
tada_report() {  # tada_report <ts:YYYYMMDD-HHMMSS> <advanced|no-next-step|none>
  local ts="$1" status="$2" body="## Completion report\nEngagement complete.\n"
  case "$status" in
    none) : ;;
    *) body="${body}\npress-status: ${status}\n" ;;
  esac
  seed_file "jobs/tada/$PREFIX-$ts.md" "$(printf "$body")"
}

# A usage ledger for one press tick with a single billable result row.
usage_ledger() {  # usage_ledger <ts:YYYYMMDD-HHMMSS> <iso-ts> <billable-tokens>
  local ts="$1" iso="$2" tok="$3"
  seed_file "usage/$PREFIX-$ts.jsonl" \
    "$(printf '{"source":"result","input_tokens":0,"output_tokens":%s,"cache_creation_tokens":0,"ts":"%s","base":"%s-%s"}\n{"source":"none","ts":"%s","base":"%s-%s","outcome":"tada"}\n' \
        "$tok" "$iso" "$PREFIX" "$ts" "$iso" "$PREFIX" "$ts")"
}

run_pre() {  # run_pre [env-assignments...] → fills $OUT/$RC
  rm -rf "$TR/clone"
  set +e
  OUT="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
             GARDEN=testhost GARDEN_STATE="$TR/state" \
             GARDEN_MT_PRESS_PREFLIGHT_CLONE="$TR/clone" \
             GARDEN_ALERT_CMD="$ALERTCMD" \
             "$@" \
             bash "$PRE" "$PREFIX.md" 2>&1)"
  RC=$?
  set -e
}
alert_count() { [ -f "$ALERTLOG" ] && wc -l < "$ALERTLOG" | tr -d ' ' || echo 0; }

# ============================================================================
hr; echo "STATIC — scripts parse (bash -n)"; hr
bash -n "$PRE" && ok "preflight parses" || bad "preflight syntax error"
bash -n "$RESUME" && ok "resume parses" || bad "resume syntax error"

# ============================================================================
hr; echo "DISPATCH — empty board (no reports, no quota): exit 0"; hr
reset_bare
run_pre
[ "$RC" -eq 0 ] && ok "no reports → dispatch (exit 0)" || bad "exit $RC (want 0); OUT=$OUT"

# ============================================================================
hr; echo "DISPATCH — one idle report only (need two): exit 0"; hr
reset_bare
tada_report 20260823-120000 no-next-step
run_pre
[ "$RC" -eq 0 ] && ok "single idle report → dispatch" || bad "exit $RC (want 0); OUT=$OUT"

# ============================================================================
hr; echo "PARK (IDLE) — two most-recent reports both no-next-step: exit 2 + one alert"; hr
reset_bare
tada_report 20260823-100000 no-next-step
tada_report 20260823-120000 no-next-step
run_pre
[ "$RC" -eq 2 ] && ok "two idle reports → park (exit 2)" || bad "exit $RC (want 2); OUT=$OUT"
[ "$(alert_count)" = 1 ] && ok "parking paged the maintainer once" || bad "alert count $(alert_count) (want 1)"

# ============================================================================
hr; echo "DISPATCH — most-recent report is 'advanced' (streak broken): exit 0"; hr
reset_bare
tada_report 20260823-100000 no-next-step
tada_report 20260823-120000 advanced      # newest = advanced → not idle
run_pre
[ "$RC" -eq 0 ] && ok "advanced newest → dispatch" || bad "exit $RC (want 0); OUT=$OUT"

# ============================================================================
hr; echo "DISPATCH — legacy unmarked newest report (deploy transition): exit 0"; hr
reset_bare
tada_report 20260823-100000 no-next-step
tada_report 20260823-120000 none          # newest has no marker → treated advanced
run_pre
[ "$RC" -eq 0 ] && ok "unmarked newest → dispatch (never park on history)" || bad "exit $RC (want 0); OUT=$OUT"

# ============================================================================
hr; echo "RESUME — watermark makes the gate ignore the two stale idle reports: exit 0"; hr
reset_bare
tada_report 20260821-100000 no-next-step
tada_report 20260821-120000 no-next-step
# Confirm it parks first.
run_pre
[ "$RC" -eq 2 ] && ok "pre-resume: parked" || bad "pre-resume exit $RC (want 2); OUT=$OUT"
# Run the resume helper against the SAME per-host state, then re-evaluate.
env GARDEN=testhost GARDEN_STATE="$TR/state" bash "$RESUME" >/dev/null 2>&1
run_pre
[ "$RC" -eq 0 ] && ok "post-resume: stale idle reports ignored → dispatch" || bad "post-resume exit $RC (want 0); OUT=$OUT"

# ============================================================================
hr; echo "PARK (BUDGET) — press spend >= half the weekly quota: exit 2 + alert"; hr
reset_bare
# Two in-window ticks, 300 output tokens each = 600 billable; quota 1000 → half=500.
NOW_ISO="$(date -u +%FT%TZ)"
usage_ledger 20260823-100000 "$NOW_ISO" 300
usage_ledger 20260823-120000 "$NOW_ISO" 300
run_pre GARDEN_TOKEN_WEEKLY_QUOTA=1000
[ "$RC" -eq 2 ] && ok "600 >= 500 (half of 1000) → park (exit 2)" || bad "exit $RC (want 2); OUT=$OUT"
[ "$(alert_count)" -ge 1 ] && ok "budget park paged the maintainer" || bad "no budget alert"

# ============================================================================
hr; echo "DISPATCH (BUDGET) — press spend under half the quota: exit 0"; hr
reset_bare
NOW_ISO="$(date -u +%FT%TZ)"
usage_ledger 20260823-100000 "$NOW_ISO" 100
usage_ledger 20260823-120000 "$NOW_ISO" 100    # 200 < 500
run_pre GARDEN_TOKEN_WEEKLY_QUOTA=1000
[ "$RC" -eq 0 ] && ok "200 < 500 → dispatch" || bad "exit $RC (want 0); OUT=$OUT"

# ============================================================================
hr; echo "DISPATCH (BUDGET) — old spend ages out of the window: exit 0"; hr
reset_bare
OLD_ISO="2026-01-01T00:00:00Z"                 # far outside the 7d window
usage_ledger 20260101-000000 "$OLD_ISO" 100000
run_pre GARDEN_TOKEN_WEEKLY_QUOTA=1000
[ "$RC" -eq 0 ] && ok "stale spend excluded → dispatch (self-recovering)" || bad "exit $RC (want 0); OUT=$OUT"

# ============================================================================
# The safety invariant: an unreadable/offline journal must NEVER PARK (exit 2) —
# ensure_clone dies / sync_clone exits EX_TEMPFAIL, both non-2 exits the scheduler
# treats as work-present (fail open). We assert the gate does not silently park.
hr; echo "FAIL OPEN — journal fetch fails on an existing clone: never park (RC != 2)"; hr
reset_bare
run_pre                       # a good clone lands in $TR/clone
rm -rf "$BARE"                # remote now gone; the local clone persists
set +e
OUT="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
           GARDEN=testhost GARDEN_STATE="$TR/state" \
           GARDEN_MT_PRESS_PREFLIGHT_CLONE="$TR/clone" GARDEN_ALERT_CMD="$ALERTCMD" \
           bash "$PRE" "$PREFIX.md" 2>&1)"
RC=$?
set -e
[ "$RC" -ne 2 ] && ok "unreadable journal → never park (RC=$RC, fail open)" || bad "PARKED on an unreadable journal! OUT=$OUT"

# ============================================================================
hr
echo "minion-town-press-preflight: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
