#!/bin/bash
# timer-fire-test.sh — integration check that an @-instance timer actually fires
# its same-instance service on schedule (Bug 1 regression guard).
#
# The comment-watcher / triager timers are TEMPLATE timers: garden-X@.timer must
# trigger garden-X@<instance>.service. The historical defect was an OnActiveSec-
# only anchor that, before the service had ever run, could end up with NO future
# trigger — the timer sat `active` but never fired. The hardened templates anchor
# the first elapse to OnBootSec (a fixed monotonic reference, always recomputable
# and already-past on an up host) and bind the instance service explicitly, so a
# concrete next-trigger always exists.
#
# Two layers, each skipped (not failed) when its tooling is unavailable so the
# check is safe in a minimal CI container:
#   STATIC  — `systemd-analyze verify` parses the real garden timer+service
#             templates and resolves the @-instance binding.
#   DYNAMIC — install a throwaway @-timer/@-service pair that mirrors the hardened
#             [Timer], `enable --now` ONLY the timer (never the service), and
#             assert the service runs within a bounded wait. This reproduces
#             "active timer fires its @-instance service with no manual start".
#
# Usage: timer-fire-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
SYSD="$ROOT/scripts/systemd"
PASS=0; FAIL=0; SKIP=0
ok()   { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad()  { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
skip() { echo "  SKIP: $*"; SKIP=$((SKIP+1)); }
hr()   { echo "----------------------------------------------------------------"; }

TR=/home/kris/.garden-timer-test
rm -rf "$TR"; mkdir -p "$TR"

# ============================================================================
hr; echo "STATIC — render + systemd-analyze verify the garden @-timers"; hr
if ! command -v systemd-analyze >/dev/null 2>&1; then
  skip "systemd-analyze not present; skipping static verify"
else
  RD="$TR/units"; mkdir -p "$RD"
  for f in "$SYSD"/garden-comment-watcher@.* "$SYSD"/garden-triager@.*; do
    sed "s#@GARDEN_ROOT@#$ROOT#g" "$f" > "$RD/$(basename "$f")"
  done
  for tmpl in garden-comment-watcher garden-triager; do
    # Instantiate a concrete instance so the @%i Unit= binding is resolved.
    cp "$RD/$tmpl@.timer"   "$RD/$tmpl@verify.timer"
    cp "$RD/$tmpl@.service" "$RD/$tmpl@verify.service"
    if systemd-analyze verify "$RD/$tmpl@verify.timer" >"$TR/verify.out" 2>&1; then
      ok "$tmpl@.timer parses and binds its @-instance service"
    else
      bad "$tmpl@.timer failed verify: $(cat "$TR/verify.out")"
    fi
    # The hardened anchor MUST be present (guards against a regression to the
    # OnActiveSec-only form that could leave the timer with no future trigger).
    grep -q '^OnBootSec=' "$RD/$tmpl@.timer" && grep -q '^Unit=' "$RD/$tmpl@.timer" \
      && ok "$tmpl@.timer has the OnBootSec anchor + explicit Unit= binding" \
      || bad "$tmpl@.timer missing OnBootSec anchor or explicit Unit="
  done
fi

# ============================================================================
hr; echo "DYNAMIC — a hardened @-timer fires its @-instance service, no manual start"; hr
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=$XDG_RUNTIME_DIR/bus}"
if ! systemctl --user show-environment >/dev/null 2>&1; then
  skip "no live 'systemctl --user' manager; skipping dynamic fire test"
  hr; echo "RESULT: $PASS passed, $FAIL failed, $SKIP skipped"; hr
  [ "$FAIL" -eq 0 ]; exit $?
fi

UDIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
mkdir -p "$UDIR"
NAME="garden-timerfiretest"
MARK="$TR/fired.marker"
cleanup() {
  systemctl --user disable --now "$NAME@probe.timer" >/dev/null 2>&1 || true
  systemctl --user stop "$NAME@probe.service" >/dev/null 2>&1 || true
  rm -f "$UDIR/$NAME@.timer" "$UDIR/$NAME@.service"
  systemctl --user daemon-reload >/dev/null 2>&1 || true
}
trap cleanup EXIT

# A throwaway service that records that it ran, and a timer mirroring the hardened
# anchor shape (OnBootSec in the past on an up host → fires immediately on enable).
cat > "$UDIR/$NAME@.service" <<EOF
[Unit]
Description=garden timer-fire probe %i
[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo %i > "$MARK"'
EOF
cat > "$UDIR/$NAME@.timer" <<EOF
[Unit]
Description=garden timer-fire probe timer %i
[Timer]
Unit=$NAME@%i.service
OnBootSec=1s
OnUnitActiveSec=90s
AccuracySec=1s
[Install]
WantedBy=timers.target
EOF

rm -f "$MARK"
systemctl --user daemon-reload
# Enable+start ONLY the timer — never the service. A correct @-binding makes the
# timer trigger the same-instance service on its own.
systemctl --user enable --now "$NAME@probe.timer" >/dev/null 2>&1

fired=0
for _ in $(seq 1 30); do
  [ -f "$MARK" ] && { fired=1; break; }
  sleep 1
done
if [ "$fired" -eq 1 ] && [ "$(cat "$MARK" 2>/dev/null)" = probe ]; then
  ok "timer fired its @probe.service autonomously (no manual service start)"
else
  bad "timer never fired its @-instance service within 30s (marker absent)"
fi
ltrig="$(systemctl --user show "$NAME@probe.timer" -p LastTriggerUSec --value 2>/dev/null)"
[ -n "$ltrig" ] && ok "LastTriggerUSec advanced ($ltrig)" || bad "LastTriggerUSec still empty (timer never triggered)"

hr; echo "RESULT: $PASS passed, $FAIL failed, $SKIP skipped"; hr
[ "$FAIL" -eq 0 ]
