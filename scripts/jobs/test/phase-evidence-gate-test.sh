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
[ "$RC" -eq 20 ] && printf '%s\n' "$OUT" | grep -q 'probe-must-remain-draft' \
  && ok "panel blocks a probe from review-ready disposition" \
  || bad "panel should preserve probe draft status (rc=$RC, $OUT)"

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

echo
echo "phase-evidence-gate: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
