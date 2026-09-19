#!/bin/bash
# monk-claude-tree-reap-test.sh — prove the monk (Anthropic `claude -p`) handler
# runs its runtime in a MANAGED process group and reaps the WHOLE descendant tree,
# blocking until it drains, so the handler cannot exit before its Claude runtime
# tree is fully reaped (the garden-monk@N "starts with left-over node" symptom;
# job improve-monk-node-reap).
#
# The fix has two parts, tested here:
#   * common.sh process_tree_pids — a /proc PPid walk that enumerates a process and
#     every transitive descendant, INCLUDING a child that setsid'd into its own
#     process group/session (a bare group signal misses that child; the ppid link
#     does not).
#   * common.sh reap_process_tree — SIGTERM -> grace -> SIGKILL over both the pid
#     set AND the process group, then a bounded drain loop that WAITS for the tree
#     to disappear. Catches a setsid child by pid, and a non-setsid straggler by
#     group even after the group leader itself has died.
#   * handlers/monk-claude.sh — launches `claude -p` under `set -m` (own group) and
#     arms an EXIT/TERM/INT/HUP trap that runs reap_process_tree, so a lingering
#     runtime child is reaped by the time the handler returns.
#
# SUBTEST 1 — process_tree_pids enumerates the whole tree incl. a setsid child.
# SUBTEST 2 — reap_process_tree unit: guards; a setsid child (own group) is swept;
#             a leaderless group (leader already exited) is swept; the call BLOCKS
#             until the tree drains.
# SUBTEST 3 — integration: the real monk-claude.sh, driven with a fake `claude`
#             that leaves a lingering runtime child, reaps that child before it
#             returns (ZERO survivors).
#
# Linux /proc + setsid required for the tree assertions; degrades to SKIP without.
# Usage: monk-claude-tree-reap-test.sh
#
# The `unset $(compgen ...)` env scrub relies on word-splitting (SC2046) and the
# `A && ok || bad` assertion idiom is intentional (SC2015, bad never fails the chain).
# shellcheck disable=SC2015,SC2046
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this as a board job cannot
# splice its own GARDEN_*/JOURNAL_* state under the fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# shellcheck source=../common.sh
source "$JOBS/common.sh"

any_alive() { local p; for p in "$@"; do kill -0 "$p" 2>/dev/null && return 0; done; return 1; }

if [ ! -d /proc ] || ! command -v setsid >/dev/null 2>&1; then
  echo "  SKIP: /proc or setsid unavailable; cannot exercise the tree-reap logic"
  exit 0
fi

# ============================================================================
hr; echo "SUBTEST 1 — process_tree_pids enumerates the whole tree, including a setsid child"; hr
set -m
bash -c 'sleep 300 & setsid sleep 300 & exec sleep 300' &
leader=$!
set +m
sleep 0.5
mapfile -t tree < <(process_tree_pids "$leader")
# The tree must include the leader and >=3 members (leader + in-group sleep +
# setsid sleep). Identify the setsid member: its pgid differs from the leader's.
lead_pgid="$(ps -o pgid= -p "$leader" 2>/dev/null | tr -dc '0-9')"
setsid_found=0
for p in "${tree[@]}"; do
  pg="$(ps -o pgid= -p "$p" 2>/dev/null | tr -dc '0-9')"
  [ -n "$pg" ] && [ "$pg" != "$lead_pgid" ] && setsid_found=1
done
if [ "${#tree[@]}" -ge 3 ]; then
  ok "process_tree_pids listed the full tree (${#tree[@]} members: ${tree[*]})"
else
  bad "process_tree_pids listed only ${#tree[@]} members (expected >=3): ${tree[*]}"
fi
if [ "$setsid_found" -eq 1 ]; then
  ok "the setsid child (own process group) is enumerated by the ppid walk"
else
  bad "the setsid child was NOT enumerated — a bare group signal would miss it"
fi
# cleanup
kill -KILL -"$leader" 2>/dev/null || true
for p in "${tree[@]}"; do kill -KILL "$p" 2>/dev/null || true; done

# ============================================================================
hr; echo "SUBTEST 2 — reap_process_tree: guards, a setsid child is swept, a leaderless group is swept, the call BLOCKS to drain"; hr

# Guards: a caller bug must never broaden the signal into a fleet-wide kill.
for bad_target in "" "abc" "0" "1" "-5" "$$"; do
  if reap_process_tree "$bad_target" 1 1; then
    ok "guard: reap_process_tree '$bad_target' → clean no-op (returned 0)"
  else
    bad "guard: reap_process_tree '$bad_target' returned non-zero"
  fi
done
# Own-group must be refused so the sweep cannot take the caller down.
self_pgid="$(ps -o pgid= -p "$$" | tr -dc '0-9')"
if reap_process_tree "$self_pgid" 1 1 && kill -0 "$$" 2>/dev/null; then
  ok "guard: reap_process_tree refuses this process's OWN group (caller still alive)"
else
  bad "guard: own-group target was not refused"
fi

# A live tree with a setsid child in its own group: reap the leader, assert ALL
# (including the setsid child) are gone.
set -m
bash -c 'sleep 300 & setsid sleep 300 & exec sleep 300' &
leader=$!
set +m
sleep 0.5
mapfile -t members < <(process_tree_pids "$leader")
if [ "${#members[@]}" -ge 3 ] && any_alive "${members[@]}"; then
  ok "spawned a live tree with a setsid child (${#members[@]} members)"
else
  bad "could not spawn the multi-member tree (got ${#members[@]})"
fi
reap_process_tree "$leader" 2 5
sleep 0.3
if any_alive "${members[@]}"; then
  bad "reap_process_tree left survivors: $(ps -o pid,pgid,cmd -p "$(IFS=,; echo "${members[*]}")" 2>/dev/null | tail -n +2)"
  for p in "${members[@]}"; do kill -KILL "$p" 2>/dev/null || true; done
else
  ok "reap_process_tree swept the whole tree — setsid child included — to ZERO"
fi

# A leaderless group: the leader exits, its non-setsid children linger in the group.
# The seeded root-group SIGKILL must still reach them (a group outlives its leader).
set -m
bash -c 'sleep 300 & sleep 300 & exec sleep 0.3' &
leader2=$!
set +m
sleep 0.1
pgid2="$(ps -o pgid= -p "$leader2" 2>/dev/null | tr -dc '0-9')"
mapfile -t members2 < <(ps -eo pid,pgid | awk -v g="$pgid2" '$2==g {print $1}')
sleep 0.5   # let the leader exit; the group is now leaderless
if kill -0 "$leader2" 2>/dev/null; then
  bad "leader2 unexpectedly still alive; cannot exercise the leaderless-group path"
else
  ok "leader exited; group $pgid2 is leaderless with ${#members2[@]} lingering member(s)"
fi
reap_process_tree "$leader2" 2 5
sleep 0.3
if any_alive "${members2[@]}"; then
  bad "leaderless group survivors: $(ps -o pid,pgid,cmd -p "$(IFS=,; echo "${members2[*]}")" 2>/dev/null | tail -n +2)"
  for p in "${members2[@]}"; do kill -KILL "$p" 2>/dev/null || true; done
else
  ok "reap_process_tree swept the leaderless group via the seeded root-group signal"
fi

# It BLOCKS until drained: a child that ignores SIGTERM is only gone after the
# post-grace SIGKILL, so the call must not return until the drain loop sees it die.
set -m
bash -c 'trap "" TERM; exec sleep 300' &
stubborn=$!
set +m
sleep 0.3
start=$SECONDS
reap_process_tree "$stubborn" 2 5
elapsed=$((SECONDS - start))
sleep 0.2
if any_alive "$stubborn"; then
  bad "a SIGTERM-ignoring child survived reap_process_tree"
  kill -KILL "$stubborn" 2>/dev/null || true
elif [ "$elapsed" -ge 1 ]; then
  ok "reap_process_tree BLOCKED through the grace before SIGKILL (~${elapsed}s) and drained the tree"
else
  ok "reap_process_tree drained a SIGTERM-ignoring child (elapsed ${elapsed}s)"
fi

# ============================================================================
hr; echo "SUBTEST 3 — integration: the real monk-claude.sh manages + reaps its runtime tree"; hr
# Two paths matter, tested separately with the guarantee each can actually make:
#   3a NORMAL exit  — `claude` returns on its own; the EXIT-trap reap sweeps the
#                     process GROUP, so an in-group runtime child is gone on return.
#   3b WALL SIGNAL  — `claude` is STILL ALIVE when the handler is SIGTERMed (the
#                     gardener timeout wall); the TERM-trap reap walks the live tree
#                     and sweeps EVERYTHING, including a child that setsid'd into its
#                     own group. This is the case a bare group reap alone misses and
#                     the primary reason the handler can leak `node` today.

if ! command -v python3 >/dev/null 2>&1; then
  echo "  SKIP: python3 absent; the handler's deterministic session id needs it"
else
  # Exec-allowed temp base (the fake claude is PATH-resolved and exec'd; /tmp is
  # noexec on garden hosts).
  pick_exec_base() {
    local c probe rc
    for c in "${TMPDIR:-}" /tmp "${GARDEN_SCRATCH:-}" "${GARDEN_ROOT:+$GARDEN_ROOT/scratch}"; do
      [ -n "$c" ] && [ -d "$c" ] && [ -w "$c" ] || continue
      probe="$(mktemp -d "$c/mctr-probe.XXXXXX" 2>/dev/null)" || continue
      printf '#!/bin/sh\nexit 7\n' > "$probe/x"; chmod +x "$probe/x" 2>/dev/null
      "$probe/x" >/dev/null 2>&1; rc=$?
      rm -rf "$probe"
      [ "$rc" -eq 7 ] && { printf '%s\n' "$c"; return 0; }
    done
    return 1
  }
  EXEC_BASE="$(pick_exec_base)" || EXEC_BASE=""
  if [ -z "$EXEC_BASE" ]; then
    echo "  SKIP: no exec-allowed temp base (needed to run a fake claude)"
  else
    TR="$(mktemp -d "$EXEC_BASE/mctr.XXXXXX")"
    trap 'rm -rf "$TR" 2>/dev/null || true' EXIT

    ORIGIN="$TR/origin.git"; GROOT="$TR/garden"
    git init -q --bare "$ORIGIN"
    mkdir -p "$GROOT/scripts/jobs/handlers" "$GROOT/roles/gardener"
    git -C "$GROOT" init -q
    git -C "$GROOT" config user.email t@localhost
    git -C "$GROOT" config user.name test
    cp "$JOBS/common.sh" "$JOBS/usage-meter.sh" "$JOBS/quota-panel.sh" "$GROOT/scripts/jobs/"
    cp "$JOBS/model-tier-inventory.tsv" "$JOBS/model-routing-defaults.tsv" \
       "$JOBS/rate-card-defaults.md" "$GROOT/scripts/jobs/"
    cp "$JOBS/handlers/monk-claude.sh" "$JOBS/handlers/worker-common.sh" "$GROOT/scripts/jobs/handlers/"
    chmod +x "$GROOT/scripts/jobs/handlers/monk-claude.sh"
    printf '# gardener role (test stub)\n' > "$GROOT/roles/gardener/AGENT.md"
    printf '/scratch/\n' > "$GROOT/.gitignore"
    git -C "$GROOT" add -A
    git -C "$GROOT" commit -qm init
    git -C "$GROOT" branch -M main2
    git -C "$GROOT" remote add origin "$ORIGIN"
    git -C "$GROOT" push -q -u origin main2
    git -C "$GROOT" fetch -q origin

    HANDLER="$GROOT/scripts/jobs/handlers/monk-claude.sh"
    SCRATCH="$GROOT/scratch"
    MARKER="$(sed -n "s/^GARDEN_COMPLETION_MARKER='\(.*\)'\$/\1/p" "$JOBS/common.sh" | head -1)"
    FAKEDIR="$TR/bin"; mkdir -p "$FAKEDIR"

    # A fake `claude` reused by both paths. FAKE_STAY=1 makes it stay alive after
    # spawning the tree (the wall-signal path); otherwise it exits 0 with a valid
    # JSON envelope carrying the completion marker (`.result` is JSON-safe). It
    # records the pid of an in-GROUP child and a SETSID child (own group).
    cat > "$FAKEDIR/claude" <<'FAKE'
#!/bin/bash
set -uo pipefail
sleep 300 &                            # stays in claude's process group
echo "group $!"  >> "$FAKE_CHILD_PIDS"
setsid sleep 300 &                     # detaches into its own session/group
echo "setsid $!" >> "$FAKE_CHILD_PIDS"
# mimic Claude's session transcript so resume detection stays consistent
sid=""; prev=""
for a in "$@"; do case "$prev" in --session-id|--resume) sid="$a";; esac; prev="$a"; done
if [ -n "$sid" ]; then
  pd="$HOME/.claude/projects/$(printf '%s' "$PWD" | sed 's#/#-#g')"
  mkdir -p "$pd"; printf '{"transcript":"stub"}\n' >> "$pd/$sid.jsonl"
fi
if [ -n "${FAKE_STAY:-}" ]; then exec sleep 300; fi
printf '{"result":"%s"}\n' "${FAKE_MARKER:-done}"
FAKE
    chmod +x "$FAKEDIR/claude"
    [ -n "$MARKER" ] || echo "  note: could not read GARDEN_COMPLETION_MARKER; sentinel check skipped"

    run_handler_env=( HOME="$TR/home" PATH="$FAKEDIR:$PATH"
      GARDEN_ROOT="$GROOT" GARDEN_SCRATCH="$SCRATCH" GARDEN_STATE="$TR/state"
      GARDEN_WORKER_KIND=monk GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_STALE_HANDLER_KILL_GRACE=1
      GARDEN_MONK_CLAUDE_REAP_GRACE=2 GARDEN_MONK_CLAUDE_DRAIN_TIMEOUT=5
      FAKE_MARKER="$MARKER" )

    # --- 3a: normal exit sweeps the in-group runtime child ---------------------
    BASE=monk-tree-normal; JOB="$TR/$BASE.job"; REPORT="$TR/report-a.txt"
    printf 'Map: build (garden infra), branch main2. Do a thing.\n' > "$JOB"
    SENT_A="$TR/sentinel-a"; CPIDS_A="$TR/child-a.pids"; rm -f "$SENT_A" "$CPIDS_A"
    env "${run_handler_env[@]}" GARDEN_COMPLETION_SENTINEL="$SENT_A" \
        GARDEN_USAGE_FILE="$TR/usage-a.json" FAKE_CHILD_PIDS="$CPIDS_A" \
        bash "$HANDLER" "$BASE" "$JOB" "$REPORT"
    hrc=$?
    [ "$hrc" -eq 0 ] && ok "normal run exits 0 (backgrounded+waited invocation preserves rc)" \
      || bad "normal run should exit 0 (got $hrc)"
    if [ -n "$MARKER" ]; then
      [ -e "$SENT_A" ] && ok "completion sentinel written (report contract preserved through the restructure)" \
        || bad "completion sentinel not written on a marker-signaled completion"
    fi
    group_child="$(awk '/^group /{print $2}' "$CPIDS_A" 2>/dev/null | head -1)"
    sleep 0.3
    if [ -n "$group_child" ] && kill -0 "$group_child" 2>/dev/null; then
      bad "in-group runtime child $group_child SURVIVED a normal return — the EXIT-trap group reap failed"
      kill -KILL "$group_child" 2>/dev/null || true
    elif [ -n "$group_child" ]; then
      ok "the in-group runtime child was reaped by the EXIT-trap group sweep before the handler returned"
    else
      bad "fake claude did not record an in-group child"
    fi
    # best-effort cleanup of the setsid child (reparented; the cgroup sweep owns it)
    ss="$(awk '/^setsid /{print $2}' "$CPIDS_A" 2>/dev/null | head -1)"; kill -KILL "$ss" 2>/dev/null || true

    # --- 3b: a wall SIGTERM sweeps the WHOLE live tree, setsid child included ---
    BASE=monk-tree-signal; JOB="$TR/$BASE.job"; REPORT="$TR/report-b.txt"
    printf 'Map: build (garden infra), branch main2. Do a thing.\n' > "$JOB"
    SENT_B="$TR/sentinel-b"; CPIDS_B="$TR/child-b.pids"; rm -f "$SENT_B" "$CPIDS_B"
    env "${run_handler_env[@]}" FAKE_STAY=1 GARDEN_COMPLETION_SENTINEL="$SENT_B" \
        GARDEN_USAGE_FILE="$TR/usage-b.json" FAKE_CHILD_PIDS="$CPIDS_B" \
        bash "$HANDLER" "$BASE" "$JOB" "$REPORT" &
    hpid=$!
    # Wait for the fake claude to have spawned its tree (both pids recorded).
    for _ in $(seq 1 50); do
      [ "$(grep -c . "$CPIDS_B" 2>/dev/null || echo 0)" -ge 2 ] && break
      sleep 0.1
    done
    mapfile -t both < <(awk '{print $2}' "$CPIDS_B" 2>/dev/null)
    if [ "${#both[@]}" -ge 2 ] && any_alive "${both[@]}"; then
      ok "handler launched a live runtime tree with an in-group AND a setsid child (${both[*]})"
    else
      bad "could not stage the live runtime tree (recorded ${#both[@]} pids)"
    fi
    # The gardener's timeout wall SIGTERMs the direct handler; simulate that.
    kill -TERM "$hpid" 2>/dev/null || true
    wait "$hpid"; wrc=$?
    [ "$wrc" -eq 143 ] && ok "handler exits 143 on the wall SIGTERM (trap-driven, not an ambiguous code)" \
      || bad "handler should exit 143 on SIGTERM (got $wrc)"
    sleep 0.3
    if [ "${#both[@]}" -ge 2 ] && any_alive "${both[@]}"; then
      bad "runtime children SURVIVED the wall SIGTERM — the live-tree reap failed: $(ps -o pid,ppid,pgid,cmd -p "$(IFS=,; echo "${both[*]}")" 2>/dev/null | tail -n +2)"
      for p in "${both[@]}"; do kill -KILL "$p" 2>/dev/null || true; done
    else
      ok "ZERO runtime children survived the wall SIGTERM — the setsid child was reaped too"
    fi
  fi
fi

# ============================================================================
hr
echo "monk-claude-tree-reap-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
