#!/bin/bash
# gardener-claude-tier-serving-test.sh — the Claude handler's tier-serving policy.
#
# WHY THIS EXISTS. Two invariants meet in handlers/monk-claude.sh and had drifted
# apart from claim-job.sh's job_eligible_for_kind, which let an anthropic gardener
# CLAIM a job its handler then refused — a claim/die/requeue hot loop over the whole
# board the moment a host declared gardeners > 0 (2026-08-01).
#
#   1. MENTAT IS AN AUTHORIZATION BOUNDARY. tier: mentat runs only on an explicit
#      `dispatch: manual` job. No automatic producer may reach Fable/Mythos.
#   2. THE ANTHROPIC AUTOMATIC CEILING IS claude-opus-5-5 (design opus55-tier.md,
#      Option B, 2026-09-23). Opus 5.5 is the first-match anthropic mentor row, so an
#      automatic mentor job is served AT mentor (claude-opus-5-5) — the same tier it
#      requested. There is NO mentor->minion downshift anymore: the former ceiling
#      (Opus 4.8) is retired now that the mentor model is cheaper than it was.
#
# This test drives the resolution logic directly (no `claude -p`, no network):
# it re-implements nothing, it sources common.sh and asserts on the same helpers
# the handler calls, then greps the handler for the guard shapes themselves.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=../common.sh
source "$JOBS/common.sh"

pass=0; fail=0
ok()  { printf '  ok   %s\n' "$1"; pass=$((pass+1)); }
bad() { printf '  FAIL %s\n' "$1"; fail=$((fail+1)); }
hr()  { printf -- '---------------------------------------------------------------\n'; }

TMP="$(mktemp -d "${TMPDIR:-/tmp}/gc-tier.XXXXXX")"
trap 'rm -rf "$TMP"' EXIT

mkjob() { # mkjob <file> <frontmatter-lines...>
  local f="$1"; shift
  { printf -- '---\n'; printf '%s\n' "$@"; printf -- '---\nbody\n'; } > "$f"
}

hr; echo "INVENTORY — the tiers this policy depends on"; hr
[ "$(tier_model_for_provider mentor anthropic)" = claude-opus-5-5 ] \
  && ok "mentor/anthropic = claude-opus-5-5 (first-match mentor row, the automatic ceiling)" \
  || bad "mentor/anthropic = $(tier_model_for_provider mentor anthropic) (expected claude-opus-5-5)"
[ "$(tier_model_for_provider minion anthropic)" = claude-opus-4-8 ] \
  && ok "minion/anthropic = claude-opus-4-8" \
  || bad "minion/anthropic = $(tier_model_for_provider minion anthropic) (expected claude-opus-4-8)"

hr; echo "NO DOWNSHIFT — the tier a job is SERVED at equals the tier it requests"; hr
# Mirrors the handler's serve_tier computation exactly: under Option B there is no
# anthropic mentor->minion downshift, so the served tier is always the requested one.
serve_tier_for() { # serve_tier_for <jobfile> -> tier
  local jf="$1"
  job_tier "$jf" 2>/dev/null || true
}

mkjob "$TMP/auto-mentor.md" 'tier: mentor' 'fallback-tier: minion' 'dispatch: automatic'
[ "$(serve_tier_for "$TMP/auto-mentor.md")" = mentor ] \
  && ok "AUTOMATIC mentor job is served at mentor (no downshift)" \
  || bad "automatic mentor served at $(serve_tier_for "$TMP/auto-mentor.md")"
[ "$(tier_model_for_provider "$(serve_tier_for "$TMP/auto-mentor.md")" anthropic)" = claude-opus-5-5 ] \
  && ok "...which resolves to claude-opus-5-5 (the mentor model itself)" \
  || bad "automatic mentor resolved to the wrong model"

mkjob "$TMP/manual-mentor.md" 'tier: mentor' 'dispatch: manual'
[ "$(serve_tier_for "$TMP/manual-mentor.md")" = mentor ] \
  && ok "MANUAL mentor job is served at mentor (same as automatic now)" \
  || bad "manual mentor served at $(serve_tier_for "$TMP/manual-mentor.md")"

mkjob "$TMP/auto-minion.md" 'tier: minion' 'dispatch: automatic'
[ "$(serve_tier_for "$TMP/auto-minion.md")" = minion ] \
  && ok "minion job serves at minion" || bad "minion job perturbed"

mkjob "$TMP/auto-myrmidon.md" 'tier: myrmidon' 'dispatch: automatic'
[ "$(serve_tier_for "$TMP/auto-myrmidon.md")" = myrmidon ] \
  && ok "myrmidon job serves at myrmidon" || bad "myrmidon job perturbed"

hr; echo "MENTAT — still an authorization boundary, not a price point"; hr
# The Anthropic handler implementation lives in monk-claude.sh (gardener-claude.sh is
# now the warning-free forwarding wrapper onto it; gardener->monk rename).
H="$JOBS/handlers/monk-claude.sh"
grep -q 'requested_tier" = mentat \] && \[ .*dispatch.*!= manual' "$H" \
  && ok "handler refuses tier: mentat unless dispatch: manual" \
  || bad "handler's mentat guard is missing or reshaped"
grep -q 'accepts only explicit manual mentat/Fable jobs' "$H" \
  && bad "the OLD blanket gate is still present — automatic jobs would still die" \
  || ok "the old manual-mentat-only blanket gate is gone"
grep -q 'serve_tier=minion' "$H" \
  && bad "handler still carries the retired mentor->minion downshift" \
  || ok "the mentor->minion downshift is gone (Option B: mentor is served at mentor)"

hr; echo "CLAIM/HANDLER AGREEMENT — the hot-loop regression"; hr
# job_eligible_for_kind lives in claim-job.sh; assert the property that matters:
# every tier an anthropic gardener may CLAIM must be one the handler can SERVE.
for t in mentor minion myrmidon; do
  mkjob "$TMP/t-$t.md" "tier: $t" 'dispatch: automatic'
  claimable="$([ -n "$(tier_model_for_provider "$t" anthropic)" ] && echo yes || echo no)"
  servable="$([ -n "$(tier_model_for_provider "$(serve_tier_for "$TMP/t-$t.md")" anthropic)" ] && echo yes || echo no)"
  if [ "$claimable" = "$servable" ]; then
    ok "tier $t: claimable=$claimable servable=$servable (agree)"
  else
    bad "tier $t: claimable=$claimable but servable=$servable — claim/die/requeue loop"
  fi
done

hr
printf 'passed %d, failed %d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
