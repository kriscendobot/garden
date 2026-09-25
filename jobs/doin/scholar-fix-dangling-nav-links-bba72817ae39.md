---
priority: normal
posted_by: library-link-scan
tip: 4e146876c
dangling_count: 3
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Repair dangling navigation links in the reference library

The standing library-link-scan (garden-library-link-scan.timer) found navigation/index/
source-table links that point at files NOT committed at origin/journal2 tip
`4e146876c`. These are scholar-authored navigation surfaces (concepts/topics/sources/
roles index pages, sections/README.md, the library README), NOT verbatim leaf
section bodies, so each one is the library's to resolve.

Dangling links (referrer -> target), 3 total:

```
  concepts/xs-heap-snapshot-agent-persistence.md -> ../sections/web--haruni-kaozkit-xs-agents--what-the-snapshot-changes-in-practice.md
  concepts/xs-heap-snapshot-agent-persistence.md -> ../sections/web--haruni-kaozkit-xs-agents--why-xs-not-javascriptcore.md
  concepts/xs-heap-snapshot-agent-persistence.md -> ../sections/web--moddable-kaozkit--agents-on-ice.md
```

For each: write the missing target file (commonly an omitted `kind: index`
parent section), or correct/remove the navigation row that points at it. Before
committing a repoint, re-verify the new target exists at the current tip with
`scripts/jobs/library-link-scan.sh --exists <library-relative-path>`. Land edits
through `scripts/jobs/land-journal-edit.sh` (never the live worktree), then
re-run `scripts/jobs/library-link-scan.sh` until it is clean. Normal priority:
broken navigation, caught downstream — not an urgent gate.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-25T05:29:13Z
