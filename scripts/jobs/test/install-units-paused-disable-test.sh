#!/bin/bash
# install-units-paused-disable-test.sh — a deliberately-PAUSED unit must be
# actively STOPPED+DISABLED on every install/reconcile, not merely omitted from
# the enable set.
#
# Regression: garden-ironhorse-fuzz.timer was listed as excluded (so a reconcile
# never re-ENABLED it) but was ALREADY armed when it was paused, so it stayed
# enabled and kept launching ticks systemd SIGKILLed at their start timeout.
# Omission ≠ disarm. install-units.sh now distinguishes two classes:
#   * EXCLUDED_UNITS (omit-only, monitoring-gated: garden-mention-watcher) — the
#     maintainer may arm these by hand, so a reconcile must NEVER force-disable
#     them.
#   * PAUSED_UNITS (disarm: garden-ironhorse-fuzz) — actively stop+disable on
#     every reconcile so the pause is durable regardless of prior arm state.
#
# No real systemd: GARDEN_UNIT_CTL points at a mock that logs every call, so the
# test asserts on exactly what unit_ctl was asked to do.
#
# Usage: install-units-paused-disable-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
INSTALL="$JOBS/install-units.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so the fixture is authoritative.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN|JOURNAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# The mock (GARDEN_UNIT_CTL) is exec'd, and `[ -x ]`/execve fail with EACCES on a
# `noexec` mount (this container's /tmp). Probe candidate bases and take the first
# that actually runs a throwaway script — same pattern as run-test.sh.
tr_base=""
for cand in "${TMPDIR:-}" /var/tmp /tmp "$HOME"; do
  { [ -n "$cand" ] && [ -d "$cand" ] && [ -w "$cand" ]; } || continue
  probe="$(mktemp -d "$cand/.iup-probe.XXXXXX" 2>/dev/null)" || continue
  printf '#!/bin/sh\nexit 0\n' > "$probe/x"; chmod +x "$probe/x" 2>/dev/null || true
  if [ -x "$probe/x" ] && "$probe/x" 2>/dev/null; then rm -rf "$probe"; tr_base="$cand"; break; fi
  rm -rf "$probe"
done
[ -n "$tr_base" ] || tr_base="$HOME"
TD="$(mktemp -d "$tr_base/.iup-test.XXXXXX")"
trap 'rm -rf "$TD"' EXIT

# A GARDEN_UNIT_CTL mock recording every call verbatim, one per line. is-enabled
# returns whatever ISENABLED_<sanitized-unit> says (default: enabled), so a
# verify run can be driven into either state.
CTL="$TD/ctl.sh"; LOG="$TD/ctl.log"; : > "$LOG"
cat > "$CTL" <<'EOF'
#!/bin/bash
echo "$*" >> "$GARDEN_UNIT_CTL_LOG"
if [ "$1" = "is-enabled" ]; then
  var="ISENABLED_$(printf '%s' "$2" | tr -c 'A-Za-z0-9' _)"
  printf '%s\n' "${!var:-enabled}"
  [ "${!var:-enabled}" = enabled ] && exit 0 || exit 1
fi
exit 0
EOF
chmod +x "$CTL"
export GARDEN_UNIT_CTL="$CTL" GARDEN_UNIT_CTL_LOG="$LOG"
export XDG_CONFIG_HOME="$TD/cfg"; mkdir -p "$XDG_CONFIG_HOME/systemd/user"

# has_call <regex> — true if the ctl log has a line matching the anchored regex.
has_call() { grep -qE "$1" "$LOG"; }

# ============================================================================
hr; echo "install (render) actively disarms the paused unit(s)"; hr
: > "$LOG"
bash "$INSTALL" install >/dev/null 2>&1 || true
has_call '^disable garden-ironhorse-fuzz\.timer$'      && ok "install disables ironhorse timer"   || bad "install did NOT disable ironhorse timer"
has_call '^stop --no-block garden-ironhorse-fuzz\.timer$' && ok "install stops ironhorse timer"    || bad "install did NOT stop ironhorse timer"
has_call '^disable garden-ironhorse-fuzz\.service$'    && ok "install disables ironhorse service" || bad "install did NOT disable ironhorse service"
# The maintainer-armed-by-hand class must NEVER be force-disabled.
has_call '^disable garden-mention-watcher\.'           && bad "install force-disabled mention-watcher (must not)" || ok "install leaves mention-watcher alone"

# ============================================================================
hr; echo "enable-services (reconcile) disarms paused AND enables intended"; hr
: > "$LOG"
bash "$INSTALL" enable-services >/dev/null 2>&1 || true
has_call '^disable garden-ironhorse-fuzz\.timer$'   && ok "reconcile disables ironhorse timer"          || bad "reconcile did NOT disable ironhorse timer"
has_call '^enable garden-ironhorse-fuzz\.'          && bad "reconcile ENABLED an ironhorse unit (paused must stay off)" || ok "reconcile never enables a paused unit"
# A representative intended standing unit is still enabled — disarming paused
# units did not break the normal enable set.
has_call '^enable garden-foreman\.timer$'           && ok "reconcile still enables an intended unit (foreman)" || bad "reconcile did NOT enable garden-foreman.timer"
has_call '^disable garden-mention-watcher\.'        && bad "reconcile force-disabled mention-watcher (must not)" || ok "reconcile leaves mention-watcher alone"

# ============================================================================
hr; echo "verify reports a re-armed paused unit as drift"; hr
: > "$LOG"
# ironhorse timer reported ENABLED (a re-arm slipped past the pause); everything
# else reported enabled so intended units are clean and only the paused one drifts.
ISENABLED_garden_ironhorse_fuzz_timer=enabled \
  bash "$INSTALL" enable-services --verify >"$TD/verify.out" 2>&1; vrc=$?
[ "$vrc" -ne 0 ] && ok "verify exits non-zero when a paused unit is armed" || bad "verify exited 0 despite an armed paused unit"
grep -qi 'DRIFT: garden-ironhorse-fuzz\.timer.*paused' "$TD/verify.out" && ok "verify names the armed paused unit as drift" || bad "verify did not flag the armed paused unit"

# When every paused unit is disabled, verify is clean on that axis.
: > "$LOG"
ISENABLED_garden_ironhorse_fuzz_timer=disabled ISENABLED_garden_ironhorse_fuzz_service=disabled \
  bash "$INSTALL" enable-services --verify >"$TD/verify2.out" 2>&1 || true
grep -qi 'ok: garden-ironhorse-fuzz\.timer disabled (paused)' "$TD/verify2.out" && ok "verify reports a properly-disabled paused unit as ok" || bad "verify did not report the disabled paused unit as ok"

# ============================================================================
hr
echo "install-units-paused-disable: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
