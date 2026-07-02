#!/bin/bash
# test_identity_drift_guard.sh -- behavior test for identity-drift-guard.sh.
#
# The guard is the deterministic host-identity drift detector run as a
# gardener-scaler preflight. Verifies:
#   - GARDEN == hostname -s  -> no emission (the common case).
#   - GARDEN != hostname -s with NO recorded override -> ONE loud kind:error
#     emission, deduped across ticks (fires on tick 1, quiet after).
#   - a RECORDED override (GARDEN_IDENTITY_OVERRIDE or identity-override file
#     matching GARDEN) -> no emission (legitimate parallel pool).
#   - the emission body surfaces the leader/follower impact when the leader
#     marker names the real host but GARDEN has drifted.
#   - clearing the drift lets a later re-drift emit again.
#   - gardener-scaler.sh invokes the guard as a preflight.

set -uo pipefail

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT=$(cd "$HARNESS_DIR/../.." && pwd)
GUARD="$PROJECT_ROOT/scripts/jobs/identity-drift-guard.sh"

PASS=0
FAIL=0
ok() { PASS=$((PASS+1)); echo "  PASS: $1"; }
ko() { FAIL=$((FAIL+1)); echo "  FAIL: $1"; }

echo "=== test_identity_drift_guard ==="

[ -f "$GUARD" ] || { echo "missing $GUARD"; exit 2; }

SCRATCH=$(mktemp -d -t idg-XXXXXX)
trap 'rm -rf "$SCRATCH"' EXIT
mkdir -p "$SCRATCH/state"

HOST="$(hostname -s 2>/dev/null || echo host)"
EMITFILE="$SCRATCH/emitted.txt"

# Run the guard with a captured emission sink and a stubbed leader marker (named
# the REAL host, so a drifted GARDEN reads as follower). $1 overrides GARDEN.
run_guard() {
  local garden="$1"
  rm -f "$EMITFILE"
  set +e
  GARDEN="$garden" \
  GARDEN_STATE="$SCRATCH/state" \
  GARDEN_LEADER="$HOST" \
  GARDEN_IDENTITY_GUARD_EMIT="cat >> '$EMITFILE'" \
    bash "$GUARD" >/dev/null 2>&1
  RC=$?
  set -e
}
emitted() { [ -s "$EMITFILE" ]; }

# --- 1. no divergence -> no emission ---
run_guard "$HOST"
if ! emitted; then ok "GARDEN == hostname -s does not emit"; else ko "clean identity emitted"; fi
[ "$RC" -eq 0 ] && ok "guard exits 0 on clean identity" || ko "guard exit $RC on clean identity"

# --- 2. genuine drift -> emits once, then deduped ---
run_guard "driftname"
if emitted; then ok "unrecorded drift emits a kind:error"; else ko "unrecorded drift did not emit"; fi
grep -q 'DRIFT' "$EMITFILE" && ok "body announces DRIFT" || ko "body missing DRIFT"
grep -q 'driftname' "$EMITFILE" && ok "body names the drifted GARDEN" || ko "body missing GARDEN"
grep -q "$HOST" "$EMITFILE" && ok "body names hostname -s" || ko "body missing hostname"
grep -qi 'follower\|leader-only singleton' "$EMITFILE" && ok "body surfaces leader/follower impact" || ko "body missing leader impact"
[ -f "$SCRATCH/state/identity-drift-reported" ] && ok "dedup marker written" || ko "dedup marker not written"

# second tick, same drift -> quiet
run_guard "driftname"
if ! emitted; then ok "same drift is deduped (no re-emit)"; else ko "same drift re-emitted"; fi

# --- 3. recorded override -> no emission ---
printf 'driftname\n' > "$SCRATCH/state/identity-override"
run_guard "driftname"
if ! emitted; then ok "recorded identity-override file silences the guard"; else ko "override file still emitted"; fi
rm -f "$SCRATCH/state/identity-override"

# env override
rm -f "$SCRATCH/state/identity-drift-reported"
rm -f "$EMITFILE"
set +e
GARDEN="driftname" GARDEN_STATE="$SCRATCH/state" GARDEN_LEADER="$HOST" \
  GARDEN_IDENTITY_OVERRIDE="driftname" \
  GARDEN_IDENTITY_GUARD_EMIT="cat >> '$EMITFILE'" \
  bash "$GUARD" >/dev/null 2>&1
set -e
if [ ! -s "$EMITFILE" ]; then ok "GARDEN_IDENTITY_OVERRIDE env silences the guard"; else ko "override env still emitted"; fi

# --- 4. drift clears, re-drift emits again ---
run_guard "driftname"              # re-arm drift
[ -f "$SCRATCH/state/identity-drift-reported" ] || ko "expected re-armed marker"
run_guard "$HOST"                  # clear
[ ! -f "$SCRATCH/state/identity-drift-reported" ] && ok "marker cleared when drift resolves" || ko "marker survived resolution"
run_guard "driftname"              # re-drift
if emitted; then ok "re-drift after clearing emits again"; else ko "re-drift did not emit"; fi

# --- 5. the scaler wires the guard as a preflight ---
grep -q 'identity-drift-guard.sh' "$PROJECT_ROOT/scripts/jobs/gardener-scaler.sh" \
  && ok "gardener-scaler.sh invokes the guard" || ko "gardener-scaler.sh does not call the guard"

echo "=== test_identity_drift_guard: $PASS passed, $FAIL failed ==="
if [ "$FAIL" -gt 0 ]; then exit 1; fi
exit 0
