#!/bin/bash
# cgroup-drain-test.sh - guard the ExecStopPost cgroup drain (scripts/jobs/cgroup-drain.sh).
#
# The drain is the watcher units' last line against "Found left-over process (git) in
# control group while starting unit": it must SIGKILL a live straggler and wait for it
# to go, name it (cmdline + state) in the log, report a SIGKILL survivor at the
# deadline instead of hanging, and never touch anything outside its own unit cgroup.

set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRAIN="$(cd "$HERE/.." && pwd)/cgroup-drain.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }

TR="$(mktemp -d "${TMPDIR:-/tmp}/cgroup-drain.XXXXXX")"
STRAY=""
trap '[ -n "$STRAY" ] && kill -KILL "$STRAY" 2>/dev/null; rm -rf "$TR"' EXIT

# spawn_stray — a detached process standing in for a leaked git (not our child, so
# the drain's own-child exemption does not apply to it). Sets STRAY.
spawn_stray() {
  setsid -f bash -c 'exec -a cgdrain-stray-git sleep 120' </dev/null >/dev/null 2>&1
  STRAY=""
  for _ in $(seq 1 50); do
    STRAY="$(pgrep -f '^cgdrain-stray-git' | head -1)"
    [ -n "$STRAY" ] && break
    sleep 0.05
  done
}

echo "D1 - a live straggler is SIGKILLed, awaited, and named in the log"
spawn_stray
if [ -z "$STRAY" ]; then
  bad "could not spawn the fixture straggler"
else
  echo "$STRAY" > "$TR/procs"
  out="$(GARDEN_CGROUP_DRAIN_PROCS_FILE="$TR/procs" GARDEN_CGROUP_DRAIN_DEADLINE_SECS=5 \
    bash "$DRAIN" garden-comment-watcher@x.service 2>&1)"; rc=$?
  if [ "$rc" -eq 0 ]; then ok "drain exits 0"; else bad "drain exited rc=$rc"; fi
  if kill -0 "$STRAY" 2>/dev/null && [ "$(awk '{print $3}' "/proc/$STRAY/stat" 2>/dev/null)" != Z ]; then
    bad "straggler $STRAY still alive after the drain"
  else
    ok "straggler felled before the drain returned"
  fi
  case "$out" in
    *"straggler after main exit: pid=$STRAY "*"cmd=cgdrain-stray-git"*) ok "straggler logged with its cmdline" ;;
    *) bad "straggler not described in the log: $out" ;;
  esac
  case "$out" in
    *"cgroup drained: 1 straggler(s)"*) ok "drain summary logged" ;;
    *) bad "no drain summary: $out" ;;
  esac
  STRAY=""
fi

echo "D2 - an empty cgroup drains silently"
: > "$TR/empty"
out="$(GARDEN_CGROUP_DRAIN_PROCS_FILE="$TR/empty" bash "$DRAIN" garden-comment-watcher@x.service 2>&1)"; rc=$?
if [ "$rc" -eq 0 ] && [ -z "$out" ]; then ok "empty cgroup: rc 0, no output"; else bad "empty cgroup: rc=$rc out=$out"; fi

echo "D3 - a SIGKILL survivor hits the deadline, is described, and never wedges the stop"
# pid 1 refuses our SIGKILL (EPERM for a non-root caller; SIGNAL_UNKILLABLE for a
# root one), which is how a D-state git looks to the drain.
echo 1 > "$TR/unkillable"
t0=$SECONDS
out="$(GARDEN_CGROUP_DRAIN_PROCS_FILE="$TR/unkillable" GARDEN_CGROUP_DRAIN_DEADLINE_SECS=1 \
  bash "$DRAIN" garden-comment-watcher@x.service 2>&1)"; rc=$?
el=$((SECONDS - t0))
if [ "$rc" -eq 0 ]; then ok "deadline path exits 0"; else bad "deadline path rc=$rc"; fi
if [ "$el" -le 4 ]; then ok "deadline bounds the loop (${el}s)"; else bad "deadline did not bound the loop (${el}s)"; fi
case "$out" in
  *"WARN: 1 straggler(s) survived SIGKILL"*"pid=1 state="*"wchan="*) ok "survivor described at the deadline" ;;
  *) bad "deadline WARN missing the survivor's state: $out" ;;
esac

echo "D4 - outside its own unit cgroup the drain is a no-op (no fixture override)"
spawn_stray
if [ -n "$STRAY" ]; then
  env -u GARDEN_CGROUP_DRAIN_PROCS_FILE GARDEN_TEST=0 \
    bash "$DRAIN" garden-comment-watcher@not-this-cgroup.service >/dev/null 2>&1
  if kill -0 "$STRAY" 2>/dev/null; then ok "foreign cgroup left untouched"; else bad "drain swept a foreign cgroup"; fi
  # The fixture override is honored only in a test context.
  echo "$STRAY" > "$TR/procs"
  GARDEN_TEST=0 GARDEN_CGROUP_DRAIN_PROCS_FILE="$TR/procs" \
    bash "$DRAIN" garden-comment-watcher@x.service >/dev/null 2>&1
  if kill -0 "$STRAY" 2>/dev/null; then ok "fixture override ignored outside a test context"; else bad "fixture override honored in production"; fi
  kill -KILL "$STRAY" 2>/dev/null; STRAY=""
else
  bad "could not spawn the fixture straggler"
fi

echo "D5 - --describe names state, wchan and cmdline"
out="$(bash "$DRAIN" --describe $$ 999999999 2>&1)"
case "$out" in
  *"pid=$$ state="*"wchan="*"cmd="*"pid=999999999 gone"*) ok "--describe output" ;;
  *) bad "--describe output: $out" ;;
esac

echo
echo "cgroup-drain-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
