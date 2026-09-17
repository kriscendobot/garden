#!/bin/bash
# alert-maintainer-edge-test.sh — a recurring config-freeze fault is one
# edge-triggered incident (fires when it BEGINS or its fingerprint CHANGES,
# silent while unchanged), followed by exactly one recovery notice. This is the
# dedup that keeps budget-level.sh's preflight freeze (e.g. a missing/invalid
# physical cap) from warning every leveling tick.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-alert-edge.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

export GARDEN_TEST=1
export GARDEN_STATE="$TR/state"
SINK="$TR/alerts.log"
: > "$SINK"
# Capture every delivery/recovery through the alternate sink: "<key>|<msg-first-line>".
export GARDEN_ALERT_CMD="$TR/sink.sh"
cat > "$GARDEN_ALERT_CMD" <<'EOF'
#!/bin/bash
printf '%s|%s\n' "$1" "$(printf '%s' "$2" | head -1)" >> "$GARDEN_SINK"
EOF
chmod +x "$GARDEN_ALERT_CMD"
export GARDEN_SINK="$SINK"

# shellcheck source=../common.sh
source "$JOBS/common.sh"

KEY=budget-level-monk-preflight
FAIL_A="fleet monk allocation frozen: oros-studio-garden-ce242c49 missing/invalid monk physical cap"
FAIL_B="fleet monk allocation frozen: oros-studio-garden-ce242c49 uncalibrated provenance"
OK="fleet monk allocation recovered; leveling resumed"

# Begins: first occurrence fires.
alert_maintainer_edge "$KEY" "$FAIL_A" "$FAIL_A" \
  || { echo "FAIL: first freeze did not fire the edge"; exit 1; }
# Unchanged: the identical fault stays silent, tick after tick.
alert_maintainer_edge "$KEY" "$FAIL_A" "$FAIL_A" \
  && { echo "FAIL: an unchanged freeze re-fired"; exit 1; }
alert_maintainer_edge "$KEY" "$FAIL_A" "$FAIL_A" \
  && { echo "FAIL: an unchanged freeze re-fired"; exit 1; }
[ "$(grep -c "^$KEY|" "$SINK")" -eq 1 ] \
  || { echo "FAIL: unchanged freeze did not collapse to ONE delivery"; cat "$SINK"; exit 1; }

# Changes: a different fingerprint re-alerts at once, even inside the throttle window.
alert_maintainer_edge "$KEY" "$FAIL_B" "$FAIL_B" \
  || { echo "FAIL: a changed freeze reason did not re-fire"; exit 1; }
[ "$(grep -c "^$KEY|" "$SINK")" -eq 2 ] \
  || { echo "FAIL: changed freeze did not deliver a second notice"; cat "$SINK"; exit 1; }

# Recovers: valid config returns → exactly one recovery notice, then the latch is gone.
alert_maintainer_edge_clear "$KEY" "$OK" \
  || { echo "FAIL: recovery did not emit a notice while a fault was latched"; exit 1; }
grep -q "^$KEY|RECOVERED: $OK" "$SINK" \
  || { echo "FAIL: recovery notice not delivered"; cat "$SINK"; exit 1; }
[ ! -e "$GARDEN_STATE/alerts/${KEY}.fingerprint" ] \
  || { echo "FAIL: recovery did not drop the fingerprint"; exit 1; }
# Idempotent recovery: nothing latched → no-op, no second recovery notice.
alert_maintainer_edge_clear "$KEY" "$OK" \
  && { echo "FAIL: recovery fired with nothing latched"; exit 1; }
[ "$(grep -c "RECOVERED:" "$SINK")" -eq 1 ] \
  || { echo "FAIL: a second recovery notice leaked"; cat "$SINK"; exit 1; }

# Re-arms: a later freeze after recovery gets its own fresh first notice.
alert_maintainer_edge "$KEY" "$FAIL_A" "$FAIL_A" \
  || { echo "FAIL: a post-recovery freeze did not re-fire"; exit 1; }
[ "$(grep -c "^$KEY|$FAIL_A" "$SINK")" -eq 2 ] \
  || { echo "FAIL: post-recovery freeze did not emit a fresh notice"; cat "$SINK"; exit 1; }

echo "PASS: preflight freeze warns on begin+change, suppresses repeats, recovers once, re-arms"
