#!/bin/bash
# orthographer-divergence-grep-test.sh — validate the deterministic divergence-grep
# (gardening/orthographer-divergence-grep.sh) that cost-gates the orthographer jury
# seat AND is the terminating oracle of the americanizer's apply-then-re-grep loop.
#
# Asserts the contract:
#   1. HIT: a real British spelling in an added prose line is reported as
#      `<path>:<line>: <british> -> <american> [cat]` and `check` exits 0.
#   2. EXCLUDE always-ise: surprise / exercise / advertise are NOT flagged
#      (never on the list — precision over recall).
#   3. EXCLUDE false friends: genre / acre / your / tour are NOT flagged.
#   4. WIDE NET: a British spelling inside an IDENTIFIER and inside a QUOTED string
#      IS flagged (the seat, not the grep, adjudicates identifier vs prose).
#   5. ADDED-ONLY: a REMOVED British word is not a hit.
#   6. CLEAN: all-American added lines => `check` exits 1 and `lines` is empty
#      (skip the seat — no wasted claude -p).
#   7. WHOLE-WORD: a row token embedded in a larger word (discolouration) is not
#      matched by the `colour` row.
#   8. CASE-INSENSITIVE detect: `Colour` is flagged.
#   9. NO-BASE: an unresolvable base => `check` exits 1 (skip), quiet.
#  10. NO-LIST: a missing word list => exit 2 (LOUD), never a silent clean.
#  11. SKIP non-prose: the word list itself and a lockfile do not self-trigger.
#  12. CONVERGENCE: the apply-then-re-grep loop reaches a zero-candidate fixpoint
#      in finite steps (the load-bearing americanizer invariant).
#
# Hermetic: throwaway git repos + the shipped divergences.tsv, no network, no
# systemd. The test's own source is a `.sh` file, so it stays clean under the
# code-only scanners; the fixtures are throwaway .md/.js files.

# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never fails).
# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREP="$(cd "$HERE/../gardening" && pwd)/orthographer-divergence-grep.sh"
TSV="$(cd "$HERE/../../.." && pwd)/skills/american-english-normalization/divergences.tsv"
TR="$(mktemp -d "${TMPDIR:-/tmp}/odg-test.XXXXXX")"
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
run_report() { GARDEN_DIVERGENCES_TSV="$TSV" bash "$GREP" report "$1" "${2:-HEAD~1}" 2>/dev/null; }
run_check()  { GARDEN_DIVERGENCES_TSV="$TSV" bash "$GREP" check  "$1" "${2:-HEAD~1}" 2>/dev/null; }

# --- 1,2,3,4: HIT + exclusions + wide net -----------------------------------
R1="$TR/mix"; make_repo "$R1" doc.md
commit_file "$R1" doc.md \
  'base line' \
  'We serialise the colour and normalise behaviour here.' \
  'This will surprise you; exercise and advertise stay put.' \
  'Genre and acre and your tour are false friends.' \
  'The function serialise() is an upstream identifier.' \
  'He wrote "colour" in a quoted upstream string.'
rep1="$(run_report "$R1")"
echo "$rep1" | grep -q 'doc.md:2: serialise -> serialize \[ise-verb\]' && ok "1 HIT serialise reported with replacement+category" || bad "1 HIT serialise ($rep1)"
echo "$rep1" | grep -q 'doc.md:2: colour -> color' && ok "1 HIT colour reported" || bad "1 HIT colour"
echo "$rep1" | grep -q 'doc.md:2: behaviour -> behavior' && ok "1 HIT behaviour reported" || bad "1 HIT behaviour"
echo "$rep1" | grep -qi 'surprise\|exercise\|advertise' && bad "2 EXCLUDE always-ise leaked" || ok "2 EXCLUDE always-ise (surprise/exercise/advertise) not flagged"
echo "$rep1" | grep -qi 'genre\|acre\|your\|tour' && bad "3 EXCLUDE false friend leaked" || ok "3 EXCLUDE false friends (genre/acre/your/tour) not flagged"
echo "$rep1" | grep -q 'doc.md:5: serialise' && ok "4 WIDE NET identifier serialise flagged (seat adjudicates)" || bad "4 WIDE NET identifier"
echo "$rep1" | grep -q 'doc.md:6: colour' && ok "4 WIDE NET quoted-string colour flagged (seat adjudicates)" || bad "4 WIDE NET quoted string"
run_check "$R1"; [ "$?" -eq 0 ] && ok "1 check exit 0 on a hit" || bad "1 check exit code on hit"

# --- 5: ADDED-ONLY ----------------------------------------------------------
R5="$TR/removed"; make_repo "$R5" doc.md
# base has a british word; the change REMOVES it and adds an american line.
printf 'base line\nold colour text\n' > "$R5/doc.md"; git -C "$R5" add -A; git -C "$R5" commit -qm withbrit >/dev/null
commit_file "$R5" doc.md 'base line' 'new color text'
rep5="$(run_report "$R5")"
echo "$rep5" | grep -q 'colour' && bad "5 ADDED-ONLY flagged a removed british word ($rep5)" || ok "5 ADDED-ONLY a removed british word is not a hit"

# --- 6: CLEAN ---------------------------------------------------------------
R6="$TR/clean"; make_repo "$R6" doc.md
commit_file "$R6" doc.md 'base line' 'We serialize the color and normalize behavior here.'
out6="$(GARDEN_DIVERGENCES_TSV="$TSV" bash "$GREP" lines "$R6" HEAD~1 2>/dev/null)"
[ -z "$out6" ] && ok "6 CLEAN all-american: lines empty" || bad "6 CLEAN lines not empty ($out6)"
run_check "$R6"; [ "$?" -eq 1 ] && ok "6 CLEAN check exit 1 (skip seat)" || bad "6 CLEAN check exit code"

# --- 7: WHOLE-WORD ----------------------------------------------------------
R7="$TR/wholeword"; make_repo "$R7" doc.md
commit_file "$R7" doc.md 'base line' 'The discolouration and colourfulness of glamour.'
rep7="$(run_report "$R7")"
# 'discolouration' embeds 'colour' but with alnum neighbours -> NOT matched.
# 'glamour' is a documented false friend -> NOT a row.
echo "$rep7" | grep -q 'discolouration:\|:.*colour ->.*discolour' && bad "7 WHOLE-WORD matched inside discolouration" || ok "7 WHOLE-WORD colour does not match inside discolouration"
echo "$rep7" | grep -qi 'glamour' && bad "7 false friend glamour flagged" || ok "7 false friend glamour not flagged"

# --- 8: CASE-INSENSITIVE ----------------------------------------------------
R8="$TR/case"; make_repo "$R8" doc.md
commit_file "$R8" doc.md 'base line' 'Colour and SERIALISE at sentence start.'
rep8="$(run_report "$R8")"
echo "$rep8" | grep -qi 'colour -> color' && ok "8 CASE-INSENSITIVE Colour flagged" || bad "8 CASE Colour"
echo "$rep8" | grep -qi 'serialise -> serialize' && ok "8 CASE-INSENSITIVE SERIALISE flagged" || bad "8 CASE SERIALISE"

# --- 9: NO-BASE -------------------------------------------------------------
R9="$TR/nobase"; make_repo "$R9" doc.md
GARDEN_DIVERGENCES_TSV="$TSV" bash "$GREP" check "$R9" doesnotexist 2>/dev/null; rc9=$?
[ "$rc9" -eq 1 ] && ok "9 NO-BASE check exit 1 (skip)" || bad "9 NO-BASE check exit ($rc9)"

# --- 10: NO-LIST ------------------------------------------------------------
GARDEN_DIVERGENCES_TSV="$TR/nope.tsv" bash "$GREP" check "$R1" HEAD~1 2>/dev/null; rc10=$?
[ "$rc10" -eq 2 ] && ok "10 NO-LIST exit 2 (LOUD)" || bad "10 NO-LIST exit ($rc10)"

# --- 11: SKIP non-prose (the word list + a lockfile do not self-trigger) -----
R11="$TR/nonprose"; make_repo "$R11" README.md
mkdir -p "$R11/skills/x"
cp "$TSV" "$R11/skills/x/divergences.tsv"
printf 'serialise colour behaviour\n' > "$R11/yarn.lock"
commit_file "$R11" README.md 'base line' 'All american here: serialize color.'
git -C "$R11" add -A; git -C "$R11" commit -qm nonprose >/dev/null
rep11="$(run_report "$R11")"
echo "$rep11" | grep -q 'divergences.tsv:\|yarn.lock:' && bad "11 non-prose self-triggered ($rep11)" || ok "11 SKIP non-prose (divergences.tsv + yarn.lock) do not self-trigger"

# --- 12: CONVERGENCE — apply-then-re-grep loop reaches zero ------------------
# Model the americanizer loop with a deterministic sed apply derived from the
# grep digest, then re-grep. Assert it terminates at zero in finite rounds.
R12="$TR/converge"; make_repo "$R12" doc.md
commit_file "$R12" doc.md 'base line' \
  'We serialise the colour and normalise the behaviour.' \
  'Then we optimise and finalise the organisation.'
rounds=0; max=10
while :; do
  rounds=$((rounds+1))
  lines="$(GARDEN_DIVERGENCES_TSV="$TSV" bash "$GREP" lines "$R12" HEAD~1 2>/dev/null)"
  [ -z "$lines" ] && break
  [ "$rounds" -gt "$max" ] && { bad "12 CONVERGENCE did not terminate in $max rounds"; break; }
  # Apply every british->american pair the digest names (whole-word, case-preserving
  # for the lowercase fixtures here), committing so the next `HEAD~1` diff shrinks.
  while IFS= read -r l; do
    br="$(printf '%s' "$l" | sed -E 's/^[^:]+:[0-9]+: ([^ ]+) -> ([^ ]+).*/\1/')"
    am="$(printf '%s' "$l" | sed -E 's/^[^:]+:[0-9]+: ([^ ]+) -> ([^ ]+).*/\2/')"
    sed -i -E "s/\\b$br\\b/$am/g" "$R12/doc.md"
  done <<EOF
$lines
EOF
  git -C "$R12" add -A; git -C "$R12" commit -qm "round $rounds" >/dev/null
done
GARDEN_DIVERGENCES_TSV="$TSV" bash "$GREP" check "$R12" HEAD~1 2>/dev/null; rc12=$?
if [ "$rc12" -eq 1 ] && [ "$rounds" -le "$max" ]; then
  ok "12 CONVERGENCE loop reached zero-candidate fixpoint in $rounds round(s)"
else
  bad "12 CONVERGENCE fixpoint not reached (rc=$rc12 rounds=$rounds)"
fi

echo
echo "orthographer-divergence-grep-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
