#!/bin/bash
# enable-services-test.sh — install-units.sh enable-services coverage + drift guard.
#
# Regression for the 2026-06-26 dormant-timers defect: several garden timers
# (foreman, deadmail, follow-up, proxy, mirror-closer) were installed but the
# hand-maintained enable list never enabled them, so the services never ran. The
# fix DERIVES the enable set from the units actually present, so a newly-added
# garden-*.timer / standalone garden-*.service is covered automatically. These
# checks assert the derived set, the documented exclusions (templates +
# monitoring-gated mention-watcher), the retired-unit cleanup, and the drift
# verify — all against a mocked `systemctl --user`, no real systemd required.
#
# Usage: enable-services-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
SRC="$ROOT/scripts/systemd"
INSTALL="$JOBS/install-units.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

TR=/home/kris/.garden-enable-test
rm -rf "$TR"; mkdir -p "$TR"

# Common mocked-systemctl env: the script's unit_ctl routes through this.
export GARDEN_ROOT="$ROOT"
export GARDEN_UNIT_CTL="$HERE/mock-systemctl.sh"
export GARDEN_MOCK_STATE="$TR/armed" GARDEN_MOCK_LOG="$TR/log"
reset_mock() { : > "$GARDEN_MOCK_STATE"; : > "$GARDEN_MOCK_LOG"; }

# ============================================================================
hr; echo "STATIC — the script parses (bash -n)"; hr
bash -n "$INSTALL" && ok "install-units.sh parses" || bad "install-units.sh has a syntax error"
bash -n "$HERE/mock-systemctl.sh" && ok "mock-systemctl.sh parses" || bad "mock-systemctl.sh has a syntax error"

# ============================================================================
hr; echo "ENABLE — derived set covers all intended timers + standalone services"; hr
reset_mock
"$INSTALL" enable-services >/dev/null 2>&1

# Build the EXPECTED set independently of the script: every non-template
# garden-*.timer with WantedBy=timers.target EXCEPT mention-watcher, plus every
# non-template garden-*.service that has NO sibling timer and declares [Install].
expected="$TR/expected"; : > "$expected"
for f in "$SRC"/garden-*.timer; do
  b="$(basename "$f")"; case "$b" in *@*) continue;; esac
  [ "$b" = garden-mention-watcher.timer ] && continue
  grep -q '^WantedBy=timers\.target' "$f" && echo "$b" >> "$expected"
done
for f in "$SRC"/garden-*.service; do
  b="$(basename "$f")"; case "$b" in *@*) continue;; esac
  [ "$b" = garden-mention-watcher.service ] && continue
  base="${b%.service}"; [ -e "$SRC/$base.timer" ] && continue
  grep -q '^WantedBy=' "$f" && echo "$b" >> "$expected"
done
sort -o "$expected" "$expected"
sort "$GARDEN_MOCK_STATE" > "$TR/armed.sorted"
if diff -q "$expected" "$TR/armed.sorted" >/dev/null; then
  ok "enabled set == derived intended set ($(wc -l <"$expected") units)"
else
  bad "enabled set differs from intended set:"; diff "$expected" "$TR/armed.sorted" | sed 's/^/      /'
fi

# Each of the formerly-dormant timers is now present.
for u in garden-foreman.timer garden-deadmail.timer garden-follow-up.timer \
         garden-proxy.timer garden-mirror-closer.timer; do
  grep -qxF "$u" "$GARDEN_MOCK_STATE" && ok "$u enabled (was dormant)" || bad "$u NOT enabled"
done
# Standalone continuous services are enabled as services (the bulletin migration
# case). The design-poller was retired 2026-06-26 (its unit no longer ships), so
# it is no longer asserted here.
for u in garden-bulletin.service; do
  grep -qxF "$u" "$GARDEN_MOCK_STATE" && ok "$u enabled (standalone service)" || bad "$u NOT enabled"
done

# ============================================================================
hr; echo "EXCLUDE — templates and the monitoring-gated watcher stay off"; hr
grep -q '@' "$GARDEN_MOCK_STATE" \
  && bad "a template unit (garden-*@) was enabled" || ok "no template unit enabled (per-instance only)"
grep -q mention-watcher "$GARDEN_MOCK_STATE" \
  && bad "garden-mention-watcher was auto-enabled (monitoring-gated)" \
  || ok "garden-mention-watcher NOT auto-enabled (left for maintainer to arm)"

# ============================================================================
hr; echo "RETIRE — the bulletin's old oneshot timer is disabled"; hr
grep -q 'disable --now garden-bulletin.timer' "$GARDEN_MOCK_LOG" \
  && ok "retired garden-bulletin.timer disabled on enable" || bad "garden-bulletin.timer not retired"

# ============================================================================
hr; echo "VERIFY — drift check passes when enabled, fails when a unit drops"; hr
reset_mock
"$INSTALL" enable-services >/dev/null 2>&1
set +e
"$INSTALL" enable-services --verify >/dev/null 2>&1; vrc=$?
set -e
[ "$vrc" -eq 0 ] && ok "verify on a fully-enabled host reports no drift (rc=0)" || bad "verify false-positive (rc=$vrc)"
# Drop one intended unit → verify must flag it and exit non-zero.
grep -vxF 'garden-foreman.timer' "$GARDEN_MOCK_STATE" > "$GARDEN_MOCK_STATE.t"; mv "$GARDEN_MOCK_STATE.t" "$GARDEN_MOCK_STATE"
set +e
vout="$("$INSTALL" enable-services --verify 2>&1)"; vrc2=$?
set -e
{ [ "$vrc2" -ne 0 ] && grep -q 'DRIFT: garden-foreman.timer' <<<"$vout"; } \
  && ok "verify flags a dropped unit and exits non-zero (drift visible)" || bad "verify missed the drift (rc=$vrc2)"

hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
