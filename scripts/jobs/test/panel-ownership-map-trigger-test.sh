#!/bin/bash
# panel-ownership-map-trigger-test.sh — prove the design-panel ownership-map
# pre-pass force-adds the decomplector (with evidence) when a design spans multiple
# architectural layers, and stays inert on a single-layer design. Mirrors
# panel-banner-trigger-test.sh's harness.

# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-omap-trigger.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

WT="$TR/wt"; mkdir -p "$WT/designs"
git -C "$WT" init -q
git -C "$WT" config user.email t@localhost; git -C "$WT" config user.name test
git -C "$WT" remote add origin https://github.com/example/project.git
printf '# roadmap\n' > "$WT/designs/placeholder.md"
git -C "$WT" add -A; git -C "$WT" commit -qm base

run_panel() { # run_panel <rundir> <fandir>
  local rundir="$1" fandir="$2"
  FAN_DIR="$fandir" FAN_SLEEP=0 \
  GARDEN_PANEL_SINGLE_ROUND=1 \
  GARDEN_DESIGN_SEATS=critic \
  GARDEN_PANEL_CONCURRENCY=2 \
  GARDEN_PANEL_SEAT="$HERE/panel-parallel-fanout-stub.sh" \
  GARDEN_PANEL_DECIDE="$HERE/panel-decide-stub.sh" \
  GARDEN_PANEL_RELATED_DESIGN=: \
  GARDEN_PANEL_APPELLATE=: \
  GARDEN_PANEL_RECORD=: \
  GARDEN_PANEL_RUNDIR="$rundir" \
    bash "$PANEL" "$WT" 123 HEAD~1 >/dev/null 2>&1
}

# --- multi-layer design: force-add decomplector ----------------------------
cat > "$WT/designs/multi.md" <<'EOF'
# Multi-layer design
The engine interpreter evaluates bytecode and runs to quiescence. The supervisor
daemon holds a per-worker transcript and snapshot; it owns the crank commit and
discard, restart, and replay. A three-way CrankOutcome is returned at the Machine
seam.
EOF
git -C "$WT" add -A; git -C "$WT" commit -qm multi
run_panel "$TR/multi-run" "$TR/multi-fan"; rc=$?
[ "$rc" -eq 0 ] && ok "panel completes when ownership-map pre-pass fires" \
  || bad "panel failed when ownership-map pre-pass fired (exit $rc)"
grep -q 'none from decomplector' "$TR/multi-run/round-1.md" 2>/dev/null \
  && ok "multi-layer design force-adds decomplector to a trimmed design panel" \
  || bad "decomplector was not force-added on a multi-layer design"
{ [ -s "$TR/multi-run/ownership-map.md" ] && grep -q 'CrankOutcome' "$TR/multi-run/ownership-map.md"; } \
  && ok "ownership-map evidence names the fused candidate CrankOutcome" \
  || bad "ownership-map evidence missing or does not name CrankOutcome"

# --- single-layer design: inert --------------------------------------------
git -C "$WT" reset -q --hard HEAD~1
cat > "$WT/designs/single.md" <<'EOF'
# A parser tweak
The interpreter evaluates bytecode and runs to quiescence. This design adds one
opcode to the instruction stream. Nothing else changes.
EOF
git -C "$WT" add -A; git -C "$WT" commit -qm single
run_panel "$TR/single-run" "$TR/single-fan"; rc=$?
[ "$rc" -eq 0 ] && ok "panel completes on single-layer control" \
  || bad "panel failed on single-layer control (exit $rc)"
grep -q 'none from decomplector' "$TR/single-run/round-1.md" 2>/dev/null \
  && bad "single-layer control wrongly force-added decomplector" \
  || ok "single-layer control leaves the trimmed design panel unchanged"
[ ! -s "$TR/single-run/ownership-map.md" ] \
  && ok "single-layer control produces no ownership-map evidence" \
  || bad "single-layer control unexpectedly produced ownership-map evidence"

echo "panel-ownership-map-trigger: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
