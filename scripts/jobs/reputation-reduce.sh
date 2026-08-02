#!/bin/bash
# reputation-reduce.sh — the reputation REDUCER: the SOLE writer of the derived arm
# projections (design cleric-worker-bid-auction-reputation.md §4.5).
#
# A LEADER-ONLY singleton timer (garden-reputation-reducer, sibling of the foreman).
# It never contends on the projection tree because it is the only writer of it; the
# bidders only READ arms/. Deterministic, plain code, NO LLM: reviewer text is only
# ever COUNTED (word totals), never fed to a model, so it is injection-safe by
# construction (monitoring safety constraint).
#
# Two jobs per tick, both CAS-safe on the journal push:
#   1. FINALIZE pending events. reputation/pending/<base>.md holds a completed job
#      whose acceptance was unknown at completion (a PR still in gauntlet/review).
#      Finalize it from, in precedence order: a committed verdict override
#      (reputation/verdicts/<base>) > a garden-internal main2 job (accepted on its
#      un-poisoned tada) > leave pending (a PR outcome not yet known — a follow-on
#      gh/merge-signal reader, deferred, will drop a verdict file). On finalize,
#      compute the inferred human-review dollars from any committed review
#      observables (reputation/reviews/<base>: rounds/comment_words) and fold them
#      into the aggregate, then move the event pending/ -> events/.
#   2. RECOMPUTE the arm projections from the full events/ set (Welford per arm), so
#      arms/<kind>/<provider>/<model>/<thoughtfulness>/<wc>@<target>.md always
#      reflects every finalized event — EVERY event, including a cost-censored one,
#      which still moves attempts/accepts, and is priced from the WALLCLOCK PROXY
#      (its journal claim-to-tada wallclock x the rate card, with duration_secs as
#      a compatibility fallback) when the
#      ledger could not price it at all
#      (see recompute_arms). Recompute-from-events (not incremental fold)
#      keeps the projection a pure function of the event log — reproducible and
#      auditable — and idempotent (an unchanged projection is a no-op commit).
#
# Usage: reputation-reduce.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=auction.sh
source "$HERE/auction.sh"     # reputation.sh helpers (source-once guarded)
GARDEN_TAG="rep-reduce"

DIR="${GARDEN_REDUCER_CLONE:-$GARDEN_STATE/reducer/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

# --- 1. finalize pending events ---------------------------------------------
finalize_pending() {
  local pf base tgt accepted verdict rounds words human agentic aggregate
  [ -d "$DIR/$REP_PENDING" ] || return 0
  shopt -s nullglob
  for pf in "$DIR/$REP_PENDING"/*.md; do
    base="$(basename "$pf" .md)"
    tgt="$(plan_field "$pf" target)"; tgt="${tgt:-main2}"
    accepted=""
    if [ -f "$DIR/$REP_VERDICTS/$base" ]; then
      accepted="$(sed -n 's/^accepted:[[:space:]]*//p' "$DIR/$REP_VERDICTS/$base" 2>/dev/null | head -1)"
    fi
    if [ -z "$accepted" ] && [ "$tgt" = main2 ]; then accepted=true; fi
    [ -n "$accepted" ] || continue    # still unknown: leave pending for a later tick

    # inferred human-review dollars from committed observables (0 when none)
    rounds=""; words=""
    if [ -f "$DIR/$REP_ROOT/reviews/$base" ]; then
      rounds="$(sed -n 's/^rounds:[[:space:]]*//p' "$DIR/$REP_ROOT/reviews/$base" 2>/dev/null | head -1 | tr -dc '0-9')"
      words="$(sed -n 's/^comment_words:[[:space:]]*//p' "$DIR/$REP_ROOT/reviews/$base" 2>/dev/null | head -1 | tr -dc '0-9')"
    fi
    human="$(rep_human_dollars "${rounds:-0}" "${words:-0}")"
    agentic="$(plan_field "$pf" agentic_dollars)"; agentic="${agentic:-censored}"
    if [ "$agentic" = censored ]; then aggregate=censored; else
      aggregate="$(awk -v a="$agentic" -v h="$human" 'BEGIN{printf "%.6f", a+h}')"
    fi

    mkdir -p "$DIR/$REP_EVENTS"
    # rewrite the frontmatter with the finalized accepted + human/aggregate dollars,
    # preserving the rest, and move pending -> events.
    awk -v acc="$accepted" -v hum="$human" -v agg="$aggregate" '
      /^accepted:/     { print "accepted: " acc; next }
      /^human_dollars:/{ print "human_dollars: " hum; next }
      /^aggregate_dollars:/{ print "aggregate_dollars: " agg; next }
      { print }
    ' "$pf" > "$DIR/$REP_EVENTS/$base.md"
    git -C "$DIR" add "$REP_EVENTS/$base.md"
    git -C "$DIR" rm -q "$REP_PENDING/$base.md"
    log "finalized pending event '$base' -> accepted=$accepted (human \$$human, aggregate \$$aggregate)"
  done
  shopt -u nullglob
}

# --- 2. recompute arm projections from events/ -------------------------------
recompute_arms() {
  local ef base kind provider model tht wc tgt accepted agg adjusted rel armhash dur hum estd
  local span secs
  local work; work="$(mktemp -d "${TMPDIR:-/tmp}/rep-reduce.XXXXXX")"
  # One log pass derives each completed engagement's proxy wallclock: the final
  # attempt's claim->tada span PLUS min(interval, GARDEN_REP_ATTEMPT_CAP_SECS) for
  # each earlier reaped attempt (rep_wallclock_index). It counts requeue engagement
  # that duration_secs cannot see, while the cap keeps idle queue time between a reap
  # and the next claim out of the bill. Built per tick and never committed, so the
  # projection stays a pure function of journal history and the rate card.
  rep_wallclock_index "$DIR" > "$work/wallclock.idx" 2>/dev/null || : > "$work/wallclock.idx"
  shopt -s nullglob
  # Fold every event into a per-arm data file (accepted + aggregate dollars) plus a
  # per-arm meta file (the arm fields, from the first event seen for that arm).
  for ef in "$DIR/$REP_EVENTS"/*.md; do
    base="$(basename "$ef" .md)"
    kind="$(plan_field "$ef" kind)";       provider="$(plan_field "$ef" provider)"
    model="$(plan_field "$ef" model)";     tht="$(plan_field "$ef" thoughtfulness)"
    wc="$(plan_field "$ef" work_class)";   tgt="$(plan_field "$ef" target)"
    accepted="$(plan_field "$ef" accepted)"
    agg="$(plan_field "$ef" aggregate_dollars)"
    [ -n "$kind" ] && [ -n "$provider" ] && [ -n "$model" ] && [ -n "$tht" ] \
      && [ -n "$wc" ] && [ -n "$tgt" ] || continue
    rel="$(rep_arm_relpath "$kind" "$provider" "$model" "$tht" "$wc" "$tgt")"
    armhash="$(printf '%s' "$rel" | (sha1sum 2>/dev/null || shasum) | cut -c1-32)"
    if [ ! -f "$work/$armhash.meta" ]; then
      printf '%s\n%s\n%s\n%s\n%s\n%s\n%s\n' \
        "$kind" "$provider" "$model" "$tht" "$wc" "$tgt" "$rel" > "$work/$armhash.meta"
    fi
    # A sanctioned adjustment is a real invoice/backfill figure. It wins over
    # the event's raw ledger/proxy value while preserving both source records.
    # COST SOURCE per event: adjustment/ledger, else the WALLCLOCK PROXY
    # (duration_secs x the arm's rate-card dollars-per-second), else nothing.
    # The ledger ALWAYS wins where it exists, so no arm gets a worse estimate as a
    # consequence of the proxy — it only fills holes the ledger left. The proxy is
    # re-derived HERE, from the event's raw duration and the CURRENT rate card,
    # rather than read from the event's own `estimated_dollars:` (which
    # complete-job.sh records as provenance): that keeps the projection a pure
    # function of (events, rate card), so correcting a rate is a journal data edit
    # that re-prices all history on the next tick, with no event ever rewritten.
    adjusted="$(rep_adjusted_agentic_dollars "$DIR" "$base")"
    case "$adjusted" in
      '') ;;
      *) printf '%s %s adjustment\n' "${accepted:-false}" "$adjusted" >> "$work/$armhash.dat"; continue ;;
    esac
    case "$agg" in
      ''|censored)
        dur="$(plan_field "$ef" duration_secs)"
        hum="$(plan_field "$ef" human_dollars)"
        # The journal's claim -> tada commit timestamps are the engagement's
        # wallclock, counting earlier attempts capped at GARDEN_REP_ATTEMPT_CAP_SECS.
        # duration_secs clocks only the final worker attempt, so it is a fallback for
        # old/incomplete log history that yields no positive span.
        span="$(rep_wallclock_lookup "$work/wallclock.idx" "$base")"
        secs="$(rep_proxy_secs "${span:-}" "${dur:-0}")"
        estd="$(rep_estimated_dollars "$DIR" "$provider" "$model" "$tht" "$secs" "${hum:-0}")"
        case "$estd" in
          censored) printf '%s CENSORED none\n' "${accepted:-false}" >> "$work/$armhash.dat" ;;
          *)        printf '%s %s wallclock\n' "${accepted:-false}" "$estd" >> "$work/$armhash.dat" ;;
        esac ;;
      *) printf '%s %s ledger\n' "${accepted:-false}" "$agg" >> "$work/$armhash.dat" ;;
    esac
  done
  shopt -u nullglob

  # For each arm, compute the projection and write it (git no-ops an unchanged file).
  local mf stats att acc cen est mean m2
  shopt -s nullglob
  for mf in "$work"/*.meta; do
    armhash="$(basename "$mf" .meta)"
    { read -r kind; read -r provider; read -r model; read -r tht; read -r wc; read -r tgt; read -r rel; } < "$mf"
    # ACCEPTANCE terms fold EVERY event; COST terms fold only the cost-OBSERVED
    # ones. A censored sample is a missing COST measurement (the usage ledger was
    # absent — rep_agentic_dollars fails open), and that must never discard the
    # event's independent ACCEPTANCE measurement: design §4.5 — "cost-censored
    # samples count toward the acceptance rate, are excluded from the dollar mean,
    # and are flagged in the projection (`censored: n`)".
    # mean_dollars stays cost-PER-ACCEPTED (failed attempts amortized): the
    # cost-observed per-attempt mean divided by the full-population acceptance rate.
    # With nothing censored (n == att) that reduces to the historical sumd/acc, and
    # the n==att branch computes it that way EXACTLY, so an uncensored arm's file is
    # byte-identical to before this change (no churn, and idempotence preserved).
    # m2 stays the Welford sum over the cost-priced samples only; its sample count is
    # therefore (attempts - censored + estimated), which is what rep_cost_samples
    # derives and rep_thompson_draw uses.
    #
    # `censored:` counts every event the LEDGER could not price and NEVER shrinks —
    # it is the arm's honest report of how much of its cost evidence is real.
    # `estimated:` is the subset of those the WALLCLOCK PROXY could price; those
    # samples DO enter mean_dollars/m2, so a censored arm finally has a cost
    # posterior, while the two counters together still say exactly how it was
    # obtained. A wholly-unpriceable event (no duration, or an arm with no rate) is
    # censored-and-not-estimated and contributes acceptance only, as before.
    stats="$(awk '
      { af=$1; d=$2; src=$3;
        att++; if (af=="true") acc++;
        if (src!="ledger") cen++;
        if (src=="wallclock") est++;
        if (d=="CENSORED") next;
        n++; delta=d-mean; mean+=delta/n; m2+=delta*(d-mean); sumd+=d;
      }
      END{ rate = (att>0)? acc/att : 0;
           md = (acc>0 && n>0)? ((n==att)? sumd/acc : (sumd/n)/rate) : 0;
           printf "%d %d %d %d %.6f %.6f\n", att+0, acc+0, cen+0, est+0, md, m2+0; }' "$work/$armhash.dat")"
    read -r att acc cen est mean m2 <<<"$stats"
    mkdir -p "$DIR/$(dirname "$rel")"
    {
      printf 'kind: %s\n' "$kind"
      printf 'provider: %s\n' "$provider"
      printf 'model: %s\n' "$model"
      printf 'thoughtfulness: %s\n' "$tht"
      printf 'work_class: %s\n' "$wc"
      printf 'target: %s\n' "$tgt"
      printf 'attempts: %s\n' "$att"
      printf 'accepts: %s\n' "$acc"
      printf 'censored: %s\n' "$cen"
      printf 'estimated: %s\n' "$est"
      printf 'mean_dollars: %s\n' "$mean"
      printf 'm2: %s\n' "$m2"
      printf 'acceptance_rate: %s\n' "$(awk -v a="$acc" -v t="$att" 'BEGIN{printf "%.4f", (t>0)?a/t:0}')"
    } > "$DIR/$rel"
    git -C "$DIR" add "$rel"
  done
  shopt -u nullglob
  rm -rf "$work"
}

finalize_pending
recompute_arms

if git -C "$DIR" diff --cached --quiet 2>/dev/null; then
  clone_unlock "$DIR"
  log "no reputation changes this tick"
  exit 0
fi
rc=0; commit_and_push "$DIR" "reputation: reduce events -> arm projections ($GARDEN)" || rc=$?
if [ "$rc" -eq 0 ]; then
  log "reputation projections updated"
elif [ "$rc" -eq 2 ]; then
  log "nothing to commit"
else
  # A lost push race is benign — the next tick recomputes from the same events.
  log "reputation reduce push failed (rc=$rc); next tick retries"
fi
exit 0
