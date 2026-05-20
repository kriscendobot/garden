#!/usr/bin/env bash
# node-lts-window-watch.sh
#
# Sensor + planner + (optional) applier for Node.js LTS-window-driven pin
# updates. See SKILL.md for the full contract.
#
# Usage:
#   node-lts-window-watch.sh [--probe-only|--plan-only|--apply] [<project-root>]
#
# Default mode: --plan-only.
# Exit codes:
#   0 = no motion (or probe-only succeeded)
#   1 = plan is non-empty (or --apply applied edits)
#   2 = upstream fetch or local probe failed (internal error)

set -euo pipefail

MODE="--plan-only"
PROJECT_ROOT=""
for arg in "$@"; do
  case "$arg" in
    --probe-only|--plan-only|--apply) MODE="$arg" ;;
    -*) echo "unknown flag: $arg" >&2; exit 2 ;;
    *) PROJECT_ROOT="$arg" ;;
  esac
done
PROJECT_ROOT="${PROJECT_ROOT:-$PWD}"

if [[ ! -d "$PROJECT_ROOT" ]]; then
  echo "project root does not exist: $PROJECT_ROOT" >&2
  exit 2
fi

SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"
PROBES_DIR="$SKILL_DIR/probes"

# ---- 1. Upstream probe -----------------------------------------------------

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "# fetching upstream Node.js metadata" >&2
if ! curl -fsSL https://nodejs.org/dist/index.json > "$TMP/dist.json"; then
  echo "failed to fetch nodejs.org/dist/index.json" >&2
  exit 2
fi
if ! curl -fsSL https://raw.githubusercontent.com/nodejs/Release/main/schedule.json > "$TMP/schedule.json"; then
  echo "failed to fetch nodejs/Release schedule.json" >&2
  exit 2
fi

# Compute window state via the upstream-window probe.
"$PROBES_DIR/upstream-window.sh" "$TMP/dist.json" "$TMP/schedule.json" > "$TMP/window.json"

if [[ "$MODE" == "--probe-only" ]]; then
  echo "# upstream window:" >&2
  cat "$TMP/window.json"
fi

# ---- 2. Local inventory ----------------------------------------------------

"$PROBES_DIR/inventory.sh" "$PROJECT_ROOT" > "$TMP/inventory.json"

if [[ "$MODE" == "--probe-only" ]]; then
  echo "# local inventory:" >&2
  cat "$TMP/inventory.json"
  exit 0
fi

# ---- 3. Plan ---------------------------------------------------------------

"$PROBES_DIR/plan.sh" "$TMP/window.json" "$TMP/inventory.json" "$PROJECT_ROOT" > "$TMP/plan.json"

# Always print the plan summary.
"$PROBES_DIR/report.sh" "$TMP/window.json" "$TMP/inventory.json" "$TMP/plan.json"

PLAN_ENTRIES="$(jq '.entries | length' "$TMP/plan.json")"

if [[ "$PLAN_ENTRIES" -eq 0 ]]; then
  echo "" >&2
  echo "# no motion; exiting 0" >&2
  exit 0
fi

if [[ "$MODE" == "--plan-only" ]]; then
  echo "" >&2
  echo "# plan has $PLAN_ENTRIES entries; re-run with --apply to write" >&2
  exit 1
fi

# ---- 4. Apply --------------------------------------------------------------

"$PROBES_DIR/apply.sh" "$TMP/plan.json" "$PROJECT_ROOT"
echo "" >&2
echo "# applied $PLAN_ENTRIES plan entries; the calling builder commits" >&2
exit 1
