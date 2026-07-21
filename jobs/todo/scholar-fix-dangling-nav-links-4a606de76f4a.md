---
priority: normal
posted_by: library-link-scan
tip: 0495081ef
dangling_count: 1
---
# Repair dangling navigation links in the reference library

The standing library-link-scan (garden-library-link-scan.timer) found navigation/index/
source-table links that point at files NOT committed at origin/journal2 tip
`0495081ef`. These are scholar-authored navigation surfaces (concepts/topics/sources/
roles index pages, sections/README.md, the library README), NOT verbatim leaf
section bodies, so each one is the library's to resolve.

Dangling links (referrer -> target), 1 total:

```
  sources/kni--examples-subroutine.md -> ../sections/kni--examples-subroutine--overview.md
```

For each: write the missing target file (commonly an omitted `kind: index`
parent section), or correct/remove the navigation row that points at it. Before
committing a repoint, re-verify the new target exists at the current tip with
`scripts/jobs/library-link-scan.sh --exists <library-relative-path>`. Land edits
through `scripts/jobs/land-journal-edit.sh` (never the live worktree), then
re-run `scripts/jobs/library-link-scan.sh` until it is clean. Normal priority:
broken navigation, caught downstream — not an urgent gate.
