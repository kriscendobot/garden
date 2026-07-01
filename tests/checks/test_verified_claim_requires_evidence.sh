#!/bin/bash
# test_verified_claim_requires_evidence.sh -- smoke-test the
# verified-claim-requires-evidence gate.
#
# Verifies:
#   - The real project tree is clean (exits 0): the discipline is
#     present in all four required files.
#   - A tree without roles/ self-passes (the invariant is garden-only).
#   - A clean fixture (all required files carry both anchors) exits 0,
#     including when an anchor is split by a markdown line-wrap.
#   - A missing required file fires and is named.
#   - A file missing the "real-execution evidence" anchor fires.
#   - A file missing the "actual browser run" anchor fires.

set -uo pipefail

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT=$(cd "$HARNESS_DIR/../.." && pwd)
GATE_DIR="$PROJECT_ROOT/scripts/checks/verified-claim-requires-evidence"
CHECK="$GATE_DIR/check.sh"

PASS=0
FAIL=0
ok() { PASS=$((PASS+1)); echo "  PASS: $1"; }
ko() { FAIL=$((FAIL+1)); echo "  FAIL: $1"; }

echo "=== test_verified_claim_requires_evidence ==="

[ -x "$CHECK" ] || [ -f "$CHECK" ] || { echo "missing $CHECK"; exit 2; }

REQUIRED_FILES=(
  roles/COMMON.md
  roles/gardener/AGENT.md
  roles/jurors/saboteur/AGENT.md
  roles/jurors/skeptic/AGENT.md
)

# --- 1. the real tree is clean ---
set +e
out=$(GATE_REPO_ROOT="$PROJECT_ROOT" bash "$CHECK" 2>&1)
rc=$?
set -e
if [ "$rc" -eq 0 ]; then ok "real project tree is clean (exit 0)"; else ko "real tree fired (rc=$rc): $out"; fi

SCRATCH=$(mktemp -d -t verify-evidence-XXXXXX)
trap 'rm -rf "$SCRATCH"' EXIT

run_gate() {
  set +e
  OUT=$(GATE_REPO_ROOT="$SCRATCH" bash "$CHECK" 2>&1)
  RC=$?
  set -e
}

# A file body that carries both anchors, with "real-execution evidence"
# deliberately split across a markdown line-wrap to exercise the
# whitespace-normalized match.
seed_clean() {
  rm -rf "${SCRATCH:?}/roles"
  for f in "${REQUIRED_FILES[@]}"; do
    mkdir -p "$SCRATCH/$(dirname "$f")"
    cat > "$SCRATCH/$f" <<'EOF'
A "verified" claim requires real-execution
evidence. A UI acceptance criterion needs an actual browser run.
EOF
  done
}

# --- 2. a tree without roles/ self-passes ---
run_gate  # SCRATCH has no roles/ yet
if [ "$RC" -eq 0 ]; then ok "tree without roles/ self-passes (exit 0)"; else ko "no-roles tree fired (rc=$RC): $OUT"; fi

# --- 3. clean fixture exits 0 (line-wrapped anchor still matches) ---
seed_clean
run_gate
if [ "$RC" -eq 0 ]; then ok "clean fixture exits 0 (line-wrapped anchor matches)"; else ko "clean fixture fired (rc=$RC): $OUT"; fi

# --- 4. missing required file fires ---
seed_clean
rm -f "$SCRATCH/roles/jurors/saboteur/AGENT.md"
run_gate
if [ "$RC" -ne 0 ]; then ok "missing required file fires"; else ko "missing file did not fire"; fi
echo "$OUT" | grep -q 'roles/jurors/saboteur/AGENT.md' && ok "names the missing file" || ko "did not name the missing file ($OUT)"

# --- 5. missing "real-execution evidence" anchor fires ---
seed_clean
printf 'A UI acceptance criterion needs an actual browser run.\n' > "$SCRATCH/roles/COMMON.md"
run_gate
if [ "$RC" -ne 0 ]; then ok "missing evidence anchor fires"; else ko "missing evidence anchor did not fire"; fi
echo "$OUT" | grep -q 'real-execution evidence' && ok "names the evidence anchor" || ko "did not name the evidence anchor ($OUT)"

# --- 6. missing "actual browser run" anchor fires ---
seed_clean
printf 'A "verified" claim requires real-execution evidence.\n' > "$SCRATCH/roles/gardener/AGENT.md"
run_gate
if [ "$RC" -ne 0 ]; then ok "missing browser-run anchor fires"; else ko "missing browser-run anchor did not fire"; fi
echo "$OUT" | grep -q 'actual browser run' && ok "names the browser-run anchor" || ko "did not name the browser-run anchor ($OUT)"

echo "=== test_verified_claim_requires_evidence: $PASS passed, $FAIL failed ==="
if [ "$FAIL" -gt 0 ]; then exit 1; fi
exit 0
