#!/bin/bash
# complete-job.sh — consumer primitive: finish a job, doin → tada (report).
#
# Usage: complete-job.sh <gardener-id> <basename> <report-file>
#   Removes jobs/doin/<basename> and writes jobs/tada/<basename> from
#   <report-file>, under the SAME reserved basename.
#
# Unlike a claim, completion touches only THIS gardener's own basename, so it
# is safe to retry on push contention: re-sync, re-apply the deterministic
# rm+add, push again.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=auction.sh
source "$HERE/auction.sh"     # reputation.sh helpers + JOBS_BIDS (source-once guarded)

id="${1:?usage: complete-job.sh <gardener-id> <basename> <report-file>}"
base="${2:?missing basename}"
report="${3:?missing report-file}"
# The completing worker's kind, inherited from the spine (gardener.sh exports it).
KIND="${GARDEN_WORKER_KIND:-gardener}"
GARDEN_TAG="done/$id"
[ -f "$report" ] || die "report file not found: $report"
case "$base" in -*|*/*|.*|'') die "illegal basename: '$base'";; esac

DIR="${GARDEN_GARDENER_CLONE:-$GARDEN_STATE/gardeners/$id/journal}"
ensure_clone "$DIR"

# record_reputation_event — write reputation/{events,pending}/<base>.md for this
# completed base and git-add it so it rides the completion push (design §4.5). It
# reads the still-present doin job file to resolve the ran arm and classify the
# work; every read is fail-open (a missing field defaults). Reputation is worth
# nothing if it can strand a finished job, so this is called under `|| true`.
#
# ACCEPTANCE at record time: a garden-internal job (target main2, no PR) is
# ACCEPTED on its un-doomed tada — it completed, so we record `accepted: true`
# into events/. A job against a PR target has an outcome we do not yet know, so we
# record `accepted: pending` into pending/ for the reducer to finalize from the
# merge/un-draft/verdict signal. A committed verdict override (reputation/verdicts/
# <base>) always wins. Human-review dollars are 0 at record time; the reducer fills
# them from the review data when it finalizes a PR-target event.
record_reputation_event() {
  local jf="$DIR/$JOBS_DOIN/$base.md" provider model tht wc tgt agentic
  local attempts duration awarded nbidders accepted human aggregate dest
  local cost_source estimated
  [ -f "$jf" ] || jf="$DIR/$JOBS_TADA/$base.md"   # fall back to the just-copied report/tada
  { read -r provider; read -r model; read -r tht; } < <(rep_resolve_arm "$KIND" "$jf")
  wc="$(rep_work_class "$jf")"; tgt="$(rep_target "$jf")"
  agentic="$(rep_agentic_dollars "$DIR" "$base")"
  # attempts = requeue cycles + 1 (a reaped/resumed job's sunk cost is real cost).
  attempts="$(sed -n 's/.*garden-reaped:[[:space:]]*\([0-9]\+\).*/\1/p' "$jf" 2>/dev/null | tail -1)"
  attempts=$(( ${attempts:-0} + 1 ))
  duration="${GARDEN_JOB_DURATION_SECS:-}"
  awarded="$(sed -n 's/^[[:space:]]*awarded_bid:[[:space:]]*//p' "$jf" 2>/dev/null | head -1)"
  nbidders="$(auction_list_bidders "$DIR" "$base" | grep -c . || true)"
  # acceptance
  if [ -f "$DIR/$REP_VERDICTS/$base" ]; then
    accepted="$(sed -n 's/^accepted:[[:space:]]*//p' "$DIR/$REP_VERDICTS/$base" 2>/dev/null | head -1)"
    [ -n "$accepted" ] || accepted=true
  elif [ "$tgt" = main2 ]; then
    accepted=true
  else
    accepted=pending
  fi
  human=0
  # The RAW censored state is preserved verbatim: `agentic_dollars` / `aggregate_dollars`
  # say what the LEDGER knew, and nothing else is ever written into them. When the
  # ledger knew nothing, the wallclock proxy (duration_secs x the rate card) supplies a
  # cost ESTIMATE in its own field, flagged by `cost_source:`, so an arm can always
  # report how much of its cost evidence is real. The reducer re-derives this from
  # the completed journal claim-to-tada span and the rate card, so the event's
  # immediate estimate is only provenance and a corrected rate or span re-prices
  # history without rewriting an event.
  # A FLAT-SUBSCRIPTION provider (Anthropic Max — rep_provider_is_flat) reports a
  # per-call `total_cost_usd` that is NOTIONAL list-price, not money. Keep it in
  # `agentic_dollars` as audit evidence (so the raw ledger reading is never lost), but
  # censor the AGGREGATE the reducer folds so cost falls through to the true-costed
  # wallclock proxy — the same treatment a natively-censored event gets. A metered
  # provider (kimi/fireworks/openai paid) keeps its real ledger dollars.
  if [ "$agentic" = censored ] || rep_provider_is_flat "$provider"; then
    aggregate=censored
    estimated="$(rep_estimated_dollars "$DIR" "$provider" "$model" "$tht" "${duration:-0}" "$human" 2>/dev/null || echo censored)"
    case "$estimated" in censored|'') cost_source=none; estimated='' ;; *) cost_source=wallclock ;; esac
  else
    aggregate="$(awk -v a="$agentic" -v h="$human" 'BEGIN{printf "%.6f", a+h}')"
    cost_source=ledger; estimated=''
  fi
  case "$accepted" in
    pending) dest="$REP_PENDING/$base.md" ;;
    *)       dest="$REP_EVENTS/$base.md" ;;
  esac
  mkdir -p "$DIR/$(dirname "$dest")"
  {
    printf -- '---\n'
    printf 'base: %s\n' "$base"
    printf 'kind: %s\n' "$KIND"
    printf 'provider: %s\n' "$provider"
    printf 'model: %s\n' "$model"
    printf 'thoughtfulness: %s\n' "$tht"
    printf 'work_class: %s\n' "$wc"
    printf 'target: %s\n' "$tgt"
    printf 'accepted: %s\n' "$accepted"
    printf 'agentic_dollars: %s\n' "$agentic"
    printf 'human_dollars: %s\n' "$human"
    printf 'aggregate_dollars: %s\n' "$aggregate"
    printf 'cost_source: %s\n' "$cost_source"
    if [ -n "$estimated" ]; then printf 'estimated_dollars: %s\n' "$estimated"; fi
    printf 'attempts: %s\n' "$attempts"
    printf 'duration_secs: %s\n' "$duration"
    printf 'awarded_bid: %s\n' "$awarded"
    printf 'bidders: %s\n' "${nbidders:-0}"
    printf 'source: live\n'
    printf 'recorded_by: %s\n' "$GARDEN/$KIND-$id"
    printf 'recorded_at: %s\n' "$(date -u +%FT%TZ)"
    printf -- '---\n'
    printf 'reputation event for %s: arm %s/%s/%s work_class %s target %s accepted %s\n' \
      "$base" "$provider" "$model" "$tht" "$wc" "$tgt" "$accepted"
  } > "$DIR/$dest"
  git -C "$DIR" add "$dest"
}

# Completion only touches this gardener's own basename, so it is guaranteed to
# fast-forward once it lands a clean window — retry generously with backoff
# rather than giving up and stranding the job in doin.
for attempt in $(seq 1 100); do
  sync_clone "$DIR"
  mkdir -p "$DIR/$JOBS_TADA"
  cp "$report" "$DIR/$JOBS_TADA/$base.md"
  # The final engagement rides this same completion CAS.  Only append while the
  # doin claim exists: a retry after a successful transition must re-stamp the
  # view but never duplicate a CostRecord.
  if [ -e "$DIR/$JOBS_DOIN/$base.md" ] && [ -n "${GARDEN_ENGAGEMENT_USAGE:-}" ]; then
    usage_ledger_stage_row "$DIR" "$base" "${GARDEN_JOB_DURATION_SECS:-0}" tada "$GARDEN_ENGAGEMENT_USAGE" || true
  fi
  # An agent can copy a stale/fake block into its report.  Strip it wholesale and
  # derive the replacement exclusively from the external journal ledger.
  sed -i '/<!-- garden-usage-begin:/,/<!-- garden-usage-end -->/d' "$DIR/$JOBS_TADA/$base.md"
  usage_footer "$DIR" "$base" >> "$DIR/$JOBS_TADA/$base.md" 2>/dev/null || true
  git -C "$DIR" add "$JOBS_TADA/$base.md"

  # --- reputation event (design §4.5) -----------------------------------------
  # Record ONE reputation event for this completed base, keyed to the arm that ran
  # (the same rep_resolve_arm the claim/auction computed). This is the completion
  # signal the reducer consumes: it rides THIS completion push (own basename, single
  # writer), never a separate CAS. Best-effort and fail-open — a failure here must
  # NEVER strand a genuinely-finished job in doin, so the whole block is guarded and
  # its rc is discarded. Written while the doin job file is still present (before the
  # git rm below), because rep_resolve_arm/work_class/target read it.
  record_reputation_event || true

  [ -e "$DIR/$JOBS_DOIN/$base.md" ] && git -C "$DIR" rm -q "$JOBS_DOIN/$base.md"
  [ -e "$DIR/work/$base" ]       && git -C "$DIR" rm -q "work/$base"
  # Sweep this base's transient bid files: the auction is decided, the job is done.
  # The winning/losing bid summary is already folded into the reputation event's
  # audit fields (§3.2 cleanup), so the raw bid files are no longer needed.
  [ -d "$DIR/$(auction_bid_dir "$base")" ] && git -C "$DIR" rm -rq "$(auction_bid_dir "$base")" 2>/dev/null || true
  # destroy this job doer's inbox; its lifetime ends with the job.
  [ -d "$DIR/inbox/$base" ]      && git -C "$DIR" rm -rq "inbox/$base"
  # Capture the return with `|| rc=$?` (NOT `rc=$?` after an `if`): a false `if`
  # with no `else` has exit status 0, which would swallow commit_and_push's rc=2
  # "nothing to commit" (the idempotent re-run) and burn the whole retry loop.
  rc=0; commit_and_push "$DIR" "tada($base) done $GARDEN/gardener-$id" || rc=$?
  if [ "$rc" -eq 0 ]; then
    log "completed '$base'"
    # This doin→tada→push IS the "gardener job completion" edge: kick the foreman
    # to re-evaluate now rather than at its next poll. Non-blocking + best-effort;
    # never fails or delays this completion (foreman_kick swallows all errors).
    foreman_kick
    exit 0
  fi
  [ "$rc" -eq 2 ] && { log "'$base' already completed (nothing to commit)"; exit 0; }
  log "completion of '$base' lost a push race (attempt $attempt); retrying"
  backoff "$attempt"
done
die "could not complete '$base' after retries"
