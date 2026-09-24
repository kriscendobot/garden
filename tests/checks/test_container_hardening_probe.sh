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

# --- hermetic verdict state: never touch the real marker or post a real notice --
VT="$(mktemp -d "${TMPDIR:-/tmp}/hardening-probe-test.XXXXXX")"
trap 'rm -rf "$VT"' EXIT
NOTICES="$VT/notices.log"; : > "$NOTICES"
cat > "$VT/notice.sh" <<EOF
#!/bin/bash
body="\$(cat)"
printf 'NOTICE %s\n' "\$*" >> "$NOTICES"
EOF
chmod +x "$VT/notice.sh"
export GARDEN_HARDENING_NOTICE="$VT/notice.sh" GARDEN="testhost-garden-00000000"
unset GARDEN_HARDENING_STRICT GARDEN_HARDENING_PENDING_RENOTIFY

# --- run it and check the OUTPUT CONTRACT + exit-code consistency -------------
# We are (usually) inside a container, so the probe runs its checks. Whatever the
# posture, the summary must exist and the exit code must agree with it. The run
# uses a fresh marker path, so a failure is either PENDING (rc 3) or real (rc 1).
set +e
out="$(GARDEN_HARDENING_MARKER="$VT/live/hardened-verified" $PROBE 2>&1)"
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
  # Exit-code consistency: 0 iff zero failures; else 3 (PENDING, said so) or 1.
  if [ "${failed_n:-0}" -eq 0 ]; then
    [ "$rc" -eq 0 ] && ok "exit 0 when zero checks failed" || ko "checks all passed but rc=$rc"
  elif [ "$rc" -eq 3 ]; then
    echo "$out" | grep -q 'PENDING RECREATE' && ok "unrecreated live host → PENDING RECREATE, rc=3 ($failed_n failing)" \
      || ko "rc=3 without a PENDING RECREATE verdict"
  else
    [ "$rc" -eq 1 ] && ok "exit 1 when a check failed ($failed_n failing)" || ko "$failed_n failing but rc=$rc"
  fi
fi

# --- verdict matrix (the --verdict-selftest seam, no environment probing) -----
verdict() {  # verdict <marker-dir> <posture> <total> [ENV=VAL...] → prints rc
  local m="$1" p="$2" t="$3"; shift 3
  env GARDEN_HARDENING_MARKER="$VT/$m/hardened-verified" "$@" "$PROBE" --verdict-selftest "$p" "$t" >/dev/null 2>&1
  echo $?
}
# Unrecreated host (no marker), only launcher-posture checks fail → PENDING, one notice.
: > "$NOTICES"
r1="$(verdict unrec 3 3)"; r2="$(verdict unrec 3 3)"
[ "$r1" = 3 ] && [ "$r2" = 3 ] && ok "unrecreated host: posture-only failure → rc 3 (clean for the unit)" \
  || ko "unrecreated host rc=$r1/$r2, want 3"
n="$(grep -c 'container-hardening-pending-recreate-testhost' "$NOTICES")"
[ "$n" = 1 ] && ok "pending recreate reported through ONE coalesced notice across repeat runs" \
  || ko "pending notices sent: $n (want 1): $(cat "$NOTICES")"
[ ! -e "$VT/unrec/hardened-verified" ] && ok "pending run records no hardened marker" || ko "pending run wrote the marker"
r="$(verdict unrec 3 3 GARDEN_HARDENING_STRICT=1)"
[ "$r" = 1 ] && ok "GARDEN_HARDENING_STRICT=1 reports the unrecreated host as rc 1" || ko "strict rc=$r, want 1"
# A credential check failing (not fixed by a recreate) is never pending.
r="$(verdict unrec 2 3)"
[ "$r" = 1 ] && ok "unrecreated host with a credential/guard failure → rc 1 (not masked as pending)" || ko "rc=$r, want 1"
# First all-pass run records the marker and closes the pending notice.
: > "$NOTICES"
r="$(verdict unrec 0 0)"
[ "$r" = 0 ] && [ -f "$VT/unrec/hardened-verified" ] && ok "first all-pass run → rc 0 and records the hardened marker" \
  || ko "all-pass rc=$r, marker=$(ls "$VT/unrec" 2>&1)"
grep -q -- '--recovered container-hardening-pending-recreate-testhost' "$NOTICES" \
  && ok "the verified run closes the pending notice (--recovered)" || ko "no recovered notice: $(cat "$NOTICES")"
# Regressed hardened host: the marker exists, a posture check fails → loud rc 1.
: > "$NOTICES"
set +e; rout="$(GARDEN_HARDENING_MARKER="$VT/unrec/hardened-verified" "$PROBE" --verdict-selftest 1 1 2>&1)"; r=$?; set -e
[ "$r" = 1 ] && echo "$rout" | grep -q REGRESSED && ok "regressed hardened host → rc 1 with REGRESSED" \
  || ko "regressed host rc=$r out=$rout"
[ ! -s "$NOTICES" ] && ok "a regression is not folded into the pending notice" || ko "regression posted a pending notice"

# --- the unit treats PENDING (3) as success, a regression (1) as failure --------
UNIT="$PROJECT_ROOT/scripts/systemd/garden-container-hardening.service"
grep -qE '^SuccessExitStatus=.*\b3\b' "$UNIT" && ok "unit SuccessExitStatus includes 3 (pending)" || ko "unit does not accept exit 3"
grep -q -- '--expect 3' "$UNIT" && ok "self-heal-run treats 3 as clean (--expect 3)" || ko "self-heal-run missing --expect 3"
grep -qE '^SuccessExitStatus=.*\b1\b' "$UNIT" && ko "unit wrongly accepts exit 1" || ok "exit 1 (regression) still fails the unit"

# --- wiring: bring-up verification and periodic timer ------------------------
grep -q 'check-container-hardening.sh' "$PROJECT_ROOT/context/operations/starting.md" \
  && ok "starting.md § Verify references the probe" || ko "starting.md does not reference the probe"
[ -f "$PROJECT_ROOT/scripts/systemd/garden-container-hardening.service" ] \
  && [ -f "$PROJECT_ROOT/scripts/systemd/garden-container-hardening.timer" ] \
  && ok "periodic hardening units present" || ko "periodic hardening units missing"

echo "=== test_container_hardening_probe: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] || exit 1
exit 0
