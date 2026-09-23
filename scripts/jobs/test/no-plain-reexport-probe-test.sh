#!/bin/bash
# no-plain-reexport-probe-test.sh — validate the deterministic re-export probe
# (gardening/pre-push-gates/probes/no-plain-reexport.sh) that is the author-time
# preventive for the re-export deprecation policy AND the reexport-auditor jury
# seat's pre-pass. Covers the design's Test plan:
#   - FINDING: a bare `export { x } from './y.js'` is flagged.
#   - CLEAN: the same line under a `@deprecated`-pointing JSDoc is not flagged.
#   - each `export … from` form (named, renamed, default-as, wildcard, namespace).
#   - EXEMPT: a file with `reexport-policy-exempt` in its first five lines is skipped.
#   - STRING/COMMENT non-match: an `export … from` inside a string literal is not flagged.
#   - REMOVED-only: a removed re-export line is not a hit (added-only via set-diff).
#   - BARREL: an index.js barrel IS flagged (Decision 1, not exempt).
#   - TYPE-ONLY: `export type { … } from` and `.d.ts` are skipped (Decision 5).
#   - SET-DIFFERENCE: a re-export already present in the base is not re-flagged when
#     the file is edited elsewhere; a genuinely new one added beside it IS.
#   - check/report seat pre-pass exit convention (0 candidate / 1 clean / 1 no-base).
#
# Hermetic: throwaway git repos, the vendored parser, no network, no systemd.

# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never fails).
# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"
PROBE="$ROOT/scripts/jobs/gardening/pre-push-gates/probes/no-plain-reexport.sh"
export GARDEN_ROOT="$ROOT"
TR="$(mktemp -d "${TMPDIR:-/tmp}/npr-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

# make_repo <dir> — a git repo with one committed base file (base.js, no re-exports).
make_repo() {
  local dir="$1"
  mkdir -p "$dir"; git -C "$dir" init -q
  git -C "$dir" config user.email t@localhost; git -C "$dir" config user.name test
  printf 'export const seed = 1;\n' > "$dir/base.js"
  git -C "$dir" add -A; git -C "$dir" commit -qm base >/dev/null
}
# stage_file <dir> <file> <line...> — write the file and stage it (unstaged->staged path).
stage_file() {
  local dir="$1" f="$2"; shift 2
  printf '%s\n' "$@" > "$dir/$f"
  git -C "$dir" add -A
}
# gate <dir> — run the probe in gate mode; capture output + exit.
GATE_OUT=""; GATE_RC=0
gate() { GATE_OUT="$("$PROBE" "$1" 2>&1)"; GATE_RC=$?; }

# --- FINDING: bare named re-export ------------------------------------------
R="$TR/finding"; make_repo "$R"
stage_file "$R" m.js "export { x } from './y.js';"
gate "$R"
{ [ "$GATE_RC" -eq 1 ] && echo "$GATE_OUT" | grep -q "^fail: m.js:1 .*from 'y.js\|from './y.js'"; } \
  && ok "FINDING bare named re-export flagged (exit 1)" || bad "FINDING ($GATE_RC: $GATE_OUT)"

# --- CLEAN: deprecated shim -------------------------------------------------
R="$TR/clean"; make_repo "$R"
stage_file "$R" m.js \
  "/** @deprecated Import { x } from './y.js' directly. */" \
  "export { x } from './y.js';"
gate "$R"
{ [ "$GATE_RC" -eq 0 ] && echo "$GATE_OUT" | grep -qx pass; } \
  && ok "CLEAN deprecated shim not flagged (exit 0, pass)" || bad "CLEAN ($GATE_RC: $GATE_OUT)"

# --- each form is flagged ---------------------------------------------------
for form in \
  "export { x } from './y.js';:named" \
  "export { x as y } from './y.js';:renamed" \
  "export { default as z } from './y.js';:default-as" \
  "export * from './y.js';:wildcard" \
  "export * as ns from './y.js';:namespace"; do
  line="${form%:*}"; label="${form##*:}"
  R="$TR/form-$label"; make_repo "$R"
  stage_file "$R" m.js "$line"
  gate "$R"
  { [ "$GATE_RC" -eq 1 ] && echo "$GATE_OUT" | grep -q '^fail:'; } \
    && ok "FORM $label flagged" || bad "FORM $label not flagged ($GATE_RC: $GATE_OUT)"
done

# --- EXEMPT marker ----------------------------------------------------------
R="$TR/exempt"; make_repo "$R"
stage_file "$R" m.js \
  "// reexport-policy-exempt: reviewed compatibility surface" \
  "export { x } from './y.js';"
gate "$R"
{ [ "$GATE_RC" -eq 0 ] && echo "$GATE_OUT" | grep -qx pass; } \
  && ok "EXEMPT reexport-policy-exempt marker skips the file" || bad "EXEMPT ($GATE_RC: $GATE_OUT)"

# --- STRING literal / comment non-match -------------------------------------
R="$TR/string"; make_repo "$R"
stage_file "$R" m.js \
  "const s = \"export { x } from './y.js'\";" \
  "// export { z } from './z.js' in a comment" \
  "export const real = s;"
gate "$R"
{ [ "$GATE_RC" -eq 0 ] && echo "$GATE_OUT" | grep -qx pass; } \
  && ok "STRING/COMMENT re-export text is not matched" || bad "STRING/COMMENT ($GATE_RC: $GATE_OUT)"

# --- REMOVED-only: a removed re-export is not a hit --------------------------
R="$TR/removed"; make_repo "$R"
# base commits a file that ALREADY has a re-export
printf "export { x } from './y.js';\n" > "$R/m.js"
git -C "$R" add -A; git -C "$R" commit -qm withreexport >/dev/null
# the change REMOVES it, leaving no re-export
stage_file "$R" m.js "export const only = 1;"
gate "$R"
{ [ "$GATE_RC" -eq 0 ] && echo "$GATE_OUT" | grep -qx pass; } \
  && ok "REMOVED-only: deleting a re-export is not a finding" || bad "REMOVED-only ($GATE_RC: $GATE_OUT)"

# --- BARREL is flagged (Decision 1) -----------------------------------------
R="$TR/barrel"; make_repo "$R"
stage_file "$R" index.js \
  "export * from './a.js';" \
  "export { b } from './b.js';"
gate "$R"
{ [ "$GATE_RC" -eq 1 ] && echo "$GATE_OUT" | grep -q '^fail: index.js:'; } \
  && ok "BARREL index.js re-exports ARE flagged (not exempt)" || bad "BARREL ($GATE_RC: $GATE_OUT)"

# --- TYPE-ONLY skipped (Decision 5) -----------------------------------------
R="$TR/typeonly"; make_repo "$R"
stage_file "$R" m.ts \
  "export type { T } from './y.js';" \
  "export type * from './z.js';"
gate "$R"
{ [ "$GATE_RC" -eq 0 ] && echo "$GATE_OUT" | grep -qx pass; } \
  && ok "TYPE-ONLY re-exports skipped" || bad "TYPE-ONLY ($GATE_RC: $GATE_OUT)"

# .d.ts declaration file skipped entirely
R="$TR/dts"; make_repo "$R"
stage_file "$R" types.d.ts "export { x } from './y.js';"
gate "$R"
{ [ "$GATE_RC" -eq 0 ] && echo "$GATE_OUT" | grep -qx pass; } \
  && ok "TYPE-ONLY .d.ts file skipped" || bad ".d.ts ($GATE_RC: $GATE_OUT)"

# --- SET-DIFFERENCE: pre-existing re-export not re-flagged on unrelated edit --
R="$TR/setdiff"; make_repo "$R"
printf "export { x } from './y.js';\nexport const k = 1;\n" > "$R/m.js"
git -C "$R" add -A; git -C "$R" commit -qm baseexport >/dev/null
# edit an UNRELATED line; the pre-existing re-export must NOT be re-flagged
stage_file "$R" m.js "export { x } from './y.js';" "export const k = 2;"
gate "$R"
{ [ "$GATE_RC" -eq 0 ] && echo "$GATE_OUT" | grep -qx pass; } \
  && ok "SET-DIFF pre-existing re-export not re-flagged on unrelated edit" || bad "SET-DIFF stable ($GATE_RC: $GATE_OUT)"
# now ADD a genuinely new re-export beside the old one -> only the new one is flagged
stage_file "$R" m.js "export { x } from './y.js';" "export const k = 2;" "export { w } from './w.js';"
gate "$R"
{ [ "$GATE_RC" -eq 1 ] && echo "$GATE_OUT" | grep -q "w.js" && ! echo "$GATE_OUT" | grep -q ":1 .*y.js"; } \
  && ok "SET-DIFF newly-added re-export flagged, old one not" || bad "SET-DIFF new ($GATE_RC: $GATE_OUT)"

# --- seat pre-pass: check / report exit convention --------------------------
R="$TR/prepass"; make_repo "$R"
base="$(git -C "$R" rev-parse HEAD)"
printf "export { x } from './y.js';\n" > "$R/m.js"
git -C "$R" add -A; git -C "$R" commit -qm addplain >/dev/null
"$PROBE" check "$R" "$base"; rc=$?
[ "$rc" -eq 0 ] && ok "PREPASS check exit 0 on a candidate" || bad "PREPASS check candidate ($rc)"
rep="$("$PROBE" report "$R" "$base" 2>/dev/null)"
echo "$rep" | grep -q '^summary: 1 candidate' && ok "PREPASS report summary counts the candidate" || bad "PREPASS report ($rep)"
# clean change -> check exit 1 (skip the seat)
R="$TR/prepass-clean"; make_repo "$R"
base="$(git -C "$R" rev-parse HEAD)"
printf "export const p = 2;\n" > "$R/m.js"
git -C "$R" add -A; git -C "$R" commit -qm cleanchange >/dev/null
"$PROBE" check "$R" "$base"; rc=$?
[ "$rc" -eq 1 ] && ok "PREPASS check exit 1 on a clean change (skip seat)" || bad "PREPASS check clean ($rc)"
# no resolvable base -> check exit 1 (skip), quiet
"$PROBE" check "$R" doesnotexist 2>/dev/null; rc=$?
[ "$rc" -eq 1 ] && ok "PREPASS check exit 1 on no-base (skip)" || bad "PREPASS no-base ($rc)"

echo
echo "no-plain-reexport-probe-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
