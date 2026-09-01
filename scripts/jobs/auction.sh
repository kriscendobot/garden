#!/bin/bash
# auction.sh — the decentralized bid auction PROTOCOL over the journal push-CAS.
#
# The PROTOCOL half of the bid auction (design cleric-worker-bid-auction-reputation.md
# §3); reputation.sh is the DATA + MATH half and is sourced here. Both are sourced
# AFTER common.sh. Source-once guarded.
#
# The auction inserts a bounded bid-collection WINDOW between a job's post and its
# claim, then resolves by a rule EVERY worker computes identically from the same
# committed journal data (§3.2) — "who awards" is everyone and no one: the award is
# a pure function of the journal, and the accepted claim push (todo→doin) stays the
# SINGLE serialization point, exactly as in the race. Every safety property of the
# race is preserved:
#   * No double-award — STRUCTURAL: the todo→doin push CAS admits exactly one
#     winner; the ranking only decides WHO SHOULD push, never who CAN. A protocol
#     violation (a rogue early push) is at worst a mis-award, never a double-award
#     or a lost job.
#   * Degrades to the race — zero or one bid, or a fully-distracted fleet, lands on
#     today's behavior plus a bounded delay (the staged eligibility below).
#   * The reaper is untouched — an awarded-then-orphaned claim is an ordinary stale
#     doin/ entry, requeued on the same TTL.
#
# A job opts in with `market: bid`; anything else (including every `priority:
# urgent` job) is claimed by the untouched race. During the temporary endolin
# Claude-quota route, bid jobs also use that same CAS race after all ordinary
# qualification gates have passed. See auction_market_mode.

[ -n "${GARDEN_AUCTION_SH_SOURCED:-}" ] && return 0
GARDEN_AUCTION_SH_SOURCED=1

# reputation.sh lives beside this file; source it (it is source-once guarded too).
# shellcheck source=reputation.sh
source "$(dirname "${BASH_SOURCE[0]}")/reputation.sh"

# --- config (env-overridable; journal config/auction.md layers on top later) --
: "${GARDEN_AUCTION_BID_WINDOW:=120}"    # seconds a bid window stays open (§3.2, D2)
: "${GARDEN_AUCTION_GRACE:=30}"          # seconds per staged-eligibility widening (§3.2 liveness)

# jobs/bids/<base>/ holds one file per bidder — per-bidder filenames mean bids never
# contend with each other (only with unrelated journal pushes, the ordinary retry).
JOBS_BIDS="jobs/bids"
auction_bid_dir() { printf '%s/%s\n' "$JOBS_BIDS" "${1:?auction_bid_dir: base}"; }

# --- window ------------------------------------------------------------------

# auction_market_mode <jobfile> — `bid` iff the job opted into the auction with a
# `market: bid` header AND this host is not temporarily routed around Claude
# quota; `race` otherwise (the default, and every urgent job). This sits after
# claim-job's provider/capability predicates, so it changes only selection, never
# which workers are qualified to run the job.
auction_market_mode() {
  local m; m="$(plan_field "${1:?auction_market_mode: jobfile}" market)"
  case "$m" in
    bid)
      [ "$(quota_routing_mode)" = race ] && printf 'race\n' || printf 'bid\n'
      ;;
    *) printf 'race\n' ;;
  esac
}

# auction_now — wall clock in epoch seconds (overridable for deterministic tests).
auction_now() { printf '%s\n' "${GARDEN_AUCTION_NOW:-$(date +%s 2>/dev/null || echo 0)}"; }

# auction_bid_window <jobfile> — the per-job window in seconds: a `bid_window:`
# header, else the configured default. Non-numeric falls back to the default.
auction_bid_window() {
  local w; w="$(plan_field "${1:?}" bid_window | tr -dc '0-9')"
  [ -n "$w" ] || w="$GARDEN_AUCTION_BID_WINDOW"
  printf '%s\n' "$w"
}

# auction_posted_at_epoch <dir> <base> <jobfile> — the shared window-start instant,
# in epoch seconds, that EVERY worker computes identically. Precedence:
#   1. a `posted_at:` header (an iso8601 the producer stamped) — the shared constant
#      §3.2 relies on;
#   2. else the commit time the job file was ADDED on the branch (a journal fact,
#      identical across clones) — so an auction still has a shared deadline even for
#      a job posted without the header;
#   3. else now (last resort: this observer's window starts now — a safe degradation
#      that only delays, never double-awards).
auction_posted_at_epoch() {
  local dir="${1:?}" base="${2:?}" jf="${3:?}" iso e sub
  iso="$(plan_field "$jf" posted_at)"
  if [ -n "$iso" ]; then
    e="$(date -d "$iso" +%s 2>/dev/null || true)"
    [ -n "$e" ] && { printf '%s\n' "$e"; return 0; }
  fi
  for sub in "$JOBS_TODO" "$JOBS_DOIN"; do
    e="$(git -C "$dir" log -1 --diff-filter=A --format=%ct -- "$sub/$base.md" 2>/dev/null || true)"
    [ -n "$e" ] && { printf '%s\n' "$e"; return 0; }
  done
  auction_now
}

# --- bidding -----------------------------------------------------------------

# auction_bidder_id <kind> <id> — this worker instance's stable bidder identity,
# <kind>-<host>-<id>, sanitized to one path segment.
auction_bidder_id() { rep_sanitize "${1:?}-${GARDEN}-${2:?}"; }

# auction_bid_dollars <dir> <base> <bidder> <provider> <model> <thoughtfulness> <work_class> <target>
# The seeded Thompson draw for this arm at this job — the same draw the award rule
# recomputes (§3.2). Seed = "<base>|<bidder>|<provider>/<model>/<thoughtfulness>",
# so it is reproducible from the journal alone.
auction_bid_dollars() {
  local dir="$1" base="$2" bidder="$3" provider="$4" model="$5" tht="$6" wc="$7" tgt="$8"
  local rel proj att acc mean m2 cen est seed
  rel="$(rep_arm_relpath "${bidder%%-*}" "$provider" "$model" "$tht" "$wc" "$tgt")"
  proj="$(rep_read_projection "$dir" "$rel")"
  read -r att acc mean m2 cen est <<<"$proj"
  seed="$base|$bidder|$provider/$model/$tht"
  # The censored count is NOT discarded: it is what separates this arm's COST
  # evidence from its ACCEPTANCE evidence, so an arm whose dollars were never
  # measured — and whose wallclock the rate card cannot price either — draws from
  # the prior instead of from a zeroed mean (rep_thompson_draw). `estimated` is the
  # censored subset the WALLCLOCK PROXY did price: those samples are back in the cost
  # pool, and are passed on separately so the draw can widen for proxy evidence.
  rep_thompson_draw "$att" "$mean" "$m2" "$acc" "$seed" \
    "$(rep_cost_samples "$att" "$cen" "$est")" "$est"
}

# auction_write_bid <dir> <base> — ensure THIS worker (GARDEN_WORKER_KIND / the id
# in $GARDEN_GARDENER_CLONE's caller) has a committed bid for <base>. Idempotent: a
# no-op when this bidder's file already exists on the board. Writes its own
# per-bidder file and pushes; a lost push race is the caller's ordinary retry.
# Requires: KIND and ID passed via env AUCTION_KIND / AUCTION_ID (claim-job sets them).
# Returns 0 whether it wrote or found an existing bid; non-zero only on a push failure.
auction_write_bid() {
  local dir="${1:?}" base="${2:?}" kind="${AUCTION_KIND:?}" id="${AUCTION_ID:?}"
  local bidder bdir jf provider model tht wc tgt bid_dollars
  bidder="$(auction_bidder_id "$kind" "$id")"
  bdir="$(auction_bid_dir "$base")"
  # Already bid? (committed file present after the caller's fresh sync.)
  [ -f "$dir/$bdir/$bidder.md" ] && return 0
  jf="$dir/$JOBS_TODO/$base.md"
  [ -f "$jf" ] || return 0     # job moved out of todo under us; nothing to bid on
  { read -r provider; read -r model; read -r tht; } < <(rep_resolve_arm "$kind" "$jf")
  wc="$(rep_work_class "$jf")"; tgt="$(rep_target "$jf")"
  bid_dollars="$(auction_bid_dollars "$dir" "$base" "$bidder" "$provider" "$model" "$tht" "$wc" "$tgt")"
  local rel proj att acc mean m2 cen est
  rel="$(rep_arm_relpath "$kind" "$provider" "$model" "$tht" "$wc" "$tgt")"
  proj="$(rep_read_projection "$dir" "$rel")"; read -r att acc mean m2 cen est <<<"$proj"
  mkdir -p "$dir/$bdir"
  {
    printf -- '---\n'
    printf 'bidder: %s\n' "$bidder"
    printf 'kind: %s\n' "$kind"
    printf 'provider: %s\n' "$provider"
    printf 'model: %s\n' "$model"
    printf 'thoughtfulness: %s\n' "$tht"
    printf 'work_class: %s\n' "$wc"
    printf 'target: %s\n' "$tgt"
    printf 'attempts: %s\n' "$att"
    printf 'accepts: %s\n' "$acc"
    printf 'mean_dollars: %s\n' "$mean"
    printf 'm2: %s\n' "$m2"
    printf 'censored: %s\n' "$cen"
    printf 'estimated: %s\n' "$est"
    printf 'bid_dollars: %s\n' "$bid_dollars"
    printf 'bid_at: %s\n' "$(date -u +%FT%TZ)"
    printf -- '---\n'
    printf 'deterministic Thompson bid by %s for %s (work_class %s, target %s)\n' "$bidder" "$base" "$wc" "$tgt"
  } > "$dir/$bdir/$bidder.md"
  git -C "$dir" add "$bdir/$bidder.md"
  commit_and_push "$dir" "bid($base) $bidder \$$bid_dollars"
}

# --- award (the pure function every worker computes) -------------------------

# auction_list_bidders <dir> <base> — the bidder ids with a committed bid, one/line.
auction_list_bidders() {
  local dir="${1:?}" base="${2:?}" bdir; bdir="$(auction_bid_dir "$base")"
  find "$dir/$bdir" -mindepth 1 -maxdepth 1 -type f -name '*.md' -printf '%f\n' 2>/dev/null \
    | sed -n 's/\.md$//p' || true
}

# auction_award_order <dir> <base> — the bidders ranked BEST-first by the award rule
# (§3.2): a deterministic Thompson draw per bid from the arm's CURRENT committed
# projection (verified, not trusted — the bid's self-reported posterior is ignored
# for ranking), ascending by drawn aggregate dollars, ties broken by hash(base‖
# bidder) (which also spreads load uniformly across identical-arm instances). Every
# host computes the identical order from the same journal state. Prints one bidder
# per line, rank 1 first.
auction_award_order() {
  local dir="${1:?}" base="${2:?}" bidder bf provider model tht wc tgt draw tie
  local bdir; bdir="$(auction_bid_dir "$base")"
  {
    while IFS= read -r bidder; do
      [ -n "$bidder" ] || continue
      bf="$dir/$bdir/$bidder.md"
      provider="$(plan_field "$bf" provider)"; model="$(plan_field "$bf" model)"
      tht="$(plan_field "$bf" thoughtfulness)"; wc="$(plan_field "$bf" work_class)"
      tgt="$(plan_field "$bf" target)"
      draw="$(auction_bid_dollars "$dir" "$base" "$bidder" "$provider" "$model" "$tht" "$wc" "$tgt")"
      tie="$(rep_seed_int "$base|$bidder")"
      printf '%s\t%s\t%s\n' "$draw" "$tie" "$bidder"
    done < <(auction_list_bidders "$dir" "$base")
  } | sort -t"$(printf '\t')" -k1,1g -k2,2n | cut -f3
}

# auction_rank_of <dir> <base> <bidder> — this bidder's 1-based rank in the award
# order, or empty if it did not bid.
auction_rank_of() {
  local dir="$1" base="$2" bidder="$3" n=0 b
  while IFS= read -r b; do
    n=$((n+1)); [ "$b" = "$bidder" ] && { printf '%s\n' "$n"; return 0; }
  done < <(auction_award_order "$dir" "$base")
  return 1
}

# auction_window_open <dir> <base> <jobfile> — 0 (true) while now < close, so the
# caller BIDS rather than claims. close = posted_at + bid_window.
auction_window_open() {
  local dir="$1" base="$2" jf="$3" start win now
  start="$(auction_posted_at_epoch "$dir" "$base" "$jf")"
  win="$(auction_bid_window "$jf")"
  now="$(auction_now)"
  [ "$now" -lt $(( start + win )) ]
}

# auction_eligible_now <dir> <base> <jobfile> <bidder> — 0 (true) iff THIS bidder
# may claim <base> right now under the staged-eligibility rule (§3.2 liveness):
#   * window still open                      -> NOT eligible (bid, don't claim)
#   * zero bids after close                  -> eligible (race degeneration)
#   * elapsed past close in [0,grace)        -> rank 1 only
#   * [grace,2·grace)                        -> ranks 1–2
#   * [2·grace,3·grace)                      -> ranks 1–3
#   * >= 3·grace                             -> ANYONE (fully degraded to the race)
# A worker that never bid is eligible only at the anyone stage. Every stage is
# computed from the same shared timestamps, so no coordination is needed and a dead
# rank-1 winner cannot strand the job.
auction_eligible_now() {
  local dir="$1" base="$2" jf="$3" bidder="$4"
  local start win now elapsed grace stage rank nbids
  start="$(auction_posted_at_epoch "$dir" "$base" "$jf")"
  win="$(auction_bid_window "$jf")"
  now="$(auction_now)"
  elapsed=$(( now - start - win ))
  [ "$elapsed" -lt 0 ] && return 1            # window still open: bid, do not claim
  grace="$GARDEN_AUCTION_GRACE"; [ "$grace" -ge 1 ] 2>/dev/null || grace=30
  nbids="$(auction_list_bidders "$dir" "$base" | grep -c . || true)"
  [ "${nbids:-0}" -eq 0 ] && return 0         # zero bids -> race (anyone)
  # stage = how many ranks are currently eligible (1 at close, +1 each grace step)
  stage=$(( elapsed / grace + 1 ))
  [ "$stage" -ge 4 ] && return 0              # >= 3*grace: anyone stage
  rank="$(auction_rank_of "$dir" "$base" "$bidder" || true)"
  [ -n "$rank" ] || return 1                  # did not bid, not yet the anyone stage
  [ "$rank" -le "$stage" ]
}
