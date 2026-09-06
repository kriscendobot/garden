#!/bin/bash
# journal-entry-project-test.sh — coverage for journal-entry.sh project tags.
#
# Regression for a misspelled `project: endojs-endo-but-for-bots` body tag that
# escaped into the journal. The daily Dependabot backstop searches the canonical
# project's ledger and therefore missed that entry. A tagged entry must name a
# directory under projects/ in the synced journal, and an unknown tag must fail
# without advancing the journal.
#
# Hermetic: a throwaway bare journal origin stands in for the shared journal. No
# real journal and no network are touched.
#
# Usage: journal-entry-project-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ENTRY="$JOBS/journal-entry.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

TR="$(mktemp -d /home/kris/.garden-jentry-project-test.XXXXXX)"
trap 'rm -rf "$TR"' EXIT
BARE="$TR/origin.git"
STATE="$TR/state"
CLONE="$STATE/producer/journal"
git_id=(-c user.name=test -c user.email=test@localhost)

git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/entries" "$SEED/projects/endo-but-for-bots"
touch "$SEED/entries/.gitkeep"
printf '# Endo bot fixture\n' > "$SEED/projects/endo-but-for-bots/README.md"
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed journal fixture"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin journal2

run_entry() {
  set +e
  OUT="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
             GARDEN_STATE="$STATE" GARDEN_ROOT="$TR" \
             GARDEN_PRODUCER_CLONE="$CLONE" \
             GARDEN=testhost GARDEN_ROLE=gardener \
             GARDEN_NO_MAINTAINER_ALERT=1 \
             bash "$ENTRY" progress <<<"$BODY" 2>&1)"
  RC=$?
  set -e
}

origin_head() { git -C "$BARE" rev-parse journal2; }
count_entries() { git -C "$BARE" ls-tree -r --name-only journal2 -- entries | grep -cE 'Z-progress-' || true; }

bash -n "$ENTRY" && ok "journal-entry.sh parses" || bad "syntax error"

BODY="project: endo-but-for-bots

known project entry"
run_entry
[ "$RC" -eq 0 ] && [ "$(count_entries)" -eq 1 ] \
  && ok "a canonical project tag posts" \
  || bad "known project tag failed (rc=$RC): $OUT"

H0="$(origin_head)"
BODY="project: endojs-endo-but-for-bots

misspelled project entry"
run_entry
[ "$RC" -ne 0 ] && grep -qF "unknown project slug 'endojs-endo-but-for-bots'" <<<"$OUT" \
  && ok "an unknown project tag fails loudly" \
  || bad "unknown project tag was not loudly refused (rc=$RC): $OUT"
[ "$(origin_head)" = "$H0" ] && [ "$(count_entries)" -eq 1 ] \
  && ok "an unknown project tag writes nothing" \
  || bad "unknown project tag advanced the journal"

# The producer clone already exists. Add a project through a separate checkout;
# the next invocation must sync before validating and recognize the new slug.
EDIT="$TR/edit"; git clone -q --branch journal2 "$BARE" "$EDIT"
mkdir -p "$EDIT/projects/new-project"
printf '# New project fixture\n' > "$EDIT/projects/new-project/README.md"
git -C "$EDIT" add projects/new-project/README.md
git -C "$EDIT" "${git_id[@]}" commit -q -m "add a project after producer clone"
git -C "$EDIT" push -q origin journal2
BODY="project: new-project

freshly registered project entry"
run_entry
[ "$RC" -eq 0 ] && [ "$(count_entries)" -eq 2 ] \
  && ok "validation uses the freshly synced journal" \
  || bad "fresh project was not recognized after sync (rc=$RC): $OUT"

H1="$(origin_head)"
BODY="project: endo-but-for-bots
project: missing-project

two-tag entry"
run_entry
[ "$RC" -ne 0 ] && grep -qF "unknown project slug 'missing-project'" <<<"$OUT" \
  && [ "$(origin_head)" = "$H1" ] \
  && ok "every project tag is validated before posting" \
  || bad "a later unknown tag was not refused (rc=$RC): $OUT"

BODY="an entry with no project tag"
run_entry
[ "$RC" -eq 0 ] && [ "$(count_entries)" -eq 3 ] \
  && ok "an untagged entry remains valid" \
  || bad "untagged entry failed (rc=$RC): $OUT"

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
