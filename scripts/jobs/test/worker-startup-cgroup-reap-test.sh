#!/bin/bash
# worker-startup-cgroup-reap-test.sh — a restarted worker clears detached
# descendants from its systemd cgroup before reaching the claim loop.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
# shellcheck source=../common.sh
source "$JOBS/common.sh"

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-worker-cgroup-reap.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
PROC="$TR/proc"
CGROUP="$TR/cgroup"
CGPATH="/user.slice/user-1000.slice/user@1000.service/app.slice/garden-cleric@1.service"
PROCS="$CGROUP$CGPATH/cgroup.procs"
mkdir -p "$PROC/self" "$(dirname "$PROCS")"
printf '0::%s\n' "$CGPATH" > "$PROC/self/cgroup"

write_status() {
  mkdir -p "$PROC/$1"
  printf 'Name:\tfixture\nState:\t%s (fixture)\nPPid:\t%s\n' "${3:-S}" "$2" > "$PROC/$1/status"
}
write_stat() {
  printf '%s (fixture) S 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 %s\n' "$1" "$2" > "$PROC/$1/stat"
}
# Current invocation: self-heal wrapper 500 owns this shell and sibling tee 501.
write_status "$$" 500
write_status 500 1
write_status 501 500
# Prior invocation: detached leader 600 plus child 601, both reparented away
# from the current wrapper. A detached grandchild 602 appears during TERM grace.
write_status 600 1
write_status 601 600
write_status 602 600
printf '%s\n' "$$" 500 501 600 601 > "$PROCS"

export GARDEN_PROC_ROOT="$PROC" GARDEN_CGROUP_ROOT="$CGROUP"
export GARDEN_STATE="$TR/state"
export GARDEN_WORKER_STARTUP_REAP_STATE_DIR="$GARDEN_STATE/worker-cgroup-reap"
export GARDEN_WORKER_STARTUP_REAP_GRACE=0 GARDEN_WORKER_STARTUP_REAP_KILL_WAIT=0
export GARDEN_WORKER_STARTUP_REAP_RETRY_SECS=300
ALERTS="$TR/alerts"
alert_maintainer() { printf 'open %s\n' "$1" >> "$ALERTS"; }
alert_maintainer_clear() { printf 'clear %s\n' "$1" >> "$ALERTS"; }
KILLS="$TR/kills"
kill() {
  printf '%s %s\n' "$1" "$2" >> "$KILLS"
  if [ "$1" = -TERM ] && [ "$2" = 600 ]; then
    printf '%s\n' "$$" 500 501 600 601 602 > "$PROCS"
  elif [ "$1" = -KILL ]; then
    printf '%s\n' "$$" 500 501 > "$PROCS"
  fi
  return 0
}

reap_stale_worker_cgroup cleric 1 0

if grep -qx -- '-TERM 600' "$KILLS" && grep -qx -- '-TERM 601' "$KILLS"; then
  ok "startup sweep TERM-signals every stale process"
else
  bad "startup sweep missed a stale process on its TERM pass ($(tr '\n' ';' < "$KILLS"))"
fi
if grep -qx -- '-KILL 600' "$KILLS" && grep -qx -- '-KILL 601' "$KILLS" \
    && grep -qx -- '-KILL 602' "$KILLS"; then
  ok "startup sweep re-scans and KILL-signals survivors plus late children"
else
  bad "startup sweep did not close the post-TERM fork race ($(tr '\n' ';' < "$KILLS"))"
fi
if grep -Eq -- "-(TERM|KILL) ($$|500|501)$" "$KILLS"; then
  bad "startup sweep signalled the current wrapper tree"
else
  ok "startup sweep preserves gardener, self-heal wrapper, and tee sibling"
fi

# A zombie whose owner reaps it during the bounded wait clears without either a
# signal or a persisted residue episode.
: > "$KILLS"
write_status 710 1 Z
write_stat 710 7100
printf '%s\n' "$$" 500 501 710 > "$PROCS"
export GARDEN_WORKER_STARTUP_REAP_KILL_WAIT=1
sleep() { printf '%s\n' "$$" 500 501 > "$PROCS"; }
reap_stale_worker_cgroup cleric 1 0
unset -f sleep
export GARDEN_WORKER_STARTUP_REAP_KILL_WAIT=0
if [ ! -s "$KILLS" ] && [ ! -e "$GARDEN_WORKER_STARTUP_REAP_STATE_DIR/cleric-1.state" ]; then
  ok "startup sweep gives the owning parent/systemd a bounded wait to reap zombies"
else
  bad "owner-reaped zombie was signalled or persisted as residue"
fi

# An unreaped zombie cannot respond to signals. A live D-state survivor gets one
# TERM/KILL attempt, but an immediate restart into the identical residue must
# rate-limit the whole set rather than SIGKILLing the same pid again.
: > "$KILLS"
write_status 700 1 Z
write_status 701 1 D
write_stat 700 7000
write_stat 701 7010
printf '%s\n' "$$" 500 501 700 701 > "$PROCS"
kill() { printf '%s %s\n' "$1" "$2" >> "$KILLS"; return 0; }
reap_stale_worker_cgroup cleric 1 0
first_kills="$(wc -l < "$KILLS")"
# Kernel state can move between D and S without making this a new descendant;
# cooldown identity is pid+start-time, while state remains diagnostic.
write_status 701 1 S
reap_stale_worker_cgroup cleric 1 0
second_kills="$(wc -l < "$KILLS")"
if grep -Eq -- '-(TERM|KILL) 700$' "$KILLS"; then
  bad "startup sweep tried to signal an unreapable zombie"
else
  ok "startup sweep waits for zombie owner/systemd instead of signalling the zombie"
fi
if [ "$first_kills" -eq 2 ] && [ "$second_kills" -eq "$first_kills" ] \
    && grep -qx -- '-TERM 701' "$KILLS" && grep -qx -- '-KILL 701' "$KILLS"; then
  ok "unchanged live residue is signalled once then rate-limited across restart"
else
  bad "persistent live residue was signalled repeatedly ($(tr '\n' ';' < "$KILLS"))"
fi
STATE="$GARDEN_WORKER_STARTUP_REAP_STATE_DIR/cleric-1.state"
if grep -q '^700:Z:1,701:S:1$' <(sed -n '4p' "$STATE") && [ "$(sed -n '3p' "$STATE")" -eq 2 ]; then
  ok "persistent residue records states, parents, and repeated observations"
else
  bad "persistent residue state was not recorded accurately ($(tr '\n' ';' < "$STATE" 2>/dev/null || true))"
fi
if grep -Eq '^open worker-cgroup-residue-.+-cleric-1$' "$ALERTS"; then
  ok "persistent residue escalates through the coalescing maintainer-alert key"
else
  bad "persistent residue was not escalated"
fi

# A recycled numeric pid is a different process and must not inherit cooldown.
write_stat 701 7011
before_reuse="$(wc -l < "$KILLS")"
reap_stale_worker_cgroup cleric 1 0
after_reuse="$(wc -l < "$KILLS")"
if [ $((after_reuse - before_reuse)) -eq 2 ] && [ "$(sed -n '3p' "$STATE")" -eq 1 ]; then
  ok "pid reuse (changed kernel start time) gets a fresh cleanup attempt"
else
  bad "pid reuse incorrectly inherited the prior process cooldown"
fi

# Once the cgroup owner has reaped the residue, retire the cooldown state.
printf '%s\n' "$$" 500 501 > "$PROCS"
reap_stale_worker_cgroup cleric 1 0
if [ ! -e "$STATE" ] && grep -Eq '^clear worker-cgroup-residue-.+-cleric-1$' "$ALERTS"; then
  ok "resolved cgroup residue clears its cooldown state and alert episode"
else
  bad "resolved cgroup residue did not clear state and alert episode"
fi

: > "$KILLS"
printf '0::/user.slice/user-1000.slice/user@1000.service/app.slice/session-9.scope\n' > "$PROC/self/cgroup"
reap_stale_worker_cgroup cleric 1 0
if [ ! -s "$KILLS" ]; then
  ok "non-worker cgroup leaf is a strict no-op"
else
  bad "non-worker cgroup leaf was signalled"
fi

if awk '/reap_stale_worker_cgroup .*\|\| true/{call=NR} /^while :; do/{loop=NR; exit} END{exit !(call && loop && call < loop)}' "$JOBS/gardener.sh"; then
  ok "gardener invokes cgroup cleanup before its claim loop"
else
  bad "gardener does not invoke cgroup cleanup before its claim loop"
fi

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
