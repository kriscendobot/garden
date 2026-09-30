#!/bin/bash
# handler-wall-watchdog-test.sh — the independent handler wall bound.
#
# `timeout --foreground` once let a claimed handler run 3702s against a 2400s
# budget (2026-09-30T05:36:39Z). gardener.sh now runs common.sh
# handler_wall_watchdog beside `timeout`: it SIGTERMs the handler's process group at
# budget + GARDEN_HANDLER_WATCHDOG_GRACE and SIGKILLs it at budget +
# GARDEN_HANDLER_KILL_AFTER + GARDEN_HANDLER_WATCHDOG_KILL_LAG, and is cancelled on
# every handler exit.
#
# SUBTEST 1 — unit: guards refuse unsafe targets; an early-exiting group ends the
#             watchdog without signalling; a TERM-ignoring group is TERMed then
#             KILLed on schedule and the marker records both.
# SUBTEST 2 — integration: the REAL gardener.sh runs a handler whose TERM-ignoring
#             descendant SIGSTOPs `timeout`; the worker still returns, the
#             descendant dies by budget + kill-after, and the outcome is rc=124.
#
# systemd is not required. Usage: handler-wall-watchdog-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# shellcheck source=../common.sh
source "$JOBS/common.sh"

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-wall-watchdog.XXXXXX")"
LEFTOVER=()
cleanup() {
  local p
  for p in "${LEFTOVER[@]}"; do kill -CONT "$p" 2>/dev/null || true; kill -KILL "$p" 2>/dev/null || true; done
  rm -rf "$TR"
}
trap cleanup EXIT

# ============================================================================
hr; echo "SUBTEST 1 — handler_wall_watchdog unit"; hr

self_pgid="$(ps -o pgid= -p "$$" | tr -dc '0-9')"
for target in "" "abc" "0" "1" "$$" "$self_pgid"; do
  if handler_wall_watchdog "$target" 0 0 "$TR/guard.marker" && [ ! -e "$TR/guard.marker" ]; then
    ok "guard: target '$target' is a no-op"
  else
    bad "guard: target '$target' was not refused"
  fi
done

# An early-exiting group: the watchdog must return promptly and never fire.
set -m
sleep 1 &
quick_pgid=$!
set +m
t0=$SECONDS
handler_wall_watchdog "$quick_pgid" 30 60 "$TR/quick.marker"
if [ $((SECONDS - t0)) -le 4 ] && [ ! -s "$TR/quick.marker" ]; then
  ok "an early-exiting group ends the watchdog without signalling"
else
  bad "watchdog did not return promptly for an exited group (took $((SECONDS - t0))s)"
fi

# A TERM-ignoring group: TERM at 1s is swallowed, KILL at 3s must end it.
set -m
bash -c 'trap "" TERM; bash -c "trap \"\" TERM; while :; do sleep 1; done" & while :; do sleep 1; done' &
stuck_pgid=$!
set +m
LEFTOVER+=("$stuck_pgid")
sleep 0.3
mapfile -t members < <(ps -eo pid,pgid | awk -v g="$stuck_pgid" '$2==g {print $1}')
t0=$SECONDS
handler_wall_watchdog "$stuck_pgid" 1 3 "$TR/stuck.marker"
elapsed=$((SECONDS - t0))
sleep 0.3
alive=0; for p in "${members[@]}"; do kill -0 "$p" 2>/dev/null && alive=1; done
if [ "$alive" -eq 0 ] && [ "$elapsed" -ge 2 ] && [ "$elapsed" -le 5 ]; then
  ok "a TERM-ignoring group (${#members[@]} members) was KILLed on schedule (${elapsed}s, bound 3s)"
else
  bad "TERM-ignoring group not killed on schedule (alive=$alive elapsed=${elapsed}s)"
fi
if grep -q '^TERM ' "$TR/stuck.marker" && grep -q '^KILL ' "$TR/stuck.marker"; then
  ok "the marker records the TERM and KILL escalation"
else
  bad "marker missing escalation records: $(cat "$TR/stuck.marker" 2>/dev/null)"
fi

# ============================================================================
hr; echo "SUBTEST 2 — integration: a TERM-ignoring descendant cannot extend the worker"; hr
BARE="$TR/journal.git"; BRANCH=journal2
git_id=(-c user.name=test -c user.email=test@localhost)
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
  for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
  printf '# walljob\n\ndo the work for walljob\n' > "jobs/todo/walljob.md" )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: 1 job + structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

BUDGET=2; KILL_AFTER=4; KILL_LAG=2
PIDFILE="$TR/wall.pids"; : > "$PIDFILE"
env GARDEN="wallhost" GARDEN_STATE="$TR/state" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_HANDLER_TIMEOUT=$BUDGET \
    GARDEN_HANDLER_KILL_AFTER=$KILL_AFTER GARDEN_HANDLER_WATCHDOG_GRACE=1 \
    GARDEN_HANDLER_REAP_GRACE=2 GARDEN_NO_MAINTAINER_ALERT=1 \
    GARDEN_WALL_PIDFILE="$PIDFILE" \
    GARDEN_JOB_HANDLER="$HERE/wall-bypass-handler-stub.sh" \
    "$JOBS/gardener.sh" 1 > "$TR/gardener.log" 2>&1 &
gardener_pid=$!

# Poll (bounded) for the descendant to be recorded, then for its death.
desc=""; start=""
for _ in $(seq 1 120); do
  mapfile -t rec < <(cat "$PIDFILE" 2>/dev/null)
  if [ "${#rec[@]}" -ge 2 ]; then start="${rec[0]}"; desc="${rec[1]}"; break; fi
  sleep 0.5
done
if [ -n "$desc" ]; then
  LEFTOVER+=("$desc")
  ok "handler spawned a TERM-ignoring descendant (pid $desc) that stops its timeout"
else
  bad "handler never recorded its descendant; log: $(tail -5 "$TR/gardener.log")"
fi
died_at=""
if [ -n "$desc" ]; then
  for _ in $(seq 1 60); do
    if ! kill -0 "$desc" 2>/dev/null; then died_at="$(date +%s)"; break; fi
    sleep 0.5
  done
fi
bound=$((BUDGET + KILL_AFTER + KILL_LAG + 2))
if [ -n "$died_at" ] && [ $((died_at - start)) -le "$bound" ]; then
  ok "descendant killed $((died_at - start))s after handler start (bound ${bound}s = budget + kill-after + kill-lag + polling slack)"
else
  bad "descendant outlived the configured bound (died_at='${died_at}', start='${start}', bound ${bound}s)"
fi

# The worker itself must return (bounded wait; a wedge fails rather than hangs).
returned=0
for _ in $(seq 1 120); do
  if ! kill -0 "$gardener_pid" 2>/dev/null; then returned=1; break; fi
  sleep 0.5
done
if [ "$returned" -eq 1 ]; then
  ok "the gardener worker returned after the watchdog fired"
else
  bad "the gardener worker wedged; log: $(tail -5 "$TR/gardener.log")"
  kill -KILL "$gardener_pid" 2>/dev/null || true
fi
wait "$gardener_pid" 2>/dev/null || true
if grep -q "handler wall watchdog fired for 'walljob'" "$TR/gardener.log"; then
  ok "the gardener logged the watchdog kill"
else
  bad "no watchdog log line; log: $(grep -i 'rc=\|watchdog' "$TR/gardener.log" | tail -5)"
fi
if grep -Eq "rc=124" "$TR/gardener.log"; then
  ok "the watchdog kill is recorded as a wall-clock overrun (rc=124)"
else
  bad "rc=124 not recorded; log: $(grep -i 'rc=' "$TR/gardener.log" | tail -5)"
fi
if ls "${TMPDIR:-/tmp}"/garden-watchdog-walljob.* >/dev/null 2>&1; then
  bad "watchdog marker file leaked"
else
  ok "watchdog marker cleaned up"
fi

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
