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

write_status() { mkdir -p "$PROC/$1"; printf 'Name:\tfixture\nPPid:\t%s\n' "$2" > "$PROC/$1/status"; }
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
export GARDEN_WORKER_STARTUP_REAP_GRACE=0 GARDEN_WORKER_STARTUP_REAP_KILL_WAIT=0
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
