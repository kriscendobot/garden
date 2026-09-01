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
# A tracked clone can also disappear entirely — or be misconfigured to a path that
# never existed: the tracked default long named worktrees/endojs-endo.git, a clone
# absent on every host (only the endojs-endo-but-for-bots.git fork clone is ever
# present), so the keeper re-warned `missing or not a git repo … skipping` on every
# ~30m tick and freshened nothing, the exact stale-clone hazard it exists to kill.
# A genuinely-vanished clone is the same shape (worktrees/endojs-endo-but-for-bots.git
# went missing at 09:30 and again at 10:00 on 2026-07-02), and every prior version of
# this keeper only re-warned each tick — never repaired it — so every downstream
# worktree/dispatch that needs the clone stayed broken indefinitely. The keeper now
# PROVISIONS a genuinely-missing clone rather than
# skipping forever: it re-clones from the explicit fourth <clone-url> field of the
# tracked row when one is given (the unambiguous source; logging `REPAIRED`), else
# from the <remote> when that is itself a URL/path (also `REPAIRED`), and otherwise
# DERIVES the canonical upstream URL deterministically from the dir basename —
# worktrees/<owner>-<name>.git maps to <GARDEN_CLONE_URL_BASE>/<owner>/<name>.git —
# and clones from that (logging a `provisioned missing clone` line), so even a clone
# tracked by a bare remote name still self-heals (the basename derivation is the
# ambiguous last resort — an explicit <clone-url> is preferred). The re-clone is
# staged into a SIBLING temp path and atomically `mv -T`d into place only once it
# is complete, so a partial/timed-out or racing clone never half-populates or
# clobbers the tracked path (bounded_clone). The fresh bare clone gets its fetch
# refspec set exactly as ensure-project-worktree.sh prescribes, then falls through
# to the normal fetch + fast-forward. Guards: a missing clone whose source cannot
# be REACHED is left for the next tick to retry (no re-clone loop) — a transient
# blip (offline, DNS) self-heals next tick — but the failure ALSO throttle-escalates
# to the maintainer inbox (alert_maintainer, deduped per clone, at most once per
# window) so a PERSISTENTLY unreachable source (a deleted upstream, a wrong
# <clone-url>) surfaces to a human instead of re-warning every ~30m tick forever
# unseen; a missing clone with NO derivable/configured source at all cannot
# self-heal on any tick, so it likewise ESCALATES so a human restores it or adds a
# <clone-url> to the row — a vanished clone surfaces to a person instead of sitting
# invisible for weeks. A present-but-corrupt dir is surfaced as STALE for manual
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
export GARDEN_TAG="clone-keeper"

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
#
# The mutable `master` branch of endojs/endo-but-for-bots is deliberately NOT
# tracked here. It is a fork integration branch, not an upstream mirror: advancing
# or recreating it from endojs/endo discards merge commits made in the fork. The
# only sanctioned upstream-base artifact on that fork is a frozen `master-<hash>`
# branch, created by the frozen-base-branch workflow when a PR needs an anchor.
#
# The tracked clone below is the kriscendobot/vattr97 fork, registered on
# maintainer request (kriskowal/garden#26, dckc: "register a fork of dckc/vattr97
# and put the design there") to hold the OpenCollective⟷ERTP design of record
# (designs/opencollective-ertp.md). Its `main` mirrors the fork's default branch;
# <remote> is the fork's own `origin`, so the fast-forward keeps the local bare
# clone in step with whatever the fleet has pushed to the fork (it does NOT sync
# the fork from upstream dckc/vattr97 — that is a separate, deliberate act). The
# fork is NOT on any watcher's safe-to-watch set (§ Monitoring safety constraint);
# registration here is purely a standing bare clone the fleet can cut design
# worktrees from. Basename kriscendobot-vattr97.git is unambiguous, but the
# <clone-url> is pinned explicitly so a missing clone can be restored without
# ambiguous basename parsing.
: "${GARDEN_TRACKED_CLONES:=worktrees/kriscendobot-vattr97.git|origin|main|ssh://git@github.com/kriscendobot/vattr97.git}"

# The canonical-upstream-URL base (GARDEN_CLONE_URL_BASE) the keeper reconstructs
# from a missing clone's dir basename lives in common.sh, alongside the shared
# is_own_git_repo / is_remote_location / derive_clone_url / bounded_clone helpers
# (triager.sh self-provisions with the same logic). Overridable for offline tests.

# is_own_git_repo, is_remote_location, derive_clone_url, and bounded_clone are
# shared helpers defined in common.sh. bounded_fetch accepts arbitrary fetch
# arguments, so triager can refresh all remotes while this keeper fetches its
# configured remote/branch. See common.sh § standing bare-clone provisioning helpers.

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
    #     a clone that disappears (worktrees/endojs-endo-but-for-bots.git, 2026-07-02) is repaired
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
      # The source is known but the re-clone did not complete. Usually transient
      # (offline, DNS, a half-open connection reaped by the timeout) and self-heals
      # next tick, so we do NOT wedge — we return to retry. But a PERSISTENTLY
      # unreachable source (a deleted upstream, a wrong <clone-url>) would otherwise
      # re-warn every ~30m tick forever into a log nobody reads — the exact "missing
      # clone silently blocks the fleet" hazard this keeper exists to kill. So the
      # failure ALSO escalates to the maintainer inbox; alert_maintainer is throttled
      # per dedup key (the stamped marker that keeps it from re-posting every tick)
      # and never fails its caller, so a transient blip alerts at most once per
      # window while a persistent failure reliably reaches a human.
      local wmsg="clone-keeper: tracked bare clone $dir is MISSING at $abs and the re-clone from '$src' failed (unreachable/offline?). It is retried next tick; if this persists the source is bad (deleted upstream, wrong <clone-url>, or firewalled) and needs manual attention — every downstream worktree/dispatch that needs this clone is blocked until it is restored."
      log "WARN: $wmsg (skipping this tick)"
      alert_maintainer "clone-keeper-reclone-failed-${dir//[^A-Za-z0-9._-]/_}" "$wmsg"
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
