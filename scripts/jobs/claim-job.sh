#!/bin/bash
# claim-job.sh — consumer primitive: atomically claim one job, todo → doin.
#
# Usage: claim-job.sh <gardener-id>
# On success: prints the claimed basename on stdout and exits 0.
# On no-work:  exits 3 (nothing claimable right now).
# On error:    exits non-zero (other).
#
# THE CLAIM IS THE ACCEPTED PUSH. A local `git mv todo→doin` is invisible to
# other workers/hosts until pushed; the push to origin/<branch> is the
# compare-and-swap. First pusher wins; a rejected (non-fast-forward) push
# means someone else moved the branch — we re-sync, and if our candidate is
# gone we BACK OFF and try the next one (no blind rebase-retry on a claim).
#
# Each gardener operates in its OWN journal clone (never a shared worktree),
# so two same-host gardeners cannot stomp each other's working tree.
#
# Candidates are drawn ONLY from JOBS_TODO. The jobs/plan/ category (parked work
# awaiting a go-ahead or deferred by priority) is never a claim candidate — it is
# promoted into todo/ first (promote-plan.sh).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

id="${1:?usage: claim-job.sh <gardener-id>}"
GARDEN_TAG="claim/$id"

fleet_draining && { log "fleet draining; refusing to claim"; exit 3; }

DIR="${GARDEN_GARDENER_CLONE:-$GARDEN_STATE/gardeners/$id/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

# Candidate ordering: start at an id-derived offset so N gardeners don't all
# grab the lexically-first job and collide on every claim.
mapfile -t cand < <(list_jobs "$DIR" "$JOBS_TODO")
n="${#cand[@]}"
[ "$n" -eq 0 ] && { log "no jobs in todo"; exit 3; }

# numeric offset from id (hash non-numeric ids)
if [[ "$id" =~ ^[0-9]+$ ]]; then off="$id"; else off=$(( $(printf '%s' "$id" | cksum | cut -d' ' -f1) )); fi
off=$(( off % n ))

for ((k=0; k<n; k++)); do
  # candidates are leaf filenames (<base>.md); the spine key is extensionless.
  base="${cand[$(( (off + k) % n ))]%.md}"
  # re-sync each attempt: the board may have moved under us
  sync_clone "$DIR"
  [ -e "$DIR/$JOBS_TODO/$base.md" ] || { log "'$base' already taken; next"; continue; }

  mkdir -p "$DIR/$JOBS_DOIN" "$DIR/work"
  git -C "$DIR" mv "$JOBS_TODO/$base.md" "$JOBS_DOIN/$base.md"
  claimed_at="$(date -u +%FT%TZ)"
  # stamp claim metadata into the job file (appended; the body is preserved)
  {
    printf '\n---\nclaim:\n'
    printf '  host: %s\n'      "$GARDEN"
    printf '  gardener: %s\n'  "$id"
    printf '  claimed_at: %s\n' "$claimed_at"
  } >> "$DIR/$JOBS_DOIN/$base.md"
  # worktree-state record under work/ (the spine: same basename). worktree_dir
  # names the REAL per-job garden worktree (handlers/gardener-claude.sh's
  # gardener-wt-<base> under GARDEN_SCRATCH) for a human inspecting the claim;
  # it is INFORMATIONAL ONLY — worktrees persist across a requeue so a resumed
  # claim re-enters its in-flight work, and nothing may delete them from board
  # state (orphans age out via the reaper's scratch janitor).
  {
    printf 'host: %s\n'         "$GARDEN"
    printf 'gardener: %s\n'     "$id"
    printf 'claimed_at: %s\n'   "$claimed_at"
    printf 'worktree_dir: %s\n' "${GARDEN_SCRATCH:-$GARDEN_ROOT/scratch}/gardener-wt-$base"
  } > "$DIR/work/$base"
  # create this job doer's inbox (unread/read), alive for the job's lifetime.
  mkdir -p "$DIR/inbox/$base/unread" "$DIR/inbox/$base/read"
  touch "$DIR/inbox/$base/unread/.gitkeep" "$DIR/inbox/$base/read/.gitkeep"
  git -C "$DIR" add "$JOBS_DOIN/$base.md" "work/$base" "inbox/$base"

  if commit_and_push "$DIR" "claim($base) $GARDEN/gardener-$id"; then
    log "claimed '$base'"
    printf '%s\n' "$base"
    exit 0
  fi

  log "lost claim race on '$base'; backing off to next candidate"
  # do NOT retry the same job; loop picks the next candidate after re-sync
done

log "could not claim any of $n candidates (all taken)"
exit 3
