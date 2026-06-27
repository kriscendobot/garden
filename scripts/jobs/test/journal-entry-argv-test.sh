#!/bin/bash
# journal-entry-argv-test.sh — coverage for journal-entry.sh's first-argument
# (kind) and body-source guards.
#
# Regression for the 2026-06-27 unguarded-argv hazard: `journal-entry.sh --help`
# wrote a PERMANENT append-only journal entry with `kind: --help` (the stray
# entries/2026/06/27/115515Z---help-gardener-a67841.md, flagged in the 115543Z
# scholar result) because line 18 (`kind="${1:?...}"`) accepted anything as the
# kind. The script must instead: treat -h/--help as a query (print usage, exit 0,
# write/push NOTHING); reject a dash-led or otherwise malformed kind with a
# non-zero die BEFORE the clone/push loop; and reject an inline body STRING passed
# where a body-FILE path is expected (the same stdin-hang class as
# garden-harden-producer-body-read-hang) rather than silently reading stdin.
#
# Hermetic: a throwaway bare journal origin stands in for the shared journal. No
# real journal and no network are touched.
#
# Usage: journal-entry-argv-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ENTRY="$JOBS/journal-entry.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_*/JOURNAL_* state underneath the fixture (mirrors the sibling tests).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-jentry-argv-test
BARE="$TR/origin.git"
STATE="$TR/state"
CLONE="$STATE/producer/journal"
git_id=(-c user.name=test -c user.email=test@localhost)

setup_fixture() {
  rm -rf "$TR"; mkdir -p "$TR"
  git init -q --bare "$BARE"
  local SEED="$TR/seed"; git init -q "$SEED"
  git -C "$SEED" checkout -q -b journal2
  mkdir -p "$SEED/entries"; touch "$SEED/entries/.gitkeep"
  git -C "$SEED" add -A
  git -C "$SEED" "${git_id[@]}" commit -q -m "seed journal2 fixture"
  git -C "$SEED" remote add origin "$BARE"
  git -C "$SEED" push -q -u origin journal2
}

# Run journal-entry.sh against the fixture; fills $OUT, $RC. Body comes from $BODY
# (a here-string, so the function runs in THIS shell — a pipe would subshell it and
# lose $OUT/$RC). Set BODY="" for the reject cases that exit before reading a body.
run_entry() {  # run_entry [args...] ; body from $BODY
  set +e
  OUT="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
             GARDEN_STATE="$STATE" GARDEN_ROOT="$TR" \
             GARDEN_PRODUCER_CLONE="$CLONE" \
             GARDEN_HOST=testhost GARDEN_ROLE=gardener \
             GARDEN_NO_MAINTAINER_ALERT=1 \
             bash "$ENTRY" "$@" <<<"$BODY" 2>&1)"
  RC=$?
  set -e
}

# The current origin/journal2 head SHA (the serialization point: a write advances
# it, a refusal must leave it untouched).
origin_head() { git -C "$BARE" rev-parse journal2; }
# How many entry files of a given kind exist at the origin tip.
count_kind() { git -C "$BARE" ls-tree -r --name-only journal2 -- entries 2>/dev/null | grep -cE "Z-$1-" || true; }

# ============================================================================
hr; echo "STATIC — the script parses (bash -n)"; hr
bash -n "$ENTRY" && ok "journal-entry.sh parses" || bad "syntax error"

# ============================================================================
hr; echo "HELP — -h/--help prints usage, exits 0, writes NOTHING"; hr
setup_fixture
H0="$(origin_head)"
for flag in -h --help; do
  BODY="this body must never be written"
  run_entry "$flag"
  [ "$RC" -eq 0 ] && ok "$flag exits 0" || bad "$flag exit $RC (want 0): $OUT"
  grep -qi 'Usage:' <<<"$OUT" && ok "$flag prints the usage header" || bad "$flag printed no usage: $OUT"
done
[ "$(origin_head)" = "$H0" ] && ok "help wrote no journal entry (origin head unchanged)" || bad "help advanced the journal head"
[ "$(count_kind -.)" -eq 0 ] && ok "no dash-led 'kind: --help' entry landed" || bad "a --help entry landed on origin"

# ============================================================================
hr; echo "REJECT — a malformed kind fails fast, writes NOTHING"; hr
H1="$(origin_head)"
# a dash-led kind (the exact --help-as-kind class, and any stray flag)
BODY=""
run_entry --foo
[ "$RC" -ne 0 ] && ok "dash-led kind exits non-zero" || bad "dash-led kind exit $RC (want non-zero): $OUT"
grep -qi 'unknown kind' <<<"$OUT" && ok "names the unknown-kind refusal" || bad "no unknown-kind message: $OUT"
# a kind with illegal characters (a typo / accidental shell splat)
run_entry 'res ult'
[ "$RC" -ne 0 ] && ok "kind with a space exits non-zero" || bad "spaced kind exit $RC (want non-zero): $OUT"
run_entry '1bad'
[ "$RC" -ne 0 ] && ok "digit-led kind exits non-zero" || bad "digit-led kind exit $RC (want non-zero): $OUT"
[ "$(origin_head)" = "$H1" ] && ok "rejected kinds wrote no journal entry" || bad "a rejected kind advanced the journal head"

# ============================================================================
hr; echo "REJECT — an inline body STRING (non-file \$2) fails fast"; hr
H2="$(origin_head)"
# stdin is /dev/null (non-tty, empty) so the OLD silent fall-through to `cat`
# would block/hang; the guard must refuse instead of reading stdin.
set +e
OUT="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
           GARDEN_STATE="$STATE" GARDEN_ROOT="$TR" \
           GARDEN_PRODUCER_CLONE="$CLONE" \
           GARDEN_HOST=testhost GARDEN_ROLE=gardener \
           GARDEN_NO_MAINTAINER_ALERT=1 \
           bash "$ENTRY" progress "an inline body string" </dev/null 2>&1)"
RC=$?
set -e
[ "$RC" -ne 0 ] && ok "inline-body \$2 exits non-zero" || bad "inline-body \$2 exit $RC (want non-zero): $OUT"
grep -qi 'not a readable file' <<<"$OUT" && ok "names the body-source refusal" || bad "no body-source message: $OUT"
[ "$(origin_head)" = "$H2" ] && ok "inline-body refusal wrote no journal entry" || bad "inline-body advanced the journal head"

# ============================================================================
hr; echo "ACCEPT — a valid kind still posts a real entry"; hr
# body on stdin (the common producer path)
BODY="$(printf '%s\n' "a real progress note")"
run_entry progress
[ "$RC" -eq 0 ] && ok "exit 0 posting a valid 'progress' entry" || bad "exit $RC posting progress: $OUT"
[ "$(count_kind progress)" -ge 1 ] && ok "a progress entry reached origin/journal2" || bad "no progress entry on origin"
# body from a real file path ($2)
bf="$TR/body.md"; printf '%s\n' "# result" "body from a file" > "$bf"
BODY=""
run_entry result "$bf"
[ "$RC" -eq 0 ] && ok "exit 0 posting with a body-FILE \$2" || bad "exit $RC posting with body file: $OUT"
grep -qF "body from a file" <<<"$(git -C "$BARE" ls-tree -r --name-only journal2 -- entries \
  | grep -E 'Z-result-' | head -1 | xargs -I{} git -C "$BARE" show "journal2:{}")" \
  && ok "body-file content reached origin/journal2" || bad "body-file content not on origin"

# ============================================================================
hr
echo "RESULTS: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
