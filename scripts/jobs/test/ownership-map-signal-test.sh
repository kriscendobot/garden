#!/bin/bash
# ownership-map-signal-test.sh — validate the deterministic ownership-map sensor
# (gardening/ownership-map-signal.sh), the durable review-cycle sensor for the
# architectural-boundary-ownership review-miss cluster.
#
# Asserts the contract:
#   1. RELITIGATION (files mode): a design in the endojs/endo-but-for-bots#1018
#      shape — an engine-side `CrankOutcome` at the Machine seam while the
#      transcript/embargo/commit responsibilities are the supervisor's, with NO
#      ownership-map section — fires (exit 10), reports 4 layers, map_present=no,
#      flag=yes, and names CrankOutcome as a fused candidate. The evidence paragraph
#      names the four ownership questions and CrankOutcome.
#   2. RELITIGATION (worktree/diff mode): the same design added as a new design doc
#      in a throwaway repo — the exact shape a design-only PR presents — fires the
#      same way. This replays the panel round that missed it.
#   3. NEGATIVE CONTROL: a multi-component design that carries an explicit, coherent
#      `## Ownership map` section and surfaces no fused name still ENGAGES the seat
#      (exit 10, layers>=2) but is flag=no — the check does not manufacture a failure
#      merely for naming multiple layers.
#   4. SINGLE-LAYER: a design that names only one layer is clear (exit 0), no map owed.
#   5. UNDETERMINED: no base ref / no design files -> exit 3, never silently clear.
#
# Hermetic: throwaway files and git repos, no network, no systemd. If the real
# historical design (efcf04a in a local endo-but-for-bots clone) is reachable, an
# extra assertion relitigates the ACTUAL file; otherwise that check is skipped, so
# the suite never depends on a clone being present.

# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SIG="$(cd "$HERE/../gardening" && pwd)/ownership-map-signal.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/omap-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

# A design in the #1018 shape: engine layer classifies termination while the
# supervisor owns durable transcript, embargo, commit/discard, and replay; the
# engine result type is named `CrankOutcome` (an outer crank-lifecycle concept on
# the inner mechanism); no ownership-map section.
cat > "$TR/panic.md" <<'EOF'
# Ironhorse Panic

The Ironhorse engine is the interpreter that evaluates bytecode and runs each
delivery to quiescence. A crank is one inbound delivery plus its promise jobs.

## The Machine seam

The Machine/supervisor seam classifies each halt into a three-way
`CrankOutcome`: Committed, Uncaught, or Panicked. `CrankOutcome::classify(halt)`
is the engine-side constructor at this seam.

## The Message Embargo Contract

The supervisor holds a crank's outbound messages until the crank commits; a panic
discards them. A per-worker write-ahead transcript makes embargo, restart, and
replay one durability contract: restore the worker from its last snapshot and
replay the transcript. The supervisor owns the commit/discard decision and the
durable heap-and-transcript join.
EOF

# --- 1: relitigation, files mode -------------------------------------------
out="$("$SIG" --files "$TR/panic.md" --evidence-file "$TR/ev1.txt")"; rc=$?
[ "$rc" -eq 10 ] && ok "files mode: #1018-shape design fires (exit 10)" \
  || bad "files mode: expected exit 10, got $rc"
grep -q 'layers=4' <<<"$out" && ok "files mode: 4 layers detected" \
  || bad "files mode: expected layers=4 ($out)"
grep -q 'map_present=no' <<<"$out" && ok "files mode: no ownership-map section" \
  || bad "files mode: expected map_present=no ($out)"
grep -q 'flag=yes' <<<"$out" && ok "files mode: flagged as suspected boundary violation" \
  || bad "files mode: expected flag=yes ($out)"
grep -q 'fused_candidates=\[CrankOutcome\]' <<<"$out" && ok "files mode: CrankOutcome named as fused candidate" \
  || bad "files mode: expected CrankOutcome fused candidate ($out)"
{ grep -q 'CrankOutcome' "$TR/ev1.txt" \
  && grep -qi 'commit/discard' "$TR/ev1.txt" \
  && grep -qi 'restart/replay' "$TR/ev1.txt" \
  && grep -qi 'execution classification' "$TR/ev1.txt"; } \
  && ok "files mode: evidence names CrankOutcome and the four ownership questions" \
  || bad "files mode: evidence missing CrankOutcome or an ownership question ($(cat "$TR/ev1.txt"))"

# --- 2: relitigation, worktree/diff mode (design added) --------------------
R2="$TR/repo"; mkdir -p "$R2/designs"; git -C "$R2" init -q
git -C "$R2" config user.email t@localhost; git -C "$R2" config user.name test
printf '# roadmap\n' > "$R2/README.md"
git -C "$R2" add -A; git -C "$R2" commit -qm base >/dev/null
cp "$TR/panic.md" "$R2/designs/ironhorse-panic.md"
git -C "$R2" add -A; git -C "$R2" commit -qm 'add design' >/dev/null
out2="$("$SIG" "$R2" --base HEAD~1)"; rc2=$?
{ [ "$rc2" -eq 10 ] && grep -q 'layers=4' <<<"$out2" && grep -q 'flag=yes' <<<"$out2" \
  && grep -q 'CrankOutcome' <<<"$out2"; } \
  && ok "worktree mode: added design doc fires the same way (replays the missed panel round)" \
  || bad "worktree mode: expected attention+layers=4+flag=yes+CrankOutcome (rc=$rc2, $out2)"

# --- 3: negative control — explicit coherent ownership map -----------------
cat > "$TR/coherent.md" <<'EOF'
# Worker crank durability

The engine interpreter evaluates bytecode and runs to quiescence. The supervisor
daemon coordinates cranks. Durable state lives in a per-worker transcript; commit
and replay are supervisor responsibilities.

## Ownership map

| Boundary | Mechanism | Policy | Durable state | Lifecycle/commit authority | Value crossing |
| --- | --- | --- | --- | --- | --- |
| engine -> supervisor | engine evaluates and runs to quiescence | supervisor decides commit vs discard | supervisor owns the transcript and snapshot | supervisor owns commit/discard, restart, replay | the engine returns an execution result; the supervisor classifies it |

The engine only reports how execution ended; it never persists, commits, or
replays. Snapshot, transcript, embargo, and crank-commit policy are the
supervisor's alone.
EOF
out3="$("$SIG" --files "$TR/coherent.md" --evidence-file "$TR/ev3.txt")"; rc3=$?
[ "$rc3" -eq 10 ] && ok "negative control: multi-layer design still engages the seat (exit 10)" \
  || bad "negative control: expected exit 10, got $rc3"
grep -q 'map_present=yes' <<<"$out3" && ok "negative control: ownership-map section detected" \
  || bad "negative control: expected map_present=yes ($out3)"
grep -q 'flag=no' <<<"$out3" && ok "negative control: NOT flagged — coherent map, no fused name" \
  || bad "negative control: expected flag=no ($out3)"
grep -qi 'do NOT flag it merely for naming multiple layers' "$TR/ev3.txt" \
  && ok "negative control: evidence posture is confirm-coherence, not accuse" \
  || bad "negative control: evidence missing the confirm posture ($(cat "$TR/ev3.txt"))"

# --- 4: single-layer design -> clear ---------------------------------------
cat > "$TR/single.md" <<'EOF'
# A parser tweak

The interpreter evaluates bytecode and runs to quiescence. This design adds one
opcode to the instruction stream. Nothing else changes.
EOF
out4="$("$SIG" --files "$TR/single.md")"; rc4=$?
{ [ "$rc4" -eq 0 ] && grep -q 'ownership-map-verdict=clear' <<<"$out4"; } \
  && ok "single-layer design is clear (exit 0), no ownership map owed" \
  || bad "single-layer: expected clear/exit 0 (rc=$rc4, $out4)"

# --- 5: undetermined -------------------------------------------------------
R5="$TR/norepo"; mkdir -p "$R5"
out5="$("$SIG" "$R5" --base HEAD~1 2>/dev/null)"; rc5=$?
{ [ "$rc5" -eq 3 ] && grep -q 'ownership-map-verdict=undetermined' <<<"$out5"; } \
  && ok "no base ref -> undetermined (exit 3), never silently clear" \
  || bad "undetermined: expected exit 3 (rc=$rc5, $out5)"

# --- bonus: relitigate the ACTUAL historical file if a clone is reachable ---
BARE=""
for c in /home/kris/garden2/worktrees/endojs-endo-but-for-bots.git \
         /home/kris/garden2/worktrees/kriscendobot-endo-but-for-bots.git; do
  [ -d "$c" ] && git -C "$c" cat-file -e "efcf04a26d1114d1d1c90f52895eec7e8f49fc54^{commit}" 2>/dev/null && { BARE="$c"; break; }
done
if [ -n "$BARE" ]; then
  git -C "$BARE" show efcf04a26d1114d1d1c90f52895eec7e8f49fc54:designs/ironhorse-panic.md > "$TR/real.md" 2>/dev/null
  outr="$("$SIG" --files "$TR/real.md")"; rcr=$?
  { [ "$rcr" -eq 10 ] && grep -q 'flag=yes' <<<"$outr" && grep -q 'CrankOutcome' <<<"$outr"; } \
    && ok "REAL #1018 design at efcf04a fires (attention, flag=yes, CrankOutcome): $outr" \
    || bad "REAL #1018 design did not fire as expected (rc=$rcr, $outr)"
else
  echo "  SKIP: no local endo-but-for-bots clone with efcf04a — hermetic fixtures cover the shape"
fi

echo
echo "ownership-map-signal: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
