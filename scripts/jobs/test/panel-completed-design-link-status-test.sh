#!/bin/bash
# Prove completed designs force the archivist when a linked local design still
# claims an incomplete status, and stay quiet when the linked statuses agree.

# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
FIXTURES="$HERE/fixtures/completed-design-link-status"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-design-link-status.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

WT="$TR/wt"
mkdir -p "$WT/designs"
git -C "$WT" init -q
git -C "$WT" config user.email t@localhost
git -C "$WT" config user.name test
git -C "$WT" remote add origin https://github.com/example/project.git
cp "$FIXTURES/linked-incomplete.md" "$WT/designs/linked-incomplete.md"
cp "$FIXTURES/linked-complete.md" "$WT/designs/linked-complete.md"
printf '# baseline\n' > "$WT/designs/changed.md"
git -C "$WT" add -A
git -C "$WT" commit -qm base

run_panel() { # run_panel <rundir> <fandir>
  local rundir="$1" fandir="$2"
  FAN_DIR="$fandir" FAN_SLEEP=0 \
  GARDEN_PANEL_SINGLE_ROUND=1 \
  GARDEN_DESIGN_SEATS=critic \
  GARDEN_PANEL_CONCURRENCY=2 \
  GARDEN_PANEL_SEAT="$HERE/panel-parallel-fanout-stub.sh" \
  GARDEN_PANEL_DECIDE="$HERE/panel-decide-stub.sh" \
  GARDEN_PANEL_RELATED_DESIGN=: \
  GARDEN_PANEL_OWNERSHIP_MAP=: \
  GARDEN_PANEL_PHASE_EVIDENCE_CHECK=: \
  GARDEN_PANEL_PR_BODY_TEMPLATE_CHECK=: \
  GARDEN_PANEL_MECHANISM_REPEAT=: \
  GARDEN_PANEL_APPELLATE=: \
  GARDEN_PANEL_RECORD=: \
  GARDEN_PANEL_RUNDIR="$rundir" \
    bash "$PANEL" "$WT" 123 HEAD~1 >/dev/null 2>&1
}

cp "$FIXTURES/completed-links-incomplete.md" "$WT/designs/changed.md"
git -C "$WT" add -A; git -C "$WT" commit -qm contradictory
run_panel "$TR/contradictory-run" "$TR/contradictory-fan"; rc=$?
[ "$rc" -eq 0 ] && ok "panel completes when linked status audit fires" \
  || bad "panel failed when linked status audit fired (exit $rc)"
grep -q 'none from archivist' "$TR/contradictory-run/round-1.md" 2>/dev/null \
  && ok "contradictory linked status force-adds archivist" \
  || bad "archivist was not force-added for contradictory linked status"
grep -q 'contradictory linked status: designs/linked-incomplete.md:1: Status: Proposed' \
  "$TR/contradictory-run/completed-design-link-status.md" 2>/dev/null \
  && ok "evidence identifies the linked document and exact status line" \
  || bad "linked status evidence is missing its exact line"

git -C "$WT" reset -q --hard HEAD~1
cp "$FIXTURES/completed-links-complete.md" "$WT/designs/changed.md"
git -C "$WT" add -A; git -C "$WT" commit -qm consistent
run_panel "$TR/consistent-run" "$TR/consistent-fan"; rc=$?
[ "$rc" -eq 0 ] && ok "panel completes when linked statuses agree" \
  || bad "panel failed when linked statuses agree (exit $rc)"
grep -q 'none from archivist' "$TR/consistent-run/round-1.md" 2>/dev/null \
  && bad "agreeing statuses wrongly force-added archivist" \
  || ok "agreeing statuses leave the trimmed design panel unchanged"
[ ! -s "$TR/consistent-run/completed-design-link-status.md" ] \
  && ok "agreeing statuses produce no audit evidence" \
  || bad "agreeing statuses unexpectedly produced audit evidence"

echo "panel-completed-design-link-status: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
