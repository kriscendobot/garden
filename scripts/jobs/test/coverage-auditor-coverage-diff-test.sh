#!/bin/bash
# coverage-auditor-coverage-diff-test.sh — validate the deterministic coverage-diff
# script (gardening/coverage-auditor-coverage-diff.sh) that cost-gates the
# coverage-auditor jury seat.
#
# Asserts the contract:
#   1. HIT: an added line that is an executable statement with 0 hits is reported
#      as <path>:<line> and `check` exits 0 (dispatch the juror).
#   2. NO-HIT: an added executable statement with >0 hits is covered (not reported).
#   3. N/A: an added NON-executable line (blank/comment, absent from statementMap)
#      is neither covered nor uncovered — never reported.
#   4. CLEAN: when every added executable line is covered, `check` exits 1 and
#      `lines` is empty (skip the juror — no wasted claude -p).
#   5. ADDED-ONLY: a REMOVED uncovered line is not a hit.
#   6. FILE-NOT-IN-REPORT: an added code file with no coverage entry (vendored /
#      config-excluded) is N/A, not flagged.
#   7. REPORT: the `report` subcommand appends a `summary: N ... across M ...` count.
#   8. NO-REPORT: a missing coverage JSON => exit 2 (LOUD), never a silent covered.
#   9. NO-BASE: an unresolvable base => exit 1 (skip), quiet-with-reason.
#  10. NON-CODE: an uncovered-looking line in a .md file is not scanned.
#
# Hermetic: throwaway git repos + fixture coverage JSON, no network, no systemd.
# The test's own source is a `.sh` file, so it stays clean under the code-only
# scanners; the fixtures are throwaway .js/.ts files.

# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never fails).
# shellcheck disable=SC2015
set -uo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIFF="$(cd "$HERE/../gardening" && pwd)/coverage-auditor-coverage-diff.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/cacd-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

# make_repo <dir> <basefile> — a git repo with one committed base file.
make_repo() {
  local dir="$1" f="$2"
  mkdir -p "$dir"; git -C "$dir" init -q
  git -C "$dir" config user.email t@localhost; git -C "$dir" config user.name test
  printf 'const base = 1;\n' > "$dir/$f"
  git -C "$dir" add -A; git -C "$dir" commit -qm base >/dev/null
}
# commit_lines <dir> <file> <line...> — overwrite the file and commit.
commit_lines() {
  local dir="$1" f="$2"; shift 2
  printf '%s\n' "$@" > "$dir/$f"
  git -C "$dir" add -A; git -C "$dir" commit -qm change >/dev/null
}
# write_cov <dir> <relpath> <json-of-statementMap-and-s> — write a c8-style report.
# Emits a coverage-final.json whose sole entry is <dir>/<relpath> (absolute, as c8
# records it) with the given statementMap ("m") and hit map ("s").
write_cov() {
  local dir="$1" rel="$2" statementMap="$3" s="$4"
  mkdir -p "$dir/coverage"
  cat > "$dir/coverage/coverage-final.json" <<EOF
{
  "$dir/$rel": {
    "path": "$dir/$rel",
    "statementMap": $statementMap,
    "s": $s,
    "branchMap": {}, "b": {}, "fnMap": {}, "f": {}
  }
}
EOF
}

# --- 1 & 2 & 3: a change with a covered line, an uncovered line, and a comment --
# New file.js after change (lines): 1 const base=1;  2 //note  3 export const a=covered;
#                                   4 export const b=uncovered;
# statementMap: stmt0 -> line 3 (hits 5, covered), stmt1 -> line 4 (hits 0, uncovered).
# Line 2 (comment) has NO statement -> N/A. Line 1 is unchanged base.
R1="$TR/mixed"; make_repo "$R1" file.js
commit_lines "$R1" file.js 'const base = 1;' '// note' 'export const a = covered();' 'export const b = uncovered();'
write_cov "$R1" file.js \
  '{"0":{"start":{"line":3,"column":0},"end":{"line":3,"column":40}},"1":{"start":{"line":4,"column":0},"end":{"line":4,"column":40}}}' \
  '{"0":5,"1":0}'
"$DIFF" check "$R1" >/dev/null 2>&1 \
  && ok "check: an uncovered new executable line exits 0 (dispatch)" || bad "check missed an uncovered new line"
l1="$("$DIFF" lines "$R1" 2>/dev/null)"
printf '%s\n' "$l1" | grep -qx 'file.js:4' \
  && ok "lines: reports the uncovered line file.js:4" || bad "lines wrong ($l1)"
printf '%s\n' "$l1" | grep -q 'file.js:3' \
  && bad "lines flagged the COVERED line 3 (hits>0)" || ok "lines: covered line 3 not reported"
printf '%s\n' "$l1" | grep -q 'file.js:2' \
  && bad "lines flagged the comment line 2 (non-executable)" || ok "lines: comment line 2 is N/A (not reported)"

# --- 4: CLEAN — every added executable line covered -> exit 1, empty ---------
R4="$TR/clean"; make_repo "$R4" file.js
commit_lines "$R4" file.js 'const base = 1;' 'export const a = covered();'
write_cov "$R4" file.js \
  '{"0":{"start":{"line":2,"column":0},"end":{"line":2,"column":40}}}' '{"0":3}'
"$DIFF" check "$R4" >/dev/null 2>&1 \
  && bad "check fired on a fully-covered change (should skip)" || ok "check: fully-covered change exits 1 (skip juror)"
[ -z "$("$DIFF" lines "$R4" 2>/dev/null)" ] \
  && ok "lines: fully-covered change prints nothing" || bad "lines reported on a clean change"

# --- 5: ADDED-ONLY — a REMOVED uncovered line is not a hit ------------------
R5="$TR/removed"; mkdir -p "$R5"; git -C "$R5" init -q
git -C "$R5" config user.email t@l; git -C "$R5" config user.name t
printf 'const base = 1;\nexport const gone = uncovered();\n' > "$R5/file.js"
git -C "$R5" add -A; git -C "$R5" commit -qm base >/dev/null
printf 'const base = 1;\n' > "$R5/file.js"   # the uncovered line is REMOVED
git -C "$R5" add -A; git -C "$R5" commit -qm shrink >/dev/null
write_cov "$R5" file.js \
  '{"0":{"start":{"line":2,"column":0},"end":{"line":2,"column":40}}}' '{"0":0}'
"$DIFF" check "$R5" >/dev/null 2>&1 \
  && bad "check flagged a REMOVED uncovered line (not added-only)" || ok "check: removed line is not a hit (added-only)"

# --- 6: FILE-NOT-IN-REPORT — added code file absent from coverage -> N/A -----
# The change adds an uncovered-looking line in vendor.js, but the report only
# covers file.js. vendor.js has no entry (config-excluded/vendored) -> not flagged.
R6="$TR/absent"; make_repo "$R6" file.js
printf 'const base = 1;\nexport const kept = 1;\n' > "$R6/file.js"
printf 'export const v = uncovered();\n' > "$R6/vendor.js"
git -C "$R6" add -A; git -C "$R6" commit -qm addvendor >/dev/null
write_cov "$R6" file.js \
  '{"0":{"start":{"line":2,"column":0},"end":{"line":2,"column":20}}}' '{"0":4}'
out6="$("$DIFF" lines "$R6" 2>/dev/null)"
printf '%s\n' "$out6" | grep -q 'vendor.js' \
  && bad "flagged vendor.js which has no coverage entry (should be N/A)" || ok "file absent from report is N/A (not flagged)"

# --- 7: REPORT — summary count trailer --------------------------------------
rep="$("$DIFF" report "$R1" 2>/dev/null)"
printf '%s\n' "$rep" | grep -qx 'summary: 1 uncovered new line(s) across 1 file(s)' \
  && ok "report: appends the summary count" || bad "report summary wrong ($rep)"

# --- 8: NO-REPORT — missing coverage JSON -> exit 2 (loud), never covered ----
R8="$TR/noreport"; make_repo "$R8" file.js
commit_lines "$R8" file.js 'const base = 1;' 'export const a = uncovered();'
set +e; err8="$("$DIFF" check "$R8" 2>&1 >/dev/null)"; rc8=$?; set -e
[ "$rc8" -eq 2 ] && ok "check: no coverage report -> exit 2 (cannot determine)" || bad "no-report rc=$rc8 (want 2)"
printf '%s' "$err8" | grep -qi 'no c8 coverage report' \
  && ok "no-report: loud stderr reason (never silent 'covered')" || bad "no-report reason not surfaced ($err8)"

# --- 9: NO-BASE — unresolvable base -> exit 1 (skip), quiet-with-reason ------
R9="$TR/nobase"; mkdir -p "$R9"; git -C "$R9" init -q
git -C "$R9" config user.email t@l; git -C "$R9" config user.name t
printf 'const only = 1;\n' > "$R9/file.js"
git -C "$R9" add -A; git -C "$R9" commit -qm only >/dev/null   # no HEAD~1
write_cov "$R9" file.js '{}' '{}'
set +e; "$DIFF" check "$R9" >/dev/null 2>&1; rc9=$?; set -e
[ "$rc9" -eq 1 ] && ok "check: unresolvable base -> exit 1 (skip)" || bad "no-base rc=$rc9 (want 1)"

# --- 10: NON-CODE — an uncovered-looking line in a .md file is not scanned ---
R10="$TR/md"; make_repo "$R10" file.js
printf 'const base = 1;\n' > "$R10/file.js"
printf '# Title\nExample: `export const b = uncovered();`\n' > "$R10/doc.md"
git -C "$R10" add -A; git -C "$R10" commit -qm adddoc >/dev/null
write_cov "$R10" file.js '{}' '{}'
out10="$("$DIFF" lines "$R10" 2>/dev/null)"
printf '%s\n' "$out10" | grep -q 'doc.md' \
  && bad "flagged a line inside a markdown file" || ok "markdown is not scanned (code files only)"

echo "----------------------------------------------------------------"
echo "coverage-auditor-coverage-diff: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
