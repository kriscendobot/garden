#!/bin/bash
# panel-banner-trigger-test.sh - prove banner detection triggers an archivist
# juror review instead of a pre-review deletion handler.

# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-banner-trigger.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

WT="$TR/wt"
mkdir -p "$WT"
git -C "$WT" init -q
git -C "$WT" config user.email t@localhost
git -C "$WT" config user.name test
git -C "$WT" remote add origin https://github.com/example/project.git
printf 'const base = 1;\n' > "$WT/file.js"
git -C "$WT" add file.js
git -C "$WT" commit -qm base

rule() { printf -- '-%.0s' $(seq 1 "$1"); }
run_panel() { # run_panel <rundir> <fandir>
  local rundir="$1" fandir="$2"
  FAN_DIR="$fandir" FAN_SLEEP=0 \
  GARDEN_PANEL_SINGLE_ROUND=1 \
  GARDEN_CODE_SEATS=assessor \
  GARDEN_PANEL_CONCURRENCY=2 \
  GARDEN_PANEL_SEAT="$HERE/panel-parallel-fanout-stub.sh" \
  GARDEN_PANEL_DECIDE="$HERE/panel-decide-stub.sh" \
  GARDEN_PANEL_RELATED_DESIGN=: \
  GARDEN_PANEL_APPELLATE=: \
  GARDEN_PANEL_RECORD=: \
  GARDEN_PANEL_RUNDIR="$rundir" \
    bash "$PANEL" "$WT" 123 HEAD~1 >/dev/null 2>&1
}

printf 'const base = 1;\n// %s\n' "$(rule 20)" > "$WT/file.js"
git -C "$WT" add file.js
git -C "$WT" commit -qm banner
run_panel "$TR/banner-run" "$TR/banner-fan"
rc=$?
[ "$rc" -eq 0 ] && ok "panel completes when banner pre-pass fires" \
  || bad "panel failed when banner pre-pass fired (exit $rc)"
grep -q 'none from archivist' "$TR/banner-run/round-1.md" 2>/dev/null \
  && ok "banner hit force-adds archivist to a trimmed panel" \
  || bad "archivist was not force-added on banner hit"
grep -q 'file.js:.*----' "$TR/banner-run/comment-banners.md" 2>/dev/null \
  && ok "archivist evidence records the detected location" \
  || bad "banner evidence does not record the detected location"

git -C "$WT" reset -q --hard HEAD~1
printf 'const base = 1;\n// ordinary prose\n' > "$WT/file.js"
git -C "$WT" add file.js
git -C "$WT" commit -qm prose
run_panel "$TR/clean-run" "$TR/clean-fan"
rc=$?
[ "$rc" -eq 0 ] && ok "panel completes on clean control" \
  || bad "panel failed on clean control (exit $rc)"
grep -q 'none from archivist' "$TR/clean-run/round-1.md" 2>/dev/null \
  && bad "clean control wrongly force-added archivist" \
  || ok "clean control leaves the trimmed seat list unchanged"
[ ! -s "$TR/clean-run/comment-banners.md" ] \
  && ok "clean control produces no banner evidence" \
  || bad "clean control unexpectedly produced banner evidence"

echo "panel-banner-trigger: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
