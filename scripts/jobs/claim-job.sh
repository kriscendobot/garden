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
# The claiming worker's kind (gardener | cleric), inherited from the spine
# (gardener.sh exports GARDEN_WORKER_KIND); default gardener for a standalone call.
KIND="${GARDEN_WORKER_KIND:-gardener}"
KIND_PROVIDER="$(worker_kind_field "$KIND" provider 2>/dev/null || echo anthropic)"
GARDEN_TAG="claim/$id"

fleet_draining && { log "fleet draining; refusing to claim"; exit 3; }

# --- §1.3 pre-auction claim eligibility (the interim backend-fit filter) ------
#
# Now that more than one backend claims from the same board, a worker must never
# claim a job it cannot honor: a job pinned to a Claude model is gardener-only, one
# pinned to a codex model is cleric-only, an UNPINNED job (no `model:`, or an
# unknown/typo value) is claimable by either kind. This is a small deterministic
# predicate — no LLM, no auction — and it is the seam the bid auction (build child 2)
# later replaces: under the auction, backend fit is PRICED into the bid instead of
# hard-filtered. A concrete claude-* id resolves only in the anthropic map and a
# gpt-*/codex id only in the openai map, so a job pins at most one provider.
job_eligible_for_kind() {
  local jf="$1" pinned=""
  local m; m="$(plan_field "$jf" model)"
  [ -n "$m" ] || return 0                        # no model: unpinned -> eligible
  if [ -n "$(resolve_model_tier anthropic "$m")" ]; then pinned=anthropic
  elif [ -n "$(resolve_model_tier openai "$m")" ]; then pinned=openai
  else return 0; fi                              # unknown value -> treat as unpinned
  [ "$pinned" = "$KIND_PROVIDER" ]
}

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

  # §1.3 backend-fit filter: skip a job pinned to a provider this kind cannot honor.
  if ! job_eligible_for_kind "$DIR/$JOBS_TODO/$base.md"; then
    log "'$base' is pinned to a model this $KIND ($KIND_PROVIDER) cannot honor; skipping (backend-fit)"
    continue
  fi

  mkdir -p "$DIR/$JOBS_DOIN" "$DIR/work"
  git -C "$DIR" mv "$JOBS_TODO/$base.md" "$JOBS_DOIN/$base.md"
  claimed_at="$(date -u +%FT%TZ)"
  # stamp claim metadata into the job file (appended; the body is preserved). The
  # worker_kind is recorded so tada reports, usage rows, and (build child 2)
  # reputation events know which backend did the work.
  {
    printf '\n---\nclaim:\n'
    printf '  host: %s\n'      "$GARDEN"
    printf '  gardener: %s\n'  "$id"
    printf '  worker_kind: %s\n' "$KIND"
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
    printf 'worker_kind: %s\n'  "$KIND"
    printf 'claimed_at: %s\n'   "$claimed_at"
    printf 'worktree_dir: %s\n' "${GARDEN_SCRATCH:-$GARDEN_ROOT/scratch}/gardener-wt-$base"
  } > "$DIR/work/$base"
  # create this job doer's inbox (unread/read), alive for the job's lifetime.
  mkdir -p "$DIR/inbox/$base/unread" "$DIR/inbox/$base/read"
  touch "$DIR/inbox/$base/unread/.gitkeep" "$DIR/inbox/$base/read/.gitkeep"
  git -C "$DIR" add "$JOBS_DOIN/$base.md" "work/$base" "inbox/$base"

  if commit_and_push "$DIR" "claim($base) $GARDEN/$KIND-$id"; then
    log "claimed '$base'"
    printf '%s\n' "$base"
    exit 0
  fi

  log "lost claim race on '$base'; backing off to next candidate"
  # do NOT retry the same job; loop picks the next candidate after re-sync
done

log "could not claim any of $n candidates (all taken)"
exit 3
