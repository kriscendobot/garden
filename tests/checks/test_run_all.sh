#!/bin/bash
# test_run_all.sh -- smoke-test the pre-dispatch grep-gate runner.
#
# Verifies:
#   - --list enumerates the installed gates.
#   - --dry-run on a clean tree exits 0.
#   - --dry-run on a tree with an offender exits non-zero and names
#     the firing gate, without invoking the (stubbed) claude binary.
#   - When a gate fires without --dry-run, claude IS invoked (the
#     stub records the invocation in a log).
#   - --gate <name> filters to one gate.

set -uo pipefail

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT=$(cd "$HARNESS_DIR/../.." && pwd)
RUN_ALL="$PROJECT_ROOT/scripts/checks/run-all.sh"

PASS=0
FAIL=0

ok() { PASS=$((PASS+1)); echo "  PASS: $1"; }
ko() { FAIL=$((FAIL+1)); echo "  FAIL: $1"; }

echo "=== test_run_all ==="

[ -x "$RUN_ALL" ] || [ -f "$RUN_ALL" ] || { echo "missing $RUN_ALL"; exit 2; }

# The claude stub below is placed on PATH and MUST be executable: bash's
# PATH search (and `command -v`) probes with the equivalent of `[ -x ]`,
# which honors a mount's `noexec` flag. The default temp base (/tmp) is
# mounted `noexec` in the garden container, so a stub written there reads
# as "present but not runnable", the PATH search skips it, and the runner
# falls through to the REAL /usr/bin/claude — subtest 4 then spawns a live
# agent and burns tokens on every `tests/checks/run.sh` (this bit: the two
# stub assertions failed for exactly this reason). So base the fixture on
# an EXEC-capable filesystem, probing candidates the way
# scripts/jobs/test/{claude-bin-resolver,gardener-worktree}-test.sh do.
pick_exec_base() {
  local c probe rc
  for c in "${GARDEN_TEST_TMP:-}" "${TMPDIR:-}" /tmp /var/tmp "${GARDEN_SCRATCH:-}" \
           "${GARDEN_ROOT:+$GARDEN_ROOT/scratch}"; do
    [ -n "$c" ] || continue
    [ -d "$c" ] && [ -w "$c" ] || continue
    probe="$(mktemp -d "$c/run-all-probe.XXXXXX" 2>/dev/null)" || continue
    printf '#!/bin/sh\nexit 7\n' > "$probe/x"; chmod +x "$probe/x" 2>/dev/null
    "$probe/x" >/dev/null 2>&1; rc=$?
    rm -rf "$probe"
    [ "$rc" -eq 7 ] && { printf '%s\n' "$c"; return 0; }
  done
  return 1
}
EXEC_BASE="$(pick_exec_base)" || {
  echo "  SKIP: no exec-allowed temp base (needed to run a fake claude)"
  exit 0
}

# Build a scratch tree that mirrors the runner-required layout. The
# runner expects scripts/checks/<gate>/check.sh+prompt.md under the
# repo root.
SCRATCH=$(mktemp -d "$EXEC_BASE/run-all.XXXXXX")
STUB_BIN=$(mktemp -d "$EXEC_BASE/run-all-bin.XXXXXX")
STUB_LOG="$SCRATCH/claude-invocations.log"

trap 'rm -rf "$SCRATCH" "$STUB_BIN"' EXIT

git -C "$SCRATCH" init --quiet --initial-branch=main
git -C "$SCRATCH" config user.name "test-bot"
git -C "$SCRATCH" config user.email "test@example.invalid"

mkdir -p "$SCRATCH/scripts/checks"

# Copy in the real runner unmodified.
cp "$RUN_ALL" "$SCRATCH/scripts/checks/run-all.sh"
chmod +x "$SCRATCH/scripts/checks/run-all.sh"

# Install two synthetic gates: one always-clean, one that fires when
# a sentinel file exists.
mkdir -p "$SCRATCH/scripts/checks/always-clean"
cat > "$SCRATCH/scripts/checks/always-clean/check.sh" <<'EOF'
#!/bin/bash
exit 0
EOF
chmod +x "$SCRATCH/scripts/checks/always-clean/check.sh"
echo "always-clean prompt" > "$SCRATCH/scripts/checks/always-clean/prompt.md"

mkdir -p "$SCRATCH/scripts/checks/sentinel"
cat > "$SCRATCH/scripts/checks/sentinel/check.sh" <<'EOF'
#!/bin/bash
if [ -f "$GATE_REPO_ROOT/SENTINEL" ]; then
  echo "sentinel present" >&2
  exit 1
fi
exit 0
EOF
chmod +x "$SCRATCH/scripts/checks/sentinel/check.sh"
echo "sentinel prompt body" > "$SCRATCH/scripts/checks/sentinel/prompt.md"

cat > "$SCRATCH/README.md" <<'EOF'
# scratch
EOF
git -C "$SCRATCH" add -A
git -C "$SCRATCH" commit --quiet -m "scratch: gates in place"

# Build a claude stub that records its invocation. Put it on PATH.
cat > "$STUB_BIN/claude" <<EOF
#!/bin/bash
echo "claude invoked: \$*" >> "$STUB_LOG"
exit 0
EOF
chmod +x "$STUB_BIN/claude"

# FAIL-CLOSED GUARD (defense in depth): assert the stub really is what the
# name `claude` resolves to under the test PATH, BEFORE any non-dry subtest
# can dispatch. Without this, a stub that is unexecutable (noexec base) or
# shadowed silently hands subtest 4 to the REAL claude, which spawns a live
# agent, burns tokens, and still leaves the assertions failing with no hint
# as to why. Abort loudly instead of leaking to production.
resolved=$(PATH="$STUB_BIN:$PATH" bash -c 'command -v claude' 2>/dev/null || true)
if [ "$resolved" != "$STUB_BIN/claude" ]; then
  echo "FATAL: claude stub does not win PATH resolution (got '${resolved:-none}'," >&2
  echo "       expected '$STUB_BIN/claude'). Refusing to run: the non-dry subtest" >&2
  echo "       would invoke the REAL claude. Is $EXEC_BASE mounted noexec?" >&2
  exit 2
fi

# --- 1. --list enumerates both gates ---
set +e
listing=$(bash "$SCRATCH/scripts/checks/run-all.sh" --list --repo "$SCRATCH" 2>&1)
rc=$?
set -e
if [ "$rc" -eq 0 ]; then ok "--list exits 0"; else ko "--list exit was $rc"; fi
if echo "$listing" | grep -q '^always-clean$'; then ok "--list names always-clean"; else ko "--list missing always-clean (got: $listing)"; fi
if echo "$listing" | grep -q '^sentinel$'; then ok "--list names sentinel"; else ko "--list missing sentinel (got: $listing)"; fi

# --- 2. --dry-run on clean tree exits 0 ---
set +e
PATH="$STUB_BIN:$PATH" bash "$SCRATCH/scripts/checks/run-all.sh" --dry-run --repo "$SCRATCH" >/dev/null 2>&1
rc=$?
set -e
if [ "$rc" -eq 0 ]; then ok "--dry-run on clean tree exits 0"; else ko "--dry-run clean exit was $rc"; fi

# --- 3. --dry-run on dirty tree exits non-zero, no claude invocation ---
touch "$SCRATCH/SENTINEL"
: > "$STUB_LOG"
set +e
out=$(PATH="$STUB_BIN:$PATH" bash "$SCRATCH/scripts/checks/run-all.sh" --dry-run --repo "$SCRATCH" 2>&1)
rc=$?
set -e
if [ "$rc" -ne 0 ]; then ok "--dry-run on dirty tree exits non-zero"; else ko "--dry-run dirty exit was $rc"; fi
if echo "$out" | grep -q 'gate fired.*sentinel'; then ok "--dry-run reports firing gate"; else ko "--dry-run did not report firing (got: $out)"; fi
if [ ! -s "$STUB_LOG" ]; then ok "--dry-run did not invoke claude"; else ko "--dry-run invoked claude (log: $(cat "$STUB_LOG"))"; fi

# --- 4. without --dry-run, claude IS invoked ---
: > "$STUB_LOG"
set +e
out=$(PATH="$STUB_BIN:$PATH" bash "$SCRATCH/scripts/checks/run-all.sh" --repo "$SCRATCH" 2>&1)
rc=$?
set -e
if [ "$rc" -ne 0 ]; then ok "non-dry firing exits non-zero"; else ko "non-dry firing exit was $rc"; fi
if [ -s "$STUB_LOG" ]; then ok "non-dry firing invoked claude"; else ko "non-dry firing did not invoke claude"; fi
if grep -q 'sentinel prompt body' "$STUB_LOG"; then ok "claude received the gate's prompt.md content"; else ko "claude did not get prompt body (log: $(cat "$STUB_LOG"))"; fi

# --- 5. --gate filter ---
rm -f "$SCRATCH/SENTINEL"  # back to clean
set +e
out=$(PATH="$STUB_BIN:$PATH" bash "$SCRATCH/scripts/checks/run-all.sh" --dry-run --gate always-clean --repo "$SCRATCH" 2>&1)
rc=$?
set -e
if [ "$rc" -eq 0 ]; then ok "--gate filter to clean gate exits 0"; else ko "--gate filter exit was $rc"; fi

# --- 6. --gate unknown name surfaces usage error ---
set +e
PATH="$STUB_BIN:$PATH" bash "$SCRATCH/scripts/checks/run-all.sh" --dry-run --gate nonexistent --repo "$SCRATCH" >/dev/null 2>&1
rc=$?
set -e
if [ "$rc" -eq 64 ]; then ok "--gate <unknown> exits 64"; else ko "--gate <unknown> exit was $rc (expected 64)"; fi

echo "=== test_run_all: $PASS passed, $FAIL failed ==="
if [ "$FAIL" -gt 0 ]; then exit 1; fi
exit 0
