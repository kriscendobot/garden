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
: "${GARDEN_FETCH_REAP_AGE:=120}"  # seconds a `git fetch` may run before it is killed

# --- stuck-fetch janitor -----------------------------------------------------
#
# A journal fetch should finish in well under a minute; git has no default IO
# timeout, so a half-open connection left by a transient network blip can hang a
# `git fetch` FOREVER, and (since clones serialize behind an flock) a stuck fetch
# holds its clone lock and wedges every producer behind it — that is how one
# stale connection wedged the whole fleet for ~15 minutes (2026-06-25). The
# timeout wrapper in common.sh bounds NEW fetches; this janitor is the backstop
# that reaps any `git fetch` already running past GARDEN_FETCH_REAP_AGE seconds
# (one that started before this shipped, or somehow escaped its `timeout`), and
# surfaces a one-line anomaly so a stuck fetch self-heals in minutes.
#
# `ps -o etimes` is elapsed seconds since start; the `[g]it` bracket trick keeps
# this very grep out of its own match.
reap_stuck_fetches() {
  local killed=0 pid etimes cmd procs
  # SC2009: we need ps's etimes/args columns (pgrep gives neither), so grep ps.
  # shellcheck disable=SC2009
  procs="$(ps -eo pid=,etimes=,args= 2>/dev/null | grep -E '[g]it.* fetch' || true)"
  while read -r pid etimes cmd; do
    [ -n "$pid" ] || continue
    case "$cmd" in *git*fetch*) ;; *) continue ;; esac
    if [ "$etimes" -ge "$GARDEN_FETCH_REAP_AGE" ]; then
      log "ANOMALY: killing stuck git fetch pid=$pid age=${etimes}s (>${GARDEN_FETCH_REAP_AGE}s): $cmd"
      kill -TERM "$pid" 2>/dev/null || true
      killed=$((killed+1))
    fi
  done <<< "$procs"
  [ "$killed" -gt 0 ] && log "stuck-fetch janitor killed $killed stuck fetch(es)"
  return 0
}

# Reap stuck fetches FIRST: if the reaper's own sync_clone below would contend
# for a clone lock held by a hung fetch, clearing the hang first lets this very
# tick proceed instead of blocking behind it.
reap_stuck_fetches

DIR="${GARDEN_REAPER_CLONE:-$GARDEN_STATE/reaper/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

now="$(date -u +%s)"
reaped=0
for base in $(list_jobs "$DIR" "$JOBS_DOIN"); do
  # board files carry .md; the work/ spine key is extensionless.
  spine="${base%.md}"
  f="$DIR/$JOBS_DOIN/$base"
  claimed_at="$(sed -n 's/^  claimed_at: //p' "$f" | head -1)"
  ts=0; [ -n "$claimed_at" ] && ts="$(date -u -d "$claimed_at" +%s 2>/dev/null || echo 0)"
  age=$(( now - ts ))
  if [ "$ts" -eq 0 ] || [ "$age" -lt "$GARDEN_CLAIM_TTL" ]; then
    continue
  fi
  log "reaping '$base' (age ${age}s ≥ TTL ${GARDEN_CLAIM_TTL}s)"

  # best-effort orphaned-worktree cleanup from the work/ record
  wt="$(sed -n 's/^worktree_dir: //p' "$DIR/work/$spine" 2>/dev/null | head -1)"
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
  [ -e "$DIR/work/$spine" ] && git -C "$DIR" rm -q "work/$spine"
  git -C "$DIR" add "$JOBS_TODO/$base"
  if commit_and_push "$DIR" "requeue($base) reaped stale claim by $GARDEN_HOST"; then
    reaped=$((reaped+1))
  else
    log "requeue of '$base' lost a race; will retry next reaper tick"
  fi
done
log "reaped $reaped stale claim(s)"
