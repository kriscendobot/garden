#!/usr/bin/env bash
# report.sh <window.json> <inventory.json> <plan.json>
#
# Prints the human-readable per-run report. The sensor prints this on every run
# (including no-motion runs). The producer posts it as the job body, and the
# claiming gardener copies it into the upgrade-PR body, when a plan is non-empty.

set -euo pipefail

WINDOW="$1"
INVENTORY="$2"
PLAN="$3"

today=$(jq -r '.today' "$WINDOW")
active=$(jq -r '.active_lts' "$WINDOW")
maint=$(jq -r '.maintenance_lts | join(", ")' "$WINDOW")
current=$(jq -r '.current' "$WINDOW")

echo "# Node.js LTS window report"
echo
echo "Generated: $today  (window state: active=$active, maintenance=[$maint], current=$current)"
echo

echo "## Plan"
echo
plan_count=$(jq '.entries | length' "$PLAN")
if [[ "$plan_count" -eq 0 ]]; then
  echo "(no motion; every pin surface already matches the policy)"
else
  jq -r '.entries[] |
    "  \(.kind): \(.file):\(.line)  \(.current | tostring) -> \(.desired | tostring)  (\(.reason))"' "$PLAN"
fi
echo
echo "rollup: $plan_count surface(s) affected."
echo

echo "## Upstream sources"
echo
echo "- https://nodejs.org/dist/index.json"
echo "- https://raw.githubusercontent.com/nodejs/Release/main/schedule.json"
echo

echo "## Out-of-scope inventory"
echo
frozen_count=$(jq '[.surfaces[] | select(.kind == "frozen" or .kind == "engines-node-report")] | length' "$INVENTORY")
if [[ "$frozen_count" -eq 0 ]]; then
  echo "(none)"
else
  jq -r '.surfaces[] | select(.kind == "frozen" or .kind == "engines-node-report") |
    "  \(.kind): \(.file):\(.line)  \(.current | tostring)  \(.reason // "report-only")"' "$INVENTORY"
fi
