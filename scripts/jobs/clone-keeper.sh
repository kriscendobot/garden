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
# indefinitely. The keeper now PROVISIONS a genuinely-missing clone rather than
# skipping forever: it re-clones from the explicit fourth <clone-url> field of the
# tracked row when one is given (the unambiguous source; logging `REPAIRED`), else
# from the <remote> when that is itself a URL/path (also `REPAIRED`), and otherwise
# DERIVES the canonical upstream URL deterministically from the dir basename —
# worktrees/<owner>-<name>.git maps to <GARDEN_CLONE_URL_BASE>/<owner>/<name>.git —
# and clones from that (logging a `provisioned missing clone` line), so even a clone
# tracked by a bare remote name still self-heals (the basename derivation is the
# ambiguous last resort — an explicit <clone-url> is preferred). The fresh bare
# clone gets its fetch refspec set exactly as
# ensure-project-worktree.sh prescribes, then falls through to the normal
# fetch + fast-forward. Guards: a missing clone whose source cannot be REACHED is
# left for the next tick to retry (no re-clone loop, logged WARN — it is transient,
# e.g. offline); a missing clone with NO derivable/configured source at all cannot
# self-heal on any tick, so instead of an un-drained WARN it ESCALATES to the
# maintainer inbox (alert_maintainer) so a human restores it or adds a <clone-url>
# to the row — a vanished clone surfaces to a person instead of sitting invisible
# for weeks. A present-but-corrupt dir is surfaced as STALE for manual
# reconciliation rather than clobbered (it may hold un-pushed local state).
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

# Tracked bare clones, one per line: "<dir>|<remote>|<branch>[|<clone-url>]". <dir>
# is relative to GARDEN_ROOT (or absolute). <remote> is the FETCH source of the
# periodic fast-forward: either a bare remote NAME (e.g. `origin`, resolvable only
# while the clone still exists) or a URL/path. The optional fourth <clone-url> is
# the AUTHORITATIVE re-clone source used when the dir goes missing — give it
# explicitly so the owner/repo split is unambiguous (deriving `endojs`/`endo` from
# a hyphenated basename cannot tell owner `a-b`/name `c` from owner `a`/name `b-c`,
# so it is only a last resort). Re-clone source precedence when the dir is gone:
#   1. the explicit <clone-url> fourth field, when set (unambiguous);
#   2. else <remote>, when it is itself a URL/path (not a bare name);
#   3. else the URL DERIVED from the dir basename (<owner>-<name>.git ->
#      <GARDEN_CLONE_URL_BASE>/<owner>/<name>.git), the ambiguous last resort.
# Blank lines and #-comment lines are ignored. Override GARDEN_TRACKED_CLONES
# (newline-separated, same format) for tests or to track additional clones.
: "${GARDEN_TRACKED_CLONES:=worktrees/endojs-endo.git|origin|master|https://github.com/endojs/endo.git}"

# Base of the canonical upstream URL the keeper reconstructs from a missing clone's
# dir basename (worktrees/<owner>-<name>.git -> <base>/<owner>/<name>.git) when the
# tracked source is a bare remote name. Overridable for offline tests.
: "${GARDEN_CLONE_URL_BASE:=https://github.com}"

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
# (like "origin"). A location source drives a missing clone's re-clone directly; a
# bare name cannot be resolved once the clone is gone, so the keeper falls back to
# deriving the URL from the dir basename (derive_clone_url) for a bare-name source.
is_remote_location() {
  case "$1" in
    *://*|*@*:*|*/*) return 0 ;;
    *) return 1 ;;
  esac
}

# Reconstruct the canonical upstream URL of a MISSING tracked clone from its dir
# basename. The garden names standing bare clones worktrees/<owner>-<name>.git (the
# forward map ensure-project-worktree.sh builds), so a vanished clone's upstream can
# be derived deterministically by reversing it: strip the .git suffix, split on the
# FIRST '-' into <owner>/<name>, and form <GARDEN_CLONE_URL_BASE>/<owner>/<name>.git.
# Echoes the URL and returns 0 when derivable; returns 1 when the basename does not
# fit the <owner>-<name>.git shape (no .git suffix, or no '-' to split on).
derive_clone_url() {
  local abs="$1" bn owner name
  bn="$(basename -- "$abs")"
  case "$bn" in *.git) bn="${bn%.git}" ;; *) return 1 ;; esac
  case "$bn" in *-*) ;; *) return 1 ;; esac
  owner="${bn%%-*}"
  name="${bn#*-}"
  [ -n "$owner" ] && [ -n "$name" ] || return 1
  printf '%s/%s/%s.git\n' "$GARDEN_CLONE_URL_BASE" "$owner" "$name"
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
  local dir="$1" remote="$2" branch="$3" clone_url="${4:-}" abs="$1"
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
    # Pick a clone source, most-authoritative first: the explicit fourth
    # <clone-url> field of the tracked row (unambiguous owner/repo, wins over
    # everything); else the <remote> when it is itself a URL/path (it can pin a
    # non-GitHub upstream); else the canonical GitHub URL DERIVED from the dir
    # basename so even a clone tracked by a bare remote name self-heals — but that
    # derivation is ambiguous for hyphenated owners/names, hence the last resort.
    local src provisioned=
    if [ -n "$clone_url" ]; then
      src="$clone_url"
    elif is_remote_location "$remote"; then
      src="$remote"
    elif src="$(derive_clone_url "$abs")"; then
      provisioned=1
    else
      # Nothing can auto-recreate this clone: the remote is a bare name (dead once
      # the clone is gone), no explicit fourth <clone-url> is configured, and the
      # basename does not fit <owner>-<name>.git to derive one. A bare WARN here is
      # exactly the failure mode this keeper exists to kill — it would drain into
      # the log and the vanished clone would sit invisible for weeks (the endo
      # six-week block). ESCALATE to the maintainer inbox so a human restores it or
      # adds a <clone-url> to the row. alert_maintainer is throttled and never fails
      # its caller, so this stays a self-contained per-clone step.
      local emsg="clone-keeper: tracked bare clone $dir is MISSING at $abs and cannot be auto-recreated — remote '$remote' is a bare name (unresolvable once the clone is gone), no explicit fourth <clone-url> field is set on its GARDEN_TRACKED_CLONES row, and no upstream URL could be derived from its basename. Every downstream worktree/dispatch that needs this clone is blocked until it is restored. Fix: add a <clone-url> fourth field to the row (unambiguous re-clone source) or re-clone by hand. This is the six-week endo stale-clone hazard the keeper exists to prevent."
      log "STALE: $emsg"
      alert_maintainer "clone-keeper-missing-nourl-${dir//[^A-Za-z0-9._-]/_}" "$emsg"
      return 0
    fi
    if ! bounded_clone "$src" "$abs"; then
      log "WARN: tracked clone $dir is missing at $abs and re-clone from $src failed (unreachable/offline?); skipping"
      return 0
    fi
    # A bare clone carries NO fetch refspec, so set it exactly as
    # ensure-project-worktree.sh prescribes — otherwise origin/* tracking refs on
    # worktrees cut from this clone would stay frozen through later fetches.
    git -C "$abs" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*' || true
    if [ -n "$provisioned" ]; then
      log "provisioned missing clone $dir from $src"
    else
      log "REPAIRED: re-created missing bare clone $dir at $abs from $src"
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

while IFS='|' read -r dir remote branch clone_url; do
  dir="${dir#"${dir%%[![:space:]]*}"}"   # ltrim
  [ -n "$dir" ] || continue
  case "$dir" in \#*) continue ;; esac
  # rtrim the last field so a trailing space/CR in the row does not corrupt the URL.
  clone_url="${clone_url%"${clone_url##*[![:space:]]}"}"
  keep_clone "$dir" "${remote:-origin}" "${branch:-master}" "$clone_url"
done <<< "$GARDEN_TRACKED_CLONES"
