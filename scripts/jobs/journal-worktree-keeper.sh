#!/bin/bash
# journal-worktree-keeper.sh — keep the shared $GARDEN_ROOT/journal worktree
# fast-forwarded to origin/journal2, CONSERVATIVELY.
#
# The journal/ worktree is the human-and-agent-readable checkout of the journal2
# branch (the job board + message bus). The scripted pipeline never advances it:
# every producer/gardener works in its OWN per-instance clone under $GARDEN_STATE
# or $GARDEN_SCRATCH, and common.sh INTENTIONALLY never touches journal/ (a
# `reset --hard` there would autostash/clobber a live agent's uncommitted WIP —
# see the stored feedback feedback_journal_reset_clobbers_garden and
# feedback_journal_poll_daemon_race). So the worktree only advances when a human
# or an agent happens to fast-forward it by hand, and otherwise drifts unbounded:
# observed 2331 commits behind origin/journal2 with 3 stray unpushed local-only
# commits. Every agent that lands in journal/ then pays a detect-and-route-around
# tax, and the lag is itself a `reset --hard` foot-gun.
#
# This keeper moves that fast-forward off the agent and onto a cadence timer, the
# same shape as clone-keeper.sh, but with HARD conservatism because journal/ is a
# live working tree, not a bare clone:
#
#   * bounded fetch of origin/journal2 (the timeout + retry helper from
#     common.sh; git has no IO timeout of its own, so a half-open connection can
#     hang a fetch forever). A failing fetch (offline, DNS) is logged and the
#     worktree is left where it is — never wedged;
#   * advance ONLY via `git merge --ff-only origin/journal2`, and ONLY when the
#     tree is provably safe to advance: `git status --porcelain` is empty AND
#     `git rev-list --count origin/journal2..HEAD` is 0 (no local-ahead/divergent
#     commits). A dirty tree or any local-ahead commit means a human or a live
#     agent has WIP here; we NEVER reset, pull, stash, or clobber it. Instead we
#     emit a single THROTTLED alert_maintainer report naming the divergence and
#     leave the worktree exactly as we found it.
#
# Runs on garden-journal-worktree-keeper.timer (~30m), the same cadence as
# clone-keeper. Quiet on the no-op path (a one-line "already fresh"); a
# fast-forward and any divergence are logged, and a divergence also escalates to
# the maintainer inbox (throttled) so a stuck worktree surfaces to a human
# instead of silently rotting weeks-behind.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="journal-worktree-keeper"

# The shared journal worktree. Overridable for tests; defaults to the real one.
: "${GARDEN_JOURNAL_WORKTREE:=$GARDEN_ROOT/journal}"
JW="$GARDEN_JOURNAL_WORKTREE"

# Fetch + conservative fast-forward of the journal worktree. Every failure path
# logs and returns 0 so a transient hiccup never marks the tick Failed; only a
# true, safe fast-forward moves the ref.
keep_journal_worktree() {
  if ! git -C "$JW" rev-parse --git-dir >/dev/null 2>&1; then
    log "WARN: journal worktree missing or not a git repo at $JW; skipping"
    return 0
  fi

  # Bounded, timeout-wrapped, retrying fetch of origin/$JOURNAL_BRANCH (the
  # common.sh helper). A non-zero return is a connectivity hiccup: leave the
  # worktree untouched and let the next tick catch up.
  if ! journal_fetch "$JW"; then
    log "fetch of origin/$JOURNAL_BRANCH failed (offline?); leaving $JW untouched"
    return 0
  fi

  local remote head
  remote="$(git -C "$JW" rev-parse --verify --quiet "refs/remotes/origin/$JOURNAL_BRANCH" || true)"
  head="$(git -C "$JW" rev-parse --verify --quiet HEAD || true)"
  if [ -z "$remote" ] || [ -z "$head" ]; then
    log "WARN: could not resolve HEAD or origin/$JOURNAL_BRANCH in $JW; skipping"
    return 0
  fi

  if [ "$head" = "$remote" ]; then
    log "$JW: already fresh at $head"
    return 0
  fi

  # The two safety gates: a clean tree AND no local-ahead/divergent commits.
  local dirty ahead behind dirty_count
  dirty="$(git -C "$JW" status --porcelain 2>/dev/null || true)"
  ahead="$(git -C "$JW" rev-list --count "origin/$JOURNAL_BRANCH..HEAD" 2>/dev/null || echo 0)"
  behind="$(git -C "$JW" rev-list --count "HEAD..origin/$JOURNAL_BRANCH" 2>/dev/null || echo 0)"

  if [ -n "$dirty" ] || [ "${ahead:-0}" -ne 0 ]; then
    dirty_count="$(printf '%s\n' "$dirty" | grep -c . || true)"
    local msg
    msg="journal worktree $JW has DIVERGED from origin/$JOURNAL_BRANCH and was left UNTOUCHED (no reset/pull/stash): ${ahead:-0} local-ahead commit(s), ${behind} behind, ${dirty_count} dirty path(s). Reconcile by hand: 'git -C $JW status', 'git -C $JW log --oneline origin/$JOURNAL_BRANCH..HEAD', then rebase/push or discard the local commits. (host=$GARDEN_HOST)"
    log "DIVERGED: $msg"
    alert_maintainer "journal-worktree-divergence-$GARDEN_HOST" "$msg"
    return 0
  fi

  # Clean and strictly behind: a real fast-forward is safe. Use --ff-only so an
  # unexpected non-ancestor state (a race that snuck a local commit in after the
  # gate) can only refuse, never create a merge commit.
  if git -C "$JW" merge --ff-only "origin/$JOURNAL_BRANCH" >/dev/null 2>&1; then
    log "$JW: fast-forwarded $head -> $remote (${behind} commit(s))"
  else
    local msg
    msg="journal worktree $JW could not fast-forward to origin/$JOURNAL_BRANCH despite a clean, non-ahead tree; left UNTOUCHED. Inspect 'git -C $JW status'. (host=$GARDEN_HOST)"
    log "STALE: $msg"
    alert_maintainer "journal-worktree-fffail-$GARDEN_HOST" "$msg"
  fi
  return 0
}

keep_journal_worktree
