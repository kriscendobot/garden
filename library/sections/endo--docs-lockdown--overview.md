---
title: Lockdown (overview)
source: docs/lockdown.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-13
ingested_by: scholar
topics: [hardened-javascript]
status: current
kind: index
section_count: 2
---

> Abstract: The lockdown() API and its option taxonomy: 14 safety-vs-compatibility options whose defaults are 'safe' plus environment-variable fallthroughs (LOCKDOWN_*). Tables map each option to its settings, env var, and details link. The tradeoff framing: safety vs compatibility, though a tremendous amount of legacy code runs compatibly under SES even with all options at 'safe'. mathTaming and dateTaming are deprecated; Math.random and Date.now are disabled in compartments and must be injected as endowments.

Sections:

- [Lockdown](endo--docs-lockdown--overview--lockdown.md)
- [`lockdown` Options](endo--docs-lockdown--overview--lockdown-options.md)

Source: [docs/lockdown.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/lockdown.md) at commit `fe81477b`.
