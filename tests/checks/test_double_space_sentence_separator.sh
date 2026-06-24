#!/bin/bash
# test_double_space_sentence_separator.sh -- smoke-test the
# double-space-sentence-separator gate.
#
# Verifies:
#   - A clean diff (no changes) exits 0.
#   - A diff that adds a multi-sentence line exits non-zero.
#   - A diff that adds a line with an allowlisted token (e.g.) exits 0.
#   - A diff that adds an offender AND an allowlisted token still fires
#     (the allowlist filters tokens, not lines).
#   - Pre-existing multi-sentence lines that are not in the diff are
#     ignored (diff-scoped).

set -uo pipefail

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT=$(cd "$HARNESS_DIR/../.." && pwd)
GATE_DIR="$PROJECT_ROOT/scripts/checks/double-space-sentence-separator"
CHECK="$GATE_DIR/check.sh"

PASS=0
FAIL=0

ok() { PASS=$((PASS+1)); echo "  PASS: $1"; }
ko() { FAIL=$((FAIL+1)); echo "  FAIL: $1"; }

echo "=== test_double_space_sentence_separator ==="

SCRATCH=$(mktemp -d -t double-space-XXXXXX)
trap 'rm -rf "$SCRATCH"' EXIT

git -C "$SCRATCH" init --quiet --initial-branch=main
git -C "$SCRATCH" config user.name "test-bot"
git -C "$SCRATCH" config user.email "test@example.invalid"

# Establish a base commit on main with one pre-existing multi-sentence
# line. This pre-existing line must NOT trigger the gate later when we
# diff against this base.
cat > "$SCRATCH/preexisting.md" <<'EOF'
# preexisting

Pre-existing multi-sentence prose. Was already here.
EOF
git -C "$SCRATCH" add -A
git -C "$SCRATCH" commit --quiet -m "scratch: base"

BASE=$(git -C "$SCRATCH" rev-parse HEAD)

# --- 1. no diff: clean exit ---
set +e
GATE_REPO_ROOT="$SCRATCH" GATE_BASE_REF="$BASE" bash "$CHECK" 2>/dev/null
rc=$?
set -e
if [ "$rc" -eq 0 ]; then ok "empty diff exits 0"; else ko "empty diff exit was $rc"; fi

# --- 2. new offender in the diff ---
cat > "$SCRATCH/offender.md" <<'EOF'
# offender

A first sentence. A second sentence on the same line.
EOF
git -C "$SCRATCH" add -A
git -C "$SCRATCH" commit --quiet -m "scratch: add offender"

set +e
out=$(GATE_REPO_ROOT="$SCRATCH" GATE_BASE_REF="$BASE" bash "$CHECK" 2>&1)
rc=$?
set -e
if [ "$rc" -ne 0 ]; then ok "new offender fires gate"; else ko "gate missed new offender"; fi
if echo "$out" | grep -q 'offender.md'; then ok "stderr names offender.md"; else ko "stderr did not name offender.md (got: $out)"; fi
if echo "$out" | grep -q 'second sentence'; then ok "stderr surfaces the offending text"; else ko "stderr missing offender text (got: $out)"; fi

# --- 3. pre-existing line is not re-litigated ---
# The diff base above includes a pre-existing multi-sentence line in
# preexisting.md. We did not modify preexisting.md in the new commit.
# The gate should fire only on offender.md, not on preexisting.md.
if echo "$out" | grep -q 'preexisting.md'; then
  ko "gate fired on pre-existing line (diff-scope broken)"
else
  ok "pre-existing line ignored (diff-scope honored)"
fi

# --- 4. allowlisted token alone (e.g.) does not fire ---
# Reset by branching off BASE so the diff against BASE is the new file
# only.
git -C "$SCRATCH" reset --hard --quiet "$BASE"
cat > "$SCRATCH/allow.md" <<'EOF'
# allow

A line with e.g. an example and nothing else mid-line.
EOF
git -C "$SCRATCH" add -A
git -C "$SCRATCH" commit --quiet -m "scratch: allowlisted only"

set +e
out=$(GATE_REPO_ROOT="$SCRATCH" GATE_BASE_REF="$BASE" bash "$CHECK" 2>&1)
rc=$?
set -e
if [ "$rc" -eq 0 ]; then ok "allowlisted token alone does not fire"; else ko "gate misfired on allowlisted token (out: $out)"; fi

# --- 5. offender AND allowlisted token: still fires ---
git -C "$SCRATCH" reset --hard --quiet "$BASE"
cat > "$SCRATCH/mixed.md" <<'EOF'
# mixed

A line with e.g. allowlisted text. Then a second offending sentence.
EOF
git -C "$SCRATCH" add -A
git -C "$SCRATCH" commit --quiet -m "scratch: mixed"

set +e
out=$(GATE_REPO_ROOT="$SCRATCH" GATE_BASE_REF="$BASE" bash "$CHECK" 2>&1)
rc=$?
set -e
if [ "$rc" -ne 0 ]; then ok "mixed line still fires"; else ko "gate missed mixed line (out: $out)"; fi

# --- 6. salutation alone (Dr.) does not fire ---
git -C "$SCRATCH" reset --hard --quiet "$BASE"
cat > "$SCRATCH/salutation.md" <<'EOF'
# salutation

Met Dr. Smith on the way home, nothing else mid-line.
EOF
git -C "$SCRATCH" add -A
git -C "$SCRATCH" commit --quiet -m "scratch: salutation"

set +e
out=$(GATE_REPO_ROOT="$SCRATCH" GATE_BASE_REF="$BASE" bash "$CHECK" 2>&1)
rc=$?
set -e
if [ "$rc" -eq 0 ]; then ok "salutation alone does not fire"; else ko "gate misfired on salutation (out: $out)"; fi

echo "=== test_double_space_sentence_separator: $PASS passed, $FAIL failed ==="
if [ "$FAIL" -gt 0 ]; then exit 1; fi
exit 0
