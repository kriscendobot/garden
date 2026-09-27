#!/bin/bash
# worktree-sweeper-follower-test.sh — pin that the terminal-worktree sweeper is a
# PER-HOST safety net, NOT a leader-only singleton.
#
# History: garden-worktree-sweeper.service once carried
# `ExecCondition=is-main-host.sh`, so on every FOLLOWER the oneshot was skipped on
# every tick (`Result=exec-condition`) and the local terminal residue accumulated
# without bound — endolin-garden2-5bcdff64 held 100 project-wt-* dirs / 41 GB that
# had NEVER been swept. The garbage is local to each host (each host makes its own
# gardener-wt-<base> / project-wt-* checkouts and can only see/reclaim its own), so
# the gate was simply wrong. This test pins two independent guarantees:
#
#   1. STATIC: the unit carries no `ExecCondition=is-main-host` and its timer is
#      enabled on a follower (mirrors sysop-test.sh's per-host assertions).
#   2. BEHAVIORAL: with this host configured as a FOLLOWER (GARDEN != the leader
#      marker, is-main-host.sh reports follower), worktree-sweeper.sh still
#      reclaims a terminal (doomed) local worktree.
#
# Usage: worktree-sweeper-follower-test.sh
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
SRC="$ROOT/scripts/systemd"
# shellcheck source=test-tmpdir.sh
source "$HERE/test-tmpdir.sh"
TR="$(mktemp -d "$(garden_test_exec_tmpdir)/worktree-sweeper-follower.XXXXXXXX")"
trap 'rm -rf "$TR"' EXIT
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }
hr()  { echo "----------------------------------------------------------------"; }
git_id=(-c user.name=test -c user.email=test@localhost)

FOLLOWER="hostb-garden-bbbb2222"
LEADER="hosta-garden-aaaa1111"

# ============================================================================
hr; echo "STATIC — the unit is per-host (no is-main-host gate) and enabled on a follower"; hr
UNIT="$SRC/garden-worktree-sweeper.service"
# Strip full-line comments first: the unit now MENTIONS is-main-host in a comment
# (explaining why it deliberately omits the gate); only an EXECUTABLE
# ExecCondition= directive would be the actual leader gate.
if grep -vE '^[[:space:]]*#' "$UNIT" | grep -qE '^ExecCondition=.*is-main-host'; then
  bad "garden-worktree-sweeper.service is leader-gated (ExecCondition=is-main-host) — must run on every host"
else
  ok "garden-worktree-sweeper.service carries no is-main-host ExecCondition (per-host, not leader-gated)"
fi

# The sweeper script must not sneak the gate in either (no executable is_main_host
# / is-main-host.sh call; a comment reference is fine).
if grep -vE '^[[:space:]]*#' "$JOBS/worktree-sweeper.sh" | grep -qE 'is_main_host|is-main-host'; then
  bad "worktree-sweeper.sh has an executable leader check — it must sweep on every host"
else
  ok "worktree-sweeper.sh has no executable leader check"
fi

# install-units.sh must enable the timer on a follower (leader != this host).
ETR="$TR/enable"; mkdir -p "$ETR"
MOCK="$HERE/mock-systemctl.sh"
export GARDEN_UNIT_CTL="$MOCK" GARDEN_MOCK_STATE="$ETR/armed" GARDEN_MOCK_LOG="$ETR/log"
: > "$GARDEN_MOCK_STATE"; : > "$GARDEN_MOCK_LOG"
export XDG_CONFIG_HOME="$ETR/config"; DEST="$XDG_CONFIG_HOME/systemd/user"; rm -rf "$DEST"; mkdir -p "$DEST"
for f in "$SRC"/garden-*.service "$SRC"/garden-*.timer; do [ -e "$f" ] && cp "$f" "$DEST/$(basename "$f")"; done
[ -e "$SRC/garden-worker@.service.in" ] \
  && sed -e "s#@GARDEN_ROOT@#$ROOT#g" -e "s#@WORKER_KIND@#gardener#g" "$SRC/garden-worker@.service.in" > "$DEST/garden-monk@.service"
GARDEN="$FOLLOWER" GARDEN_LEADER="$LEADER" "$JOBS/install-units.sh" enable-services >/dev/null 2>&1
grep -qxF 'garden-worktree-sweeper.timer' "$GARDEN_MOCK_STATE" \
  && ok "garden-worktree-sweeper.timer enabled on a follower host (fires on every host)" \
  || bad "garden-worktree-sweeper.timer NOT enabled on a follower"
unset XDG_CONFIG_HOME GARDEN_UNIT_CTL GARDEN_MOCK_STATE GARDEN_MOCK_LOG

# ============================================================================
hr; echo "BEHAVIORAL — the sweep reclaims a terminal worktree on a follower host"; hr
GROOT="$TR/garden"; SCRATCH="$GROOT/scratch"; STATE="$TR/state"
mkdir -p "$GROOT/worktrees" "$SCRATCH" "$STATE"
git init -q "$GROOT"
printf 'root\n' > "$GROOT/root.txt"
git -C "$GROOT" "${git_id[@]}" add root.txt
git -C "$GROOT" "${git_id[@]}" commit -qm root
git -C "$GROOT" branch -M main2

# Confirm the topology: with GARDEN != the leader marker, this host IS a follower.
if GARDEN="$FOLLOWER" GARDEN_LEADER="$LEADER" GARDEN_ROOT="$GROOT" \
   GARDEN_SCRATCH="$SCRATCH" GARDEN_STATE="$STATE" bash "$JOBS/is-main-host.sh"; then
  bad "is-main-host.sh reported LEADER for a host whose GARDEN != the leader marker"
else
  ok "is-main-host.sh reports FOLLOWER for this host (GARDEN=$FOLLOWER, leader=$LEADER)"
fi

# Journal fixture: one internal terminal (doomed) job, one still-live doin job.
JBARE="$TR/journal.git"; JSEED="$TR/journal-seed"
git init -q --bare "$JBARE"
git init -q "$JSEED"; git -C "$JSEED" checkout -qb journal2
mkdir -p "$JSEED/jobs/tada" "$JSEED/jobs/doin" "$JSEED/jobs/plan"
printf '%s\n' '---' 'doomed: true' '---' > "$JSEED/jobs/plan/gone.md"
printf 'still live\n' > "$JSEED/jobs/doin/alive.md"
git -C "$JSEED" "${git_id[@]}" add jobs
git -C "$JSEED" "${git_id[@]}" commit -qm journal
git -C "$JSEED" remote add origin "$JBARE"
git -C "$JSEED" push -q origin journal2

git -C "$GROOT" worktree add -q --detach "$SCRATCH/gardener-wt-gone" main2
git -C "$GROOT" worktree add -q --detach "$SCRATCH/gardener-wt-alive" main2

GARDEN="$FOLLOWER" GARDEN_LEADER="$LEADER" GARDEN_ROOT="$GROOT" GARDEN_SCRATCH="$SCRATCH" \
  GARDEN_STATE="$STATE" JOURNAL_REMOTE="$JBARE" JOURNAL_BRANCH=journal2 \
  GARDEN_WORKTREE_SWEEP_MAX=100 \
  GARDEN_GH="$HERE/worktree-sweeper-gh-stub.sh" WORKTREE_SWEEPER_GH_CALLS="$TR/gh-calls" \
  bash "$JOBS/worktree-sweeper.sh" >"$TR/sweep.log" 2>&1

[ ! -e "$SCRATCH/gardener-wt-gone" ] \
  && ok "follower sweep reclaimed the doomed terminal worktree" \
  || bad "follower sweep left the doomed terminal worktree behind (leader-gating regressed?)"
[ -d "$SCRATCH/gardener-wt-alive" ] \
  && ok "follower sweep preserved the still-live doin worktree" \
  || bad "follower sweep removed a live doin worktree"

echo
echo "worktree sweeper (follower): $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
