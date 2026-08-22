#!/bin/bash
# related-design-panel-seat-stub.sh — a GARDEN_PANEL_SEAT fixture for
# related-design-sensing-test.sh. panel.sh calls it as `<seat> <pr> <wt> <base>`.
# It emits a minimal per-juror block and, for the integrator, records to
# $GARDEN_RD_SEAT_LOG whether panel.sh's related-design pre-pass exported the
# evidence file (the mechanism that FORCES the integrator lens over the outstanding
# related-design direction). Committed because /tmp is noexec.
set -euo pipefail
seat="$1"

if [ "$seat" = integrator ] && [ -n "${GARDEN_RD_SEAT_LOG:-}" ]; then
  ev="${GARDEN_PANEL_RELATED_DESIGN_EVIDENCE:-}"
  if [ -n "$ev" ] && [ -s "$ev" ]; then
    {
      echo "integrator-saw-evidence=1"
      grep -c '^related-design pr=' "$ev" 2>/dev/null | sed 's/^/related-pr-lines=/'
      grep -q 'related-design-verdict=attention' "$ev" && echo "verdict=attention" || echo "verdict=other"
    } > "$GARDEN_RD_SEAT_LOG"
  else
    echo "integrator-saw-evidence=0" > "$GARDEN_RD_SEAT_LOG"
  fi
fi

cat <<EOF
### $seat

**Verdict:** approve

**Findings:**
- none (stub). [rule: skills/panel-review/SKILL.md]
EOF
