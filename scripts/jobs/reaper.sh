#!/bin/bash
# reaper.sh — requeue stale claims (the `doin` watchdog pivoker lacks).
#
# Usage: reaper.sh
#
# Scans jobs/doin/ for claims older than GARDEN_CLAIM_TTL seconds and moves
# them back to jobs/todo/ (stripping the claim stamp), removes the matching
# work/<base> record, and best-effort removes any orphaned worktree named by
# that basename. A gardener that died mid-job thus releases its job back to
# the pool. Each requeue is its own CAS push (back off on contention).
#
# This is vigil's "idle-but-pending → trigger" decision retargeted from
# systemd unit state to claim-file age.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="reaper"

: "${GARDEN_CLAIM_TTL:=3600}"   # seconds a claim may sit in doin before reaping

DIR="${GARDEN_REAPER_CLONE:-$GARDEN_STATE/reaper/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

now="$(date -u +%s)"
reaped=0
for base in $(list_jobs "$DIR" "$JOBS_DOIN"); do
  f="$DIR/$JOBS_DOIN/$base"
  claimed_at="$(sed -n 's/^  claimed_at: //p' "$f" | head -1)"
  ts=0; [ -n "$claimed_at" ] && ts="$(date -u -d "$claimed_at" +%s 2>/dev/null || echo 0)"
  age=$(( now - ts ))
  if [ "$ts" -eq 0 ] || [ "$age" -lt "$GARDEN_CLAIM_TTL" ]; then
    continue
  fi
  log "reaping '$base' (age ${age}s ≥ TTL ${GARDEN_CLAIM_TTL}s)"

  # best-effort orphaned-worktree cleanup from the work/ record
  wt="$(sed -n 's/^worktree_dir: //p' "$DIR/work/$base" 2>/dev/null | head -1)"
  if [ -n "$wt" ] && [ -d "$wt" ]; then
    git -C "$wt" rev-parse --is-inside-work-tree >/dev/null 2>&1 \
      && git --git-dir="$(git -C "$wt" rev-parse --git-common-dir 2>/dev/null)" worktree remove --force "$wt" 2>/dev/null \
      || rm -rf "$wt" 2>/dev/null || true
    log "removed orphaned worktree $wt"
  fi

  sync_clone "$DIR"
  [ -e "$f" ] || { log "'$base' already moved by someone else; skip"; continue; }
  # strip the appended claim stamp (everything from the trailing '---' marker)
  mkdir -p "$DIR/$JOBS_TODO"
  sed '/^---$/,$d' "$f" > "$DIR/$JOBS_TODO/$base"
  git -C "$DIR" rm -q "$JOBS_DOIN/$base"
  [ -e "$DIR/work/$base" ] && git -C "$DIR" rm -q "work/$base"
  git -C "$DIR" add "$JOBS_TODO/$base"
  if commit_and_push "$DIR" "requeue($base) reaped stale claim by $GARDEN_HOST"; then
    reaped=$((reaped+1))
  else
    log "requeue of '$base' lost a race; will retry next reaper tick"
  fi
done
log "reaped $reaped stale claim(s)"
