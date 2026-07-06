---
source: README.md
source_repo: gutentags/kamera
source_commit: 09b81cc16b40ce22f09337f5bba6a66fbd1bdc8c
source_date: 2015-09-07
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
section_count: 2
status: current
---

The README of Kamera (`gutentags/kamera`), the single-focus enforcer for Guten Tag applications. The kamera is a singleton — injected at the root scope so every child component and widget shares one — that guarantees at most one component holds focus at a time: when a widget takes focus it blurs whatever held it before. This is the focus-management peer of the other dependency-injected coordinators a Guten Tag scope shares (the [[animation-coordination|Blick]] animator, the [[module-loader|System]] loader). The document covers the singleton's purpose and root-scope injection, and the `attention.takeFocus(this)` / `blur()` widget contract.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/kamera--readme--overview.md) | focus-management, html-modules | current |
| [focus-api](../sections/kamera--readme--focus-api.md) | focus-management, html-modules | current |
