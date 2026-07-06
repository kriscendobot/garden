#!/bin/bash
# insert-sections-table-row-test.sh — validate the deterministic Sections-table
# row inserter on throwaway fixtures. The regression it guards: a topic page
# whose see-also block at the bottom is a BARE bullet list (no "## See also"
# heading) must still receive the new row INSIDE the "## Sections" table, anchored
# on the table's last row — not appended at EOF after the bullets (the 2026-06-28
# erights-part-2 / pass-style.md mis-placement; job improve-sections-table-row-
# insert-anchor).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$HERE/../insert-sections-table-row.sh"
TR="$(mktemp -d /tmp/insert-sections-test.XXXXXX)"
trap 'rm -rf "$TR"' EXIT
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

NEWROW='| [new--section](../sections/new--section.md) | endo pkg/README.md | A freshly ingested section. |'

# Assert the new row landed immediately after the last ORIGINAL table row and
# strictly before any non-table content that follows the table.
assert_in_table() {  # assert_in_table <file> <last-original-row-substr>
  local f="$1" anchor="$2" newline anchorline
  newline=$(grep -n -F "$NEWROW" "$f" | head -1 | cut -d: -f1 || true)
  anchorline=$(grep -n -F "$anchor" "$f" | head -1 | cut -d: -f1 || true)
  if [ -z "$newline" ]; then bad "row not inserted into $f"; return; fi
  if [ -z "$anchorline" ]; then bad "anchor row vanished from $f"; return; fi
  if [ "$newline" -eq $((anchorline + 1)) ]; then
    ok "row inserted directly after the last table row (line $newline)"
  else
    bad "row at line $newline, expected $((anchorline + 1)) (just after anchor)"
  fi
  # The line after the new row must NOT be a table row (it is now the last row).
  local after; after=$(sed -n "$((newline + 1))p" "$f")
  case "$after" in
    '|'*) bad "a table row follows the inserted row — not appended at table end";;
    *)    ok "inserted row is the table's last row";;
  esac
}

# --- Case 1: headingless see-also bullet list (the regression) ---------------
cat > "$TR/headingless.md" <<'EOF'
# Topic: pass-style

> Abstract: classification system.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [a--overview](../sections/a--overview.md) | endo a/README.md | First. |
| [b--overview](../sections/b--overview.md) | endo b/README.md | Last original. |

- [`marshal`](marshal.md): the serialization package.
- [`captp`](captp.md): capability transport.
EOF
bash "$SCRIPT" "$TR/headingless.md" "$NEWROW" 2>/dev/null
assert_in_table "$TR/headingless.md" 'b--overview' "Last original."
# The trailing bullets must remain after the table, untouched.
if grep -q '^- \[`captp`\]' "$TR/headingless.md"; then ok "see-also bullets preserved"; else bad "see-also bullets lost"; fi

# --- Case 2: explicit "## See also" heading after the table ------------------
cat > "$TR/withheading.md" <<'EOF'
# Topic: marshal

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [b--overview](../sections/b--overview.md) | endo b/README.md | Last original. |

## See also

- [`pass-style`](pass-style.md)
EOF
bash "$SCRIPT" "$TR/withheading.md" "$NEWROW" 2>/dev/null
assert_in_table "$TR/withheading.md" 'b--overview' "Last original."
if grep -q '^## See also' "$TR/withheading.md"; then ok "## See also heading preserved"; else bad "## See also heading lost"; fi

# --- Case 3: table runs to end of file (no trailing content) -----------------
printf '# Topic: x\n\n## Sections\n\n| Section | Source | One-line abstract |\n|---------|--------|-------------------|\n| [b--overview](../sections/b--overview.md) | endo b/README.md | Last original. |\n' > "$TR/eof.md"
bash "$SCRIPT" "$TR/eof.md" "$NEWROW" 2>/dev/null
assert_in_table "$TR/eof.md" 'b--overview' "Last original."

# --- Case 4: idempotency — re-inserting the same row is a byte-for-byte no-op -
cp "$TR/headingless.md" "$TR/idem.md"
bash "$SCRIPT" "$TR/idem.md" "$NEWROW" 2>/dev/null
if cmp -s "$TR/headingless.md" "$TR/idem.md"; then ok "idempotent re-insert is a no-op"; else bad "idempotent re-insert changed the file"; fi

# --- Case 5: empty table (header + separator only) ---------------------------
cat > "$TR/empty.md" <<'EOF'
# Topic: y

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|

- [`other`](other.md)
EOF
bash "$SCRIPT" "$TR/empty.md" "$NEWROW" 2>/dev/null
assert_in_table "$TR/empty.md" '|---------|' "separator"

# --- Case 6: error surfaces — no "## Sections" heading -----------------------
printf '# Topic: z\n\nNo sections here.\n' > "$TR/nosections.md"
if bash "$SCRIPT" "$TR/nosections.md" "$NEWROW" 2>/dev/null; then
  bad "expected failure on a file with no ## Sections heading"
else
  ok "errors (exit $?) when no ## Sections heading is present"
fi

# --- Case 7: malformed row (no leading pipe) is rejected, file untouched ------
cp "$TR/headingless.md" "$TR/badrow.md"
if bash "$SCRIPT" "$TR/badrow.md" "not a table row" 2>/dev/null; then
  bad "expected failure on a row without a leading pipe"
else
  if cmp -s "$TR/headingless.md" "$TR/badrow.md"; then ok "malformed row rejected, file untouched"; else bad "malformed row mutated the file"; fi
fi

# --- Case 8: live-worktree refusal (Part 2 root-cause guard) ------------------
# Editing a topic file INSIDE the shared $GARDEN_ROOT/journal read worktree in
# place is what re-dirtied the tree the journal-worktree-keeper must keep clean.
# When GARDEN_ROOT is set and the target resolves under $GARDEN_ROOT/journal, the
# inserter must refuse (exit 1) and leave the file byte-for-byte untouched.
mkdir -p "$TR/gardenroot/journal/library/topics"
cp "$TR/headingless.md" "$TR/gardenroot/journal/library/topics/pass-style.md"
cp "$TR/gardenroot/journal/library/topics/pass-style.md" "$TR/live-before.md"
if GARDEN_ROOT="$TR/gardenroot" bash "$SCRIPT" "$TR/gardenroot/journal/library/topics/pass-style.md" "$NEWROW" 2>/dev/null; then
  bad "expected refusal editing a file inside the live worktree"
else
  if cmp -s "$TR/live-before.md" "$TR/gardenroot/journal/library/topics/pass-style.md"; then
    ok "refused the live-worktree edit, file untouched"
  else bad "live-worktree file was mutated despite refusal"; fi
fi
# A path OUTSIDE $GARDEN_ROOT/journal (an isolated clone) is still accepted.
mkdir -p "$TR/clone/library/topics"
cp "$TR/headingless.md" "$TR/clone/library/topics/pass-style.md"
if GARDEN_ROOT="$TR/gardenroot" bash "$SCRIPT" "$TR/clone/library/topics/pass-style.md" "$NEWROW" 2>/dev/null; then
  ok "accepted an edit in an isolated clone (outside the live worktree)"
else bad "wrongly refused an isolated-clone edit"; fi

# --- Case 9: concept page "## Sections that touch this concept" table ---------
# A concept page (journal/library/concepts/<c>.md) heads its table with the
# variant "## Sections that touch this concept", not the bare "## Sections". The
# inserter must anchor on that heading's table too, so scholars no longer place
# concept-page rows by hand (job improve-sections-table-row-concept-heading).
cat > "$TR/concept.md" <<'EOF'
# Concept: retention-accumulator

> Abstract: how retention accumulates.

## Sections that touch this concept

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [a--overview](../sections/a--overview.md) | endo a/README.md | First. |
| [b--overview](../sections/b--overview.md) | endo b/README.md | Last original. |

- [`marshal`](../topics/marshal.md): related topic.
EOF
bash "$SCRIPT" "$TR/concept.md" "$NEWROW" 2>/dev/null
assert_in_table "$TR/concept.md" 'b--overview' "Last original."
if grep -q '^- \[`marshal`\]' "$TR/concept.md"; then ok "concept-page trailing bullets preserved"; else bad "concept-page bullets lost"; fi

# --- Case 10: a heading that merely starts with "Sections" is NOT matched -----
# The widened match enumerates the two exact forms, so an unrelated heading whose
# text only begins with the word "Sections" must not be picked up as the anchor.
cat > "$TR/unrelated.md" <<'EOF'
# Topic: w

## Sections overview and rationale

Prose, no table here.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [b--overview](../sections/b--overview.md) | endo b/README.md | Last original. |
EOF
bash "$SCRIPT" "$TR/unrelated.md" "$NEWROW" 2>/dev/null
assert_in_table "$TR/unrelated.md" 'b--overview' "Last original."

echo "----------------------------------------------------------------"
echo "PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ]
