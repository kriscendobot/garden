#!/bin/bash
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUDIT="$(cd "$HERE/../.." && pwd)/context-graph-size-audit.py"
FIXTURE="$(mktemp -d)"
trap 'rm -rf "$FIXTURE"' EXIT

MAIN="$FIXTURE/main"
JOURNAL="$FIXTURE/journal"
mkdir -p "$MAIN/roles/test" "$MAIN/context/topic" "$MAIN/designs" \
  "$JOURNAL/projects/demo" "$JOURNAL/library/sections" "$JOURNAL/periodicals"

printf '%s\n' '# Main' '[Extra](extra.md)' '[Big design](designs/big.md)' >"$MAIN/CLAUDE.md"
printf '%s\n' '# Agent' '[Main](CLAUDE.md)' >"$MAIN/AGENTS.md"
printf '%s\n' '# Readme' >"$MAIN/README.md"
printf '%s\n' '# Worktrees' >"$MAIN/WORKTREES.md"
printf '%s\n' '# Extra' >"$MAIN/extra.md"
printf '%s\n' '# Orphan' >"$MAIN/orphan.md"
printf '%s\n' '# Context' >"$MAIN/context/README.md"
printf '%s\n' '# Topic' >"$MAIN/context/topic/page.md"
{
  printf '%s\n' '# Long role'
  seq 1 310 | sed 's/^/line /'
} >"$MAIN/roles/test/AGENT.md"
{
  printf '%s\n' '# Long design'
  seq 1 320 | sed 's/^/line /'
} >"$MAIN/designs/big.md"

printf '%s\n' '# Journal' >"$JOURNAL/README.md"
printf '%s\n' '# Projects' '[Demo](demo/README.md)' '[Periodicals](../periodicals/README.md)' >"$JOURNAL/projects/README.md"
printf '%s\n' '# Demo' >"$JOURNAL/projects/demo/README.md"
printf '%s\n' '# Orphan' >"$JOURNAL/projects/orphan.md"
printf '%s\n' '# Library' '[Sections](sections/README.md)' >"$JOURNAL/library/README.md"
{
  printf '%s\n' '# Generated index'
  seq 1 650 | sed 's/^/row /'
} >"$JOURNAL/library/sections/README.md"
printf '%s\n' '# Periodicals' >"$JOURNAL/periodicals/README.md"

git -C "$MAIN" init -q
git -C "$MAIN" add .
git -C "$MAIN" -c user.name=test -c user.email=test@example.invalid commit -qm fixture
git -C "$JOURNAL" init -q
git -C "$JOURNAL" add .
git -C "$JOURNAL" -c user.name=test -c user.email=test@example.invalid commit -qm fixture

REPORT="$FIXTURE/report.md"
"$AUDIT" --main-root "$MAIN" --journal-root "$JOURNAL" --date 2026-08-13 --top 10 >"$REPORT"

# Default behavior (no excludes) walks the full graph: the designs doc is a root
# and reached by a link, and both long documents are reorganization candidates.
grep -Fq 'Walked 15 reachable documents and flagged 2 reorganization candidates.' "$REPORT"
grep -Fq -- "\`roles/test/AGENT.md\` (311 lines" "$REPORT"
grep -Fq -- "\`designs/big.md\` (321 lines" "$REPORT"
grep -Fq -- "\`library/sections/README.md\` (generated index, exempt)" "$REPORT"
grep -Fq '## journal2 periodicals/' "$REPORT"
grep -Fq -- "\`orphan.md\`" "$REPORT"
grep -Fq -- "\`projects/orphan.md\`" "$REPORT"

# Scoped run: --exclude-root-glob prunes the designs doc from the walk entirely
# (even though CLAUDE.md links to it), and --exclude-journal-seed drops the
# projects seed so the projects tree and everything reached only through it
# (the demo page and the periodicals tree) leaves the graph.
SCOPED="$FIXTURE/scoped.md"
"$AUDIT" --main-root "$MAIN" --journal-root "$JOURNAL" --date 2026-08-13 --top 10 \
  --exclude-root-glob 'designs/*.md' --exclude-journal-seed 'projects/README.md' >"$SCOPED"

! grep -Fq -- '`designs/big.md`' "$SCOPED"
! grep -Fq '## journal2 projects/' "$SCOPED"
! grep -Fq '## journal2 periodicals/' "$SCOPED"
grep -Fq 'Excluded main2 globs' "$SCOPED"
grep -Fq -- '`projects/README.md`' "$SCOPED"          # named as an excluded journal2 seed
# The designs doc is deliberately out of scope, not an orphan.
! grep -Fq -- '`designs/big.md`' "$SCOPED"
# Orphan signal now scopes to the single seeded journal tree (library/).
grep -Fq 'under journal2 `library/`.' "$SCOPED"

printf '%s\n' 'context-graph-size-audit-test: PASS'
