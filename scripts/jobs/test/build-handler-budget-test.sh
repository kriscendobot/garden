#!/bin/bash
# build-handler-budget-test.sh: per-role/stage default handler budgets and the
# gardener/reaper agreement they must preserve.
#
# WHY THIS EXISTS. GARDEN_HANDLER_TIMEOUT (2400s) is right for an ordinary job and
# wrong for a BUILD, which runs a full install+compile+test pass and exceeds 40
# minutes by construction. The only remedy used to be a per-job `handler-timeout:`
# header the producer had to remember; when they forgot, the handler was
# SIGTERM-killed at 2400s on every requeue, made no progress, and the reaper
# doomed it as a deterministic overrun after one cycle
# (ebfb-pr882-bootstrap-generators, 2026-08-01). Build roles now default higher.
#
# THE DANGEROUS FAILURE is not a short budget — it is DISAGREEMENT. gardener.sh
# runs the handler under `timeout <budget>`; reaper.sh decides when a claim is
# stale from its own view of the same budget. If the reaper thinks 2400s while a
# 7200s build is still running, it requeues that base onto a SECOND gardener and
# two handlers write one worktree. Both therefore call the SAME helper, and this
# test asserts they cannot drift.
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=../common.sh
source "$JOBS/common.sh"

pass=0; fail=0
ok()  { printf '  ok   %s\n' "$1"; pass=$((pass+1)); }
bad() { printf '  FAIL %s\n' "$1"; fail=$((fail+1)); }
hr()  { printf -- '---------------------------------------------------------------\n'; }

TMP="$(mktemp -d "${TMPDIR:-/tmp}/build-budget.XXXXXX")"
trap 'rm -rf "$TMP"' EXIT
mk() { printf -- '---\n%s\n---\nbody\n' "$2" > "$TMP/$1.md"; }

hr; echo "PER-ROLE DEFAULT"; hr
mk builder     'role: builder'
mk webbuilder  'role: web-builder'
mk fixer       'role: fixer'
mk designer    'role: designer'
mk norole      'tier: mentor'
mk conductor   'role: conductor'
mk review      'handler-budget-role: review'
mk panel       'role: gardener
gauntlet_stage: panel'
mk botanist    'role: botanist'
mk shepherd    'role: shepherd'

[ "$(job_handler_budget_base "$TMP/builder.md")" = 7200 ] \
  && ok "builder defaults to 7200s" || bad "builder base = $(job_handler_budget_base "$TMP/builder.md")"
[ "$(job_handler_budget_base "$TMP/webbuilder.md")" = 7200 ] \
  && ok "web-builder defaults to 7200s" || bad "web-builder base wrong"
[ "$(job_handler_budget_base "$TMP/fixer.md")" = 2400 ] \
  && ok "fixer keeps the 2400s fleet default" || bad "fixer base changed"
[ "$(job_handler_budget_base "$TMP/designer.md")" = 2400 ] \
  && ok "designer keeps the fleet default (a design is not a build)" || bad "designer base changed"
[ "$(job_handler_budget_base "$TMP/norole.md")" = 2400 ] \
  && ok "a role-less job keeps the fleet default" || bad "role-less base changed"
[ "$(job_handler_budget_base "$TMP/conductor.md")" = 7200 ] \
  && ok "conduct/merge defaults to 7200s (above the 5400s CI wait)" || bad "conductor base wrong"
[ "$(job_handler_budget_base "$TMP/review.md")" = 7200 ] \
  && ok "review directive defaults to 7200s" || bad "review base wrong"
[ "$(job_handler_budget_base "$TMP/panel.md")" = 7200 ] \
  && ok "panel stage defaults to 7200s" || bad "panel base wrong"
[ "$(job_handler_budget_base "$TMP/botanist.md")" = 7200 ] \
  && ok "botanist defaults to 7200s" || bad "botanist base wrong"
[ "$(job_handler_budget_base "$TMP/shepherd.md")" = 7200 ] \
  && ok "shepherd defaults to 7200s" || bad "shepherd base wrong"

hr; echo "GARDENER / REAPER AGREEMENT — the duplicate-execution guard"; hr
# Assert every deadline-sensitive consumer calls the same applied calculation.
grep -q 'applied_handler_budget "\$jobfile"' "$JOBS/gardener.sh" \
  && ok "gardener.sh uses applied_handler_budget" \
  || bad "gardener.sh does not use the shared applied-budget helper"
grep -q 'applied_handler_budget "\$f"' "$JOBS/reaper.sh" \
  && ok "reaper.sh uses applied_handler_budget" \
  || bad "reaper.sh does not use the shared applied-budget helper"
grep -q 'applied_handler_budget "\$job_file"' "$JOBS/deadline-nudge.sh" \
  && ok "deadline-nudge.sh uses applied_handler_budget" \
  || bad "deadline-nudge.sh does not use the shared applied-budget helper"
grep -q 'budget="\$GARDEN_HANDLER_TIMEOUT"' "$JOBS/reaper.sh" \
  && bad "reaper.sh still seeds its budget from the flat fleet default" \
  || ok "reaper.sh no longer seeds from the flat fleet default"

hr; echo "THE CLAIM-SCOPING INVARIANT still holds for a build"; hr
# budget + KILL_AFTER < CLAIM_TTL, using the defaults the units ship with.
ttl="${GARDEN_CLAIM_TTL:-14400}"; killafter="${GARDEN_HANDLER_KILL_AFTER:-60}"
b="$(job_handler_budget_base "$TMP/builder.md")"
if [ $(( b + killafter )) -lt "$ttl" ]; then
  ok "build default ${b}s + kill-after ${killafter}s < claim TTL ${ttl}s"
else
  bad "build default ${b}s breaks the single-owner invariant against TTL ${ttl}s"
fi
budget_max=$(( ttl - killafter - 1 ))
[ "$b" -le "$budget_max" ] \
  && ok "build default is within the claim budget max (${budget_max}s)" \
  || bad "build default exceeds the claim budget max"

hr; echo "EXPLICIT HEADER STILL WINS, in both directions"; hr
mk bigger  'role: builder
handler-timeout: 10800'
mk smaller 'role: builder
handler-timeout: 600'
# The header is applied at the call sites, over this base; assert the base is
# what they start from and that the header is visible to both.
[ "$(sed -n 's/^handler-timeout:[[:space:]]*//p' "$TMP/bigger.md" | head -1)" = 10800 ] \
  && ok "a builder may still declare a LARGER explicit budget" || bad "larger header lost"
[ "$(sed -n 's/^handler-timeout:[[:space:]]*//p' "$TMP/smaller.md" | head -1)" = 600 ] \
  && ok "a builder may still declare a SMALLER explicit budget" || bad "smaller header lost"
[ "$(applied_handler_budget "$TMP/bigger.md")" = 10800 ] \
  && ok "larger explicit budget is applied" || bad "larger explicit budget not applied"
[ "$(applied_handler_budget "$TMP/smaller.md")" = 600 ] \
  && ok "smaller explicit budget is applied" || bad "smaller explicit budget not applied"
mk invalid 'role: builder
handler-timeout: twelve'
[ "$(applied_handler_budget "$TMP/invalid.md")" = 7200 ] \
  && ok "invalid explicit budget leaves the per-role base in force" || bad "invalid explicit budget changed the base"
mk clamped 'role: builder
handler-timeout: 20000'
[ "$(applied_handler_budget "$TMP/clamped.md")" = 14339 ] \
  && ok "overlarge explicit budget is clamped to the claim ceiling" || bad "claim-ceiling clamp wrong"
mk paneloverride 'role: gardener
gauntlet_stage: panel
handler-timeout: 600'
[ "$(applied_handler_budget "$TMP/paneloverride.md")" = 600 ] \
  && ok "explicit handler-timeout still wins over a panel stage default" || bad "panel explicit override lost"

hr; echo "PATH PREPEND IS IDEMPOTENT"; hr
( PATH=/usr/bin:/bin
  # shellcheck source=../common.sh
  source "$JOBS/common.sh"
  source "$JOBS/common.sh"
  source "$JOBS/common.sh"
  count="$(printf '%s' "$PATH" | tr ':' '\n' | grep -Fxc "$GARDEN_BIN")"
  [ "$count" -eq 1 ] ) \
  && ok "repeated common.sh sourcing leaves one leading jobs/bin entry" \
  || bad "repeated common.sh sourcing stacked jobs/bin in PATH"

hr; echo "THE KNOB"; hr
( export GARDEN_BUILD_HANDLER_TIMEOUT=2400
  # shellcheck source=../common.sh
  source "$JOBS/common.sh"
  [ "$(role_default_handler_timeout builder)" = 2400 ] ) \
  && ok "GARDEN_BUILD_HANDLER_TIMEOUT=2400 retires the distinction" \
  || bad "the knob does not override the build default"

hr
printf 'passed %d, failed %d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
