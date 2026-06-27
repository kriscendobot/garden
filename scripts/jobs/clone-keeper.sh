#!/bin/bash
# clone-keeper.sh — keep the standing upstream bare clones fast-forward-fresh.
#
# The library fleet reads upstream history from standing BARE clones under
# worktrees/<owner>-<repo>.git (ephemeral worktrees are created off them). Those
# clones only advance when something fetches them. Keeping `origin master` fresh
# is a deterministic fetch + fast-forward — there is no LLM judgment in it — yet
# until this keeper existed it depended on an empty-inbox scholar cycle happening
# to NOTICE the lag and fast-forward by hand. On 2026-05-12..06-27 the endo bare
# clone sat pinned at master=052b0487 for SIX WEEKS, silently blocking endo
# upstream-drift re-ingestion; three separate scholar cycles flagged it before one
# finally fast-forwarded it 052b0487 -> 090175b2. This moves clone freshness off
# the agent and onto a cadence timer so the re-ingestion block can never re-form.
#
# Per tick, for each tracked clone:
#   * bounded fetch of `<remote> <branch>` — wrapped in `timeout
#     GARDEN_FETCH_TIMEOUT` with backoff/retry (git has NO IO timeout of its own,
#     so a half-open connection can hang a fetch forever); any fetch that somehow
#     outlives its bound is reaped by reaper.sh's stuck-fetch janitor, which kills
#     any `git fetch` older than GARDEN_FETCH_REAP_AGE. A failing fetch (offline,
#     DNS) is logged and the clone is left where it is — never wedged;
#   * fast-forward the LOCAL `refs/heads/<branch>` to the fetched tip, but ONLY
#     when it is a strict fast-forward. A clone whose local branch is not an
#     ancestor of upstream has DIVERGED (a stray local commit, an upstream rewrite)
#     and is surfaced loudly (`STALE: … cannot fast-forward`) rather than silently
#     lagging or being clobbered.
#
# `origin` on the endo bare clone carries no fetch refspec (it is fetched
# branch-at-a-time), so `git fetch origin master` advances FETCH_HEAD only; the
# local branch ref must be moved explicitly. We do that with a compare-and-swap
# `update-ref <new> <old>` so a concurrent advance never races us into a clobber.
#
# Runs on garden-clone-keeper.timer (~30m). Quiet on the no-op path (a one-line
# "already fresh"); a fast-forward and any anomaly are logged so a clone that
# cannot advance surfaces in the journal instead of going weeks-stale unseen.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="clone-keeper"

# Tracked bare clones, one per line: "<dir>|<remote>|<branch>". <dir> is relative
# to GARDEN_ROOT (or absolute). Blank lines and #-comment lines are ignored.
# Override GARDEN_TRACKED_CLONES (newline-separated, same format) for tests or to
# track additional clones.
: "${GARDEN_TRACKED_CLONES:=worktrees/endojs-endo.git|origin|master}"

# Bounded ref fetch for an arbitrary remote/branch, mirroring common.sh's
# journal_fetch (which is hardwired to the journal branch): each attempt is
# wrapped in `timeout GARDEN_FETCH_TIMEOUT`, transient failures retry with backoff
# up to GARDEN_FETCH_RETRIES. The `if … ; then … ; else rc=$?; fi` form keeps a
# non-zero fetch from tripping the caller's `set -e` before we can read its rc.
# Returns 0 on success, the last non-zero rc after the retry budget is spent.
bounded_fetch() {
  local dir="$1" remote="$2" branch="$3" attempt=1 rc=0
  while :; do
    if timeout "$GARDEN_FETCH_TIMEOUT" git -C "$dir" fetch -q "$remote" "$branch" 2>/dev/null; then
      return 0
    else
      rc=$?
    fi
    [ "$rc" -eq 124 ] && log "fetch $remote $branch in $dir timed out (>${GARDEN_FETCH_TIMEOUT}s) on attempt $attempt"
    if [ "$attempt" -ge "$GARDEN_FETCH_RETRIES" ]; then
      log "fetch $remote $branch in $dir failed after $attempt attempt(s) (last rc=$rc)"
      return "$rc"
    fi
    backoff; attempt=$((attempt+1))
  done
}

# Fetch + fast-forward one tracked clone. Self-contained: every failure path is
# logged and returns 0, so one unreachable/diverged clone never aborts the rest.
keep_clone() {
  local dir="$1" remote="$2" branch="$3" abs="$1"
  case "$abs" in /*) ;; *) abs="$GARDEN_ROOT/$dir" ;; esac

  if ! git -C "$abs" rev-parse --git-dir >/dev/null 2>&1; then
    log "WARN: tracked clone $dir is missing or not a git repo at $abs; skipping"
    return 0
  fi

  local old
  old="$(git -C "$abs" rev-parse --verify --quiet "refs/heads/$branch" || true)"
  if [ -z "$old" ]; then
    log "WARN: $dir has no local refs/heads/$branch; skipping"
    return 0
  fi

  if ! bounded_fetch "$abs" "$remote" "$branch"; then
    log "fetch of $remote/$branch for $dir failed (offline?); leaving $branch at $old"
    return 0
  fi

  local new
  new="$(git -C "$abs" rev-parse --verify --quiet FETCH_HEAD || true)"
  if [ -z "$new" ]; then
    log "WARN: $dir fetch of $remote/$branch left no FETCH_HEAD; skipping"
    return 0
  fi

  if [ "$new" = "$old" ]; then
    log "$dir: $branch already fresh at $old"
    return 0
  fi

  # Strict fast-forward only. A non-ancestor old tip means the clone has diverged
  # (a stray local commit or an upstream rewrite); surface it, never clobber.
  if ! git -C "$abs" merge-base --is-ancestor "$old" "$new" 2>/dev/null; then
    log "STALE: $dir cannot fast-forward $branch ($old is not an ancestor of upstream $new); needs manual reconciliation"
    return 0
  fi

  # Compare-and-swap on the old value so a concurrent advance never races us.
  if git -C "$abs" update-ref "refs/heads/$branch" "$new" "$old"; then
    log "$dir: fast-forwarded $branch $old -> $new"
  else
    log "WARN: $dir update-ref of $branch raced (moved out from under $old); will retry next tick"
  fi
  return 0
}

while IFS='|' read -r dir remote branch; do
  dir="${dir#"${dir%%[![:space:]]*}"}"   # ltrim
  [ -n "$dir" ] || continue
  case "$dir" in \#*) continue ;; esac
  keep_clone "$dir" "${remote:-origin}" "${branch:-master}"
done <<< "$GARDEN_TRACKED_CLONES"
