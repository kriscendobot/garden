#!/bin/bash
# flat-provider-censor-test.sh — the flat-subscription cost-censoring policy
# (budget-attribution child 2). On a flat plan (Anthropic Max) a per-call
# `total_cost_usd` is NOTIONAL list-price, not money, so it must NOT price the bid
# auction: the reducer treats a flat provider's ledger aggregate as cost-censored and
# falls through to the true-costed wallclock proxy, while a METERED provider keeps its
# real dollars. The raw event is never rewritten — only the derived projection changes.
#
# Subtests:
#   UNIT       — rep_provider_is_flat honors GARDEN_REP_FLAT_PROVIDERS (default
#                anthropic; empty disables; comma/space lists; metered → false).
#   REDUCER    — the SAME numeric-aggregate event set reduces to a PROXY-priced arm
#                for a flat provider and a LEDGER-priced arm for a metered one; the
#                raw events are byte-identical afterwards (the 217-backlog reversal).
#   WRITE-TIME — a completion on a flat provider records agentic_dollars (the notional
#                evidence) but a CENSORED aggregate + a proxy cost_source; a metered
#                completion keeps a numeric ledger aggregate.
#
# Deterministic, hermetic, no provider/agent/systemd. Usage: flat-provider-censor-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_|AUCTION_)' || true) 2>/dev/null || true
export GARDEN_TEST=1 GARDEN_ROOT="$ROOT" GARDEN_NO_MAINTAINER_ALERT=1
# shellcheck source=../common.sh
source "$JOBS/common.sh"
# shellcheck source=../auction.sh
source "$JOBS/auction.sh"

git_id=(-c user.name=test -c user.email=test@localhost)

# seed_board <tr> [job-base] [frontmatter] — a throwaway bare origin + a journal2
# board carrying the reputation dirs, optionally with one todo job in the first
# commit. Echoes the bare path.
seed_board() {
  local tr="$1" job="${2:-}" front="${3:-}" bare="$1/journal.git" seed="$1/seed" branch=journal2
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$branch"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada jobs/bids work repos msgs hosts entries \
             schedules cursors reputation/events reputation/pending reputation/arms \
             reputation/adjustments reputation/verdicts reputation/reviews \
             inbox/maintainer/unread inbox/maintainer/read usage
    for d in jobs/todo jobs/doin jobs/tada jobs/bids work repos msgs hosts entries \
             schedules cursors reputation/events reputation/pending reputation/arms \
             reputation/adjustments reputation/verdicts reputation/reviews usage; do
      touch "$d/.gitkeep"; done
    if [ -n "$job" ]; then
      { [ -n "$front" ] && printf -- '---\n%s\n---\n' "$front"; printf '# %s\n\ndo %s\n' "$job" "$job"; } > "jobs/todo/$job.md"
    fi )
  git -C "$seed" add -A
  git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$branch"
  printf '%s\n' "$bare"
}
verify_clone() { git clone -q --single-branch --branch journal2 "$1" "$2" 2>/dev/null; }

# ============================================================================
hr; echo "UNIT — rep_provider_is_flat honors GARDEN_REP_FLAT_PROVIDERS"; hr
( export GARDEN_REP_FLAT_PROVIDERS=anthropic
  rep_provider_is_flat anthropic ) && ok "default set: anthropic is flat" || bad "anthropic not flat by default"
( export GARDEN_REP_FLAT_PROVIDERS=anthropic
  rep_provider_is_flat fireworks ) && bad "fireworks wrongly flat" || ok "metered provider (fireworks) is NOT flat"
( export GARDEN_REP_FLAT_PROVIDERS=
  rep_provider_is_flat anthropic ) && bad "empty set still flagged anthropic" || ok "empty set disables the policy"
( export GARDEN_REP_FLAT_PROVIDERS='anthropic, moonshot'
  rep_provider_is_flat moonshot ) && ok "comma/space list: moonshot flat" || bad "list member moonshot not flat"
( export GARDEN_REP_FLAT_PROVIDERS='anthropic moonshot'
  rep_provider_is_flat openai ) && bad "openai wrongly flat" || ok "non-member openai NOT flat"
rep_provider_is_flat "" && bad "empty provider flagged flat" || ok "empty provider is not flat"

# ============================================================================
hr; echo "REDUCER — flat provider proxy-priced; metered ledger-priced; raw events intact"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/flat-reduce.XXXXXX")"
BARE="$(seed_board "$TR")"
SEED="$TR/inj"; verify_clone "$BARE" "$SEED"
# A clean journal rate card: anthropic $0.001/s, fireworks $0.002/s. The proxy for a
# 600s event is then $0.60 (anthropic) — far below the $5 notional ledger figure it
# replaces, which is exactly the true-cost reversal.
cat > "$SEED/reputation/rate-card.md" <<'EOF'
# rate card (test)

| provider | model | thoughtfulness | dollars_per_second | price_basis | source | measured_at |
| --- | --- | --- | --- | --- | --- | --- |
| anthropic | * | * | 0.001 | provisional | test fixture | 2026-08-02 |
| fireworks | * | * | 0.002 | provisional | test fixture | 2026-08-02 |
| * | * | * | 0.001 | provisional | test fixture default | 2026-08-02 |
EOF
mkev() { # mkev <base> <provider> <model> <accepted> <aggregate> <duration>
  cat > "$SEED/reputation/events/$1.md" <<EOF
---
base: $1
kind: gardener
provider: $2
model: $3
thoughtfulness: high
work_class: build:m
target: main2
accepted: $4
agentic_dollars: $5
human_dollars: 0
aggregate_dollars: $5
cost_source: ledger
attempts: 1
duration_secs: $6
source: live
---
injected
EOF
}
# A flat-provider (anthropic) arm: three numeric-aggregate events — the exact shape of
# the 217 pre-policy Anthropic events. Under the policy these must all become censored
# and be proxy-priced at 600s x $0.001 = $0.60 each.
mkev fa1 anthropic claude-opus-4-8 true  5 600
mkev fa2 anthropic claude-opus-4-8 true  5 600
mkev fa3 anthropic claude-opus-4-8 false 5 600
# A metered (fireworks) arm with the identical numeric aggregates: must stay LEDGER.
mkev fw1 fireworks fireworks-model true  5 600
mkev fw2 fireworks fireworks-model true  5 600
mkev fw3 fireworks fireworks-model false 5 600
git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m inject; git -C "$SEED" push -q origin journal2

anth_rel="reputation/arms/gardener/anthropic/claude-opus-4-8/high/build-m@main2.md"
fw_rel="reputation/arms/gardener/fireworks/fireworks-model/high/build-m@main2.md"

# Reduce with the policy ON (default anthropic-flat).
env GARDEN=fh GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    "$JOBS/reputation-reduce.sh" > "$TR/r.log" 2>&1 || true
V="$TR/v"; verify_clone "$BARE" "$V"
if [ -f "$V/$anth_rel" ]; then
  read -r att acc mean m2 cen est <<<"$(rep_read_projection "$V" "$anth_rel")"
  { [ "$att" = 3 ] && [ "$acc" = 2 ] && [ "$cen" = 3 ] && [ "$est" = 3 ]; } \
    && ok "flat arm: all 3 numeric events censored + proxy-estimated (att=3 acc=2 cen=3 est=3)" \
    || bad "flat arm counters wrong (att=$att acc=$acc cen=$cen est=$est)"
  # cost-per-accepted = per-attempt $0.60 / rate(2/3) = $0.90; NOT the $5 notional mean.
  awk -v m="$mean" 'BEGIN{exit !(m>0.89 && m<0.91)}' \
    && ok "flat arm: cost-per-accepted \$$mean from the PROXY (\$0.60/attempt / 0.667), not the \$5 notional ledger" \
    || bad "flat arm mean wrong ($mean, expected ~0.90 from the proxy)"
else
  bad "reducer wrote no flat (anthropic) arm (r.log: $(tail -3 "$TR/r.log" | tr '\n' '|'))"
fi
if [ -f "$V/$fw_rel" ]; then
  read -r fatt facc fmean fm2 fcen fest <<<"$(rep_read_projection "$V" "$fw_rel")"
  { [ "$fatt" = 3 ] && [ "$facc" = 2 ] && [ "$fcen" = 0 ] && [ "$fest" = 0 ]; } \
    && ok "metered arm: kept LEDGER dollars (att=3 acc=2 censored=0 estimated=0)" \
    || bad "metered arm disturbed (att=$fatt acc=$facc cen=$fcen est=$fest)"
  awk -v m="$fmean" 'BEGIN{exit !(m>7.49 && m<7.51)}' \
    && ok "metered arm: cost-per-accepted \$$fmean = (5+5+5)/2 — real ledger dollars survive" \
    || bad "metered arm mean wrong ($fmean, expected 7.5 from the ledger)"
else
  bad "reducer wrote no metered (fireworks) arm"
fi
# The raw events are never rewritten — the correction lives only in the projection.
[ "$(plan_field "$V/reputation/events/fa1.md" aggregate_dollars)" = 5 ] \
  && ok "raw flat event untouched (aggregate_dollars still 5; reducer never edits events)" \
  || bad "reducer rewrote the raw flat event ($(plan_field "$V/reputation/events/fa1.md" aggregate_dollars))"

# CONTROL: with the policy OFF (empty set), the same anthropic events reduce LEDGER —
# proving the reducer change is the sole cause of the reversal above.
env GARDEN=fh GARDEN_REP_FLAT_PROVIDERS= GARDEN_STATE="$TR/state-off" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    "$JOBS/reputation-reduce.sh" > "$TR/roff.log" 2>&1 || true
VOFF="$TR/voff"; verify_clone "$BARE" "$VOFF"
read -r oatt oacc omean om2 ocen oest <<<"$(rep_read_projection "$VOFF" "$anth_rel")"
if [ "$ocen" = 0 ] && awk -v m="$omean" 'BEGIN{exit !(m>7.49 && m<7.51)}'; then
  ok "control: policy OFF leaves anthropic LEDGER-priced (cen=0 mean=\$$omean) — the reducer is the reversal"
else
  bad "control (policy off) did not restore the ledger mean (cen=$ocen mean=$omean)"
fi
rm -rf "$TR"

# ============================================================================
hr; echo "WRITE-TIME — a flat completion records evidence but censors the folded aggregate"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/flat-write.XXXXXX")"
# One todo job for the gardener spine to claim and complete, in the first commit.
BARE="$(seed_board "$TR" flat-job "role: builder")"
# A stub handler that hands off a MEASURED provider dollar (as gardener-claude.sh does).
HANDLER="$TR/handler.sh"
cat > "$HANDLER" <<'EOF'
#!/bin/bash
printf 'done\n<<<GARDEN-JOB-COMPLETE>>>\n' > "$3"
printf '%s\n' '{"source":"result","model":"claude-opus-4-8","input_tokens":100,"output_tokens":20,"total_cost_usd":0.5}' > "$GARDEN_USAGE_FILE"
: > "$GARDEN_COMPLETION_SENTINEL"
EOF
chmod +x "$HANDLER"
# Policy ON: gardener kind resolves provider=anthropic, which is flat by default.
# GARDEN_JOB_HANDLER_BASH=1: run the stub via `bash` so a noexec $TMPDIR (garden hosts
# mount /tmp noexec) cannot fail the handler with rc=126 — the sanctioned test seam.
env GARDEN=flatw GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    GARDEN_WORKER_KIND=gardener GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 \
    GARDEN_JOB_HANDLER="$HANDLER" GARDEN_JOB_HANDLER_BASH=1 \
    "$JOBS/gardener.sh" 1 > "$TR/w.log" 2>&1 || true
V="$TR/v"; verify_clone "$BARE" "$V"
ev="$V/reputation/events/flat-job.md"
if [ -f "$ev" ]; then
  ok "flat completion recorded a reputation event"
  ad="$(plan_field "$ev" agentic_dollars)"
  awk -v a="$ad" 'BEGIN{exit !(a>0.49 && a<0.51)}' \
    && ok "agentic_dollars=\$$ad preserved as audit evidence (the notional ledger reading)" \
    || bad "agentic_dollars not preserved ($ad)"
  [ "$(plan_field "$ev" aggregate_dollars)" = censored ] \
    && ok "aggregate_dollars censored (the folded figure the reducer sees)" \
    || bad "aggregate_dollars not censored ($(plan_field "$ev" aggregate_dollars))"
  cs="$(plan_field "$ev" cost_source)"
  case "$cs" in wallclock|none) ok "cost_source=$cs (proxy path, not 'ledger')" ;; *) bad "cost_source should be proxy, got '$cs'" ;; esac
  # The usage ledger row still carries the real notional dollars for the auditor.
  grep -q '"total_cost_usd":0.5' "$V/usage/flat-job.jsonl" 2>/dev/null \
    && ok "usage/flat-job.jsonl still carries the raw total_cost_usd (audit evidence intact)" \
    || bad "usage ledger row lost total_cost_usd"
else
  bad "no reputation event written (w.log: $(tail -3 "$TR/w.log" | tr '\n' '|'))"
fi
rm -rf "$TR"

hr
echo "flat-provider-censor-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
