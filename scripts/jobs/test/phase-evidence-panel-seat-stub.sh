#!/bin/bash
set -eu
seat="${1:?seat}"
if [ "$seat" = integrator ] && [ -n "${GARDEN_PANEL_PHASE_EVIDENCE:-}" ] \
   && [ -s "$GARDEN_PANEL_PHASE_EVIDENCE" ]; then
  printf 'integrator-saw-phase-evidence=1\n' >> "${GARDEN_PHASE_SEAT_LOG:?}"
fi
printf '**Verdict:** approve\n\n**Findings**\n\n- none from %s\n' "$seat"
