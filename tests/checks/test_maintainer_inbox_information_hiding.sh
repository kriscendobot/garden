#!/bin/bash
# test_maintainer_inbox_information_hiding.sh -- smoke-test the
# maintainer-inbox-information-hiding gate.
#
# Verifies:
#   - The real project tree is clean (exits 0): the scrub is complete and
#     the gate's allowlist matches the live token-bearing set.
#   - A fixture with all-and-only the allowlist files carrying the token
#     exits 0 (the happy path).
#   - An issue/PR-scoped role file carrying a token fires (condition 1).
#   - A scoped role that loads an inbox-bearing skill fires (condition 2).
#   - A free-standing-looking file off the allowlist carrying a token
#     fires (condition 3a).
#   - A stale allowlist entry (token removed) fires (condition 3b).

set -uo pipefail

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT=$(cd "$HARNESS_DIR/../.." && pwd)
GATE_DIR="$PROJECT_ROOT/scripts/checks/maintainer-inbox-information-hiding"
CHECK="$GATE_DIR/check.sh"

PASS=0
FAIL=0
ok() { PASS=$((PASS+1)); echo "  PASS: $1"; }
ko() { FAIL=$((FAIL+1)); echo "  FAIL: $1"; }

echo "=== test_maintainer_inbox_information_hiding ==="

[ -x "$CHECK" ] || [ -f "$CHECK" ] || { echo "missing $CHECK"; exit 2; }

# The allowlist baked into check.sh, mirrored here so the fixture can
# reproduce a clean baseline. Kept in sync by hand; the real-tree test
# below is the authoritative end-to-end check.
ALLOWLIST=(
  roles/README.md
  roles/liaison/AGENT.md
  roles/proxy/AGENT.md
  roles/foreman/AGENT.md
  roles/gardener/AGENT.md
  roles/orchestrator/AGENT.md
  skills/message-bus/SKILL.md
  skills/at-mention-surveillance/SKILL.md
  skills/activity-feed-watcher/SKILL.md
  skills/self-healing-wrapper/SKILL.md
  skills/orchestration/SKILL.md
  skills/restore/SKILL.md
)

# --- 1. the real tree is clean ---
set +e
out=$(GATE_REPO_ROOT="$PROJECT_ROOT" bash "$CHECK" 2>&1)
rc=$?
set -e
if [ "$rc" -eq 0 ]; then ok "real project tree is clean (exit 0)"; else ko "real tree fired (rc=$rc): $out"; fi

# --- build a clean fixture: every allowlist file carries the token, a
# scoped role and its skill are inbox-free. ---
SCRATCH=$(mktemp -d -t maint-inbox-XXXXXX)
trap 'rm -rf "$SCRATCH"' EXIT

git -C "$SCRATCH" init --quiet --initial-branch=main
git -C "$SCRATCH" config user.name "test-bot"
git -C "$SCRATCH" config user.email "test@example.invalid"

seed_clean() {
  rm -rf "${SCRATCH:?}/roles" "${SCRATCH:?}/skills"
  for f in "${ALLOWLIST[@]}"; do
    mkdir -p "$SCRATCH/$(dirname "$f")"
    printf 'Free-standing reference: message-user.sh routes to the maintainer inbox.\n' > "$SCRATCH/$f"
  done
  # A scoped role (builder) that is inbox-free and loads a clean skill.
  mkdir -p "$SCRATCH/roles/builder" "$SCRATCH/skills/pre-pr-checklist"
  printf '# Role: builder\n\nUses [pre-pr-checklist](../../skills/pre-pr-checklist/SKILL.md). Reply via PR comments.\n' \
    > "$SCRATCH/roles/builder/AGENT.md"
  printf '# Skill: pre-pr-checklist\n\nNo maintainer-channel content here.\n' \
    > "$SCRATCH/skills/pre-pr-checklist/SKILL.md"
}

run_gate() {
  # The gate uses `git grep`, which searches tracked files; stage the
  # fixture so freshly written files are visible.
  git -C "$SCRATCH" add -A >/dev/null 2>&1
  set +e
  OUT=$(GATE_REPO_ROOT="$SCRATCH" bash "$CHECK" 2>&1)
  RC=$?
  set -e
}

# --- 2. clean fixture exits 0 ---
seed_clean
run_gate
if [ "$RC" -eq 0 ]; then ok "clean fixture exits 0"; else ko "clean fixture fired (rc=$RC): $OUT"; fi

# --- 3. condition 1: scoped role carries a token ---
seed_clean
printf '\nWhen blocked, message-user.sh the maintainer inbox.\n' >> "$SCRATCH/roles/builder/AGENT.md"
run_gate
if [ "$RC" -ne 0 ]; then ok "scoped-role leak fires"; else ko "scoped-role leak did not fire"; fi
echo "$OUT" | grep -q 'roles/builder/AGENT.md' && ok "names the offending scoped role" || ko "did not name builder ($OUT)"

# --- 4. condition 2: scoped role loads an inbox-bearing skill ---
seed_clean
# builder loads message-bus (an allowlisted, token-bearing skill).
printf '\nUses [message-bus](../../skills/message-bus/SKILL.md) for coordination.\n' \
  >> "$SCRATCH/roles/builder/AGENT.md"
run_gate
if [ "$RC" -ne 0 ]; then ok "scoped-role-loads-inbox-skill fires"; else ko "loads-inbox-skill did not fire"; fi
echo "$OUT" | grep -q 'loads skills/message-bus/SKILL.md' && ok "names the loaded inbox skill" || ko "did not name the loaded skill ($OUT)"

# --- 5. condition 3a: off-allowlist file carries a token ---
seed_clean
mkdir -p "$SCRATCH/skills/some-new-skill"
printf '# Skill\n\nReport to the maintainer inbox via message-user.sh.\n' \
  > "$SCRATCH/skills/some-new-skill/SKILL.md"
run_gate
if [ "$RC" -ne 0 ]; then ok "off-allowlist leak fires"; else ko "off-allowlist leak did not fire"; fi
echo "$OUT" | grep -q 'some-new-skill' && ok "names the off-allowlist file" || ko "did not name off-allowlist file ($OUT)"

# --- 6. condition 3b: stale allowlist entry (token removed) ---
seed_clean
printf 'No inbox content anymore.\n' > "$SCRATCH/skills/self-healing-wrapper/SKILL.md"
run_gate
if [ "$RC" -ne 0 ]; then ok "stale allowlist entry fires"; else ko "stale allowlist entry did not fire"; fi
echo "$OUT" | grep -q 'STALE' && ok "reports a stale allowlist entry" || ko "did not report STALE ($OUT)"

echo "=== test_maintainer_inbox_information_hiding: $PASS passed, $FAIL failed ==="
if [ "$FAIL" -gt 0 ]; then exit 1; fi
exit 0
