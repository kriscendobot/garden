#!/bin/bash
# test_claude_md_inventory_drift.sh -- smoke-test the claude-md-inventory-drift gate.
#
# Verifies:
#   - A roster that names every on-disk role/skill exits 0.
#   - A skill present on disk but absent from the roster exits non-zero
#     and names the offending skill on stderr.
#   - A role present on disk but absent from the roster exits non-zero
#     and names the offending role on stderr.
#   - A name is NOT considered indexed merely because it is a substring
#     of a longer hyphenated token already in the roster.
#   - A bare prose mention (no backticks) counts as indexed.
#   - A repo with no CLAUDE.md passes silently.

set -uo pipefail

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT=$(cd "$HARNESS_DIR/../.." && pwd)
GATE_DIR="$PROJECT_ROOT/scripts/checks/claude-md-inventory-drift"
CHECK="$GATE_DIR/check.sh"

PASS=0
FAIL=0

ok() { PASS=$((PASS+1)); echo "  PASS: $1"; }
ko() { FAIL=$((FAIL+1)); echo "  FAIL: $1"; }

echo "=== test_claude_md_inventory_drift ==="

[ -x "$CHECK" ] || [ -f "$CHECK" ] || { echo "missing $CHECK"; exit 2; }

SCRATCH=$(mktemp -d -t claude-md-inv-XXXXXX)
trap 'rm -rf "$SCRATCH"' EXIT

# Lay down a minimal library: two roles, two skills, plus a juror seat
# that must be ignored.
mkdir -p "$SCRATCH/roles/liaison" "$SCRATCH/roles/web-builder" \
         "$SCRATCH/roles/jurors/saboteur" \
         "$SCRATCH/skills/job-board" "$SCRATCH/skills/oauth-use-case-patterns"
echo "liaison role" > "$SCRATCH/roles/liaison/AGENT.md"
echo "web-builder role" > "$SCRATCH/roles/web-builder/AGENT.md"
echo "juror seat" > "$SCRATCH/roles/jurors/saboteur/AGENT.md"
echo "job-board skill" > "$SCRATCH/skills/job-board/SKILL.md"
echo "oauth skill" > "$SCRATCH/skills/oauth-use-case-patterns/SKILL.md"

write_claude_md() {
  cat > "$SCRATCH/CLAUDE.md"
}

# --- 1. complete roster exits 0 ---
write_claude_md <<'EOF'
# Garden

## Current inventory

- Roles: `liaison`, `web-builder`.
- Skills: `job-board`, `oauth-use-case-patterns`.

## Job system

Other prose that should not be scanned.
EOF
set +e
GATE_REPO_ROOT="$SCRATCH" bash "$CHECK" 2>/dev/null
rc=$?
set -e
if [ "$rc" -eq 0 ]; then ok "complete roster exits 0"; else ko "complete roster exit was $rc (expected 0)"; fi

# --- 2. missing skill fires and is named ---
write_claude_md <<'EOF'
# Garden

## Current inventory

- Roles: `liaison`, `web-builder`.
- Skills: `job-board`.

## Job system
EOF
set +e
out=$(GATE_REPO_ROOT="$SCRATCH" bash "$CHECK" 2>&1)
rc=$?
set -e
if [ "$rc" -ne 0 ]; then ok "missing skill exits non-zero"; else ko "missing skill exit was $rc (expected non-zero)"; fi
if echo "$out" | grep -q 'oauth-use-case-patterns'; then ok "stderr names the missing skill"; else ko "stderr did not name the missing skill (got: $out)"; fi

# --- 3. missing role fires and is named ---
write_claude_md <<'EOF'
# Garden

## Current inventory

- Roles: `liaison`.
- Skills: `job-board`, `oauth-use-case-patterns`.

## Job system
EOF
set +e
out=$(GATE_REPO_ROOT="$SCRATCH" bash "$CHECK" 2>&1)
rc=$?
set -e
if [ "$rc" -ne 0 ]; then ok "missing role exits non-zero"; else ko "missing role exit was $rc (expected non-zero)"; fi
if echo "$out" | grep -q 'web-builder'; then ok "stderr names the missing role"; else ko "stderr did not name the missing role (got: $out)"; fi

# --- 4. juror seats are NOT enumerated ---
# Roster names roles+skills but NOT the juror seat; gate must still pass.
write_claude_md <<'EOF'
# Garden

## Current inventory

- Roles: `liaison`, `web-builder`.
- Skills: `job-board`, `oauth-use-case-patterns`.

## Job system
EOF
set +e
out=$(GATE_REPO_ROOT="$SCRATCH" bash "$CHECK" 2>&1)
rc=$?
set -e
if [ "$rc" -eq 0 ]; then ok "juror seat not enumerated; exits 0"; else ko "gate fired on a juror seat (rc=$rc, out=$out)"; fi

# --- 5. substring of a longer hyphenated token is NOT indexed ---
# Add a `builder` role; a roster listing only `web-builder` must NOT
# count it as present.
mkdir -p "$SCRATCH/roles/builder"
echo "builder role" > "$SCRATCH/roles/builder/AGENT.md"
write_claude_md <<'EOF'
# Garden

## Current inventory

- Roles: `liaison`, `web-builder`.
- Skills: `job-board`, `oauth-use-case-patterns`.

## Job system
EOF
set +e
out=$(GATE_REPO_ROOT="$SCRATCH" bash "$CHECK" 2>&1)
rc=$?
set -e
if [ "$rc" -ne 0 ] && echo "$out" | grep -qw 'builder' && echo "$out" | grep -q 'roles/builder/AGENT.md'; then
  ok "substring of web-builder does not satisfy builder"
else
  ko "builder wrongly treated as indexed by web-builder (rc=$rc, out=$out)"
fi
rm -rf "$SCRATCH/roles/builder"

# --- 6. a bare prose mention (no backticks) counts as indexed ---
mkdir -p "$SCRATCH/roles/triager"
echo "triager role" > "$SCRATCH/roles/triager/AGENT.md"
write_claude_md <<'EOF'
# Garden

## Current inventory

- Roles: `liaison`, `web-builder`. A job's nature is chosen by the triager.
- Skills: `job-board`, `oauth-use-case-patterns`.

## Job system
EOF
set +e
GATE_REPO_ROOT="$SCRATCH" bash "$CHECK" 2>/dev/null
rc=$?
set -e
if [ "$rc" -eq 0 ]; then ok "bare prose mention counts as indexed"; else ko "bare prose mention not counted (rc=$rc)"; fi
rm -rf "$SCRATCH/roles/triager"

# --- 7. no CLAUDE.md passes silently ---
NOCLAUDE=$(mktemp -d -t claude-md-inv-none-XXXXXX)
mkdir -p "$NOCLAUDE/skills/job-board"
echo "x" > "$NOCLAUDE/skills/job-board/SKILL.md"
set +e
GATE_REPO_ROOT="$NOCLAUDE" bash "$CHECK" 2>/dev/null
rc=$?
set -e
rm -rf "$NOCLAUDE"
if [ "$rc" -eq 0 ]; then ok "no CLAUDE.md passes silently"; else ko "no CLAUDE.md did not pass (rc=$rc)"; fi

echo "=== test_claude_md_inventory_drift: $PASS passed, $FAIL failed ==="
if [ "$FAIL" -gt 0 ]; then exit 1; fi
exit 0
