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
# A tracked clone can also disappear entirely: on 2026-07-02 worktrees/endojs-endo.git
# went missing at 09:30 and again at 10:00, and every prior version of this keeper
# only re-warned `missing or not a git repo … skipping` each tick — never repaired
# it — so every downstream worktree/dispatch that needs the endo clone stayed broken
# indefinitely. The keeper now REPAIRS a genuinely-missing clone by re-cloning it
# from its known source (the same location the keeper fetches from, when that is a
# URL/path rather than a bare remote name), logging a `REPAIRED` line. Guards: a
# genuinely-unreachable source falls back to the existing skip (no re-clone loop,
# the next tick retries), and a present-but-corrupt dir is surfaced as STALE for
# manual reconciliation rather than clobbered (it may hold un-pushed local state).
#
# When the tracked source is a bare remote NAME (e.g. `origin`) that carries no
# fetch refspec, or a URL/path fetched directly, `git fetch <src> <branch>`
# advances FETCH_HEAD only; the local branch ref must be moved explicitly. We do
# that with a compare-and-swap `update-ref <new> <old>` so a concurrent advance
# never races us into a clobber.
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
# to GARDEN_ROOT (or absolute). <remote> is the fetch source: either a bare remote
# NAME (e.g. `origin`, resolvable only while the clone still exists) or a URL/path
# (e.g. https://…/endo.git) that can ALSO re-clone the dir if it goes missing. A
# bare name cannot drive a re-clone (there is no repo left to resolve it against),
# so track a clone by URL/path if you want the keeper to repair it when it vanishes.
# Blank lines and #-comment lines are ignored. Override GARDEN_TRACKED_CLONES
# (newline-separated, same format) for tests or to track additional clones.
: "${GARDEN_TRACKED_CLONES:=worktrees/endojs-endo.git|https://github.com/endojs/endo.git|master}"

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
    backoff "$attempt"; attempt=$((attempt+1))
  done
}

# True when $abs is ITS OWN bare git repo, not a discovered ANCESTOR repo. The
# tracked clones live under worktrees/ inside the garden root, which is itself a git
# repo, so a plain `rev-parse --git-dir` on a missing/corrupt dir would walk up and
# succeed against the garden repo — a false positive. We require the resolved
# absolute git-dir to equal $abs. Fails (non-zero) when $abs is missing (git cannot
# chdir) or is a non-repo dir (git discovers an ancestor whose git-dir != $abs).
is_own_git_repo() {
  local abs="$1" gd a g
  gd="$(git -C "$abs" rev-parse --absolute-git-dir 2>/dev/null || true)"
  [ -n "$gd" ] || return 1
  a="$(realpath -m "$abs" 2>/dev/null || echo "$abs")"
  g="$(realpath -m "$gd" 2>/dev/null || echo "$gd")"
  [ "$a" = "$g" ]
}

# True when $1 is a fetchable/cloneable URL or path rather than a bare remote NAME
# (like "origin"). A bare name cannot be resolved to a URL once the clone is gone,
# so only a location can drive a re-clone of a missing tracked clone.
is_remote_location() {
  case "$1" in
    *://*|*@*:*|*/*) return 0 ;;
    *) return 1 ;;
  esac
}

# Bounded bare clone of <src> into <abs>, mirroring bounded_fetch's timeout+retry
# discipline (git has no IO timeout of its own). git clone removes its own target
# on an internal error, but a timeout SIGTERM can leave a partial tree, so we scrub
# any non-repo leftover before each retry (and on final failure) to keep the
# missing-vs-corrupt discrimination in keep_clone accurate on the next tick.
# Returns 0 on success, the last non-zero rc after the retry budget is spent.
bounded_clone() {
  local src="$1" abs="$2" attempt=1 rc=0
  mkdir -p "$(dirname "$abs")"
  while :; do
    if timeout "$GARDEN_FETCH_TIMEOUT" git clone -q --bare "$src" "$abs" 2>/dev/null; then
      return 0
    else
      rc=$?
    fi
    [ -e "$abs" ] && ! is_own_git_repo "$abs" && rm -rf "$abs"
    [ "$rc" -eq 124 ] && log "clone of $src into $abs timed out (>${GARDEN_FETCH_TIMEOUT}s) on attempt $attempt"
    if [ "$attempt" -ge "$GARDEN_FETCH_RETRIES" ]; then
      log "clone of $src into $abs failed after $attempt attempt(s) (last rc=$rc)"
      return "$rc"
    fi
    backoff "$attempt"; attempt=$((attempt+1))
  done
}

# Fetch + fast-forward one tracked clone. Self-contained: every failure path is
# logged and returns 0, so one unreachable/diverged clone never aborts the rest.
keep_clone() {
  local dir="$1" remote="$2" branch="$3" abs="$1"
  case "$abs" in /*) ;; *) abs="$GARDEN_ROOT/$dir" ;; esac

  if ! is_own_git_repo "$abs"; then
    # The tracked clone is gone or broken. Two very different situations:
    #   * a present-but-corrupt dir → surface as STALE, never clobber (it may hold
    #     un-pushed local state; manual reconciliation is safer than a re-clone);
    #   * a genuinely MISSING dir whose source location is known → re-create it, so
    #     a clone that disappears (worktrees/endojs-endo.git, 2026-07-02) is repaired
    #     next tick instead of re-warned forever with every dependent left broken.
    if [ -e "$abs" ]; then
      log "STALE: tracked clone $dir at $abs exists but is not a git repo; needs manual reconciliation (not clobbering)"
      return 0
    fi
    if ! is_remote_location "$remote"; then
      log "WARN: tracked clone $dir is missing at $abs and remote '$remote' is a bare name (no URL known to re-clone from); skipping"
      return 0
    fi
    if ! bounded_clone "$remote" "$abs"; then
      log "WARN: tracked clone $dir is missing at $abs and re-clone from $remote failed (unreachable?); skipping"
      return 0
    fi
    if git -C "$abs" rev-parse --verify --quiet "refs/heads/$branch" >/dev/null 2>&1; then
      log "REPAIRED: re-created missing bare clone $dir at $abs from $remote (branch $branch)"
    else
      log "REPAIRED: re-created missing bare clone $dir at $abs from $remote, but it has no refs/heads/$branch"
    fi
    # Fall through to the normal fetch + fast-forward below: a no-op on a
    # just-cloned repo, but it keeps the ref-freshness contract in one place.
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
