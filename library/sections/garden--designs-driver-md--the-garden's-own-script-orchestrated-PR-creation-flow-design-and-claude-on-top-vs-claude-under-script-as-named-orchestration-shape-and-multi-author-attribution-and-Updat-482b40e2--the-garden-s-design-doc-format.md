---
title: §The garden's design-doc format distinct from endo-but-for-bots
source-slug: garden--designs-driver-md
section-slug: the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-section-at-top
source-url: https://github.com/kriskowal/garden/blob/main/designs/driver.md
source-repo: kriskowal/garden
source-path: designs/driver.md
source-author: gardener + fixer + designer
total-lines: 691
ingest-cycle: 281
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
parent: garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-section-at-top
---

The garden's metadata table differs from the endo-but-for-bots template (cycle 265's CLAUDE.md spec):

```
| Created | 2026-05-29 |
| Updated | 2026-06-04 |
| Author  | gardener, fixer, designer |
| Status  | Proposed   |
```

§Compared to endo-but-for-bots's:
```
| **Created** | YYYY-MM-DD |
| **Updated** | YYYY-MM-DD |
| **Author** | Name (prompted) |
| **Status** | Not Started |
```

§Three-named-differences-in-the-garden's-design-doc-format:
1. **Field names are NOT bold** — `| Created |` not `| **Created** |`.
2. **No `(prompted)` suffix on the Author** — the garden uses agent-role-names directly (gardener + fixer + designer).
3. **Multi-author named with comma-separated list** — three named roles as authors of a single document.

§First-explicit-observation in library: **§the-garden's-design-doc-format-IS-distinct-from-the-endo-but-for-bots-design-doc-format + §two-design-doc-format-conventions-now-observed (endo-but-for-bots + garden) + §the-cluster's-formats-IS-not-universal**.

§First-explicit-observation in library: **§multi-author-attribution-by-role-name-as-named-discipline — §the-garden-treats-roles-as-authors-not-just-as-agent-context-fragments + §three-named-roles (gardener + fixer + designer) authored this design + §the-attribution-IS-collective-not-individual**.

§Sibling-pattern to many open-source projects where commits are co-authored — but here the attribution IS at the design-doc level not the commit level; §the-roles-are-the-authors-the-PR-mechanism-IS-the-attribution-vehicle.
