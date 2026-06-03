#!/bin/bash
# test_bench_engines_rename.sh -- smoke-test the bench-engines-rename gate.
#
# Verifies:
#   - A clean tree exits 0.
#   - A tree with a .bench-engines reference exits non-zero and prints
#     the offending file path to stderr.
#   - The gate's own files are not counted (the exclusion holds).

set -uo pipefail

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT=$(cd "$HARNESS_DIR/../.." && pwd)
GATE_DIR="$PROJECT_ROOT/scripts/checks/bench-engines-rename"
CHECK="$GATE_DIR/check.sh"

PASS=0
FAIL=0

ok() { PASS=$((PASS+1)); echo "  PASS: $1"; }
ko() { FAIL=$((FAIL+1)); echo "  FAIL: $1"; }

echo "=== test_bench_engines_rename ==="

[ -x "$CHECK" ] || [ -f "$CHECK" ] || { echo "missing $CHECK"; exit 2; }

# --- 1. clean tree (the real project's current state minus a fixture) ---
# Build a minimal scratch repo. Test in isolation rather than relying
# on the surrounding tree being clean.

SCRATCH=$(mktemp -d -t bench-engines-XXXXXX)
trap 'rm -rf "$SCRATCH"' EXIT

git -C "$SCRATCH" init --quiet --initial-branch=main
git -C "$SCRATCH" config user.name "test-bot"
git -C "$SCRATCH" config user.email "test@example.invalid"

cat > "$SCRATCH/README.md" <<'EOF'
# scratch

A clean tree with no offending pattern.
EOF
git -C "$SCRATCH" add -A
git -C "$SCRATCH" commit --quiet -m "scratch: initial"

set +e
GATE_REPO_ROOT="$SCRATCH" bash "$CHECK" 2>/dev/null
rc=$?
set -e
if [ "$rc" -eq 0 ]; then ok "clean tree exits 0"; else ko "clean tree exit was $rc (expected 0)"; fi

# --- 2. tree with offender ---
cat > "$SCRATCH/example.md" <<'EOF'
# example

This file mentions the wrong path: .bench-engines/foo.
EOF
git -C "$SCRATCH" add -A
git -C "$SCRATCH" commit --quiet -m "scratch: add offender"

set +e
out=$(GATE_REPO_ROOT="$SCRATCH" bash "$CHECK" 2>&1)
rc=$?
set -e
if [ "$rc" -ne 0 ]; then ok "dirty tree exits non-zero"; else ko "dirty tree exit was $rc (expected non-zero)"; fi
if echo "$out" | grep -q 'example.md'; then ok "stderr names the offending file"; else ko "stderr did not name example.md (got: $out)"; fi

# --- 3. gate's own files are excluded ---
# Reset and copy the real gate directory in; the gate must not fire on
# its own README / prompt that name `.bench-engines` by example.
rm -rf "$SCRATCH/.git"
git -C "$SCRATCH" init --quiet --initial-branch=main
git -C "$SCRATCH" config user.name "test-bot"
git -C "$SCRATCH" config user.email "test@example.invalid"

rm -f "$SCRATCH/example.md"
mkdir -p "$SCRATCH/scripts/checks/bench-engines-rename"
cp "$GATE_DIR/check.sh" "$GATE_DIR/prompt.md" "$GATE_DIR/README.md" \
  "$SCRATCH/scripts/checks/bench-engines-rename/"

cat > "$SCRATCH/README.md" <<'EOF'
# scratch
EOF

git -C "$SCRATCH" add -A
git -C "$SCRATCH" commit --quiet -m "scratch: gate in place"

set +e
GATE_REPO_ROOT="$SCRATCH" bash "$CHECK" 2>/dev/null
rc=$?
set -e
if [ "$rc" -eq 0 ]; then ok "gate's own files excluded; exits 0"; else ko "gate fired on its own docs (rc=$rc)"; fi

echo "=== test_bench_engines_rename: $PASS passed, $FAIL failed ==="
if [ "$FAIL" -gt 0 ]; then exit 1; fi
exit 0
