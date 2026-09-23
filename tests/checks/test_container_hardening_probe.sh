#!/bin/bash
# test_container_hardening_probe.sh -- behavior test for
# scripts/check-container-hardening.sh, the container-hardening acceptance probe.
#
# The probe is environment-sensing (caps, sudo, /dev, gh, ssh-add), so a full
# hardened-vs-unhardened matrix would need a real recreated container. Here we
# assert the pieces that hold in ANY environment and are the probe's contract:
#   - the script exists, is executable, and parses / shellchecks clean;
#   - it emits all seven named checks and a summary line;
#   - its EXIT CODE is consistent with the summary (0 iff zero failures, else 1);
#   - the host/container guard clause is present (SKIP → exit 2 off-container);
#   - it is wired into bring-up verification and a periodic timer.
#
# Deterministic and hermetic: no network, no journal, no claude.

set -uo pipefail

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT=$(cd "$HARNESS_DIR/../.." && pwd)
PROBE="$PROJECT_ROOT/scripts/check-container-hardening.sh"

PASS=0
FAIL=0
ok() { PASS=$((PASS+1)); echo "  PASS: $1"; }
ko() { FAIL=$((FAIL+1)); echo "  FAIL: $1"; }

echo "=== test_container_hardening_probe ==="

[ -f "$PROBE" ] || { echo "missing $PROBE"; exit 2; }
[ -x "$PROBE" ] && ok "probe is executable" || ko "probe not executable"

# --- parses / shellcheck ------------------------------------------------------
bash -n "$PROBE" && ok "probe parses (bash -n)" || ko "probe has a syntax error"
if command -v shellcheck >/dev/null 2>&1; then
  shellcheck "$PROBE" >/dev/null 2>&1 && ok "probe is shellcheck-clean" || ko "probe has shellcheck findings"
else
  echo "  SKIP: shellcheck not installed"
fi

# --- the seven checks are all present in the source ---------------------------
for needle in \
  '/.dockerenv' 'effective caps' 'passwordless' 'block device' \
  'mount of a block device' 'kriskowal' 'SSH agent'; do
  grep -qi "$needle" "$PROBE" && ok "check present: $needle" || ko "check missing: $needle"
done

# --- the off-container SKIP guard exists (exit 2 semantics) -------------------
grep -q '/.dockerenv' "$PROBE" && grep -q 'exit 2' "$PROBE" \
  && ok "off-container SKIP guard present (exit 2)" || ko "no off-container SKIP guard"

# --- run it and check the OUTPUT CONTRACT + exit-code consistency -------------
# We are (usually) inside a container, so the probe runs its checks. Whatever the
# posture, the summary must exist and the exit code must agree with it.
set +e
out="$($PROBE 2>&1)"
rc=$?
set -e

if [ "$rc" -eq 2 ]; then
  # Ran off-container (or PID-1 cgroup unrecognized): the SKIP path. Contract: it
  # said so and did not pretend to have a verdict.
  echo "$out" | grep -qi 'SKIP' && ok "off-container run SKIPs cleanly (rc=2)" \
    || ko "rc=2 but no SKIP message (got: $out)"
else
  summary="$(echo "$out" | grep -oE 'hardening probe: [0-9]+ passed, [0-9]+ failed' | tail -1)"
  [ -n "$summary" ] && ok "emits a summary line" || ko "no summary line (got: $out)"
  failed_n="$(echo "$summary" | grep -oE '[0-9]+ failed' | grep -oE '[0-9]+')"
  passed_n="$(echo "$summary" | grep -oE '[0-9]+ passed' | grep -oE '[0-9]+')"
  [ -n "$passed_n" ] && [ "$passed_n" -ge 1 ] && ok "at least one check evaluated" || ko "no checks evaluated"
  # Exit-code consistency: 0 iff zero failures, else 1.
  if [ "${failed_n:-0}" -eq 0 ]; then
    [ "$rc" -eq 0 ] && ok "exit 0 when zero checks failed" || ko "checks all passed but rc=$rc"
  else
    [ "$rc" -eq 1 ] && ok "exit 1 when a check failed ($failed_n failing)" || ko "$failed_n failing but rc=$rc"
  fi
fi

# --- wiring: bring-up verification and periodic timer ------------------------
grep -q 'check-container-hardening.sh' "$PROJECT_ROOT/context/operations/starting.md" \
  && ok "starting.md § Verify references the probe" || ko "starting.md does not reference the probe"
[ -f "$PROJECT_ROOT/scripts/systemd/garden-container-hardening.service" ] \
  && [ -f "$PROJECT_ROOT/scripts/systemd/garden-container-hardening.timer" ] \
  && ok "periodic hardening units present" || ko "periodic hardening units missing"

echo "=== test_container_hardening_probe: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] || exit 1
exit 0
