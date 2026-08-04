#!/bin/bash
# handler-orphan-reap-test.sh — the structural backstop for the 2026-07-20/21
# incident: the xs2rust-endor-press leaked 356 orphaned processes (four `endor-xst`
# pegging full cores plus a 344-proc `endor`/`manager-node.js` daemon tree) because
# a claim-scoped handler that overran / doomed left the OS process tree it spawned
# running headless, reparented to `systemd --user` with no agent watching.
#
# The fix: gardener.sh launches every handler in its OWN process group (job control,
# `timeout --foreground` so the tree stays in the one group we capture) and sweeps
# that whole group after the handler returns for ANY reason (common.sh
# reap_process_group: SIGTERM → grace → SIGKILL). This test proves a handler that
# EXCEEDS ITS TIMEBOX leaves ZERO orphaned descendants.
#
# SUBTEST 1 — reap_process_group unit: guards (non-numeric / init(1) / own-group are
#             refused) and a real spawned tree is SIGTERM→SIGKILL swept to zero.
# SUBTEST 2 — integration: the REAL gardener.sh runs a stub that spawns a multi-level
#             descendant tree then hangs past a tiny GARDEN_HANDLER_TIMEOUT (rc=124);
#             after the gardener returns, EVERY recorded descendant PID is gone.
#
# systemd is not required. Usage: handler-orphan-reap-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (a live gardener running this test as a board job would
# otherwise splice its own GARDEN_*/JOURNAL_* state underneath the fixture).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# shellcheck source=../common.sh
source "$JOBS/common.sh"

# A descendant tree is considered fully reaped when no recorded pid is alive.
any_alive() { local p; for p in "$@"; do kill -0 "$p" 2>/dev/null && return 0; done; return 1; }

# ============================================================================
hr; echo "SUBTEST 1 — reap_process_group: guards refuse dangerous targets; a real tree is swept to zero"; hr

# Guards: a caller bug must never turn the sweep into a fleet-wide kill. Each of
# these returns cleanly (0) WITHOUT signalling anything.
for bad_target in "" "abc" "0" "1" "-5" "$$"; do
  if reap_process_group "$bad_target" 1; then
    ok "guard: reap_process_group '$bad_target' → no-op (refused, returned 0)"
  else
    bad "guard: reap_process_group '$bad_target' returned non-zero (should be a clean no-op)"
  fi
done
# The this-process's-own-group guard: our own pgid must be refused so the sweep can
# never take the caller down with the orphans.
self_pgid="$(ps -o pgid= -p "$$" | tr -dc '0-9')"
if reap_process_group "$self_pgid" 1 && kill -0 "$$" 2>/dev/null; then
  ok "guard: reap_process_group refuses this process's OWN group (caller still alive)"
else
  bad "guard: own-group target was not refused (the caller could be killed by its own sweep)"
fi

# A real tree: spawn a process group (job control gives the background job its own
# pgid == its pid), populate it with a small descendant tree, then sweep it.
set -m
bash -c 'sleep 3600 & sleep 3600 & sleep 3600' &
grp_pgid=$!
set +m
sleep 0.5
# Collect the group members' pids for a liveness assertion independent of pgid.
mapfile -t members < <(ps -eo pid,pgid | awk -v g="$grp_pgid" '$2==g {print $1}')
if [ "${#members[@]}" -ge 2 ] && any_alive "${members[@]}"; then
  ok "spawned a live process group (pgid=$grp_pgid, ${#members[@]} members)"
else
  bad "could not spawn a multi-member live group to sweep (got ${#members[@]} members)"
fi
reap_process_group "$grp_pgid" 3
sleep 0.3
if any_alive "${members[@]}"; then
  bad "reap_process_group left survivors in the group: $(ps -o pid,cmd -p "${members[*]}" 2>/dev/null | tail -n +2)"
  # best-effort cleanup so the test host is left clean
  kill -KILL -"$grp_pgid" 2>/dev/null || true
else
  ok "reap_process_group swept the whole group to ZERO survivors (SIGTERM→SIGKILL)"
fi

# ============================================================================
hr; echo "SUBTEST 2 — integration: a real gardener overrun leaves ZERO orphaned descendants"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-orphan-reap.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; BRANCH=journal2
git_id=(-c user.name=test -c user.email=test@localhost)

git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
  for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
  printf '# treejob\n\ndo the work for treejob\n' > "jobs/todo/treejob.md" )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: 1 job + structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
PIDFILE="$TR/orphan.pids"; : > "$PIDFILE"

# Run the REAL gardener.sh: oneshot, tiny 2s handler bound, against the stub that
# spawns a multi-level descendant tree (recording each pid to $PIDFILE) then hangs.
# The timeout wrapper fires at 2s (rc=124) and gardener.sh MUST sweep the group.
env GARDEN="treehost" GARDEN_STATE="$TR/state" \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_HANDLER_TIMEOUT=2 GARDEN_HANDLER_REAP_GRACE=3 \
    GARDEN_ORPHAN_PIDFILE="$PIDFILE" \
    GARDEN_JOB_HANDLER="$HERE/orphan-tree-handler-stub.sh" \
    "$JOBS/gardener.sh" 1 > "$TR/gardener.log" 2>&1 || true

# The stub recorded every descendant pid it spawned.
mapfile -t tree_pids < <(grep -E '^[0-9]+$' "$PIDFILE" 2>/dev/null || true)
if [ "${#tree_pids[@]}" -ge 3 ]; then
  ok "handler spawned a descendant tree (${#tree_pids[@]} pids recorded)"
else
  bad "handler did not record the expected descendant tree (got ${#tree_pids[@]} pids); log: $(tail -3 "$TR/gardener.log")"
fi

# (a) the overrun actually happened (handler hit its wall, rc=124).
if grep -Eq "rc=124" "$TR/gardener.log"; then
  ok "handler exceeded its timebox (rc=124 overrun observed)"
else
  bad "rc=124 overrun not observed in the gardener log: $(grep -i 'handler\|working\|rc=' "$TR/gardener.log" | tail -3)"
fi

# (b) THE DEFINITION OF DONE: ZERO of the handler's descendants survive.
sleep 0.5
if [ "${#tree_pids[@]}" -ge 1 ] && any_alive "${tree_pids[@]}"; then
  survivors="$(ps -o pid,ppid,pgid,cmd -p "$(IFS=,; echo "${tree_pids[*]}")" 2>/dev/null | tail -n +2)"
  bad "ORPHANS SURVIVED the overrun — the leak is NOT fixed:"
  echo "$survivors" | sed 's/^/        /'
  # leave the host clean
  for p in "${tree_pids[@]}"; do kill -KILL "$p" 2>/dev/null || true; done
else
  ok "ZERO orphaned descendants after the overrun (the process group was swept)"
fi

# ============================================================================
hr; echo "SUBTEST 3 — integration: a handler that SELF-EXITS (doom path, no timeout kill) also leaves ZERO orphans"; hr
# The true incident discriminator. On rc=124 the OLD `timeout` already group-killed
# a non-detaching tree, but when the handler RETURNS ON ITS OWN (a `claude -p` that
# crashed / hit a quota cut, then requeue-exhausts into doom) NO timeout kill fires
# and the OLD gardener never touched the spawned tree — it survived headless. The
# unconditional post-return sweep now reaps it. Same seeded board, a stub that spawns
# a tree then `exit 7` (non-124, non-signal).
TR2="$(mktemp -d "${TMPDIR:-/tmp}/garden-orphan-selfexit.XXXXXX")"; trap 'rm -rf "$TR" "$TR2"' EXIT
BARE2="$TR2/journal.git"
git init -q --bare "$BARE2"
SEED2="$TR2/seed"; git init -q "$SEED2"
git -C "$SEED2" checkout -q -b "$BRANCH"
( cd "$SEED2"
  mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
  for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
  printf '# exitjob\n\ndo the work for exitjob\n' > "jobs/todo/exitjob.md" )
git -C "$SEED2" add -A
git -C "$SEED2" "${git_id[@]}" commit -q -m "seed: 1 job + structure"
git -C "$SEED2" remote add origin "$BARE2"
git -C "$SEED2" push -q -u origin "$BRANCH"

PIDFILE2="$TR2/orphan.pids"; : > "$PIDFILE2"
env GARDEN="exithost" GARDEN_STATE="$TR2/state" \
    JOURNAL_REMOTE="$BARE2" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_HANDLER_TIMEOUT=30 GARDEN_HANDLER_REAP_GRACE=3 \
    GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_ORPHAN_PIDFILE="$PIDFILE2" \
    GARDEN_JOB_HANDLER="$HERE/orphan-tree-selfexit-handler-stub.sh" \
    "$JOBS/gardener.sh" 1 > "$TR2/gardener.log" 2>&1 || true

mapfile -t tree_pids2 < <(grep -E '^[0-9]+$' "$PIDFILE2" 2>/dev/null || true)
if [ "${#tree_pids2[@]}" -ge 3 ]; then
  ok "self-exit handler spawned a descendant tree (${#tree_pids2[@]} pids recorded)"
else
  bad "self-exit handler did not record the expected tree (got ${#tree_pids2[@]}); log: $(tail -3 "$TR2/gardener.log")"
fi
# The handler returned on its OWN — no timeout kill (no rc=124 in the log).
if grep -Eq "rc=124" "$TR2/gardener.log"; then
  bad "unexpected rc=124 — the self-exit path must NOT trip the timeout wall (budget was 30s, handler self-exits at ~1s)"
else
  ok "handler self-exited (no timeout kill fired — this is the doom path, not the wall)"
fi
sleep 0.5
if [ "${#tree_pids2[@]}" -ge 1 ] && any_alive "${tree_pids2[@]}"; then
  survivors2="$(ps -o pid,ppid,pgid,cmd -p "$(IFS=,; echo "${tree_pids2[*]}")" 2>/dev/null | tail -n +2)"
  bad "ORPHANS SURVIVED a self-exit — the doom-path leak is NOT fixed:"
  echo "$survivors2" | sed 's/^/        /'
  for p in "${tree_pids2[@]}"; do kill -KILL "$p" 2>/dev/null || true; done
else
  ok "ZERO orphaned descendants after a self-exit (the process group was swept on return)"
fi

# ============================================================================
hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
