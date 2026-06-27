#!/bin/bash
# watchman.sh — tell gardeners to reread after a deploy advances the root tree.
#
# Usage: watchman.sh
#
# Each tick: fetch origin and broadcast a deterministic "reread your role and
# skills" message to all active gardeners when this container's local tree HEAD
# has CHANGED since the last tick, then — best-effort — run the richer evolution
# handler (`claude -p` wearing the watchman role) for targeted notes.
#
# The aggressive checkout is RETIRED by default (GARDEN_AGGRESSIVE_CHECKOUT=0).
# Under the deliberate-deploy model (designs/deliberate-deploy.md) NOTHING
# fast-forwards the root tree except deploy-garden.sh: development happens in
# per-subagent worktrees, and the root is a deployed version advanced only by a
# drained deploy. So the watchman no longer touches the tree; it keeps only its
# BROADCAST role. Because the local tree HEAD now changes exactly once per deploy,
# the reread broadcast naturally becomes a POST-DEPLOY reread signal — which is
# precisely when gardeners need to reread their (newly-deployed) roles and skills.
#
# The legacy aggressive checkout remains behind GARDEN_AGGRESSIVE_CHECKOUT=1 for a
# host that has not yet cut over (it fast-forwards only a tree with no TRACKED
# edits and posts a resolve-wedge job, never pages the maintainer, on a wedge),
# but it is OFF by default and should stay off — re-enabling it reintroduces the
# continuous-ff collision this model was built to remove.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=wedge-resolve.sh
source "$HERE/wedge-resolve.sh"
GARDEN_TAG="watchman"
: "${GARDEN_MAIN_BRANCH:=main2}"
: "${GARDEN_AGGRESSIVE_CHECKOUT:=0}"
: "${GARDEN_WATCH_HANDLER:=$HERE/handlers/watchman-claude.sh}"

fleet_draining && { log "fleet draining; skipping"; exit 0; }

git -C "$GARDEN_ROOT" fetch -q origin "$GARDEN_MAIN_BRANCH" 2>/dev/null || log "fetch of origin/$GARDEN_MAIN_BRANCH failed (offline?)"

local_sha="$(git -C "$GARDEN_ROOT" rev-parse --verify --quiet "$GARDEN_MAIN_BRANCH" || true)"
[ -n "$local_sha" ] || die "cannot resolve local $GARDEN_MAIN_BRANCH in $GARDEN_ROOT"
up_sha="$(git -C "$GARDEN_ROOT" rev-parse --verify --quiet "origin/$GARDEN_MAIN_BRANCH" || echo "$local_sha")"

# Aggressively converge local main2 onto upstream when behind (and clean).
if [ "$up_sha" != "$local_sha" ] && [ "$GARDEN_AGGRESSIVE_CHECKOUT" = "1" ]; then
  if git -C "$GARDEN_ROOT" merge-base --is-ancestor "$local_sha" "$up_sha" 2>/dev/null; then
    # "Clean enough to fast-forward" means no TRACKED changes. Untracked files
    # (--untracked-files=no excludes them) are not WIP and must not wedge the
    # fleet — only genuine tracked edits we'd risk clobbering should block.
    dirty_tracked="$(git -C "$GARDEN_ROOT" status --porcelain --untracked-files=no 2>/dev/null)"
    if [ -z "$dirty_tracked" ]; then
      if git -C "$GARDEN_ROOT" merge --ff-only "origin/$GARDEN_MAIN_BRANCH" >/dev/null 2>&1; then
        log "fast-forwarded $GARDEN_MAIN_BRANCH: $local_sha → $up_sha"
        local_sha="$up_sha"
      else
        # No tracked WIP, yet the ff was refused — typically an untracked file
        # colliding with an incoming tracked path. Resolve autonomously; never clobber.
        log "WARN: ff-merge to origin/$GARDEN_MAIN_BRANCH refused (untracked collision with an incoming path?); posting resolve-wedge job"
        trigger_wedge_resolution "$local_sha" "$up_sha" "fast-forward refused (an untracked file collides with an incoming tracked path)" ""
      fi
    else
      log "WARN: $GARDEN_MAIN_BRANCH worktree has TRACKED changes; skipping aggressive checkout, posting resolve-wedge job"
      trigger_wedge_resolution "$local_sha" "$up_sha" "tracked working-tree changes block the fast-forward" "$dirty_tracked"
    fi
  fi
fi

target="$local_sha"
SEEN="$GARDEN_STATE/watchman/seen-$GARDEN_MAIN_BRANCH"
mkdir -p "$(dirname "$SEEN")"
old_sha="$(cat "$SEEN" 2>/dev/null || true)"
if [ "$old_sha" = "$target" ]; then
  log "no change on $GARDEN_MAIN_BRANCH ($target)"
  exit 0
fi
log "$GARDEN_MAIN_BRANCH at $target (was ${old_sha:-<none>}); notifying gardeners"

# Deterministic reread notice to every active gardener (required).
printf 'main2 advanced to %s — reread your role and skills as needed.\n' "$target" \
  | GARDEN_SENDER=watchman "$HERE/send-msg.sh" broadcast \
  || die "could not broadcast reread notice"

# Richer, targeted evolution notes (best-effort; needs claude).
"$GARDEN_WATCH_HANDLER" "${old_sha:-}" "$target" "$GARDEN_ROOT" \
  || log "evolution handler skipped (no claude or nothing to add)"

printf '%s\n' "$target" > "$SEEN"
log "broadcast reread up to $target"
