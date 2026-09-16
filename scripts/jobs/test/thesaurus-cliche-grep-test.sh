#!/bin/bash
# thesaurus-cliche-grep-test.sh — validate the deterministic cliché-grep
# (gardening/thesaurus-cliche-grep.sh) that cost-gates the thesaurus jury seat AND
# is the terminating oracle of the deslopper's apply-then-re-grep loop.
#
# Asserts the contract:
#   1. HIT: a true-positive Botese cliché in an added prose line is reported as
#      `<path>:<line>: <phrase> [<cat>] rewrite: <sug>` and `check` exits 0.
#   2. FALSE-POSITIVE AVOIDED (the load-bearing precision property): a LEGITIMATE
#      LITERAL use of the same word — a real "load-bearing wall", a real fabric
#      "seam", a Feathers testing "seam" — is NOT flagged, because the list matches
#      the distinctive multi-word COLLOCATION, not the bare word.
#   3. NO BARE-WORD MATCH: bare "load-bearing" / bare "seam" with no listed
#      collocation is NOT flagged.
#   4. WIDE NET: a cliché inside a QUOTED string IS flagged (the seat, not the grep,
#      adjudicates quote vs prose).
#   5. ADDED-ONLY: a REMOVED cliché is not a hit.
#   6. CLEAN: plain, cliché-free added lines => `check` exits 1 and `lines` empty.
#   7. WHOLE-PHRASE: a phrase embedded in a larger token / plural is not matched.
#   8. CASE-INSENSITIVE detect: `Load-Bearing Invariant` is flagged.
#   9. WHITESPACE-NORMALIZE: `load-bearing   invariant` (extra spaces) is flagged.
#  10. NO-BASE: an unresolvable base => `check` exits 1 (skip), quiet.
#  11. NO-LIST: a missing phrase list => exit 2 (LOUD), never a silent clean.
#  12. SKIP non-prose: the phrase list itself and a lockfile do not self-trigger.
#  13. CONVERGENCE: the apply-then-re-grep loop reaches a zero-candidate fixpoint in
#      finite steps (the deslopper invariant), modelling "apply" as a rephrase that
#      removes the matched phrase.
#
# Hermetic: throwaway git repos + the shipped cliches.tsv, no network, no systemd.
# The test's own source is a `.sh` file, so it stays clean under the code-only
# scanners; the fixtures are throwaway .md/.js files.

# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never fails).
# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREP="$(cd "$HERE/../gardening" && pwd)/thesaurus-cliche-grep.sh"
TSV="$(cd "$HERE/../../.." && pwd)/skills/botese-normalization/cliches.tsv"
TR="$(mktemp -d "${TMPDIR:-/tmp}/tcg-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

# make_repo <dir> <basefile> — a git repo with one committed base file.
make_repo() {
  local dir="$1" f="$2"
  mkdir -p "$dir"; git -C "$dir" init -q
  git -C "$dir" config user.email t@localhost; git -C "$dir" config user.name test
  printf 'base line\n' > "$dir/$f"
  git -C "$dir" add -A; git -C "$dir" commit -qm base >/dev/null
}
# commit_file <dir> <file> <line...> — overwrite the file and commit.
commit_file() {
  local dir="$1" f="$2"; shift 2
  printf '%s\n' "$@" > "$dir/$f"
  git -C "$dir" add -A; git -C "$dir" commit -qm change >/dev/null
}
run_report() { GARDEN_CLICHES_TSV="$TSV" bash "$GREP" report "$1" "${2:-HEAD~1}" 2>/dev/null; }
run_check()  { GARDEN_CLICHES_TSV="$TSV" bash "$GREP" check  "$1" "${2:-HEAD~1}" 2>/dev/null; }

# --- 1,2,3,4: HIT (true positive) + literal false-positive-avoided + wide net ----
R1="$TR/mix"; make_repo "$R1" doc.md
commit_file "$R1" doc.md \
  'base line' \
  'This is the load-bearing invariant that keeps the scheduler honest.' \
  'It is the seam where the two subsystems meet.' \
  'The garage has a load-bearing wall on the north side.' \
  'She sewed the seam on the left sleeve of the coat.' \
  'Introduce a seam so the collaborator can be mocked in tests.' \
  'The docs literally say "the load-bearing invariant is fragile" in quotes.'
rep1="$(run_report "$R1")"
# 1 TRUE POSITIVE — the two seed clichés, with category + rewrite.
echo "$rep1" | grep -q 'doc.md:2: load-bearing invariant \[filler-emphasis\] rewrite:' && ok "1 HIT true-positive 'load-bearing invariant' reported with category+rewrite" || bad "1 HIT load-bearing invariant ($rep1)"
echo "$rep1" | grep -q 'doc.md:3: seam where \[overwrought-metaphor\] rewrite:' && ok "1 HIT true-positive 'seam where' reported with category+rewrite" || bad "1 HIT seam where ($rep1)"
# 2 FALSE POSITIVE AVOIDED — real load-bearing wall (line 4), real fabric seam
#   (line 5), Feathers testing seam (line 6) must NOT appear.
echo "$rep1" | grep -q 'doc.md:4:' && bad "2 FALSE-POSITIVE: literal 'load-bearing wall' flagged ($rep1)" || ok "2 FALSE-POSITIVE AVOIDED: literal 'load-bearing wall' not flagged"
echo "$rep1" | grep -q 'doc.md:5:' && bad "2 FALSE-POSITIVE: literal fabric 'seam' flagged ($rep1)" || ok "2 FALSE-POSITIVE AVOIDED: literal fabric 'seam on the ...' not flagged"
echo "$rep1" | grep -q 'doc.md:6:' && bad "2 FALSE-POSITIVE: Feathers testing 'seam' flagged ($rep1)" || ok "2 FALSE-POSITIVE AVOIDED: Feathers testing 'seam so ...' not flagged"
# 4 WIDE NET — cliché inside a quoted string IS flagged (line 7); seat adjudicates.
echo "$rep1" | grep -q 'doc.md:7: load-bearing invariant' && ok "4 WIDE NET quoted-string cliché flagged (seat adjudicates)" || bad "4 WIDE NET quoted string ($rep1)"
run_check "$R1"; [ "$?" -eq 0 ] && ok "1 check exit 0 on a hit" || bad "1 check exit code on hit"

# --- 3: NO BARE-WORD MATCH --------------------------------------------------
R3="$TR/bare"; make_repo "$R3" doc.md
commit_file "$R3" doc.md 'base line' \
  'This part is load-bearing for the release train.' \
  'The seam ran the length of the hull.'
out3="$(GARDEN_CLICHES_TSV="$TSV" bash "$GREP" lines "$R3" HEAD~1 2>/dev/null)"
[ -z "$out3" ] && ok "3 NO BARE-WORD MATCH: bare 'load-bearing' / bare 'seam' not flagged" || bad "3 BARE-WORD: bare load-bearing/seam matched ($out3)"

# --- 5: ADDED-ONLY ----------------------------------------------------------
R5="$TR/removed"; make_repo "$R5" doc.md
printf 'base line\nthe old load-bearing invariant text\n' > "$R5/doc.md"; git -C "$R5" add -A; git -C "$R5" commit -qm withcliche >/dev/null
commit_file "$R5" doc.md 'base line' 'the new plain invariant text'
rep5="$(run_report "$R5")"
echo "$rep5" | grep -q 'load-bearing invariant' && bad "5 ADDED-ONLY flagged a removed cliché ($rep5)" || ok "5 ADDED-ONLY a removed cliché is not a hit"

# --- 6: CLEAN ---------------------------------------------------------------
R6="$TR/clean"; make_repo "$R6" doc.md
commit_file "$R6" doc.md 'base line' 'The invariant that keeps the scheduler honest is documented above.'
out6="$(GARDEN_CLICHES_TSV="$TSV" bash "$GREP" lines "$R6" HEAD~1 2>/dev/null)"
[ -z "$out6" ] && ok "6 CLEAN cliché-free: lines empty" || bad "6 CLEAN lines not empty ($out6)"
run_check "$R6"; [ "$?" -eq 1 ] && ok "6 CLEAN check exit 1 (skip seat)" || bad "6 CLEAN check exit code"

# --- 7: WHOLE-PHRASE (plural / embedded not matched) ------------------------
R7="$TR/wholephrase"; make_repo "$R7" doc.md
commit_file "$R7" doc.md 'base line' \
  'We enumerate the load-bearing invariants of the module.' \
  'The axis the seam follows is diagonal.'
rep7="$(run_report "$R7")"
# 'load-bearing invariants' (plural) has an alnum after 'invariant' -> NOT matched.
echo "$rep7" | grep -q 'load-bearing invariant ' && bad "7 WHOLE-PHRASE matched inside plural 'invariants'" || ok "7 WHOLE-PHRASE 'load-bearing invariant' does not match inside 'invariants'"
# 'axis the seam' embeds 'is the seam'? no — 'is the seam' needs a word boundary
# before 'is'; 'axis' ends in 'is' with an alnum before -> NOT matched.
echo "$rep7" | grep -q 'is the seam' && bad "7 WHOLE-PHRASE matched 'is the seam' inside 'axis the seam'" || ok "7 WHOLE-PHRASE 'is the seam' does not match inside 'axis the seam'"

# --- 8: CASE-INSENSITIVE ----------------------------------------------------
R8="$TR/case"; make_repo "$R8" doc.md
commit_file "$R8" doc.md 'base line' 'Load-Bearing Invariant at sentence start, Title Case.'
rep8="$(run_report "$R8")"
echo "$rep8" | grep -qi 'load-bearing invariant' && ok "8 CASE-INSENSITIVE 'Load-Bearing Invariant' flagged" || bad "8 CASE Load-Bearing Invariant ($rep8)"

# --- 9: WHITESPACE-NORMALIZE ------------------------------------------------
R9="$TR/ws"; make_repo "$R9" doc.md
commit_file "$R9" doc.md 'base line' 'The load-bearing   invariant survives extra   spacing.'
rep9="$(run_report "$R9")"
echo "$rep9" | grep -q 'load-bearing invariant' && ok "9 WHITESPACE-NORMALIZE extra spaces still matched" || bad "9 WHITESPACE-NORMALIZE ($rep9)"

# --- 10: NO-BASE ------------------------------------------------------------
R10="$TR/nobase"; make_repo "$R10" doc.md
GARDEN_CLICHES_TSV="$TSV" bash "$GREP" check "$R10" doesnotexist 2>/dev/null; rc10=$?
[ "$rc10" -eq 1 ] && ok "10 NO-BASE check exit 1 (skip)" || bad "10 NO-BASE check exit ($rc10)"

# --- 11: NO-LIST ------------------------------------------------------------
GARDEN_CLICHES_TSV="$TR/nope.tsv" bash "$GREP" check "$R1" HEAD~1 2>/dev/null; rc11=$?
[ "$rc11" -eq 2 ] && ok "11 NO-LIST exit 2 (LOUD)" || bad "11 NO-LIST exit ($rc11)"

# --- 12: SKIP non-prose (the phrase list + a lockfile do not self-trigger) ----
R12="$TR/nonprose"; make_repo "$R12" README.md
mkdir -p "$R12/skills/x"
cp "$TSV" "$R12/skills/x/cliches.tsv"
printf 'load-bearing invariant seam where\n' > "$R12/yarn.lock"
commit_file "$R12" README.md 'base line' 'Plain prose here: the invariant is documented.'
git -C "$R12" add -A; git -C "$R12" commit -qm nonprose >/dev/null
rep12="$(run_report "$R12")"
echo "$rep12" | grep -q 'cliches.tsv:\|yarn.lock:' && bad "12 non-prose self-triggered ($rep12)" || ok "12 SKIP non-prose (cliches.tsv + yarn.lock) do not self-trigger"

# --- 13: CONVERGENCE — apply-then-re-grep loop reaches zero -----------------
# Model the deslopper loop: each round, remove every matched phrase the digest names
# (a rephrase leaves no cliché behind), commit so the next `HEAD~1` diff shrinks,
# re-grep. Assert it terminates at zero in finite rounds.
R13="$TR/converge"; make_repo "$R13" doc.md
commit_file "$R13" doc.md 'base line' \
  'This is the load-bearing invariant and the load-bearing assumption.' \
  'It is the seam where things happen; this is the seam of note.'
rounds=0; max=10
while :; do
  rounds=$((rounds+1))
  lines="$(GARDEN_CLICHES_TSV="$TSV" bash "$GREP" lines "$R13" HEAD~1 2>/dev/null)"
  [ -z "$lines" ] && break
  [ "$rounds" -gt "$max" ] && { bad "13 CONVERGENCE did not terminate in $max rounds"; break; }
  # Apply: delete each matched phrase (case-insensitively) — a rephrase that removes
  # the cliché. sed with the literal phrase; phrases contain only [a-z -] here.
  while IFS= read -r l; do
    ph="$(printf '%s' "$l" | sed -E 's/^[^:]+:[0-9]+: (.*) \[[^]]+\] rewrite:.*/\1/')"
    [ -n "$ph" ] || continue
    sed -i -E "s/$ph//Ig" "$R13/doc.md"
  done <<EOF
$lines
EOF
  git -C "$R13" add -A; git -C "$R13" commit -qm "round $rounds" >/dev/null
done
GARDEN_CLICHES_TSV="$TSV" bash "$GREP" check "$R13" HEAD~1 2>/dev/null; rc13=$?
if [ "$rc13" -eq 1 ] && [ "$rounds" -le "$max" ]; then
  ok "13 CONVERGENCE loop reached zero-candidate fixpoint in $rounds round(s)"
else
  bad "13 CONVERGENCE fixpoint not reached (rc=$rc13 rounds=$rounds)"
fi

echo
echo "thesaurus-cliche-grep-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
