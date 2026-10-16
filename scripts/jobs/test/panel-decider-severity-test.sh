#!/bin/bash
# panel-decider-severity-test.sh — the foreperson decider's finding-severity rubric
# (skills/panel/SKILL.md § Finding severity; decider_rubric in panel.sh).
#
# Nit-class findings (comment/JSDoc wording, identifier spelling, commit-history
# tidiness, PR-description completeness, test style) are should-fix and must never
# block; real defects (wrong behavior, authority errors, missing tests for changed
# behavior, a false comment that invites an unsafe change) stay must-fix. Every
# fixture under fixtures/panel-decider-severity/ is a seat block labeled
# request-changes, so the decider, not the seat's label, carries the decision.
#
# Default (deterministic): runs the real decide_disposition through a single-round
# panel against a fake `claude` that records its prompt, and asserts the prompt
# carries the fixture plus the rubric line for the fixture's class, filed under the
# right severity heading.
#
# Live (opt-in, spends model tokens): GARDEN_PANEL_DECIDER_LIVE=1 runs the real
# decider model on every fixture and asserts the disposition the filename prefix
# names: `nit-*` → pass, `defect-*` → must-fix.
#
# Usage: panel-decider-severity-test.sh

# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
FIX="$HERE/fixtures/panel-decider-severity"
LIVE="${GARDEN_PANEL_DECIDER_LIVE:-0}"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-decider-severity.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

# The rubric line each fixture's class must be filed under.
rubric_line() {
  case "$1" in
    nit-jsdoc-wording)           echo "comment or JSDoc wording or accuracy that does not change behavior" ;;
    nit-identifier-spelling)     echo "identifier renames for spelling, abbreviation, or style" ;;
    nit-commit-history)          echo "commit-history tidiness" ;;
    nit-pr-description)          echo "PR title or description completeness" ;;
    nit-test-style)              echo "test-style preferences" ;;
    defect-wrong-behavior)       echo "wrong behavior: the change does something other than what it should" ;;
    defect-authority)            echo "a security, capability, or authority error" ;;
    defect-missing-test)         echo "missing tests for behavior the change adds or alters" ;;
    defect-unsafe-false-comment) echo "factually false in a way that would mislead a future change into unsafe behavior" ;;
    defect-mixed-with-nits)      echo "The disposition is 'must-fix' if any finding is MUST-FIX" ;;
  esac
}

run_panel() {  # <fixture> <out-dir> -> panel stdout+stderr; rc in $?
  local path="" 
  [ "$LIVE" = 1 ] || path="$HERE/panel-decider-severity-bin:"
  PATH="$path$PATH" \
  DECIDER_SEVERITY_OUT="$2" DECIDER_SEVERITY_FIXTURE="$1" \
  GARDEN_PANEL_PROVIDER=anthropic \
  GARDEN_PANEL_SINGLE_ROUND=1 \
  GARDEN_CODE_SEATS="assessor" \
  GARDEN_PANEL_SEAT="$HERE/panel-decider-severity-seat-stub.sh" \
  GARDEN_PANEL_APPELLATE=":" \
  GARDEN_PANEL_FIXER="true" \
  GARDEN_PANEL_UNDRAFT="true" \
  GARDEN_PANEL_SEAT_BACKOFF=0 \
  GARDEN_PANEL_DECIDE_BACKOFF=0 \
  GARDEN_PANEL_RECORD=":" \
  GARDEN_PANEL_RELATED_DESIGN=":" \
  GARDEN_PANEL_RUNDIR="$2/rd" \
    bash "$PANEL" "$TR/wt" 777 HEAD~1 2>&1
}

mkdir -p "$TR/wt"
n=0
for fixture in "$FIX"/nit-*.md "$FIX"/defect-*.md; do
  name="$(basename "$fixture" .md)"; n=$((n+1))
  out="$TR/$name"; mkdir -p "$out"
  log="$(run_panel "$fixture" "$out")"; rc=$?
  token="$(printf '%s\n' "$log" | awk 'NF{l=$0} END{print l}' | awk '{print $NF}')"
  if [ "$LIVE" = 1 ]; then
    case "$name" in nit-*) want=pass ;; *) want=must-fix ;; esac
    [ "$rc" -eq 0 ] && [ "$token" = "$want" ] \
      && ok "$name: live decider → $token" \
      || bad "$name: live decider → '$token' rc=$rc (want $want): $log"
    continue
  fi
  prompt="$out/prompt"
  [ "$rc" -eq 0 ] && [ -s "$prompt" ] \
    || { bad "$name: panel rc=$rc or no decider prompt: $log"; continue; }
  first="$(grep -m1 '^- ' "$fixture" | cut -c1-60)"
  grep -Fq -- "$first" "$prompt" \
    && ok "$name: the decider saw the fixture's finding" \
    || bad "$name: fixture finding missing from the decider prompt"
  line="$(rubric_line "$name")"
  at="$(grep -nF -- "$line" "$prompt" | head -1 | cut -d: -f1)"
  must_at="$(grep -n '^MUST-FIX (blocks the panel)' "$prompt" | head -1 | cut -d: -f1)"
  should_at="$(grep -n '^SHOULD-FIX (never blocks' "$prompt" | head -1 | cut -d: -f1)"
  if [ -z "$at" ] || [ -z "$must_at" ] || [ -z "$should_at" ]; then
    bad "$name: rubric line or severity headings missing from the decider prompt"
    continue
  fi
  case "$name" in
    nit-*)
      [ "$at" -gt "$should_at" ] \
        && ok "$name: its class is filed under SHOULD-FIX (never blocks)" \
        || bad "$name: '$line' is not under SHOULD-FIX (line $at, heading $should_at)" ;;
    defect-mixed-with-nits)
      [ "$at" -gt "$should_at" ] \
        && ok "$name: any MUST-FIX finding still makes the disposition must-fix" \
        || bad "$name: the any-must-fix rule is missing or misplaced" ;;
    defect-*)
      [ "$at" -gt "$must_at" ] && [ "$at" -lt "$should_at" ] \
        && ok "$name: its class is filed under MUST-FIX" \
        || bad "$name: '$line' is not under MUST-FIX (line $at; headings $must_at/$should_at)" ;;
  esac
done
[ "$n" -ge 10 ] && ok "ran $n fixtures" || bad "only $n fixtures found under $FIX"

if [ "$LIVE" != 1 ]; then
  prompt="$TR/defect-wrong-behavior/prompt"
  grep -Fq "When you are unsure whether a finding is a real defect, treat it as MUST-FIX" "$prompt" \
    && ok "doubt resolves to must-fix" || bad "the when-unsure rule is missing"
  grep -Fq "Ignore the label the seat put on it" "$prompt" \
    && ok "the decider classifies severity itself, not by the seat's label" \
    || bad "the ignore-the-seat-label rule is missing"
  rubric_at="$(grep -n '^SHOULD-FIX (never blocks' "$prompt" | head -1 | cut -d: -f1)"
  finding_at="$(grep -nF -- "off-by-one" "$prompt" | head -1 | cut -d: -f1)"
  [ -n "$finding_at" ] && [ -n "$rubric_at" ] && [ "$finding_at" -gt "$rubric_at" ] \
    && ok "the seat verdicts follow the rubric in the prompt" \
    || bad "the aggregate does not follow the rubric (finding $finding_at, rubric $rubric_at)"
fi

echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
