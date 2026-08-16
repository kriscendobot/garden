#!/bin/bash
# monk-worker-kind-compat-test.sh — the gardener->monk worker-kind rename,
# compatibility release (design anthropic-worker-kind-monk.md § Journal contract,
# § Staged, reversible rollout stage 0). Hermetic; no systemd, no network.
#
# Proves the compatibility guarantees that let a host run the pre-rename pool
# UNCHANGED while the new vocabulary is present and readable:
#
#   DECODER      — canonical_worker_kind is the SOLE decoder: v1 `gardener` -> monk,
#                  a known v2 kind unchanged, an unknown / contradictory tuple
#                  rejected with NO silent fallback; the v1 Anthropic fixture decodes
#                  to the monk/anthropic/claude identity.
#   DUAL PROJ    — the reducer folds a v1 `kind: gardener` event and a v2 `kind: monk`
#                  event for the SAME arm into ONE posterior, and writes BOTH the
#                  canonical reputation/arms/monk/... and the legacy
#                  reputation/arms/gardener/... projection, BYTE-EQUIVALENT except the
#                  `kind:` field — so an old binary (reads gardener/) and a new one
#                  (reads monk/) see the same numbers and a rollback never cold-starts
#                  the auction. A non-Anthropic kind (cleric) is written once, no alias.
#   COUNT/EXCL   — anthropic_active_kind reads `monks:` first, then the legacy
#                  `gardeners:`, never summing; set-monks.sh writes the `monks:` line
#                  while preserving a sibling `gardeners:` mirror; the two Anthropic
#                  spellings never both arm.
#
# Usage: monk-worker-kind-compat-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (this suite may run AS a board job under a live gardener).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_|AUCTION_)' || true) 2>/dev/null || true
export GARDEN_TEST=1 GARDEN_ROOT="$ROOT" GARDEN_NO_MAINTAINER_ALERT=1
# Use `anthropic` as a generic priced stand-in so the reducer folds a real numeric
# aggregate rather than censoring it to the wallclock proxy (as auction-reputation-test
# does for its ledger math). The dual-projection invariant is independent of pricing.
export GARDEN_REP_FLAT_PROVIDERS=
# shellcheck source=../common.sh
source "$JOBS/common.sh"

git_id=(-c user.name=test -c user.email=test@localhost)

# ============================================================================
hr; echo "DECODER — canonical_worker_kind, the SOLE worker-kind decoder"; hr
[ "$(canonical_worker_kind gardener)"       = monk ]   && ok "v1 gardener (no schema) -> monk"        || bad "v1 gardener decode"
[ "$(canonical_worker_kind gardener 1)"     = monk ]   && ok "v1 gardener (schema 1) -> monk"         || bad "schema-1 gardener decode"
[ "$(canonical_worker_kind monk)"           = monk ]   && ok "v2 monk -> monk"                        || bad "monk decode"
[ "$(canonical_worker_kind cleric)"         = cleric ] && ok "cleric unchanged"                       || bad "cleric decode"
[ "$(canonical_worker_kind hermit)"         = hermit ] && ok "hermit unchanged"                       || bad "hermit decode"
canonical_worker_kind gardener 2 >/dev/null 2>&1 && bad "v2-schema 'gardener' must reject" || ok "v2-schema 'gardener' rejected (no such v2 spelling)"
canonical_worker_kind friar     >/dev/null 2>&1 && bad "unknown kind must reject"          || ok "unknown kind rejected (no silent fallback)"
canonical_worker_kind '' 2      >/dev/null 2>&1 && bad "empty kind must reject"            || ok "empty raw kind rejected"
# The v1 Anthropic fixture decodes to the full monk/anthropic/claude identity.
ck="$(canonical_worker_kind gardener)"
[ "$(worker_kind_field "$ck" provider)"  = anthropic ] && ok "v1 fixture provider -> anthropic" || bad "v1 fixture provider"
[ "$(worker_kind_field "$ck" agent_bin)" = claude ]    && ok "v1 fixture runtime  -> claude"    || bad "v1 fixture runtime"
# The contradiction guard: a monk tuple whose provider is not anthropic is rejected.
canonical_worker_kind monk 2 openai >/dev/null 2>&1 && bad "monk/openai tuple must reject" || ok "contradictory monk/openai tuple rejected"
[ "$(canonical_worker_kind monk 2 anthropic)" = monk ] && ok "monk/anthropic tuple accepted" || bad "monk/anthropic tuple"

# ============================================================================
hr; echo "DUAL PROJECTION — reducer pools gardener+monk events, writes both spellings"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/monk-dual.XXXXXX")"
BARE="$TR/journal.git"; SEED="$TR/seed"; BR=journal2
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BR"
(
  cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/bids work hosts msgs \
           reputation/events reputation/pending reputation/arms reputation/adjustments \
           reputation/verdicts reputation/reviews
  for d in jobs/todo jobs/doin jobs/tada jobs/bids work reputation/events reputation/pending \
           reputation/arms reputation/adjustments reputation/verdicts reputation/reviews; do touch "$d/.gitkeep"; done
  # write_event <base> <kind-line...> — a finalized, accepted, ledger-priced event
  # for ONE fixed arm (provider anthropic / model claude-opus-4-8 / medium / fix:m /
  # main2). The v1 event carries `kind: gardener` and NO worker_kind_schema; the v2
  # event carries `kind: monk` + `worker_kind_schema: 2`. They describe the SAME arm.
  ev() { # ev <base> <kind> [schema]
    local base="$1" kind="$2" schema="${3:-}"
    {
      printf -- '---\n'
      printf 'base: %s\n' "$base"
      printf 'kind: %s\n' "$kind"
      [ -n "$schema" ] && printf 'worker_kind_schema: %s\n' "$schema"
      printf 'provider: anthropic\nmodel: claude-opus-4-8\nthoughtfulness: medium\n'
      printf 'work_class: fix:m\ntarget: main2\naccepted: true\n'
      printf 'agentic_dollars: 6.000000\nhuman_dollars: 0\naggregate_dollars: 6.000000\n'
      printf 'cost_source: ledger\nattempts: 1\nduration_secs: 100\nawarded_bid:\nbidders: 0\n'
      printf 'source: live\n---\nevent\n'
    } > "reputation/events/$base.md"
  }
  ev v1job gardener
  ev v2job monk 2
  # a cleric event for a DIFFERENT arm — proves a non-Anthropic kind gets no alias.
  {
    printf -- '---\nbase: clericjob\nkind: cleric\nprovider: openai\nmodel: gpt-5.6-terra\n'
    printf 'thoughtfulness: medium\nwork_class: fix:m\ntarget: main2\naccepted: true\n'
    printf 'agentic_dollars: 4.000000\nhuman_dollars: 0\naggregate_dollars: 4.000000\n'
    printf 'cost_source: ledger\nattempts: 1\nduration_secs: 50\nsource: live\n---\nevent\n'
  } > "reputation/events/clericjob.md"
)
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BR"

env GARDEN=rh GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BR" \
    GARDEN_REP_FLAT_PROVIDERS= "$JOBS/reputation-reduce.sh" > "$TR/reduce.log" 2>&1 || true

V="$TR/v"; git clone -q --single-branch --branch "$BR" "$BARE" "$V" 2>/dev/null
MONK="$V/reputation/arms/monk/anthropic/claude-opus-4-8/medium/fix-m@main2.md"
GARD="$V/reputation/arms/gardener/anthropic/claude-opus-4-8/medium/fix-m@main2.md"
CLER_M="$V/reputation/arms/cleric/openai/gpt-5.6-terra/medium/fix-m@main2.md"
CLER_ALIAS="$V/reputation/arms/monk/openai/gpt-5.6-terra/medium/fix-m@main2.md"

{ [ -f "$MONK" ] && [ -f "$GARD" ]; } && ok "both spellings projected (monk/ AND gardener/)" || bad "dual projection missing (monk=$([ -f "$MONK" ]&&echo y||echo n) gardener=$([ -f "$GARD" ]&&echo y||echo n))"

# Pooling: the v1 gardener event and the v2 monk event fold into ONE arm -> attempts 2.
if [ -f "$MONK" ]; then
  matt="$(sed -n 's/^attempts:[[:space:]]*//p' "$MONK" | head -1)"
  macc="$(sed -n 's/^accepts:[[:space:]]*//p'  "$MONK" | head -1)"
  { [ "$matt" = 2 ] && [ "$macc" = 2 ]; } && ok "gardener + monk events POOLED into one arm (attempts=2 accepts=2)" || bad "events not pooled (attempts=$matt accepts=$macc, expected 2/2)"
else
  bad "no monk arm to check pooling"
fi

# BYTE-EQUIVALENCE: the two files differ ONLY in the `kind:` line (design invariant).
if [ -f "$MONK" ] && [ -f "$GARD" ]; then
  [ "$(sed -n 's/^kind:[[:space:]]*//p' "$MONK" | head -1)" = monk ]     && ok "monk projection carries kind: monk"        || bad "monk projection kind field"
  [ "$(sed -n 's/^kind:[[:space:]]*//p' "$GARD" | head -1)" = gardener ] && ok "gardener projection carries kind: gardener" || bad "gardener projection kind field"
  # Strip the kind line from each and diff the remainder: must be identical.
  grep -v '^kind:' "$MONK" > "$TR/m.body"
  grep -v '^kind:' "$GARD" > "$TR/g.body"
  if diff -q "$TR/m.body" "$TR/g.body" >/dev/null 2>&1; then
    ok "monk/ and gardener/ projections are BYTE-EQUIVALENT except the kind field"
  else
    bad "projections differ beyond the kind field:"; diff "$TR/m.body" "$TR/g.body" | sed 's/^/      /'
  fi
  # And only the kind line differs across the WHOLE files (exactly one changed line pair).
  ndiff="$(diff "$MONK" "$GARD" | grep -c '^[<>] kind:' || true)"
  [ "$ndiff" -eq 2 ] && ok "the ONLY differing line is kind: (one < and one >)" || bad "unexpected differing lines ($ndiff kind-line halves)"
else
  bad "cannot compare projections (a spelling is missing)"
fi

# A non-Anthropic kind is written ONCE (no monk alias for a cleric arm).
{ [ -f "$CLER_M" ] && [ ! -f "$CLER_ALIAS" ]; } && ok "cleric arm written once (no monk alias for a non-Anthropic kind)" || bad "cleric arm aliasing wrong (cleric=$([ -f "$CLER_M" ]&&echo y||echo n) alias=$([ -f "$CLER_ALIAS" ]&&echo y||echo n))"

# IDEMPOTENCE with the dual projection in place: a second reduce is a no-op commit.
before="$(git -C "$V" rev-parse HEAD)"
env GARDEN=rh GARDEN_STATE="$TR/state2" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BR" \
    GARDEN_REP_FLAT_PROVIDERS= "$JOBS/reputation-reduce.sh" > "$TR/reduce2.log" 2>&1 || true
V2="$TR/v2"; git clone -q --single-branch --branch "$BR" "$BARE" "$V2" 2>/dev/null
[ "$(git -C "$V2" rev-parse HEAD)" = "$before" ] && ok "reducer idempotent with the dual projection (second tick no-ops)" || bad "reducer churned on the dual projection"
rm -rf "$TR"

# ============================================================================
hr; echo "COUNT / EXCLUSIVITY — monks: first, legacy gardeners: mirror, never both"; hr
CT="$(mktemp -d "${TMPDIR:-/tmp}/monk-count.XXXXXX")"
: > "$CT/h";                              [ "$(anthropic_active_kind "$CT/h")" = gardener ] && ok "no count line -> legacy gardener active"        || bad "active none"
printf 'gardeners: 4\n' > "$CT/h";        [ "$(anthropic_active_kind "$CT/h")" = gardener ] && ok "only gardeners: -> gardener active (pre-cutover)" || bad "active gardeners"
printf 'monks: 3\ngardeners: 4\n' > "$CT/h"; [ "$(anthropic_active_kind "$CT/h")" = monk ]   && ok "monks: present (mirror retained) -> monk wins, never summed" || bad "active monk"
# set-monks.sh writes the monks: line via a producer clone, preserving a sibling
# gardeners: mirror. anthropic is exempt from the backend probe (declarable ahead of
# the Claude login), so no GARDEN_FORCE_DECLARE is needed.
SBARE="$CT/producer.git"; SSEED="$CT/pseed"
git init -q --bare "$SBARE"; git init -q "$SSEED"; git -C "$SSEED" checkout -q -b journal2
( cd "$SSEED"; mkdir -p hosts; printf 'gardeners: 4\n' > hosts/mhost )
git -C "$SSEED" add -A; git -C "$SSEED" "${git_id[@]}" commit -q -m seed
git -C "$SSEED" remote add origin "$SBARE"; git -C "$SSEED" push -q -u origin journal2
env GARDEN=mhost GARDEN_TEST=1 GARDEN_STATE="$CT/state" GARDEN_PRODUCER_CLONE="$CT/state/producer/journal" \
    JOURNAL_REMOTE="$SBARE" JOURNAL_BRANCH=journal2 \
    "$JOBS/set-monks.sh" 3 mhost > "$CT/setmonks.log" 2>&1; smrc=$?
PV="$CT/pv"; git clone -q --single-branch --branch journal2 "$SBARE" "$PV" 2>/dev/null
if [ "$smrc" -eq 0 ]; then
  { grep -q '^monks: 3$' "$PV/hosts/mhost" && grep -q '^gardeners: 4$' "$PV/hosts/mhost"; } \
    && ok "set-monks.sh wrote 'monks: 3' and preserved the 'gardeners: 4' mirror (never summed)" \
    || bad "set-monks host file wrong: $(tr '\n' ' ' < "$PV/hosts/mhost")"
  [ "$(anthropic_active_kind "$PV/hosts/mhost")" = monk ] && ok "after set-monks the host's active Anthropic kind is monk" || bad "post set-monks active kind"
else
  bad "set-monks.sh failed (rc=$smrc): $(cat "$CT/setmonks.log")"
fi
rm -rf "$CT"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
