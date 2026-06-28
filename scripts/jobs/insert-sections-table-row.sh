#!/bin/bash
# insert-sections-table-row.sh — deterministically insert one row into a library
# topic page's "## Sections" Markdown table.
#
# Usage: insert-sections-table-row.sh <topic-file> <row>
#   <topic-file>  a topic page (e.g. journal/library/topics/<topic>.md) that
#                 contains a "## Sections" heading followed by a Markdown table.
#   <row>         the full Markdown table row to add, pipes included, e.g.
#                 "| [name](../sections/name.md) | endo pkg/README.md | One-line. |"
#
# The new row is appended as the LAST data row of the Sections table — placed
# immediately after the last existing "|"-leading line and before the blank line
# that terminates the table. The anchor is the table's own boundary, NEVER the
# presence of a trailing heading.
#
# Why this exists: a topic page's see-also block at the bottom is frequently a
# bare bullet list with NO "## See also" heading. An "insert before `## See also`,
# else append at EOF" heuristic therefore drops the row after that bullet list,
# OUTSIDE the table (this bit the 2026-06-28 erights-part-2 ingest on
# pass-style.md, journal entry 161137Z; job improve-sections-table-row-insert-
# anchor). Anchoring on the parsed table boundary removes the whole class of
# mis-placement.
#
# Idempotent: if an identical row already exists in the table, the file is left
# byte-for-byte unchanged and the script succeeds.
#
# Exit codes: 0 ok (inserted or already present); 2 usage; 1 missing/single-line
# violation; 3 no "## Sections" heading; 4 no table under "## Sections".
set -euo pipefail

usage() {
  cat >&2 <<'EOF'
usage: insert-sections-table-row.sh <topic-file> <row>
  <topic-file>  library topic page containing a "## Sections" Markdown table
  <row>         full Markdown table row to insert (pipes included), e.g.
                "| [name](../sections/name.md) | endo pkg/README.md | One-line. |"
The row is appended as the table's last data row — after the last existing
"|"-leading line, before the blank line that terminates the table. If an
identical row already exists, the file is left unchanged.
EOF
  exit 2
}

[ "$#" -eq 2 ] || usage
topic_file=$1
row=$2

[ -f "$topic_file" ] || { echo "insert-sections-table-row: no such file: $topic_file" >&2; exit 1; }

# A table row is a single line. Reject embedded newlines outright.
case $row in
  *$'\n'*) echo "insert-sections-table-row: row must be a single line" >&2; exit 1;;
esac
# Trim surrounding whitespace, then require a leading table pipe.
row=${row#"${row%%[![:space:]]*}"}
row=${row%"${row##*[![:space:]]}"}
case $row in
  '|'*) ;;
  *) echo "insert-sections-table-row: row must begin with '|' (got: $row)" >&2; exit 1;;
esac

tmp=$(mktemp "$topic_file.insert.XXXXXX")
trap 'rm -f "$tmp"' EXIT

awk -v newrow="$row" '
  { line[NR] = $0 }
  END {
    n = NR

    # 1. Locate the "## Sections" heading.
    sec = 0
    for (i = 1; i <= n; i++)
      if (line[i] ~ /^##[ \t]+Sections[ \t]*$/) { sec = i; break }
    if (sec == 0) {
      print "insert-sections-table-row: no \"## Sections\" heading in file" > "/dev/stderr"
      exit 3
    }

    # 2. Find the first table row (a "|"-leading line) after the heading,
    #    stopping if another heading intervenes (an empty Sections section).
    tstart = 0
    for (i = sec + 1; i <= n; i++) {
      if (line[i] ~ /^[ \t]*\|/) { tstart = i; break }
      if (line[i] ~ /^#/) break
    }
    if (tstart == 0) {
      print "insert-sections-table-row: no Markdown table under \"## Sections\"" > "/dev/stderr"
      exit 4
    }

    # 3. The table is the maximal run of consecutive "|"-leading lines; its last
    #    such line is the anchor. The first non-"|" line (typically blank) ends it.
    tend = tstart
    for (i = tstart; i <= n; i++) {
      if (line[i] ~ /^[ \t]*\|/) tend = i
      else break
    }

    # 4. Idempotency: identical row already in the table -> emit unchanged.
    for (i = tstart; i <= tend; i++)
      if (line[i] == newrow) {
        for (j = 1; j <= n; j++) print line[j]
        exit 0
      }

    # 5. Emit, inserting the new row right after the anchor (last table row).
    for (i = 1; i <= n; i++) {
      print line[i]
      if (i == tend) print newrow
    }
  }
' "$topic_file" > "$tmp"

# Preserve the original mode, then swap atomically.
chmod --reference="$topic_file" "$tmp" 2>/dev/null || true
mv "$tmp" "$topic_file"
trap - EXIT

echo "insert-sections-table-row: inserted row into ${topic_file}'s Sections table" >&2
