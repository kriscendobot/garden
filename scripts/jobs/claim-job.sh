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
# shellcheck source=auction.sh
source "$HERE/auction.sh"     # the bid auction (sources reputation.sh); source-once guarded

id="${1:?usage: claim-job.sh <gardener-id>}"
# The claiming worker's kind (gardener | cleric), inherited from the spine
# (gardener.sh exports GARDEN_WORKER_KIND); default gardener for a standalone call.
KIND="${GARDEN_WORKER_KIND:-gardener}"
KIND_PROVIDER="$(worker_kind_field "$KIND" provider 2>/dev/null || echo anthropic)"
# auction_write_bid reads THIS worker's kind + id from the env (so its signature
# stays a plain <dir> <base>); export them alongside the claim.
export AUCTION_KIND="$KIND" AUCTION_ID="$id"
GARDEN_TAG="claim/$id"

fleet_draining && { log "fleet draining; refusing to claim"; exit 3; }

# --- §1.3 pre-auction claim eligibility (the interim backend-fit filter) ------
#
# Now that more than one backend claims from the same board, a worker must never
# claim a job it cannot honor: a job pinned to a Claude model is gardener-only (
# provider anthropic), one pinned to a paid codex model is cleric-only (openai), one
# pinned to a served LOCAL tag (the qwen family) is hermit-only (local), and an
# UNPINNED job (no `model:`, or a value no provider's patterns match) is claimable by
# any kind. Mystic is activation-only, so its pool accepts only the exact explicit
# `model: kimi-k3` pin. Do not resolve a short alias here: a K3 job is deliberately
# never a default-routing decision.
# This is a small deterministic predicate — no LLM, no auction — and it is
# the seam the bid auction (build child 2) later replaces: under the auction, backend
# fit is PRICED into the bid instead of hard-filtered.
#
# The provider classification is DATA-DRIVEN: resolve_model_tier reads the
# journal-backed model-routing table (common.sh _model_classify, seeded by
# scripts/jobs/model-routing-defaults.tsv, doc skills/model-selection/SKILL.md), so the
# recognized-model set changes as a journal edit, not a code edit. Each provider
# owns a disjoint id space (claude-* → anthropic, qwen* → local, gpt-*/o[0-9]*/codex-*
# minus gpt-oss* → openai), so a job pins at most one provider. Local is checked
# BEFORE openai for belt-and-suspenders ordering. NOTE: a gpt-oss:* tag now matches
# NO provider → it is UNPINNED (claimable by any kind), no longer auto-local — the
# box serves qwen, not gpt-oss.
job_eligible_for_kind() {
  local jf="$1" pinned="" m role fb
  m="$(plan_field "$jf" model)"
  if [ "$KIND_PROVIDER" = moonshot ]; then
    [ "$m" = "kimi-k3" ] || return 1
    role="$(plan_role "$jf")"
    case "$role" in
      # designer stays barred: a bad design has no automatic gate (only human
      # review, hours-to-days later, high blast radius). Graduated relaxation —
      # builder first — per designs/kimi-k3-takes-opus-work-with-opus-fallback.md.
      designer) return 1 ;;
      # builder is relaxed ONLY when the instance is ARMED (config/kimi-takes-opus-
      # work=on) AND the job carries a non-empty `fallback-model:` chain — the
      # automatic opus retry is what makes routing high-stakes work to kimi
      # acceptable, so the safety net is mechanically REQUIRED before the bar lifts.
      # Absent either, the historical bar stands (the ship-disabled default).
      builder)
        fb="$(plan_field "$jf" fallback-model)"
        { kimi_fallback_enabled && [ -n "$fb" ]; } || return 1 ;;
    esac
  fi
  # Fireworks is an explicit-model-only lane.  Its `fireworks/<wire-id>` routing
  # namespace preserves the live Serverless/Fast/deployment id without making an
  # unpinned board job eligible for a newly-enabled paid provider.
  if [ "$KIND_PROVIDER" = fireworks ]; then
    [[ "$m" == fireworks/* ]] && [ -n "${m#fireworks/}" ] || return 1
  fi
  [ -n "$m" ] || return 0                        # no model: unpinned -> eligible
  if [ -n "$(resolve_model_tier anthropic "$m")" ]; then pinned=anthropic
  elif [ -n "$(resolve_model_tier local "$m")" ]; then pinned=local
  elif [ -n "$(resolve_model_tier openai "$m")" ]; then pinned=openai
  elif [ -n "$(resolve_model_tier moonshot "$m")" ]; then pinned=moonshot
  elif [ -n "$(resolve_model_tier fireworks "$m")" ]; then pinned=fireworks
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

  # --- bid auction (design §3) -------------------------------------------------
  # A `market: bid` job runs through the auction; everything else is the untouched
  # race below. The auction NEVER bypasses the push CAS: it only decides WHETHER
  # this worker should attempt the todo→doin push right now. While the bid window
  # is open the worker writes its own bid (a separate per-bidder push) and moves on
  # WITHOUT claiming; after the window closes it claims only if the deterministic
  # award rule + staged eligibility (auction_eligible_now) says it may. Whoever's
  # claim push is accepted still owns the job exactly once — a mis-timed push is at
  # worst a mis-award, never a double-award or a lost job.
  awarded_bidder=""; awarded_provider=""; awarded_model=""; awarded_tht=""
  jf="$DIR/$JOBS_TODO/$base.md"
  if [ "$(auction_market_mode "$jf")" = bid ]; then
    bidder="$(auction_bidder_id "$KIND" "$id")"
    if auction_window_open "$DIR" "$base" "$jf"; then
      # Bidding phase: ensure our bid is committed (idempotent), then move on — the
      # claim happens on a later tick once the window closes. auction_write_bid does
      # its own commit_and_push (releasing the clone lock); the next candidate's
      # sync_clone re-takes it.
      if auction_write_bid "$DIR" "$base"; then
        log "bid on '$base' as $bidder (window open); not claiming yet"
      else
        log "bid push on '$base' lost a race; will retry next tick"
      fi
      continue
    fi
    if ! auction_eligible_now "$DIR" "$base" "$jf" "$bidder"; then
      log "'$base' auction closed but $bidder not yet eligible to claim (staged widening); skipping"
      continue
    fi
    awarded_bidder="$bidder"
    { read -r awarded_provider; read -r awarded_model; read -r awarded_tht; } < <(rep_resolve_arm "$KIND" "$jf")
    log "'$base' auction: $bidder is eligible; claiming (committed arm $awarded_provider/$awarded_model/$awarded_tht)"
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
    # Auction provenance (empty for a race claim). awarded_bid is the winning
    # bidder; the committed arm is stamped so the reputation event (§4.5) keys the
    # outcome to exactly the (kind, provider, model, thoughtfulness) that ran.
    if [ -n "$awarded_bidder" ]; then
      printf '  awarded_bid: %s\n'      "$awarded_bidder"
      printf '  awarded_provider: %s\n' "$awarded_provider"
      printf '  awarded_model: %s\n'    "$awarded_model"
      printf '  awarded_thoughtfulness: %s\n' "$awarded_tht"
    fi
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
