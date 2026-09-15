#!/bin/bash
# panel-per-section-provenance-test.sh — regression guard for PER-SECTION
# provenance footnotes in the panel aggregate (scripts/jobs/gardening/panel.sh +
# scripts/jobs/comment-provenance.sh).
#
# THE PROBLEM: the panel aggregate is a body STITCHED from many seats, each its own
# `claude -p` invocation that can run at a different model/tier than its peers. The
# gh wrapper's single WHOLE-BODY provenance footer names one set of facts and so
# misattributes every seat but one. The posted panel review is the aggregate
# verbatim, so a reader cannot tell which model/harness/provider produced which
# seat's verdict.
#
# THE FIX: as each seat's block is aggregated, panel.sh appends a PER-SECTION
# footnote (seat_provenance_footnote → provenance_footnote_for_kind) naming THAT
# seat's own facts, in the same <sub> style as the whole-body footer but carrying a
# distinct section marker so it does not suppress the closing whole-body footer.
#
# SUBTEST 1 — the aggregate carries one footnote PER seat, and seats with different
#             (mocked) facts get DISTINCT footnotes (not one repeated line).
# SUBTEST 2 — a deterministic seat (no LLM) footnotes as `automatic`.
# SUBTEST 3 — fail-open: with the provenance hook OFF and no job facts in the env,
#             the aggregate simply carries NO footnotes (seat blocks intact).
#
# Hermetic: the seat review, the disposition decider, the appellate and the un-draft
# are env-stubbed, so NO real `claude -p` and NO network.
#
# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never fails).
# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-per-section-prov.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }
trap 'rm -rf "$TR"' EXIT

# Committed in-repo stubs (the test scratch is a noexec mount; panel.sh runs hooks
# directly). The seat stub emits a seat-identifying verdict block.
STUB_SEAT="$HERE/panel-parallel-fanout-stub.sh"
STUB_DECIDE="$HERE/panel-decide-stub.sh"          # prints `pass`
STUB_PROV="$HERE/panel-per-section-provenance-stub.sh"
SECTION_MARKER="garden-provenance-section"

SEATS="assessor typist stylist"
mkdir -p "$TR/wt"   # non-git worktree → code panel

run_panel() {  # run_panel <rundir> [seat-provenance-hook]
  FAN_DIR="$TR/fan" FAN_SLEEP=0 \
  GARDEN_CODE_SEATS="$SEATS" \
  GARDEN_PANEL_CONCURRENCY=3 \
  GARDEN_PANEL_SEAT="$STUB_SEAT" \
  GARDEN_PANEL_DECIDE="$STUB_DECIDE" \
  GARDEN_PANEL_APPELLATE=":" \
  GARDEN_PANEL_UNDRAFT="true" \
  GARDEN_PANEL_SEAT_ATTEMPTS=1 \
  GARDEN_PANEL_SEAT_BACKOFF=0 \
  GARDEN_PANEL_SEAT_PROVENANCE="${2:-}" \
  GARDEN_PANEL_RUNDIR="$1" \
    bash "$PANEL" "$TR/wt" 999 HEAD~1
}

hr; echo "SUBTEST 1 — distinct per-seat footnotes in the aggregate"; hr
run_panel "$TR/rd" "$STUB_PROV" >/dev/null 2>&1; rc=$?
AGG="$TR/rd/round-1.md"
[ "$rc" -eq 0 ] && ok "panel with per-section provenance exits 0" || bad "panel exited $rc"

nfoot="$(grep -c "$SECTION_MARKER" "$AGG" 2>/dev/null || true)"
[ "$nfoot" = 3 ] \
  && ok "one per-section footnote per seat (3 seats → 3 footnotes)" \
  || bad "expected 3 per-section footnotes, got $nfoot in $AGG"

# assessor (monk → anthropic/claude) and typist (cleric → openai/codex) differ.
grep -A5 '^### assessor' "$AGG" | grep -q "provider <code>anthropic</code>" \
  && grep -A5 '^### assessor' "$AGG" | grep -q "harness <code>claude</code>" \
  && grep -A5 '^### assessor' "$AGG" | grep -q "claude-opus-5" \
  && ok "assessor's footnote names its own facts (claude-opus-5 / claude / anthropic)" \
  || bad "assessor footnote wrong: $(grep -A5 '^### assessor' "$AGG")"
grep -A5 '^### typist' "$AGG" | grep -q "provider <code>openai</code>" \
  && grep -A5 '^### typist' "$AGG" | grep -q "harness <code>codex</code>" \
  && grep -A5 '^### typist' "$AGG" | grep -q "gpt-5" \
  && ok "typist's footnote names its own DIFFERENT facts (gpt-5 / codex / openai)" \
  || bad "typist footnote wrong: $(grep -A5 '^### typist' "$AGG")"

# The two footnotes are genuinely distinct lines (not one repeated whole-body footer).
ndistinct="$(grep "$SECTION_MARKER" "$AGG" | sort -u | wc -l | tr -d ' ')"
[ "$ndistinct" = 3 ] \
  && ok "the three footnotes are DISTINCT (per-seat, not one repeated line)" \
  || bad "expected 3 distinct footnotes, got $ndistinct distinct lines"

# The seat verdict blocks themselves are intact and precede their footnotes.
[ "$(grep -c '^### ' "$AGG")" = 3 ] \
  && ok "every seat block still reached the aggregate" \
  || bad "aggregate holds $(grep -c '^### ' "$AGG") seat blocks; expected 3"

hr; echo "SUBTEST 2 — a deterministic seat footnotes as 'automatic'"; hr
stylist_sec="$(grep -A5 '^### stylist' "$AGG")"
{ printf '%s' "$stylist_sec" | grep -q "model <code>automatic</code>" \
  && ! printf '%s' "$stylist_sec" | grep -q "harness <code>"; } \
  && ok "stylist (no-LLM) → 'model automatic' footnote (harness/provider omitted)" \
  || bad "stylist automatic footnote wrong: $stylist_sec"

hr; echo "SUBTEST 3 — fail-open: no hook + no job facts → no footnotes, blocks intact"; hr
( unset GARDEN_JOB_MODEL GARDEN_WORKER_KIND
  run_panel "$TR/rd-open" >/dev/null 2>&1 )
AGG2="$TR/rd-open/round-1.md"
nfoot2="$(grep -c "$SECTION_MARKER" "$AGG2" 2>/dev/null || true)"
{ [ "$nfoot2" = 0 ] && [ "$(grep -c '^### ' "$AGG2")" = 3 ]; } \
  && ok "no facts and no hook → zero footnotes, all 3 seat blocks intact (fail-open)" \
  || bad "fail-open aggregate wrong: footnotes=$nfoot2 blocks=$(grep -c '^### ' "$AGG2")"

hr
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
