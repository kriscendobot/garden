#!/bin/bash
# pre-push-gates.sh — the deterministic gate the builder and fixer run
# before every push to a PR branch.
#
# Usage:
#   pre-push-gates.sh [--no-auto-fix] [--probes-only] [--summary] [<project-root>]
#
# Stages (in order):
#   1. yarn format        — auto-fix; re-stage
#   2. yarn lint --fix    — auto-fix; re-stage
#   3. garden probes      — one script per rule in probes/
#   4. yarn typecheck     — fail-and-report; no auto-fix
#
# Exit codes:
#   0  — all stages passed (possibly after auto-fixes)
#   1  — one or more probes failed
#   2  — typecheck failed
#   64 — usage error
#
# Auto-fixable findings are silently fixed and re-staged. Non-auto-fixable
# findings are reported on stdout with a one-line summary per finding.
#
# See skills/pre-push-gates/SKILL.md for the full contract.

set -uo pipefail

NO_AUTO_FIX=0
PROBES_ONLY=0
SUMMARY=0
PROJECT_ROOT=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --no-auto-fix) NO_AUTO_FIX=1; shift;;
    --probes-only) PROBES_ONLY=1; shift;;
    --summary) SUMMARY=1; shift;;
    -*) echo "pre-push-gates: unknown option: $1" >&2; exit 64;;
    *)  PROJECT_ROOT=$1; shift;;
  esac
done

PROJECT_ROOT=${PROJECT_ROOT:-$(pwd)}
test -d "$PROJECT_ROOT" || { echo "pre-push-gates: $PROJECT_ROOT not a directory" >&2; exit 64; }
cd "$PROJECT_ROOT"

# Locate the probes directory relative to this script.
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PROBES_DIR="$SCRIPT_DIR/probes"

WORST_EXIT=0

stage_log() {
  if [ "$SUMMARY" -eq 1 ]; then
    printf '%-22s %s\n' "$1" "$2"
  else
    printf '%-22s %s\n' "$1" "$2"
  fi
}

# Stage 1: yarn format
if [ "$NO_AUTO_FIX" -eq 0 ] && [ "$PROBES_ONLY" -eq 0 ]; then
  if [ -f package.json ] && jq -e '.scripts.format' package.json >/dev/null 2>&1; then
    if yarn format >/tmp/pre-push-gates.format.out 2>&1; then
      changed=$(git status --porcelain | wc -l)
      git add -A 2>/dev/null || true
      if [ "$changed" -gt 0 ]; then
        stage_log "yarn format" "pass (auto-fixed $changed paths; re-staged)"
      else
        stage_log "yarn format" "pass (no changes)"
      fi
    else
      stage_log "yarn format" "fail; see /tmp/pre-push-gates.format.out"
      [ "$SUMMARY" -eq 0 ] && cat /tmp/pre-push-gates.format.out
      WORST_EXIT=2
    fi
  else
    stage_log "yarn format" "skip (no format script)"
  fi
fi

# Stage 2: yarn lint --fix
if [ "$NO_AUTO_FIX" -eq 0 ] && [ "$PROBES_ONLY" -eq 0 ]; then
  if [ -f package.json ] && jq -e '.scripts.lint' package.json >/dev/null 2>&1; then
    if yarn lint --fix >/tmp/pre-push-gates.lint.out 2>&1; then
      changed=$(git status --porcelain | wc -l)
      git add -A 2>/dev/null || true
      if [ "$changed" -gt 0 ]; then
        stage_log "yarn lint --fix" "pass (auto-fixed $changed paths; re-staged)"
      else
        stage_log "yarn lint --fix" "pass (no changes)"
      fi
    else
      # Some projects' lint script doesn't accept --fix; retry without.
      if yarn lint >>/tmp/pre-push-gates.lint.out 2>&1; then
        stage_log "yarn lint" "pass (no auto-fix flag; ran clean)"
      else
        stage_log "yarn lint" "fail; see /tmp/pre-push-gates.lint.out"
        [ "$SUMMARY" -eq 0 ] && tail -30 /tmp/pre-push-gates.lint.out
        [ "$WORST_EXIT" -lt 1 ] && WORST_EXIT=1
      fi
    fi
  else
    stage_log "yarn lint" "skip (no lint script)"
  fi
fi

# Stage 3: garden probes
echo "probes:"
if [ -d "$PROBES_DIR" ]; then
  any_probe=0
  for probe in "$PROBES_DIR"/*.sh; do
    [ -f "$probe" ] || continue
    any_probe=1
    name=$(basename "$probe" .sh)
    out=$(bash "$probe" 2>&1) || true
    code=$?
    if echo "$out" | head -1 | grep -q '^pass'; then
      printf '  %-30s pass\n' "$name"
    else
      printf '  %-30s %s\n' "$name" "$out"
      [ "$WORST_EXIT" -lt 1 ] && WORST_EXIT=1
    fi
  done
  if [ "$any_probe" -eq 0 ]; then
    echo "  (no probes installed in $PROBES_DIR)"
  fi
else
  echo "  (probes dir absent: $PROBES_DIR)"
fi

# Stage 4: yarn typecheck (no auto-fix)
if [ "$PROBES_ONLY" -eq 0 ]; then
  if [ -f package.json ] && jq -e '.scripts.typecheck' package.json >/dev/null 2>&1; then
    if yarn typecheck >/tmp/pre-push-gates.typecheck.out 2>&1; then
      stage_log "yarn typecheck" "pass"
    else
      stage_log "yarn typecheck" "fail; see /tmp/pre-push-gates.typecheck.out"
      [ "$SUMMARY" -eq 0 ] && tail -30 /tmp/pre-push-gates.typecheck.out
      WORST_EXIT=2
    fi
  else
    stage_log "yarn typecheck" "skip (no typecheck script)"
  fi
fi

echo ""
if [ "$WORST_EXIT" -eq 0 ]; then
  echo "result: gate passed."
else
  echo "result: gate failed (exit $WORST_EXIT); address findings and re-run."
fi

exit "$WORST_EXIT"
