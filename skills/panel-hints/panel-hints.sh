#!/bin/bash
# panel-hints.sh — recommend which jury seats to fan out to based on diff signals.
#
# Usage:
#   panel-hints.sh [--base <ref>] [--design-paths <glob>] [<project-root>]
#
# Output: a structured report on stdout (see skills/panel-hints/SKILL.md § Output).
# The supervised panel run (scripts/jobs/gardening/panel.sh) consults the output
# at its seat-selection step and fans one `claude -p` per recommended seat.
#
# The script is biased toward firing seats: any positive signal triggers; suppression
# requires every signal to be absent. The maintainer's framing on 2026-05-22:
#   "err on the side of too many reviewers. The idea is not to reduce the amount of
#    reviews we are currently doing, but to enable us to vastly expand the juror
#    profiles and make juror profiles narrower."

set -uo pipefail

BASE=""
DESIGN_PATHS="designs/"
PROJECT_ROOT=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --base) BASE=$2; shift 2;;
    --design-paths) DESIGN_PATHS=$2; shift 2;;
    -*) echo "panel-hints: unknown option: $1" >&2; exit 64;;
    *) PROJECT_ROOT=$1; shift;;
  esac
done

PROJECT_ROOT=${PROJECT_ROOT:-$(pwd)}
test -d "$PROJECT_ROOT" || { echo "panel-hints: $PROJECT_ROOT not a directory" >&2; exit 64; }
cd "$PROJECT_ROOT"

# Resolve base if not specified: prefer the upstream the current branch tracks,
# else origin/master.
if [ -z "$BASE" ]; then
  BASE=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || echo origin/master)
fi

# Verify base resolves.
if ! git rev-parse --verify "$BASE" >/dev/null 2>&1; then
  echo "panel-hints: base $BASE does not resolve" >&2
  exit 1
fi

# Locate the probes directory relative to this script.
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PROBES_DIR="$SCRIPT_DIR/probes"

# Step 1: panel-kind discrimination.
files=$(git diff --name-only "$BASE...HEAD" 2>/dev/null)
if [ -z "$files" ]; then
  echo "panel-hints: no changed paths between $BASE and HEAD" >&2
  exit 1
fi

all_design=true
for f in $files; do
  case "$f" in
    designs/*.md|*/designs/*.md) ;;
    DESIGN*.md|*/DESIGN*.md) ;;
    *) all_design=false; break;;
  esac
done

if [ "$all_design" = "true" ]; then
  # Design panel: wholesale routing.
  echo "Panel-kind: design-panel"
  echo "Design panel (7): critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice"
  for f in $files; do
    echo "  $f"
  done | head -5
  # Cross-panel: the archivist (a code-panel docs-accuracy seat) cross-fires onto a
  # design PR when the doc makes a definite technical claim about a named in-repo
  # entity, so those claims are cross-verified against the code and the doc's own
  # other statements. Symmetric to X-pedant/X-copyeditor firing onto code PRs. This
  # is the durable review-cycle sensor for the docs-claim-contradicts-code-semantics
  # review-miss cluster's design-PR member (#264: "typically a `tar.gz`" for a zip).
  arch_probe="$PROBES_DIR/C-archivist-claim-accuracy.sh"
  cross_total=7
  if [ -f "$arch_probe" ]; then
    arch_out=$(BASE="$BASE" bash "$arch_probe" 2>/dev/null)
    if [[ "$arch_out" == fire* ]]; then
      reason=$(echo "$arch_out" | cut -d' ' -f3-)
      echo "Cross-panel (1): archivist"
      echo "  archivist  $reason"
      cross_total=8
    else
      echo "Cross-panel (0): -"
    fi
  fi
  echo "Recommended total: $cross_total of 7 design-panel seats (+ $((cross_total - 7)) cross-panel)."
  exit 0
fi

# Step 2-5: code-panel case.
echo "Panel-kind: code-panel"
echo ""

ALWAYS_ON="assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober"
# coverage-auditor is always-fire on the code panel (a mandatory seat), but it is
# COST-GATED at dispatch by a deterministic c8 coverage pre-pass — its `claude -p`
# runs only when the change has uncovered new lines (seat-gate-coverage-auditor.sh).
# Its signal lives outside the diff's path/content shape (in the coverage report),
# so it has no probes/ file; it is listed here unconditionally.
ALWAYS_FIRE="scribe, releaser, coverage-auditor"
echo "Always-on core (9): $ALWAYS_ON"
echo "Always-fire (3): $ALWAYS_FIRE"
echo ""

# Run each probe; collect fire and skip lists.
fire_list=()
skip_list=()
detail_lines=()

if [ -d "$PROBES_DIR" ]; then
  for probe in "$PROBES_DIR"/*.sh; do
    [ -f "$probe" ] || continue
    out=$(BASE="$BASE" bash "$probe" 2>/dev/null)
    while IFS= read -r line; do
      case "$line" in
        fire*)
          seat=$(echo "$line" | awk '{print $2}')
          reason=$(echo "$line" | cut -d' ' -f3-)
          fire_list+=("$seat")
          detail_lines+=("  $seat ::: $reason")
          ;;
        skip*)
          seat=$(echo "$line" | awk '{print $2}')
          skip_list+=("$seat")
          ;;
      esac
    done <<< "$out"
  done
fi

# Partition fire_list into path-triggered (B-*) and content-triggered (C-*)
# by re-reading the probe filename prefix.
path_seats=()
content_seats=()
cross_seats=()
for probe in "$PROBES_DIR"/*.sh; do
  [ -f "$probe" ] || continue
  base=$(basename "$probe" .sh)
  prefix=${base%%-*}
  seat=${base#${prefix}-}
  for f in "${fire_list[@]:-}"; do
    if [ "$f" = "$seat" ]; then
      case "$prefix" in
        B) path_seats+=("$seat");;
        C) content_seats+=("$seat");;
        X) cross_seats+=("$seat");;
      esac
      break
    fi
  done
done

# Emit the path-triggered section.
if [ "${#path_seats[@]}" -gt 0 ]; then
  echo "Path-triggered (${#path_seats[@]}): $(IFS=,; echo "${path_seats[*]}" | sed 's/,/, /g')"
  for s in "${path_seats[@]}"; do
    for d in "${detail_lines[@]}"; do
      if [[ "$d" == *"  $s :::"* ]]; then
        echo "$d" | sed 's/ ::: /  /'
        break
      fi
    done
  done
else
  echo "Path-triggered (0): -"
fi
echo ""

# Emit the content-triggered section.
if [ "${#content_seats[@]}" -gt 0 ]; then
  echo "Content-triggered (${#content_seats[@]}): $(IFS=,; echo "${content_seats[*]}" | sed 's/,/, /g')"
  for s in "${content_seats[@]}"; do
    for d in "${detail_lines[@]}"; do
      if [[ "$d" == *"  $s :::"* ]]; then
        echo "$d" | sed 's/ ::: /  /'
        break
      fi
    done
  done
else
  echo "Content-triggered (0): -"
fi
echo ""

# Emit cross-panel section (design seats firing on a code-panel round).
if [ "${#cross_seats[@]}" -gt 0 ]; then
  echo "Cross-panel (${#cross_seats[@]}): $(IFS=,; echo "${cross_seats[*]}" | sed 's/,/, /g')"
  for s in "${cross_seats[@]}"; do
    for d in "${detail_lines[@]}"; do
      if [[ "$d" == *"  $s :::"* ]]; then
        echo "$d" | sed 's/ ::: /  /'
        break
      fi
    done
  done
else
  echo "Cross-panel (0): -"
fi
echo ""

# Emit the suppressed section.
if [ "${#skip_list[@]}" -gt 0 ]; then
  echo "Suppressed (${#skip_list[@]}): $(IFS=,; echo "${skip_list[*]}" | sed 's/,/, /g')"
fi

# Compute the recommended total: always-on (9) + always-fire (3) + path + content + cross.
total=$((9 + 3 + ${#path_seats[@]} + ${#content_seats[@]} + ${#cross_seats[@]}))
echo ""
echo "Recommended total: $total of 29 code-panel seats (+ ${#cross_seats[@]} cross-panel)."
