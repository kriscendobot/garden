#!/bin/bash
# Regression coverage for the sensing half of the review-miss cluster
# `design-bespoke-mechanism-over-existing-path` (endojs/endo-but-for-bots #1226,
# #1407) and the related `vestigial-mechanism-unquestioned` (#1125):
#   1. skills/panel-hints/probes/X-decomplector.sh fires on the real historical
#      added lines (quoted below) and abstains on unrelated code.
#   2. scripts/jobs/gardening/mechanism-repeat-signal.sh reports attention when the
#      two previous rounds raised must-fix on the same mechanism, and stays clear
#      otherwise.
#   3. panel.sh seats the decomplector on a code panel when either fires.
#
# Historical lines (verified against the real diffs in the completion report):
#   #1407 a62e91aca  packages/daemon/src/serve-guest-path.js imports
#         `servePrivatePath`; packages/agent-mcp-stdio/src/server.js adds
#         `connectToGuestBootstrap = async ({ socketPath })`; help text "Serve one
#         local guest on its own private Unix socket".
#   #1125 (removed by 42bad92360) formula-type.js entry `'readable-directory',`,
#         `DaemonCore['formulateReadableDirectory']`; 9a725d088c `guestPinName`.
# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"
PROBE="$ROOT/skills/panel-hints/probes/X-decomplector.sh"
SIGNAL="$ROOT/scripts/jobs/gardening/mechanism-repeat-signal.sh"
PANEL="$ROOT/scripts/jobs/gardening/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/bespoke-mechanism.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

fires() { # <name> <path> <line>
  local out; out=$(printf '%s\n' "$3" | bash "$PROBE" --scan-stdin --path "$2" 2>&1)
  case "$out" in "fire decomplector"*) ok "$1" ;; *) bad "$1 did not fire: $out" ;; esac
}
abstains() { # <name> <path> <line>
  local out; out=$(printf '%s\n' "$3" | bash "$PROBE" --scan-stdin --path "$2" 2>&1)
  [ "$out" = "skip decomplector" ] && ok "$1 abstains" || bad "$1 should abstain: $out"
}

echo "== probe: historical lines"
fires 'pr1407 servePrivatePath import (serve-guest-path.js)' packages/daemon/src/serve-guest-path.js \
  "import { servePrivatePath } from './serve-private-path.js';"
fires 'pr1407 connectToGuestBootstrap socketPath (server.js)' packages/agent-mcp-stdio/src/server.js \
  'export const connectToGuestBootstrap = async ({ socketPath }) => {'
fires 'pr1407 private Unix socket help text (help-text-data.js)' packages/daemon/src/help-text-data.js \
  "'guestBootstrapPath(id) -> Promise<string | undefined>\\nServe one local guest on its own private Unix socket and return the path.'"
fires 'pr1125 readable-directory formula type entry (formula-type.js)' packages/daemon/src/formula-type.js \
  "  'readable-directory',"
fires 'pr1125 formulateReadableDirectory maker (manager.js)' packages/daemon/src/manager.js \
  "  /** @type {DaemonCore['formulateReadableDirectory']} */"
fires 'pr1125 readable-directory type literal (types.d.ts)' packages/daemon/src/types.d.ts \
  "  type: 'readable-directory';"
fires 'pr1125 guest retention pin (manager.js)' packages/daemon/src/manager.js \
  '    const guestPinName = `guest-${'

echo "== probe: controls"
abstains 'plain helper' packages/foo/src/util.js 'export const clamp = (value, low, high) => Math.min(high, Math.max(low, value));'
abstains 'existing formula type used, not declared' packages/daemon/src/host.js "    const formula = { type: 'eval', worker, source };"
abstains 'switch case' packages/daemon/src/manager.js "    case 'eval':"
abstains 'list entry outside formula-type.js' packages/foo/src/names.js "  'readable-directory',"

echo "== probe: design-doc path in a mixed code PR"
PW="$TR/probe-wt"; mkdir -p "$PW/designs" "$PW/src"
git -C "$PW" init -q; git -C "$PW" config user.email t@localhost; git -C "$PW" config user.name test
echo base > "$PW/src/a.js"; git -C "$PW" add -A; git -C "$PW" commit -qm base
echo 'x' > "$PW/src/a.js"; echo '# d' > "$PW/designs/endo-guest-stdio-mcp.md"
git -C "$PW" add -A; git -C "$PW" commit -qm mixed
out=$(cd "$PW" && BASE=HEAD~1 bash "$PROBE")
case "$out" in "fire decomplector design doc touched (designs/endo-guest-stdio-mcp.md)"*) ok "mixed PR touching a design doc fires" ;; *) bad "design path did not fire: $out" ;; esac
git -C "$PW" reset -q --hard HEAD~1; echo 'y' > "$PW/src/a.js"; git -C "$PW" commit -qam plain
out=$(cd "$PW" && BASE=HEAD~1 bash "$PROBE")
[ "$out" = "skip decomplector" ] && ok "plain code-only PR abstains" || bad "plain PR fired: $out"

echo "== repeat signal"
RW="$TR/repeat-wt"; mkdir -p "$RW"
git -C "$RW" init -q; git -C "$RW" config user.email t@localhost; git -C "$RW" config user.name test
heads=()
for i in 1 2 3 4; do
  echo "$i" > "$RW/f"; git -C "$RW" add -A
  GIT_COMMITTER_DATE="2026-10-0${i}T00:00:00Z" git -C "$RW" commit -qm "r$i"
  heads+=("$(git -C "$RW" rev-parse HEAD)")
done
record() { # <file> <head> <lines...>
  local f="$1" h="$2"; shift 2
  { printf -- '---\nkind: panel-run\n---\n\n## Round 1 — head `%s`\n\nmust-fix items (%s):\n' "${h:0:8}" "$#"
    printf '%s\n' "$@"; } > "$f"
}
ST="$TR/store-overlap"; mkdir -p "$ST"
record "$ST/a.md" "${heads[0]}" '- engine-realist: **`packages/daemon/src/serve-guest-path.js:47`** — revoke on cancel'
record "$ST/b.md" "${heads[1]}" '- breaker: `packages/daemon/src/serve-guest-path.js:85` races collection' \
  '- orthographer: designs/x.md:3 — "cancelled"'
git -C "$RW" checkout -q "${heads[2]}"
bash "$SIGNAL" "$RW" --store-dir "$ST" --evidence-file "$TR/ev" >/dev/null; rc=$?
[ "$rc" -eq 10 ] && grep -q 'serve-guest-path.js' "$TR/ev" && ok "round 3 after two rounds on serve-guest-path.js -> attention" || bad "overlap not reported (rc=$rc)"

ST2="$TR/store-design"; mkdir -p "$ST2"
record "$ST2/a.md" "${heads[0]}" '- skeptic: § *Scoping by formula identifier*, `SO_PEERCRED` rests on a per-guest uid'
record "$ST2/b.md" "${heads[1]}" '- critic: **§ Scoping by formula identifier, bullet 2 (`SO_PEERCRED` peer verification)'
bash "$SIGNAL" "$RW" --store-dir "$ST2" --evidence-file "$TR/ev2" >/dev/null; rc=$?
[ "$rc" -eq 10 ] && grep -q 'SO_PEERCRED' "$TR/ev2" && grep -q '§ scoping by' "$TR/ev2" \
  && ok "design rounds sharing a section and identifier -> attention" || bad "design overlap not reported (rc=$rc)"

ST3="$TR/store-disjoint"; mkdir -p "$ST3"
record "$ST3/a.md" "${heads[0]}" '- breaker: `packages/a/src/one.js:1` bug'
record "$ST3/b.md" "${heads[1]}" '- breaker: `packages/b/src/two.js:1` bug'
bash "$SIGNAL" "$RW" --store-dir "$ST3" >/dev/null; rc=$?
[ "$rc" -eq 0 ] && ok "disjoint findings stay clear" || bad "disjoint findings reported (rc=$rc)"

ST4="$TR/store-cosmetic"; mkdir -p "$ST4"
record "$ST4/a.md" "${heads[0]}" '- orthographer: `packages/a/src/one.js:1` cancelled'
record "$ST4/b.md" "${heads[1]}" '- copyeditor: `packages/a/src/one.js:9` comma'
bash "$SIGNAL" "$RW" --store-dir "$ST4" >/dev/null; rc=$?
[ "$rc" -eq 0 ] && ok "cosmetic-seat overlap stays clear" || bad "cosmetic overlap reported (rc=$rc)"

ST5="$TR/store-one"; mkdir -p "$ST5"
record "$ST5/a.md" "${heads[1]}" '- breaker: `packages/a/src/one.js:1` bug'
record "$ST5/b.md" "${heads[2]}" '- breaker: `packages/a/src/one.js:2` bug'
bash "$SIGNAL" "$RW" --store-dir "$ST5" >/dev/null; rc=$?
[ "$rc" -eq 0 ] && ok "a record of the current head is excluded (only one prior round)" || bad "current-head round counted (rc=$rc)"

RD="$TR/classic-run"; mkdir -p "$RD"
printf '%s\n' "${heads[0]}" > "$RD/round-1.head"; printf '%s\n' "${heads[1]}" > "$RD/round-2.head"
printf 'Verdict: request-changes\n- `makeGuestConnect` falls back to root\n' > "$RD/round-1.breaker.md"
printf 'Verdict: request-changes\n- `makeGuestConnect` fallback is unstructured\n' > "$RD/round-2.integrator.md"
printf 'Verdict: approve\n- `makeGuestConnect` fine\n' > "$RD/round-2.assessor.md"
bash "$SIGNAL" "$RW" --rundir "$RD" --current-round 3 --evidence-file "$TR/ev3" >/dev/null; rc=$?
[ "$rc" -eq 10 ] && grep -q makeGuestConnect "$TR/ev3" && ok "classic in-process rounds -> attention" || bad "classic overlap not reported (rc=$rc)"

echo "== panel.sh integration"
WT="$TR/wt"; mkdir -p "$WT/src"
git -C "$WT" init -q; git -C "$WT" config user.email t@localhost; git -C "$WT" config user.name test
git -C "$WT" remote add origin https://github.com/example/project.git
echo 'export const a = 1;' > "$WT/src/a.js"; git -C "$WT" add -A; git -C "$WT" commit -qm base
run_panel() { # <rundir> <fandir> [store]
  FAN_DIR="$2" FAN_SLEEP=0 GARDEN_PANEL_SINGLE_ROUND=1 GARDEN_PANEL_RESUME=0 \
  GARDEN_CODE_SEATS=assessor GARDEN_PANEL_CONCURRENCY=2 \
  GARDEN_PANEL_SEAT="$HERE/panel-parallel-fanout-stub.sh" \
  GARDEN_PANEL_DECIDE="$HERE/panel-decide-stub.sh" \
  GARDEN_PANEL_RELATED_DESIGN=: GARDEN_PANEL_APPELLATE=: GARDEN_PANEL_RECORD=: \
  GARDEN_PANEL_PHASE_EVIDENCE_CHECK=: GARDEN_PANEL_PR_BODY_TEMPLATE_CHECK=: \
  GARDEN_PANEL_RECORD_STORE="${3:-$TR/no-store}" \
  GARDEN_PANEL_RUNDIR="$1" bash "$PANEL" "$WT" 123 HEAD~1 >/dev/null 2>&1
}
echo 'export const listenOn = socketPath => net.createServer().listen(socketPath);' > "$WT/src/serve.js"
git -C "$WT" add -A; git -C "$WT" commit -qm socket
run_panel "$TR/run-socket" "$TR/fan-socket"
grep -q 'none from decomplector' "$TR/run-socket/round-1.md" 2>/dev/null \
  && ok "new socket on a code panel seats the decomplector" || bad "decomplector not seated on new socket"
grep -q 'createServer\|socketPath' "$TR/run-socket/decomplector-probe.md" 2>/dev/null \
  && ok "probe evidence names the signal" || bad "probe evidence missing"

git -C "$WT" reset -q --hard HEAD~1
echo 'export const b = 2;' > "$WT/src/b.js"; git -C "$WT" add -A; git -C "$WT" commit -qm plain
run_panel "$TR/run-plain" "$TR/fan-plain"
grep -q 'none from decomplector' "$TR/run-plain/round-1.md" 2>/dev/null \
  && bad "plain code PR seated the decomplector" || ok "plain code PR leaves the trimmed panel unchanged"

# Repeat pre-pass: two prior rounds on HEAD~1's ancestry naming the same file.
p1="$(git -C "$WT" rev-parse HEAD~1)"
echo 'export const b = 3;' > "$WT/src/b.js"; git -C "$WT" commit -qam r2
p2="$(git -C "$WT" rev-parse HEAD)"
echo 'export const b = 4;' > "$WT/src/b.js"; git -C "$WT" commit -qam r3
STP="$TR/panel-store/example-project-123"; mkdir -p "$STP"
record "$STP/a.md" "$p1" '- breaker: `src/b.js:1` mechanism leaks'
record "$STP/b.md" "$p2" '- breaker: `src/b.js:1` mechanism still leaks'
run_panel "$TR/run-repeat" "$TR/fan-repeat" "$TR/panel-store"
grep -q 'none from decomplector' "$TR/run-repeat/round-1.md" 2>/dev/null \
  && ok "repeated must-fix on one file forces the decomplector" || bad "repeat pre-pass did not force the decomplector"
grep -q 'b.js' "$TR/run-repeat/mechanism-repeat.md" 2>/dev/null \
  && ok "repeat evidence names the recurring file" || bad "repeat evidence missing"

echo "bespoke-mechanism-probe: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
