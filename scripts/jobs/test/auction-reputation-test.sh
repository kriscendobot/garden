#!/bin/bash
# auction-reputation-test.sh — the decentralized bid auction + dollar-normalized
# reputation (design cleric-worker-bid-auction-reputation.md §3–§5), exercised
# deterministically and hermetically.
#
# Subtests:
#   MATH        — the deterministic Thompson draw is reproducible; cold arms draw
#                 WIDE (explore), warm-cheap arms draw LOW (exploit); work-class
#                 classification is deterministic; arm resolution per kind.
#   EVENT       — a completed job records ONE reputation event keyed to the ran arm
#                 (the completion push carries it; garden-internal main2 -> accepted).
#   REDUCER     — the reducer folds events into arm projections (Welford: attempts,
#                 accepts, mean cost-per-accepted, m2, censored) and is idempotent.
#   CENSORED    — a cost-censored event still moves attempts/accepts (only the cost
#                 estimators skip it), and an arm whose cost was NEVER measured
#                 draws the prior rather than a $0 posterior.
#   COLD-START  — a bidder with no history bids from the wide cold prior (no crash,
#                 no rich-get-richer: it still wins a share of jobs).
#   RACE-DEGEN  — a `market: bid` job with ONE bidder degenerates to a single claim;
#                 an absent/`race` job is claimed by the untouched race with no bids.
#   AWARD       — with several committed bids, the eligible rank-1 bidder (by the
#                 deterministic award order) is the one that claims; the claim stamps
#                 the awarded bid + committed arm.
#   NO-DOUBLE   — N gardeners racing the SAME closed-auction job at the anyone stage
#                 produce EXACTLY ONE claim (the push CAS is the sole serialization
#                 point; no double-award under concurrency).
#   STARVATION  — across many jobs a cold arm competing with a cheap warm arm still
#                 wins a non-zero share (Thompson exploration; no starvation).
#
# systemd is not required. Usage: auction-reputation-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (this may run AS a board job under a live gardener).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_|AUCTION_)' || true) 2>/dev/null || true
export GARDEN_TEST=1 GARDEN_ROOT="$ROOT" GARDEN_NO_MAINTAINER_ALERT=1
# shellcheck source=../common.sh
source "$JOBS/common.sh"
# shellcheck source=../auction.sh
source "$JOBS/auction.sh"

STUB="$JOBS/test/stub-handler.sh"   # a genuine-completion stub (writes the sentinel)

git_id=(-c user.name=test -c user.email=test@localhost)

# seed_board <tr> <base> [frontmatter] — throwaway bare origin + a journal2 board
# carrying reputation/ and jobs/bids/ dirs and one todo job. Echoes the bare path.
seed_board() {
  local tr="$1" base="$2" front="${3:-}" bare="$1/journal.git" seed="$1/seed" branch=journal2
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$branch"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada jobs/bids work repos msgs hosts entries \
             schedules cursors reputation/events reputation/pending reputation/arms \
             reputation/verdicts reputation/reviews inbox/maintainer/unread inbox/maintainer/read
    for d in jobs/todo jobs/doin jobs/tada jobs/bids work repos msgs hosts entries \
             schedules cursors reputation/events reputation/pending reputation/arms \
             reputation/verdicts reputation/reviews; do touch "$d/.gitkeep"; done
    { [ -n "$front" ] && printf -- '---\n%s\n---\n' "$front"; printf '# %s\n\ndo the work for %s\n' "$base" "$base"; } > "jobs/todo/$base.md" )
  git -C "$seed" add -A
  git -C "$seed" "${git_id[@]}" commit -q -m "seed"
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$branch"
  printf '%s\n' "$bare"
}

# verify_clone <bare> <dst> — fresh single-branch clone of the board.
verify_clone() { git clone -q --single-branch --branch journal2 "$1" "$2" 2>/dev/null; }

# ============================================================================
hr; echo "MATH — deterministic Thompson draw, work-class, arm resolution"; hr
d1="$(rep_thompson_draw 20 3 4 20 'seedX')"; d2="$(rep_thompson_draw 20 3 4 20 'seedX')"
[ "$d1" = "$d2" ] && ok "Thompson draw reproducible for a fixed seed ($d1)" || bad "draw not reproducible ($d1 vs $d2)"
# warm-cheap arm draws far below the cold prior mean (10); warm-expensive far above.
cheap="$(rep_thompson_draw 30 2 3 30 'sA')"; exp="$(rep_thompson_draw 30 40 3 30 'sA')"
awk -v c="$cheap" -v e="$exp" 'BEGIN{exit !(c<8 && e>30)}' \
  && ok "warm-cheap draws low ($cheap) << warm-expensive ($exp) — exploitation" \
  || bad "warm arms not separated (cheap=$cheap exp=$exp)"
# cold arm spread: over many seeds the cold prior produces a WIDE range (sd ~20).
cmin=1e9; cmax=-1e9
for s in a b c d e f g h i j k l m n o p; do
  v="$(rep_thompson_draw 0 0 0 0 "cold$s")"
  cmin="$(awk -v a="$cmin" -v b="$v" 'BEGIN{print (b<a)?b:a}')"
  cmax="$(awk -v a="$cmax" -v b="$v" 'BEGIN{print (b>a)?b:a}')"
done
awk -v lo="$cmin" -v hi="$cmax" 'BEGIN{exit !((hi-lo)>10)}' \
  && ok "cold prior is WIDE (range $cmin..$cmax) — exploration" || bad "cold prior too narrow ($cmin..$cmax)"

tmp="$(mktemp)"
printf -- '---\nrole: builder\n---\nshort\n' > "$tmp"
[ "$(rep_work_class "$tmp")" = "build:s" ] && ok "work-class build:s (small builder job)" || bad "work-class ($(rep_work_class "$tmp"))"
printf -- '---\nwork-class: fix:l\n---\nx\n' > "$tmp"
[ "$(rep_work_class "$tmp")" = "fix:l" ] && ok "explicit work-class: override honored" || bad "explicit work-class not honored"
printf -- '---\nrole: builder\n---\nx\n' > "$tmp"
[ "$(rep_resolve_arm gardener "$tmp" | paste -sd/ -)" = "anthropic/claude-opus-4-8/high" ] \
  && ok "gardener builder arm = anthropic/claude-opus-4-8/high" || bad "gardener arm wrong"
[ "$(rep_resolve_arm cleric "$tmp" | paste -sd/ -)" = "openai/gpt-5.6-terra/high" ] \
  && ok "cleric builder arm = openai/gpt-5.6-terra/high" || bad "cleric arm wrong"
rm -f "$tmp"

# ============================================================================
hr; echo "EVENT — a completed job records ONE reputation event keyed to the arm"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/auc-event.XXXXXX")"
BARE="$(seed_board "$TR" evt-job "role: builder")"
env GARDEN=eh GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    GARDEN_WORKER_KIND=gardener GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_JOB_HANDLER="$STUB" \
    "$JOBS/gardener.sh" 1 > "$TR/w.log" 2>&1 || true
V="$TR/v"; verify_clone "$BARE" "$V"
if [ -f "$V/reputation/events/evt-job.md" ]; then
  ok "reputation event written on completion (reputation/events/evt-job.md)"
  ef="$V/reputation/events/evt-job.md"
  [ "$(plan_field "$ef" kind)" = gardener ] && ok "event kind=gardener" || bad "event kind ($(plan_field "$ef" kind))"
  [ "$(plan_field "$ef" model)" = claude-opus-4-8 ] && ok "event model=claude-opus-4-8 (ran arm)" || bad "event model ($(plan_field "$ef" model))"
  [ "$(plan_field "$ef" work_class)" = build:s ] && ok "event work_class=build:s" || bad "event work_class ($(plan_field "$ef" work_class))"
  [ "$(plan_field "$ef" accepted)" = true ] && ok "internal main2 job accepted=true on tada" || bad "event accepted ($(plan_field "$ef" accepted))"
  [ "$(plan_field "$ef" agentic_dollars)" = censored ] && ok "agentic dollars censored (no usage ledger yet — fail-open)" || bad "agentic ($(plan_field "$ef" agentic_dollars))"
else
  bad "no reputation event written (w.log tail: $(tail -3 "$TR/w.log" | tr '\n' '|'))"
fi
rm -rf "$TR"

# ============================================================================
hr; echo "REDUCER — events -> arm projections (Welford), idempotent"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/auc-reduce.XXXXXX")"
BARE="$(seed_board "$TR" seedjob)"
# inject 3 finalized events for ONE arm with known aggregate dollars: 2 accepted
# ($4,$6), 1 rejected ($10 sunk). cost-per-accepted = (4+6+10)/2 = 10.
SEED="$TR/inj"; verify_clone "$BARE" "$SEED"
arm_rel="reputation/arms/gardener/anthropic/claude-opus-4-8/high/build-m@main2.md"
mkev() { # mkev <base> <accepted> <aggregate>
  cat > "$SEED/reputation/events/$1.md" <<EOF
---
base: $1
kind: gardener
provider: anthropic
model: claude-opus-4-8
thoughtfulness: high
work_class: build:m
target: main2
accepted: $2
agentic_dollars: $3
human_dollars: 0
aggregate_dollars: $3
attempts: 1
source: live
---
injected
EOF
}
mkev e1 true 4
mkev e2 true 6
mkev e3 false 10
git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m inject; git -C "$SEED" push -q origin journal2
env GARDEN=rh GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    "$JOBS/reputation-reduce.sh" > "$TR/r.log" 2>&1 || true
V="$TR/v"; verify_clone "$BARE" "$V"
if [ -f "$V/$arm_rel" ]; then
  ok "arm projection written ($arm_rel)"
  read -r att acc mean m2 cen <<<"$(rep_read_projection "$V" "$arm_rel")"
  [ "$att" = 3 ] && ok "attempts=3" || bad "attempts=$att"
  [ "$acc" = 2 ] && ok "accepts=2" || bad "accepts=$acc"
  awk -v m="$mean" 'BEGIN{exit !(m>9.99 && m<10.01)}' && ok "mean cost-per-accepted=10.0 ((4+6+10)/2)" || bad "mean=$mean"
else
  bad "reducer did not write the arm projection (r.log: $(tail -3 "$TR/r.log" | tr '\n' '|'))"
fi
# idempotent: a second run produces no new commit.
before="$(git -C "$V" rev-parse HEAD)"
env GARDEN=rh GARDEN_STATE="$TR/state2" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    "$JOBS/reputation-reduce.sh" > "$TR/r2.log" 2>&1 || true
V2="$TR/v2"; verify_clone "$BARE" "$V2"
[ "$(git -C "$V2" rev-parse HEAD)" = "$before" ] && ok "reducer idempotent (no new commit on unchanged events)" || bad "reducer churned an unchanged event set"
rm -rf "$TR"

# ============================================================================
hr; echo "CENSORED — a cost-censored event still moves acceptance; cost stays unknown"; hr
# A censored sample is a missing COST measurement (the usage ledger was absent), not
# a withheld acceptance. Design §4.5: it counts toward the acceptance rate, is
# excluded from the dollar mean, and is flagged as `censored:`. Two arms:
#   MIXED  — 5 events: 3 censored (2 accepted, 1 rejected) + $4 accepted + $10
#            rejected. attempts=5 accepts=3 censored=3, cost samples=2.
#            mean cost-per-accepted = (per-attempt (4+10)/2=7) / (rate 3/5=0.6) = 11.666667
#   FROZEN — 6 events, ALL censored, ALL accepted (the shape of every live
#            moonshot/kimi-k3 and openai/codex arm, whose CLIs emit no usage
#            ledger). Before this fix it read attempts=0 accepts=0 rate 0.0000.
TR="$(mktemp -d "${TMPDIR:-/tmp}/auc-censor.XXXXXX")"
BARE="$(seed_board "$TR" cenjob)"
SEED="$TR/inj"; verify_clone "$BARE" "$SEED"
mixed_rel="reputation/arms/gardener/anthropic/claude-opus-4-8/high/fix-m@main2.md"
frozen_rel="reputation/arms/mystic/moonshot/kimi-k3/medium/gardener-s@main2.md"
mkcev() { # mkcev <base> <model> <thoughtfulness> <work_class> <kind> <provider> <accepted> <aggregate>
  cat > "$SEED/reputation/events/$1.md" <<EOF
---
base: $1
kind: $5
provider: $6
model: $2
thoughtfulness: $3
work_class: $4
target: main2
accepted: $7
agentic_dollars: $8
human_dollars: 0
aggregate_dollars: $8
attempts: 1
source: live
---
injected
EOF
}
mkcev m1 claude-opus-4-8 high fix:m gardener anthropic true censored
mkcev m2 claude-opus-4-8 high fix:m gardener anthropic true censored
mkcev m3 claude-opus-4-8 high fix:m gardener anthropic false censored
mkcev m4 claude-opus-4-8 high fix:m gardener anthropic true 4
mkcev m5 claude-opus-4-8 high fix:m gardener anthropic false 10
for i in 1 2 3 4 5 6; do mkcev "k$i" kimi-k3 medium gardener:s mystic moonshot true censored; done
git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m inject-censored; git -C "$SEED" push -q origin journal2
env GARDEN=ch GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    "$JOBS/reputation-reduce.sh" > "$TR/c.log" 2>&1 || true
V="$TR/v"; verify_clone "$BARE" "$V"
if [ -f "$V/$mixed_rel" ]; then
  read -r att acc mean m2 cen <<<"$(rep_read_projection "$V" "$mixed_rel")"
  [ "$att" = 5 ] && [ "$acc" = 3 ] && [ "$cen" = 3 ] \
    && ok "mixed arm: censored events counted in attempts/accepts (att=5 acc=3 cen=3)" \
    || bad "mixed arm attempts/accepts/censored wrong (att=$att acc=$acc cen=$cen)"
  awk -v m="$mean" 'BEGIN{exit !(m>11.66 && m<11.67)}' \
    && ok "mixed arm: cost-per-accepted \$11.666667 from the 2 COST samples only (\$14/2 divided by rate 0.6)" \
    || bad "mixed arm mean wrong ($mean, expected 11.666667)"
  [ "$(plan_field "$V/$mixed_rel" acceptance_rate)" = "0.6000" ] \
    && ok "mixed arm: acceptance_rate 0.6000 over ALL 5 attempts" \
    || bad "mixed arm acceptance_rate ($(plan_field "$V/$mixed_rel" acceptance_rate))"
  [ "$(rep_cost_samples "$att" "$cen")" = 2 ] && ok "rep_cost_samples = attempts - censored = 2" || bad "rep_cost_samples wrong"
else
  bad "reducer wrote no mixed arm (c.log: $(tail -3 "$TR/c.log" | tr '\n' '|'))"
fi
if [ -f "$V/$frozen_rel" ]; then
  read -r fatt facc fmean fm2 fcen <<<"$(rep_read_projection "$V" "$frozen_rel")"
  { [ "$fatt" = 6 ] && [ "$facc" = 6 ] && [ "$fcen" = 6 ]; } \
    && ok "all-censored arm UNFROZEN: att=6 acc=6 cen=6 (was att=0 acc=0)" \
    || bad "all-censored arm still frozen (att=$fatt acc=$facc cen=$fcen)"
  [ "$(plan_field "$V/$frozen_rel" acceptance_rate)" = "1.0000" ] \
    && ok "all-censored arm: acceptance_rate 1.0000 reflects the real successes (was 0.0000)" \
    || bad "all-censored acceptance_rate ($(plan_field "$V/$frozen_rel" acceptance_rate))"
  awk -v m="$fmean" -v s="$fm2" 'BEGIN{exit !(m==0 && s==0)}' \
    && ok "all-censored arm: cost estimators stay 0/unknown (no dollars were observed)" \
    || bad "all-censored arm invented cost evidence (mean=$fmean m2=$fm2)"
  # THE COST-SIDE GUARD: with 6 attempts and 6 accepts the arm is past cold_n on
  # ACCEPTANCE, so reading its zeroed mean as a posterior would bid the $0.01 floor
  # and win every auction on price. Cost samples = 0 must send it to the prior.
  lo=1e9; hi=-1e9; sum=0; n=0
  for s in a b c d e f g h i j k l m n o p; do
    v="$(rep_thompson_draw "$fatt" "$fmean" "$fm2" "$facc" "cen$s" "$(rep_cost_samples "$fatt" "$fcen")")"
    lo="$(awk -v a="$lo" -v b="$v" 'BEGIN{print (b<a)?b:a}')"
    hi="$(awk -v a="$hi" -v b="$v" 'BEGIN{print (b>a)?b:a}')"
    sum="$(awk -v a="$sum" -v b="$v" 'BEGIN{printf "%.6f", a+b}')"; n=$((n+1))
  done
  avg="$(awk -v s="$sum" -v n="$n" 'BEGIN{printf "%.4f", s/n}')"
  awk -v a="$avg" -v hi="$hi" -v lo="$lo" 'BEGIN{exit !(a>3 && (hi-lo)>10)}' \
    && ok "cost-unknown arm draws the WIDE prior (mean \$$avg, range \$$lo..\$$hi) — never a \$0 bid" \
    || bad "cost-unknown arm draw collapsed (mean $avg range $lo..$hi)"
  # and the unguarded reading (cost samples defaulted to attempts) really would.
  naive="$(rep_thompson_draw "$fatt" "$fmean" "$fm2" "$facc" "cena")"
  awk -v x="$naive" 'BEGIN{exit !(x<1)}' \
    && ok "control: the same arm read WITHOUT the censored split bids \$$naive (the failure this guards)" \
    || bad "control draw unexpectedly high ($naive)"
else
  bad "reducer wrote no all-censored arm"
fi
# still idempotent with censored events in the set.
before="$(git -C "$V" rev-parse HEAD)"
env GARDEN=ch GARDEN_STATE="$TR/state2" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    "$JOBS/reputation-reduce.sh" > "$TR/c2.log" 2>&1 || true
V2="$TR/v2"; verify_clone "$BARE" "$V2"
[ "$(git -C "$V2" rev-parse HEAD)" = "$before" ] && ok "reducer idempotent over a censored event set" || bad "reducer churned a censored event set"
rm -rf "$TR"

# finalize: a PENDING PR-target event is finalized by a verdict override, and the
# inferred human-review dollars (from committed review observables) fold in.
TR="$(mktemp -d "${TMPDIR:-/tmp}/auc-final.XXXXXX")"
BARE="$(seed_board "$TR" fjob)"
SEED="$TR/inj"; verify_clone "$BARE" "$SEED"
cat > "$SEED/reputation/pending/prjob.md" <<EOF
---
base: prjob
kind: cleric
provider: openai
model: gpt-5.6-terra
thoughtfulness: high
work_class: build:m
target: upstream
accepted: pending
agentic_dollars: 8
human_dollars: 0
aggregate_dollars: 8
attempts: 1
source: live
---
pending
EOF
printf 'accepted: true\n' > "$SEED/reputation/verdicts/prjob"
printf 'rounds: 2\ncomment_words: 100\n' > "$SEED/reputation/reviews/prjob"   # 5*2 + 100/20 = 15min -> $31.25
git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m inject-pending; git -C "$SEED" push -q origin journal2
env GARDEN=fh GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    "$JOBS/reputation-reduce.sh" > "$TR/f.log" 2>&1 || true
V="$TR/v"; verify_clone "$BARE" "$V"
{ [ -f "$V/reputation/events/prjob.md" ] && [ ! -f "$V/reputation/pending/prjob.md" ]; } \
  && ok "pending event finalized (pending/ -> events/) by verdict override" \
  || bad "pending not finalized (f.log: $(tail -3 "$TR/f.log" | tr '\n' '|'))"
if [ -f "$V/reputation/events/prjob.md" ]; then
  [ "$(plan_field "$V/reputation/events/prjob.md" accepted)" = true ] && ok "finalized accepted=true" || bad "finalized accepted wrong"
  agg="$(plan_field "$V/reputation/events/prjob.md" aggregate_dollars)"
  awk -v a="$agg" 'BEGIN{exit !(a>39.24 && a<39.26)}' && ok "aggregate = agentic \$8 + inferred human \$31.25 = \$39.25" || bad "aggregate wrong ($agg)"
fi
rm -rf "$TR"

# ============================================================================
hr; echo "RACE-DEGEN — a race/absent job claims with NO bids; 1-bidder bid job claims"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/auc-degen.XXXXXX")"
BARE="$(seed_board "$TR" raceonly "role: fixer")"    # no market: bid -> pure race
env GARDEN=dh GARDEN_STATE="$TR/s1" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    GARDEN_WORKER_KIND=gardener GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_JOB_HANDLER="$STUB" \
    "$JOBS/gardener.sh" 1 > "$TR/w.log" 2>&1 || true
V="$TR/v"; verify_clone "$BARE" "$V"
{ [ -f "$V/jobs/tada/raceonly.md" ] && [ ! -d "$V/jobs/bids/raceonly" ]; } \
  && ok "race job completed with NO bid files written (untouched race path)" \
  || bad "race job: tada=$([ -f "$V/jobs/tada/raceonly.md" ] && echo y||echo n) bids=$([ -d "$V/jobs/bids/raceonly" ] && echo y||echo n)"
rm -rf "$TR"

# A single-bidder market:bid job: window OPEN -> the worker bids and does not claim;
# window CLOSED -> the same worker (rank 1 by construction) claims.
TR="$(mktemp -d "${TMPDIR:-/tmp}/auc-1bid.XXXXXX")"
START=1000000000
ISO="$(date -u -d "@$START" +%FT%TZ)"
BARE="$(seed_board "$TR" onebid "role: builder
market: bid
bid_window: 120
posted_at: $ISO")"
# Phase A: window open (now = START+10). Drive claim-job directly for one worker.
export GARDEN_GARDENER_CLONE="$TR/s/gardeners/1/journal"
env GARDEN=oh GARDEN_STATE="$TR/s" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    GARDEN_WORKER_KIND=gardener GARDEN_AUCTION_NOW=$((START+10)) \
    "$JOBS/claim-job.sh" 1 > "$TR/a.log" 2>&1 && arc=0 || arc=$?
V="$TR/va"; verify_clone "$BARE" "$V"
{ [ "$arc" -eq 3 ] && [ -f "$V/jobs/bids/onebid/gardener-oh-1.md" ] && [ -f "$V/jobs/todo/onebid.md" ]; } \
  && ok "open window: worker BID (gardener-oh-1) and did NOT claim (job still in todo)" \
  || bad "open-window bid wrong (rc=$arc bid=$([ -f "$V/jobs/bids/onebid/gardener-oh-1.md" ] && echo y||echo n) todo=$([ -f "$V/jobs/todo/onebid.md" ] && echo y||echo n))"
# Phase B: window closed (now = START+120+1). The lone bidder is rank 1 -> claims.
env GARDEN=oh GARDEN_STATE="$TR/s" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    GARDEN_WORKER_KIND=gardener GARDEN_AUCTION_NOW=$((START+121)) \
    "$JOBS/claim-job.sh" 1 > "$TR/b.log" 2>&1 && brc=0 || brc=$?
V="$TR/vb"; verify_clone "$BARE" "$V"
{ [ "$brc" -eq 0 ] && [ -f "$V/jobs/doin/onebid.md" ]; } \
  && ok "closed window: the lone bidder claimed (todo->doin) — degenerates to a single claim" \
  || bad "closed-window single-bidder claim wrong (rc=$brc doin=$([ -f "$V/jobs/doin/onebid.md" ] && echo y||echo n))"
grep -q 'awarded_bid: gardener-oh-1' "$V/jobs/doin/onebid.md" && ok "claim stamped awarded_bid: gardener-oh-1" || bad "awarded_bid not stamped"
unset GARDEN_GARDENER_CLONE
rm -rf "$TR"

# ============================================================================
hr; echo "AWARD + NO-DOUBLE — deterministic rank-1 claims; N racers -> exactly one"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/auc-award.XXXXXX")"
START=1100000000; ISO="$(date -u -d "@$START" +%FT%TZ)"
BARE="$(seed_board "$TR" bigjob "role: builder
market: bid
bid_window: 120
posted_at: $ISO")"
# Three bidders bid during the open window (distinct ids -> distinct bidders).
for i in 1 2 3; do
  export GARDEN_GARDENER_CLONE="$TR/s/gardeners/$i/journal"
  env GARDEN=ah GARDEN_STATE="$TR/s" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
      GARDEN_WORKER_KIND=gardener GARDEN_AUCTION_NOW=$((START+5)) \
      "$JOBS/claim-job.sh" "$i" > "$TR/bid$i.log" 2>&1 || true
done
unset GARDEN_GARDENER_CLONE
V="$TR/vbids"; verify_clone "$BARE" "$V"
nbids="$(ls -1 "$V/jobs/bids/bigjob" 2>/dev/null | grep -vc .gitkeep || true)"
[ "$nbids" -eq 3 ] && ok "3 distinct bids committed in the open window" || bad "expected 3 bids, got $nbids"
# The deterministic award order (computed from the committed journal by anyone).
expect1="$(auction_award_order "$V" bigjob | head -1)"
ok "deterministic award rank-1 = $expect1 (pure function of the journal)"
# Closed window, rank-1-only stage (now = close + 1). Run all three CONCURRENTLY;
# only rank 1 is eligible, and the push CAS admits exactly one claim.
for i in 1 2 3; do
  ( export GARDEN_GARDENER_CLONE="$TR/s/gardeners/$i/journal"
    env GARDEN=ah GARDEN_STATE="$TR/s" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
        GARDEN_WORKER_KIND=gardener GARDEN_AUCTION_NOW=$((START+121)) \
        "$JOBS/claim-job.sh" "$i" > "$TR/claim$i.log" 2>&1 || true ) &
done
wait
V="$TR/vclaim"; verify_clone "$BARE" "$V"
claimed_n=0; [ -f "$V/jobs/doin/bigjob.md" ] && claimed_n=1
[ "$claimed_n" -eq 1 ] && ok "exactly ONE claim under concurrency (no double-award)" || bad "claim count wrong ($claimed_n)"
if [ -f "$V/jobs/doin/bigjob.md" ]; then
  got="$(sed -n 's/^[[:space:]]*awarded_bid:[[:space:]]*//p' "$V/jobs/doin/bigjob.md" | head -1)"
  [ "$got" = "$expect1" ] && ok "the claim went to the deterministic rank-1 bidder ($got)" || bad "claim went to $got, expected rank-1 $expect1"
fi
rm -rf "$TR"

# no-double at the ANYONE stage: all three eligible, still exactly one claim.
TR="$(mktemp -d "${TMPDIR:-/tmp}/auc-anyone.XXXXXX")"
START=1200000000; ISO="$(date -u -d "@$START" +%FT%TZ)"
BARE="$(seed_board "$TR" anyjob "role: builder
market: bid
bid_window: 60
posted_at: $ISO")"
for i in 1 2 3; do
  export GARDEN_GARDENER_CLONE="$TR/s/gardeners/$i/journal"
  env GARDEN=yh GARDEN_STATE="$TR/s" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
      GARDEN_WORKER_KIND=gardener GARDEN_AUCTION_NOW=$((START+5)) \
      "$JOBS/claim-job.sh" "$i" > /dev/null 2>&1 || true
done
unset GARDEN_GARDENER_CLONE
# now = close + 3*grace + 5 = START+60 + 90 + 5 -> anyone stage (all eligible)
NOW=$((START+60+3*GARDEN_AUCTION_GRACE+5))
for i in 1 2 3; do
  ( export GARDEN_GARDENER_CLONE="$TR/s/gardeners/$i/journal"
    env GARDEN=yh GARDEN_STATE="$TR/s" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
        GARDEN_WORKER_KIND=gardener GARDEN_AUCTION_NOW=$NOW \
        "$JOBS/claim-job.sh" "$i" > "$TR/c$i.log" 2>&1 || true ) &
done
wait
V="$TR/v"; verify_clone "$BARE" "$V"
cn=0; [ -f "$V/jobs/doin/anyjob.md" ] && cn=1
[ "$cn" -eq 1 ] && ok "anyone stage: all eligible, still EXACTLY ONE claim (CAS)" || bad "anyone-stage claim count wrong ($cn)"
rm -rf "$TR"

# ============================================================================
hr; echo "COLD-START + STARVATION — a cold arm still wins a share against a warm arm"; hr
# Two bidders on each of many jobs: bidder A on a cheap WARM arm (pre-seeded
# projection), bidder B on a COLD arm (no history). Over many bases the cold arm
# must win a NON-ZERO share (Thompson exploration) — no starvation / rich-get-richer
# — while the warm-cheap arm wins the MAJORITY (exploitation).
TR="$(mktemp -d "${TMPDIR:-/tmp}/auc-starv.XXXXXX")"
# We only need the award MATH here (auction_award_order over committed bids), so
# build a fixture board by hand with two bids per base and a warm arm projection.
BARE="$TR/journal.git"; git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED"/reputation/arms
# warm arm A: gardener/anthropic/claude-opus-4-8/high build:m@main2, cheap+tight.
warmrel="reputation/arms/gardener/anthropic/claude-opus-4-8/high/build-m@main2.md"
mkdir -p "$SEED/$(dirname "$warmrel")"
cat > "$SEED/$warmrel" <<EOF
kind: gardener
provider: anthropic
model: claude-opus-4-8
thoughtfulness: high
work_class: build:m
target: main2
attempts: 40
accepts: 38
censored: 0
mean_dollars: 3.0
m2: 20.0
acceptance_rate: 0.95
EOF
awins=0; bwins=0; N=40
for j in $(seq 1 $N); do
  base="job$j"
  bdir="$SEED/jobs/bids/$base"; mkdir -p "$bdir"
  # bidder A: the warm cheap arm; bidder B: a cold arm (cleric terra, no history).
  cat > "$bdir/gardener-hA-1.md" <<EOF
---
bidder: gardener-hA-1
kind: gardener
provider: anthropic
model: claude-opus-4-8
thoughtfulness: high
work_class: build:m
target: main2
EOF
  cat > "$bdir/cleric-hB-1.md" <<EOF
---
bidder: cleric-hB-1
kind: cleric
provider: openai
model: gpt-5.6-terra
thoughtfulness: high
work_class: build:m
target: main2
EOF
done
git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m seed
for j in $(seq 1 $N); do
  w="$(auction_award_order "$SEED" "job$j" | head -1)"
  case "$w" in gardener-hA-1) awins=$((awins+1)) ;; cleric-hB-1) bwins=$((bwins+1)) ;; esac
done
echo "  (warm-cheap arm A won $awins/$N, cold arm B won $bwins/$N)"
[ "$awins" -gt "$bwins" ] && ok "warm-cheap arm wins the MAJORITY ($awins vs $bwins) — exploitation" || bad "warm arm did not dominate ($awins vs $bwins)"
{ [ "$bwins" -ge 1 ] && [ "$awins" -ge 1 ]; } && ok "cold arm still wins a non-zero share ($bwins) — exploration, no starvation" || bad "starvation: cold arm won $bwins (expected >=1)"
# determinism: recomputing the same board yields the SAME winners.
awins2=0
for j in $(seq 1 $N); do
  w="$(auction_award_order "$SEED" "job$j" | head -1)"
  [ "$w" = gardener-hA-1 ] && awins2=$((awins2+1))
done
[ "$awins2" -eq "$awins" ] && ok "award order fully deterministic across recompute ($awins2 == $awins)" || bad "award nondeterministic ($awins2 vs $awins)"
rm -rf "$TR"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
