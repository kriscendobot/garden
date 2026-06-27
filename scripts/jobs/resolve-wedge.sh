#!/bin/bash
# resolve-wedge.sh — losslessly clean a dirty-tree wedge on the shared garden
# checkout so the watchman / deploy-sync fast-forward can proceed.
#
# Usage: resolve-wedge.sh [<branch>]   (default branch: main2)
#
# This is the deterministic core of the autonomous wedge resolution the watchman
# triggers (trigger_wedge_resolution in wedge-resolve.sh posts a job; the gardener
# that claims it runs THIS script on $GARDEN_ROOT). It encodes the exact finisher
# dance a human ran successfully on 2026-06-27, mechanically and testably, so the
# claude gardener does not have to reason about git plumbing — it only has to land
# any GENUINE WIP this script parks in a stash (a judgment call left to it).
#
# It operates DIRECTLY on the shared $GARDEN_ROOT working tree — the ONE case where
# editing the shared tree in place is correct, because the dirt IS in that tree and
# we are CLEANING it, not adding work. It NEVER does a blanket `git reset --hard`,
# `git checkout .`, or `git clean -fd`; it classifies and resolves each blocking
# path individually and LOSSLESSLY:
#
#   * TRACKED file dirty but byte-identical to origin/<branch> (a redundant local
#     copy of work that already landed) → `git checkout HEAD -- <file>` (the ff
#     then re-lands origin's identical version; nothing is lost).
#   * UNTRACKED file colliding with an incoming tracked path and byte-identical to
#     origin/<branch>:<path> → `rm` it (redundant copy of landed work).
#   * GENUINE WIP — a tracked file that differs from BOTH HEAD and origin, or an
#     untracked file colliding with an incoming path whose content differs — is
#     PRESERVED, never discarded: tracked WIP is `git stash push`ed (recoverable);
#     a divergent untracked collision is moved aside into $GARDEN_SCRATCH. Both are
#     reported for a follow-up land.
#
# Exit 0 once the tree is clean enough for a fast-forward (no tracked dirt, no
# untracked collision left). Exit non-zero (leaving the wedge for a retry) if an
# unexpected state remains — never a destructive fallback.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="resolve-wedge"
BRANCH="${1:-${GARDEN_MAIN_BRANCH:-main2}}"
ROOT="$GARDEN_ROOT"
REMOTE_REF="origin/$BRANCH"

git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1 || die "$ROOT is not a git tree"
git -C "$ROOT" fetch -q origin "$BRANCH" 2>/dev/null \
  || log "WARN: fetch of $REMOTE_REF failed (offline?); resolving against the cached ref"
git -C "$ROOT" rev-parse --verify --quiet "$REMOTE_REF" >/dev/null \
  || die "cannot resolve $REMOTE_REF in $ROOT"

# Did the working tree (committed-or-not) content of <file> end up identical to the
# incoming origin/<branch> version? (diff against the remote ref, working tree side)
matches_origin() { git -C "$ROOT" diff --quiet "$REMOTE_REF" -- "$1" 2>/dev/null; }
# Is <path> a tracked file in origin/<branch> (i.e. an incoming path it collides with)?
in_origin() { git -C "$ROOT" cat-file -e "$REMOTE_REF:$1" 2>/dev/null; }

dropped=0; removed=0; stashed=0; preserved=0; left=0
declare -a STASH_NOTES=() PRESERVE_NOTES=()

# Walk the porcelain status. Field 1 is the two-char XY code, the rest is the path
# (we read the remainder of the line so paths with spaces survive; renames `->` are
# treated as a dirty tracked path and handled by the tracked branch).
while IFS= read -r line; do
  [ -n "$line" ] || continue
  code="${line:0:2}"
  path="${line:3}"
  path="${path%\"}"; path="${path#\"}"   # de-quote if git quoted an odd path
  case "$code" in
    '??')
      # Untracked. Only a COLLISION with an incoming tracked path blocks the ff.
      if in_origin "$path"; then
        if git -C "$ROOT" show "$REMOTE_REF:$path" 2>/dev/null | diff -q - "$ROOT/$path" >/dev/null 2>&1; then
          rm -f "$ROOT/$path" && { removed=$((removed+1)); log "removed redundant untracked copy of landed $path"; }
        else
          # Divergent untracked collision — genuine WIP. Move aside losslessly.
          dest="$(scratch_dir wedge-preserved)/$(basename "$path")"
          mkdir -p "$(dirname "$dest")"
          mv "$ROOT/$path" "$dest" && {
            preserved=$((preserved+1)); PRESERVE_NOTES+=("$path -> $dest")
            log "preserved divergent untracked $path at $dest (collides with an incoming path)"
          }
        fi
      else
        left=$((left+1))   # non-colliding untracked file: not a blocker, leave it
      fi
      ;;
    *)
      # Any tracked change (modified/added/staged/renamed) blocks a --ff-only.
      if matches_origin "$path"; then
        git -C "$ROOT" checkout HEAD -- "$path" \
          && { dropped=$((dropped+1)); log "dropped redundant tracked edit to $path (identical to $REMOTE_REF)"; }
      else
        # Genuine divergent WIP — park it in a stash, recoverable, never discarded.
        if git -C "$ROOT" stash push -q -- "$path" 2>/dev/null; then
          stashed=$((stashed+1)); STASH_NOTES+=("$path")
          log "stashed genuine WIP $path (differs from both HEAD and $REMOTE_REF)"
        else
          log "WARN: could not stash $path; leaving the wedge for a retry"
        fi
      fi
      ;;
  esac
done < <(git -C "$ROOT" status --porcelain=v1 --untracked-files=normal 2>/dev/null)

log "resolution: dropped=$dropped removed=$removed stashed=$stashed preserved=$preserved untouched-untracked=$left"

if [ "$stashed" -gt 0 ]; then
  printf 'WIP stashed (land via `git -C %s stash list`): %s\n' "$ROOT" "${STASH_NOTES[*]}" >&2
fi
if [ "$preserved" -gt 0 ]; then
  printf 'WIP preserved off-tree (land manually): %s\n' "${PRESERVE_NOTES[*]}" >&2
fi

# Verify: is the tree now clean enough to fast-forward?
remaining_tracked="$(git -C "$ROOT" status --porcelain --untracked-files=no 2>/dev/null)"
if [ -n "$remaining_tracked" ]; then
  log "WARN: tracked dirt remains after resolution; NOT clean, leaving for a retry:"
  log "$(printf '%s' "$remaining_tracked" | tr '\n' ';')"
  exit 1
fi
# A still-refused ff (an untracked collision we could not classify) is also a retry.
if ! git -C "$ROOT" merge-base --is-ancestor "$(git -C "$ROOT" rev-parse HEAD)" "$REMOTE_REF" 2>/dev/null; then
  log "tree clean but local HEAD is not an ancestor of $REMOTE_REF (diverged); not fast-forwardable here"
  exit 0   # divergence is a separate concern; the tree itself is clean
fi
log "tree is clean; the watchman / deploy-sync fast-forward can now proceed"
exit 0
