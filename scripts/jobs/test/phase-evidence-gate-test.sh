#!/bin/bash
# phase-evidence-gate-test.sh -- prevention + panel-sensing regression coverage.

# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GARDENING="$(cd "$HERE/../gardening" && pwd)"
GATE="$GARDENING/phase-evidence-gate.sh"
PANEL="$GARDENING/panel.sh"
SEAT_STUB="$HERE/phase-evidence-panel-seat-stub.sh"
DECIDE_STUB="$HERE/panel-decide-stub.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/phase-evidence-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

WT="$TR/wt"
mkdir -p "$WT/designs" "$WT/src"
git -C "$WT" init -q
git -C "$WT" config user.email t@localhost
git -C "$WT" config user.name test
git -C "$WT" remote add origin https://github.com/kriscendobot/minion.town.git
printf 'base\n' > "$WT/src/feature.js"
git -C "$WT" add -A
git -C "$WT" commit -qm base
BASE="$(git -C "$WT" rev-parse HEAD)"

cat > "$WT/designs/production.md" <<'EOF'
# Production capability

## Production sequence and stop gates

Implementation proceeds in this order. A failed gate stops deployment.

1. **Real substrate.** Land the provider and resolve the entitlement stop gate.
2. **Application wiring.** Connect the application to the real provider.
3. **Fresh-user canary.** Observe one live production run.

## Acceptance evidence

- Record the deployed commit and fresh-user canary observation.
- Correlate the browser result with daemon logs.

Code inspection and unit tests are prerequisites, not production evidence.
EOF
printf 'wired\n' >> "$WT/src/feature.js"
git -C "$WT" add -A
git -C "$WT" commit -qm 'feat: wire later phase'

cat > "$TR/pr87-shape.md" <<'EOF'
## What this is

The application half of `designs/production.md` production sequence step 2.
The real provider from step 1 is unmerged. The injected production seam defaults
to unavailable and the confinement probe fails closed.

## Scope boundary

Steps 1 and 3 are not attempted here. This lands wiring only.

338 unit tests pass.
EOF

run_gate() { # run_gate <mode> <body> [draft]
  local mode="$1" body="$2" draft="${3:-yes}"
  OUT=""; RC=0
  OUT="$(bash "$GATE" "$mode" "$WT" --base "$BASE" --head HEAD \
    --body-file "$body" --draft "$draft" --evidence-file "$TR/evidence")" || RC=$?
}

echo "== historical shape: later wiring plus tests cannot replace production evidence =="
run_gate author "$TR/pr87-shape.md"
[ "$RC" -eq 20 ] && ok "authoring gate blocks the PR 87 shape" \
  || bad "expected author block (20), got $RC: $OUT"
printf '%s\n' "$OUT" | grep -q 'missing-or-duplicate-ledger-markers' \
  && ok "missing phase/evidence ledger is named" || bad "missing-ledger finding absent: $OUT"

cat > "$TR/probe.md" <<'EOF'
This explores `designs/production.md` without claiming delivery.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/production.md`
Disposition: non-deliverable-probe
Probe-reason: exercise the application seam before the provider lands
Phase 1: open | provider is not landed
Phase 2: satisfied | wiring exercised with a test double
Phase 3: deferred | requires the real provider
Acceptance: deferred | production canary cannot run yet
<!-- /garden-phase-evidence-ledger -->
EOF
run_gate author "$TR/probe.md"
[ "$RC" -eq 0 ] && printf '%s\n' "$OUT" | grep -q 'verdict=probe' \
  && ok "authoring allows an explicitly non-deliverable draft probe" \
  || bad "draft probe should be allowed (rc=$RC, $OUT)"
run_gate panel "$TR/probe.md"
# A probe that reaches the panel is held draft (exit 30), not blocked: a fixer
# cannot close a phase another job owns (builder-pr-gauntlet-bypass, #148).
[ "$RC" -eq 30 ] && printf '%s\n' "$OUT" | grep -q 'verdict=hold-draft' \
  && printf '%s\n' "$OUT" | grep -q 'undraft=withheld' \
  && ! printf '%s\n' "$OUT" | grep -q 'probe-must-remain-draft' \
  && ok "panel holds a probe draft without a must-fix finding" \
  || bad "panel should hold the probe draft (rc=$RC, $OUT)"
printf '%s\n' "$OUT" | grep -q 'open=\[1:open,3:deferred\]' \
  && ok "panel reports the probe's open phases once" \
  || bad "open-phase status missing from the hold verdict: $OUT"

echo "== orchestrated slice: real code for some phases; a named successor owns the rest =="
cat > "$TR/slice.md" <<'EOF'
This lands the provider for `designs/production.md`; the canary is a later child.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/production.md`
Disposition: orchestrated-slice
Successor: production-canary-orchestration
Phase 1: satisfied | provider landed in this diff
Phase 2: partial | wiring present; production seam off until the canary
Phase 3: not-started | owned by production-canary-orchestration
Acceptance: not-started | the canary child records the production observation
<!-- /garden-phase-evidence-ledger -->
EOF
run_gate author "$TR/slice.md"
[ "$RC" -eq 0 ] && printf '%s\n' "$OUT" | grep -q 'verdict=slice' \
  && printf '%s\n' "$OUT" | grep -q 'successor=production-canary-orchestration' \
  && ok "authoring accepts a draft orchestrated slice that names its successor" \
  || bad "orchestrated slice should clear authoring (rc=$RC, $OUT)"
run_gate panel "$TR/slice.md"
[ "$RC" -eq 30 ] && printf '%s\n' "$OUT" | grep -q 'open=\[2:partial,3:not-started\]' \
  && grep -q 'Do not request changes for the open phases' "$TR/evidence" \
  && ok "panel reviews the slice's code and withholds only the un-draft" \
  || bad "panel should hold the slice draft (rc=$RC, $OUT)"
run_gate author "$TR/slice.md" no
[ "$RC" -eq 20 ] && printf '%s\n' "$OUT" | grep -q 'slice-not-draft' \
  && ok "a slice may never be opened ready (design-acceptance protection kept)" \
  || bad "non-draft slice should block (rc=$RC, $OUT)"
sed '/^Successor:/d' "$TR/slice.md" > "$TR/slice-no-successor.md"
run_gate author "$TR/slice-no-successor.md"
[ "$RC" -eq 20 ] && printf '%s\n' "$OUT" | grep -q 'missing-successor' \
  && ok "a slice without a named successor is refused" \
  || bad "slice without successor should block (rc=$RC, $OUT)"
sed 's/^Successor:.*/Successor: the canary child, later/' "$TR/slice.md" > "$TR/slice-prose-successor.md"
run_gate author "$TR/slice-prose-successor.md"
[ "$RC" -eq 20 ] && printf '%s\n' "$OUT" | grep -q 'invalid-successor' \
  && ok "a prose successor (not a resolvable base) is refused" \
  || bad "prose successor should block (rc=$RC, $OUT)"
sed '/^Phase 3:/d' "$TR/slice.md" > "$TR/slice-missing-phase.md"
run_gate panel "$TR/slice-missing-phase.md"
[ "$RC" -eq 20 ] && printf '%s\n' "$OUT" | grep -q 'missing-phase:3' \
  && ok "a slice ledger must still account for every phase (fixable, so it blocks)" \
  || bad "slice missing a phase row should block (rc=$RC, $OUT)"

cat > "$TR/deliverable.md" <<'EOF'
This delivers `designs/production.md` end to end.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/production.md`
Disposition: deliverable
Phase 1: satisfied | provider landed at commit abcdef1; entitlement recorded
Phase 2: satisfied | application uses the landed provider
Phase 3: satisfied | fresh-user production canary receipt 2026-09-27
Acceptance: satisfied | deployed browser observation correlated with daemon logs and canary receipt
<!-- /garden-phase-evidence-ledger -->
EOF
run_gate author "$TR/deliverable.md"
[ "$RC" -eq 0 ] && ok "complete deliverable ledger clears authoring" \
  || bad "complete author ledger should clear (rc=$RC, $OUT)"
run_gate panel "$TR/deliverable.md"
[ "$RC" -eq 10 ] && printf '%s\n' "$OUT" | grep -q 'acceptance=satisfied' \
  && ok "complete ledger still engages integrator comparison at panel" \
  || bad "panel should return attention for semantic comparison (rc=$RC, $OUT)"

DESIGN_HEAD="$(git -C "$WT" rev-parse HEAD)"
git -C "$WT" reset -q --hard "$BASE"
mkdir -p "$WT/designs"
cat > "$WT/designs/proposal.md" <<'EOF'
# Proposed production work
## Production sequence and stop gates
1. Land the substrate.
2. Wire the feature.
## Acceptance evidence
- Observe the deployed canary.
EOF
git -C "$WT" add -A
git -C "$WT" commit -qm 'design: propose production sequence'
cat > "$TR/design-body.md" <<'EOF'
This proposes `designs/proposal.md` for later implementation.
EOF
run_gate author "$TR/design-body.md"
[ "$RC" -eq 0 ] && printf '%s\n' "$OUT" | grep -q 'reason=design-only-diff' \
  && ok "design-only PR defines the contract without owing an implementation ledger" \
  || bad "design-only PR should clear (rc=$RC, $OUT)"
git -C "$WT" reset -q --hard "$DESIGN_HEAD"

cat > "$TR/open-deliverable.md" <<'EOF'
This claims to deliver `designs/production.md` while the substrate remains unmerged.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/production.md`
Disposition: deliverable
Phase 1: open | real provider is unmerged
Phase 2: satisfied | wiring has unit tests
Phase 3: deferred | canary requires the provider
Acceptance: missing | only unit tests exist
<!-- /garden-phase-evidence-ledger -->
EOF
run_gate author "$TR/open-deliverable.md"
[ "$RC" -eq 20 ] && printf '%s\n' "$OUT" | grep -q 'open-phase:1:open' \
  && ok "deliverable with open prerequisite is blocked" \
  || bad "open prerequisite should block (rc=$RC, $OUT)"

echo "== ensure-pr integration: authoring block occurs before PR creation =="
FAKE_PR_DB="$TR/prs.json"; export FAKE_PR_DB
FAKE_GH_LOG="$TR/gh.log"; export FAKE_GH_LOG
printf '[]\n' > "$FAKE_PR_DB"
: > "$FAKE_GH_LOG"
PINNED_BASE="main-$(printf '%s' "$BASE" | cut -c1-7)"
git -C "$WT" branch -f "$PINNED_BASE" "$BASE" >/dev/null
ensure_out=""; ensure_rc=0
ensure_out="$(GARDEN=testhost GARDEN_STATE="$TR/state" \
  GARDEN_GH="$HERE/ensure-pr-gh-stub.sh" GARDEN_ENSURE_PR_NO_JOURNAL=1 \
  GARDEN_PHASE_EVIDENCE_WORKTREE="$WT" \
  bash "$GARDENING/ensure-pr.sh" phase-evidence-test kriscendobot/minion.town \
    feat/phase-evidence "$PINNED_BASE" --title 'feat: later phase' \
    --body-file "$TR/pr87-shape.md" 2>&1)" || ensure_rc=$?
[ "$ensure_rc" -ne 0 ] && printf '%s\n' "$ensure_out" | grep -q 'phase/evidence authoring gate refused' \
  && ok "ensure-pr refuses the noncompliant body" \
  || bad "ensure-pr should refuse before create (rc=$ensure_rc, $ensure_out)"
grep -q '^pr create' "$FAKE_GH_LOG" 2>/dev/null \
  && bad "ensure-pr invoked PR creation despite the phase/evidence block" \
  || ok "ensure-pr creates no PR after the authoring block"

echo "== panel integration: deterministic block overrides an approving foreperson =="
RUNDIR="$TR/panel-run"
SEAT_LOG="$TR/seat.log"
PANEL_OUT="$TR/panel.out"
PANEL_ERR="$TR/panel.err"
GARDEN_PHASE_EVIDENCE_BODY_FILE="$TR/pr87-shape.md" \
GARDEN_PHASE_SEAT_LOG="$SEAT_LOG" \
GARDEN_PANEL_SINGLE_ROUND=1 \
GARDEN_CODE_SEATS=assessor \
GARDEN_PANEL_CONCURRENCY=2 \
GARDEN_PANEL_SEAT="$SEAT_STUB" \
GARDEN_PANEL_DECIDE="$DECIDE_STUB" \
GARDEN_PANEL_RELATED_DESIGN=: \
GARDEN_PANEL_APPELLATE=: \
GARDEN_PANEL_RECORD=: \
GARDEN_PANEL_RUNDIR="$RUNDIR" \
  bash "$PANEL" "$WT" 87 "$BASE" > "$PANEL_OUT" 2> "$PANEL_ERR"
panel_rc=$?
[ "$panel_rc" -eq 0 ] && tail -1 "$PANEL_OUT" | grep -q -- 'must-fix$' \
  && ok "panel returns must-fix while the production gate is open" \
  || bad "panel did not bind the block (rc=$panel_rc, out=$(cat "$PANEL_OUT"))"
grep -q 'integrator-saw-phase-evidence=1' "$SEAT_LOG" 2>/dev/null \
  && ok "panel force-adds integrator and hands it the gate evidence" \
  || bad "integrator was not forced or saw no evidence"
grep -q 'phase/evidence pre-pass = BLOCKED' "$PANEL_ERR" \
  && ok "panel audit trail records the deterministic block" \
  || bad "panel block audit line missing"

echo "== re-litigation: kriscendobot/minion.town#148 ledger replayed through panel mode =="
# #148 shape: an ordered six-phase design; the build delivered phases 1-2 in part,
# canary phases 3-6 belonged to a later sibling child, and the ledger said
# non-deliverable-probe. Before this fix the panel gate emitted
# probe-must-remain-draft every round and six fix rounds could not clear it.
cat > "$WT/designs/claude-cli.md" <<'DESIGN'
# Claude CLI production

## Production sequence and stop gates

1. Provider backend.
2. Credential store and confinement probe.
3. Canary: single subject.
4. Canary: child guests.
5. Canary: quota exhaustion.
6. Canary: production enablement.

## Acceptance evidence

- Live canary receipts for phases 3 through 6.
DESIGN
git -C "$WT" add -A
git -C "$WT" commit -qm 'design: claude cli sequence'
cat > "$TR/pr148-shape.md" <<'EOF'
Runs confined inference through the Claude CLI backend (`designs/claude-cli.md`).

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/claude-cli.md` (the fixture tree also carries `designs/production.md`)
Disposition: non-deliverable-probe
Probe-reason: the canary phases belong to the sibling canary child
Phase 1: partial | provider seams wired; no live credential
Phase 2: partial | probe exercised against a test daemon
Phase 3: not-started | canary child
Phase 4: not-started | canary child
Phase 5: not-started | canary child
Phase 6: not-started | canary child
Acceptance: not-started | canary child
<!-- /garden-phase-evidence-ledger -->
EOF
run_gate panel "$TR/pr148-shape.md"
[ "$RC" -eq 30 ] && printf '%s\n' "$OUT" | grep -q 'open=\[1:partial,2:partial,3:not-started,4:not-started,5:not-started,6:not-started\]' \
  && ! printf '%s\n' "$OUT" | grep -q 'probe-must-remain-draft' \
  && ok "#148 ledger: panel mode reports open phases once and holds draft (no perpetual must-fix)" \
  || bad "#148 replay should hold draft, not block (rc=$RC, $OUT)"
sed 's/^Disposition: non-deliverable-probe$/Disposition: orchestrated-slice/; s/^Probe-reason:.*/Successor: minion-town-claude-cli-production-20261003/' \
  "$TR/pr148-shape.md" > "$TR/pr148-slice.md"
run_gate author "$TR/pr148-slice.md"
[ "$RC" -eq 0 ] && printf '%s\n' "$OUT" | grep -q 'verdict=slice' \
  && ok "#148 as it should have been labeled (orchestrated-slice) clears authoring" \
  || bad "#148 slice relabel should clear authoring (rc=$RC, $OUT)"

echo "== panel integration: a held probe/slice keeps the seats' pass, binds no must-fix =="
for shape in pr148-shape pr148-slice; do
  : > "$SEAT_LOG"
  GARDEN_PHASE_EVIDENCE_BODY_FILE="$TR/$shape.md" \
  GARDEN_PHASE_SEAT_LOG="$SEAT_LOG" \
  GARDEN_PANEL_SINGLE_ROUND=1 \
  GARDEN_CODE_SEATS=assessor \
  GARDEN_PANEL_CONCURRENCY=2 \
  GARDEN_PANEL_SEAT="$SEAT_STUB" \
  GARDEN_PANEL_DECIDE="$DECIDE_STUB" \
  GARDEN_PANEL_RELATED_DESIGN=: \
  GARDEN_PANEL_APPELLATE=: \
  GARDEN_PANEL_RECORD=: \
  GARDEN_PANEL_RUNDIR="$TR/panel-run-$shape" \
    bash "$PANEL" "$WT" 148 "$BASE" > "$PANEL_OUT" 2> "$PANEL_ERR"
  panel_rc=$?
  { [ "$panel_rc" -eq 0 ] && tail -1 "$PANEL_OUT" | grep -q -- ' pass$' \
      && grep -q 'phase/evidence pre-pass = HOLD-DRAFT' "$PANEL_ERR" \
      && grep -q 'withholds the un-draft' "$PANEL_ERR"; } \
    && ok "$shape: approving seats yield pass; the hold is logged, not bound to must-fix" \
    || bad "$shape: panel should pass with a hold (rc=$panel_rc, out=$(cat "$PANEL_OUT"), err=$(grep -i 'phase' "$PANEL_ERR"))"
  grep -q 'integrator-saw-phase-evidence=1' "$SEAT_LOG" 2>/dev/null \
    && ok "$shape: the integrator still receives the open-phase evidence" \
    || bad "$shape: integrator was not handed the hold evidence"
done

echo "== panel loop mode: a passing held slice is never un-drafted =="
# The un-draft hook is `false`: calling it would fail the panel non-zero.
GARDEN_PHASE_EVIDENCE_BODY_FILE="$TR/pr148-slice.md" \
GARDEN_PHASE_SEAT_LOG="$SEAT_LOG" \
GARDEN_CODE_SEATS=assessor \
GARDEN_PANEL_CONCURRENCY=2 \
GARDEN_PANEL_SEAT="$SEAT_STUB" \
GARDEN_PANEL_DECIDE="$DECIDE_STUB" \
GARDEN_PANEL_RELATED_DESIGN=: \
GARDEN_PANEL_APPELLATE=: \
GARDEN_PANEL_RECORD=: \
GARDEN_PANEL_UNDRAFT=false \
GARDEN_PANEL_RUNDIR="$TR/panel-run-loop" \
  bash "$PANEL" "$WT" 148 "$BASE" > "$PANEL_OUT" 2> "$PANEL_ERR"
panel_rc=$?
{ [ "$panel_rc" -eq 0 ] && grep -q 'withholds the un-draft, so the PR stays draft' "$PANEL_OUT"; } \
  && ok "loop-mode pass on a held slice exits without calling the un-draft hook" \
  || bad "loop-mode held slice (rc=$panel_rc, out=$(cat "$PANEL_OUT"), err=$(tail -3 "$PANEL_ERR"))"

echo "== stale local base: a bare --base resolves to the fresher origin/<base> (#1370) =="
# A per-job worktree whose LOCAL base branch lags origin/<base>. The base's own
# advance touched src/, so a diff from the stale local ref makes a design-only PR
# look like an implementation that owes a ledger.
UP="$TR/stale-up.git"
git init -q --bare "$UP"
SWT="$TR/stale-wt"
git clone -q "$WT" "$SWT" 2>/dev/null
git -C "$SWT" config user.email t@localhost
git -C "$SWT" config user.name test
git -C "$SWT" checkout -q -B llm "$BASE"
git -C "$SWT" remote set-url origin "$UP"
git -C "$SWT" push -q origin llm
STALE_LLM="$(git -C "$SWT" rev-parse llm)"
printf 'advanced upstream\n' >> "$SWT/src/feature.js"
git -C "$SWT" commit -qam 'feat: base advances'
git -C "$SWT" push -q origin llm
git -C "$SWT" reset -q --hard "$STALE_LLM"
git -C "$SWT" fetch -q origin
git -C "$SWT" checkout -q -b design-only origin/llm
mkdir -p "$SWT/designs"
cat > "$SWT/designs/proposal.md" <<'DESIGN'
# Proposed production work
## Production sequence and stop gates
1. Land the substrate.
2. Wire the feature.
## Acceptance evidence
- Observe the deployed canary.
DESIGN
git -C "$SWT" add -A
git -C "$SWT" commit -qm 'design: propose production sequence'
[ "$(git -C "$SWT" rev-parse llm)" != "$(git -C "$SWT" rev-parse origin/llm)" ] \
  && ok "fixture: local llm is behind origin/llm" || bad "fixture: local llm is not stale"
OUT=""; RC=0
OUT="$(bash "$GATE" author "$SWT" --base llm --head HEAD \
  --body-file "$TR/design-body.md" --draft yes)" || RC=$?
[ "$RC" -eq 0 ] && printf '%s\n' "$OUT" | grep -q 'reason=design-only-diff' \
  && ok "bare --base llm compares against origin/llm and clears the design-only PR" \
  || bad "bare --base llm used the stale local ref (rc=$RC, $OUT)"
OUT=""; RC=0
OUT="$(bash "$GATE" author "$SWT" --base "$STALE_LLM" --head HEAD \
  --body-file "$TR/design-body.md" --draft yes)" || RC=$?
[ "$RC" -eq 20 ] \
  && ok "an explicit stale sha is honored as given (control: the stale diff does demand a ledger)" \
  || bad "explicit stale sha should still see the base advance (rc=$RC, $OUT)"

echo
echo "phase-evidence-gate: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
