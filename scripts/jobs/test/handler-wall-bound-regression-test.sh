#!/bin/bash
# handler-wall-bound-regression-test.sh — end-to-end evidence for the handler wall
# bound: a claimed handler whose whole tree resists SIGTERM is ended by the wall,
# and the REAL gardener.sh returns within budget + the promised 60-second bound.
#
# Production promise (gardener.sh): the watchdog TERMs the handler's process tree
# at budget + GARDEN_HANDLER_WATCHDOG_GRACE and KILLs it at budget +
# GARDEN_HANDLER_KILL_AFTER (default 60s). The fixture shortens the budget and
# kill-after so it runs in seconds, but asserts the worker's return against the
# unshortened 60-second production figure, and checks that figure is still the
# shipped default.
#
# The handler (wall-tree-handler-stub.sh) ignores TERM and spawns a same-group
# TERM-ignoring child, a same-group child whose TERM trap blocks for 300s, and a
# setsid child (its own session/group, out of reach of any group signal) with a
# TERM-ignoring grandchild. Each case asserts:
#   * every recorded member, including the escaped session, is dead by
#     start + budget + kill-after (+ polling slack), and no process carrying the
#     fixture's token survives the worker;
#   * the failure record carries the watchdog evidence (DEADLINE, TERM, KILL) and
#     a wall-overrun rc with a bounded handler elapsed;
#   * gardener.sh returns by start + budget + 60s.
# CASE A — `timeout` is intact: the realistic path, where `timeout --foreground`
#          signals only the direct handler and the watchdog must reach the rest.
# CASE B — the handler SIGSTOPs `timeout`, so only the independent watchdog acts.
#
# Leak/hang safety: every wait is a bounded poll; the EXIT/INT/TERM trap SIGCONTs
# and KILLs every recorded pid, reaps any still-running gardener tree, and sweeps
# /proc for the per-run token. systemd and cgroups are not required (the
# per-unit cgroup sweep is a separate restart backstop).
# Usage: handler-wall-bound-regression-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# shellcheck disable=SC2046  # word-split the variable list on purpose
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# shellcheck source=../common.sh
source "$JOBS/common.sh"

# The promised production wall bound past the budget; the fixture's return
# assertion uses this, never the shortened test kill-after.
PROMISED_WALL=60
BUDGET=2; GRACE=1; KILL_AFTER=4
# Polling slack: the gardener and watchdog poll once a second, and `date +%s`
# ticks at whole seconds.
SLACK=3

TOKEN="garden-wall-tree-$$-$RANDOM$RANDOM"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-wall-bound.XXXXXX")"
GARDENER_PIDS=()

token_pids() {
  local d
  for d in /proc/[0-9]*; do
    [ "${d#/proc/}" = "$$" ] && continue
    tr '\0' ' ' 2>/dev/null < "$d/cmdline" | grep -qF -- "$TOKEN" && printf '%s\n' "${d#/proc/}"
  done
  return 0
}
recorded_pids() { # <pidfile>
  awk '$1 != "start" && $2 ~ /^[0-9]+$/ {print $2}' "$1" 2>/dev/null || true
}
cleanup() {
  local p f
  set +e
  for p in "${GARDENER_PIDS[@]}"; do
    kill -0 "$p" 2>/dev/null && reap_process_tree "$p" 0 5
  done
  for f in "$TR"/*.pids; do
    [ -e "$f" ] || continue
    for p in $(recorded_pids "$f"); do kill -CONT "$p" 2>/dev/null; kill -KILL "$p" 2>/dev/null; done
  done
  for p in $(token_pids); do kill -CONT "$p" 2>/dev/null; kill -KILL "$p" 2>/dev/null; done
  rm -rf "$TR"
}
trap cleanup EXIT
trap 'exit 130' INT TERM

# ============================================================================
hr; echo "PRECONDITION — the production wall bound is still ${PROMISED_WALL}s"; hr
if grep -q '^: "${GARDEN_HANDLER_KILL_AFTER:=60}"$' "$JOBS/gardener.sh"; then
  ok "gardener.sh ships GARDEN_HANDLER_KILL_AFTER=${PROMISED_WALL}"
else
  bad "gardener.sh default GARDEN_HANDLER_KILL_AFTER is no longer ${PROMISED_WALL}s; revisit the promise"
fi
if [ "$KILL_AFTER" -lt "$PROMISED_WALL" ] && [ "$GRACE" -lt "$KILL_AFTER" ]; then
  ok "the shortened fixture bound (grace ${GRACE}s < kill-after ${KILL_AFTER}s) is tighter than production"
else
  bad "fixture bound is not strictly tighter than the production promise"
fi

BARE="$TR/journal.git"; BRANCH=journal2
git_id=(-c user.name=test -c user.email=test@localhost)
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do
    mkdir -p "$d"; touch "$d/.gitkeep"
  done )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

# run_case <label> <job-base> <stop-timeout 0|1> <accepted-rc-ERE>
run_case() {
  local label="$1" job="$2" stop="$3" rc_re="$4"
  local pidfile="$TR/$job.pids" log="$TR/$job.log"
  local gardener_pid start returned_at died_at p alive
  local -a members=()
  : > "$pidfile"
  git -C "$SEED" fetch -q origin "$BRANCH"
  git -C "$SEED" reset -q --hard "origin/$BRANCH"
  printf '# %s\n\ndo the work for %s\n' "$job" "$job" > "$SEED/jobs/todo/$job.md"
  git -C "$SEED" add "jobs/todo/$job.md"
  git -C "$SEED" "${git_id[@]}" commit -q -m "seed $job"
  git -C "$SEED" push -q origin "$BRANCH"

  env GARDEN="wallhost" GARDEN_STATE="$TR/state" \
      JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_HANDLER_TIMEOUT=$BUDGET \
      GARDEN_HANDLER_KILL_AFTER=$KILL_AFTER GARDEN_HANDLER_WATCHDOG_GRACE=$GRACE \
      GARDEN_HANDLER_REAP_GRACE=2 GARDEN_NO_MAINTAINER_ALERT=1 \
      GARDEN_WALL_PIDFILE="$pidfile" GARDEN_WALL_TREE_TOKEN="$TOKEN" \
      GARDEN_WALL_TREE_STOP_TIMEOUT="$stop" \
      GARDEN_JOB_HANDLER="$HERE/wall-tree-handler-stub.sh" \
      "$JOBS/gardener.sh" 1 > "$log" 2>&1 &
  gardener_pid=$!
  GARDENER_PIDS+=("$gardener_pid")

  # Bounded wait for the whole tree to be recorded (5 members + start line).
  for _ in $(seq 1 120); do
    [ "$(recorded_pids "$pidfile" | wc -l)" -ge 5 ] && break
    sleep 0.25
  done
  start="$(awk '$1 == "start" {print $2; exit}' "$pidfile")"
  mapfile -t members < <(recorded_pids "$pidfile")
  if [ -n "$start" ] && [ "${#members[@]}" -ge 5 ]; then
    ok "[$label] handler tree started (${#members[@]} members: $(awk '$1 != "start" {printf "%s ", $1}' "$pidfile"))"
  else
    bad "[$label] handler tree never fully recorded: $(tr '\n' ';' < "$pidfile"); log: $(tail -5 "$log")"
    return 0
  fi
  local hpgid esid
  hpgid="$(awk '$1 == "handler" {print $3}' "$pidfile")"
  esid="$(awk '$1 == "escaped" {print $4}' "$pidfile")"
  if [ -n "$hpgid" ] && [ -n "$esid" ] \
    && [ "$(awk '$1 == "escaped" {print $3}' "$pidfile")" != "$hpgid" ] \
    && [ "$(awk '$1 == "deep" {print $3}' "$pidfile")" != "$hpgid" ]; then
    ok "[$label] the escaped and deep members left the handler's process group (pgid $hpgid)"
  else
    bad "[$label] fixture did not escape the handler group: $(tr '\n' ';' < "$pidfile")"
  fi
  if [ "$stop" = "1" ]; then
    for _ in $(seq 1 20); do grep -q '^stopped-timeout ' "$pidfile" && break; sleep 0.25; done
    if grep -q '^stopped-timeout ' "$pidfile"; then
      ok "[$label] the handler SIGSTOPped its timeout wrapper"
    else
      bad "[$label] timeout wrapper was not stopped"
    fi
  fi

  # Bounded wait for every member to die.
  died_at=""
  for _ in $(seq 1 $(( (BUDGET + KILL_AFTER + PROMISED_WALL) * 4 ))); do
    alive=0
    for p in "${members[@]}"; do kill -0 "$p" 2>/dev/null && { alive=1; break; }; done
    if [ "$alive" -eq 0 ]; then died_at="$(date +%s)"; break; fi
    sleep 0.25
  done
  local tree_bound=$((BUDGET + KILL_AFTER + SLACK))
  if [ -n "$died_at" ] && [ $((died_at - start)) -le "$tree_bound" ]; then
    ok "[$label] the whole tree was dead $((died_at - start))s after handler start (bound ${tree_bound}s = budget + kill-after + slack)"
  else
    bad "[$label] tree outlived the bound (died_at='$died_at' start=$start bound ${tree_bound}s); alive: $(for p in "${members[@]}"; do kill -0 "$p" 2>/dev/null && awk -v p="$p" '$2 == p {printf "%s ", $1}' "$pidfile"; done)"
  fi

  # Bounded wait for the worker itself: budget + the promised wall bound.
  local hard_deadline=$((start + BUDGET + PROMISED_WALL))
  returned_at=""
  while [ "$(date +%s)" -le "$hard_deadline" ]; do
    if ! kill -0 "$gardener_pid" 2>/dev/null; then returned_at="$(date +%s)"; break; fi
    sleep 0.25
  done
  if [ -n "$returned_at" ]; then
    ok "[$label] gardener.sh returned $((returned_at - start))s after handler start (bound $((BUDGET + PROMISED_WALL))s = budget + ${PROMISED_WALL}s)"
  else
    bad "[$label] gardener.sh still running past budget + ${PROMISED_WALL}s; log: $(tail -5 "$log")"
    reap_process_tree "$gardener_pid" 0 5 || true
  fi
  wait "$gardener_pid" 2>/dev/null || true

  local leaked
  leaked="$(token_pids | tr '\n' ' ')"
  alive=""
  for p in "${members[@]}"; do kill -0 "$p" 2>/dev/null && alive="$alive$p "; done
  if [ -z "$leaked" ] && [ -z "$alive" ]; then
    ok "[$label] no handler-tree process survived the worker"
  else
    bad "[$label] leaked processes: token=[$leaked] recorded=[$alive]"
  fi

  # CASE A races timeout's --kill-after against the watchdog's KILL at the same
  # deadline: either the watchdog ended the live handler (rc=124) or timeout did
  # (rc=137) and the watchdog then KILLed the escaped survivors. Both are
  # deadline overruns; both must carry the watchdog's escalation evidence.
  if grep -Eq "handler wall watchdog (fired for|KILLed the surviving tree of) '$job' .*\(DEADLINE start=[0-9]* term=[0-9]* kill=[0-9]* TERM observed=.*KILL observed=" "$log"; then
    ok "[$label] the watchdog's TERM -> KILL escalation is logged with its deadlines"
  else
    bad "[$label] watchdog evidence missing: $(grep -i 'watchdog' "$log" | tail -3)"
  fi
  local rec_elapsed rec_bound=$((tree_bound + 1))
  rec_elapsed="$(sed -En "s/.*handler FAILED \(rc=($rc_re)\) for '$job' \(handler elapsed=([0-9]*)s; watchdog: DEADLINE .*KILL observed=.*/\2/p" "$log" | head -1)"
  if [ -n "$rec_elapsed" ] && [ "$rec_elapsed" -le "$rec_bound" ]; then
    ok "[$label] the failure record is rc=$(sed -n "s/.*handler FAILED (rc=\\([0-9]*\\)) for .$job.*/\\1/p" "$log" | head -1) with handler elapsed=${rec_elapsed}s (bound ${rec_bound}s) and watchdog evidence"
  else
    bad "[$label] failure record lacks rc=$rc_re / bounded elapsed / watchdog evidence: $(grep 'handler FAILED' "$log" | tail -2)"
  fi
  if grep -Eq "hit its OWN wall-clock budget \(rc=($rc_re), .*; watchdog: DEADLINE" "$log"; then
    ok "[$label] the deadline-overrun record carries the watchdog evidence"
  else
    bad "[$label] deadline-overrun record lacks watchdog evidence: $(grep 'OWN wall-clock' "$log" | tail -2)"
  fi
  if ls "${TMPDIR:-/tmp}"/garden-watchdog-"$job".* >/dev/null 2>&1; then
    bad "[$label] watchdog marker file leaked"
  else
    ok "[$label] watchdog marker cleaned up"
  fi
}

# ============================================================================
hr; echo "CASE A — timeout intact: the watchdog reaps what timeout cannot reach"; hr
# CASE A's job may be requeued by the retry classifier; CASE B uses a lexically
# earlier base so its claim never depends on that disposition.
run_case A walltree-b-intact 0 '124|137'

# ============================================================================
hr; echo "CASE B — timeout stopped: the watchdog alone bounds the tree"; hr
run_case B walltree-a-stopped 1 '124'

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
