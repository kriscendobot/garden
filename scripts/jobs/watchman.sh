#!/bin/bash
# watchman.sh — keep this container current on main2 and tell gardeners to reread.
#
# Usage: watchman.sh
#
# Each tick: fetch origin and, if origin/main2 has advanced, AGGRESSIVELY
# fast-forward this container's local main2 (so every host converges quickly on
# the latest roles/skills). Then broadcast a deterministic "reread your role and
# skills" message to all active gardeners, and — best-effort — run the richer
# evolution handler (`claude -p` wearing the watchman role) for targeted notes.
#
# The aggressive checkout only fast-forwards a tree with no TRACKED local edits;
# genuine WIP (tracked-modified / staged) is left alone and reported LOUDLY to
# the maintainer (we never clobber local edits, and a dirty tree must never
# silently freeze the fleet-wide deploy — see notify_dirty_wedge). UNTRACKED
# files (stray sibling worktrees, build artifacts that live inside the garden
# root) are NOT treated as dirty: they are not WIP and must not wedge the
# deploy. Disable the aggressive checkout entirely with GARDEN_AGGRESSIVE_CHECKOUT=0.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="watchman"
: "${GARDEN_MAIN_BRANCH:=main2}"
: "${GARDEN_AGGRESSIVE_CHECKOUT:=1}"
: "${GARDEN_WATCH_HANDLER:=$HERE/handlers/watchman-claude.sh}"

# Loudly tell the maintainer that a dirty live tree is wedging this host's deploy
# (origin advanced but the tree can't fast-forward). Deduped on (target SHA,
# blocking paths) so persistent dirtiness reports once, not on every tick.
notify_dirty_wedge() {
  local from="$1" to="$2" reason="$3" paths="$4"
  local marker="$GARDEN_STATE/watchman/dirty-notified-$GARDEN_MAIN_BRANCH"
  local sig; sig="$to:$(printf '%s' "$paths" | cksum | tr -d ' ')"
  [ "$(cat "$marker" 2>/dev/null || true)" = "$sig" ] && { log "dirty-wedge already reported for this state"; return 0; }
  mkdir -p "$(dirname "$marker")"
  if {
        printf 'watchman: %s on host %s is WEDGED — this host'\''s deploy is frozen.\n\n' "$GARDEN_MAIN_BRANCH" "$GARDEN_HOST"
        printf 'origin/%s has advanced to %s but the live tree is stuck at %s: %s.\n' "$GARDEN_MAIN_BRANCH" "$to" "$from" "$reason"
        printf 'Until the tree is clean this host will NOT pick up new roles/skills/scripts.\n'
        if [ -n "$paths" ]; then
          printf '\nTracked changes blocking the fast-forward:\n'
          printf '```\n%s\n```\n' "$paths"
          printf '\nVerify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.\n'
        fi
     } | GARDEN_SENDER=watchman "$HERE/message-user.sh" watchman-dirty-tree 2>/dev/null
  then
    printf '%s\n' "$sig" > "$marker"
    log "reported dirty-wedge to maintainer"
  else
    log "WARN: could not report dirty-wedge to maintainer"
  fi
}

killswitch_engaged && { log "killswitch engaged; skipping"; exit 0; }

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
        # colliding with an incoming tracked path. Report loudly; never clobber.
        log "WARN: ff-merge to origin/$GARDEN_MAIN_BRANCH refused (untracked collision with an incoming path?)"
        notify_dirty_wedge "$local_sha" "$up_sha" "fast-forward refused (an untracked file collides with an incoming tracked path)" ""
      fi
    else
      log "WARN: $GARDEN_MAIN_BRANCH worktree has TRACKED changes; skipping aggressive checkout"
      notify_dirty_wedge "$local_sha" "$up_sha" "tracked working-tree changes block the fast-forward" "$dirty_tracked"
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
