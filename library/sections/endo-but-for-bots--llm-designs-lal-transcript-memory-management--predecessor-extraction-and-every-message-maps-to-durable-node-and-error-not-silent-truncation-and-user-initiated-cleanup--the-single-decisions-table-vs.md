---
title: The §single-Decisions-table (vs cycle 214's two-table shape)
source-slug: endo-but-for-bots--llm-designs-lal-transcript-memory-management
section-id: predecessor-extraction-and-every-message-maps-to-durable-node-and-error-not-silent-truncation-and-user-initiated-cleanup
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/lal-transcript-memory-management.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/lal-transcript-memory-management.md
status: Not Started
ingest-cycle: 216
ingest-date: 2026-06-07
lane: designs
parent: endo-but-for-bots--llm-designs-lal-transcript-memory-management--predecessor-extraction-and-every-message-maps-to-durable-node-and-error-not-silent-truncation-and-user-initiated-cleanup
---

| Aspect | Decision |
|--------|----------|
| Node lifetime | Persists for the lifetime of the agent |
| Relationship to inbox | Independent; nodes outlive dismissed messages |
| Missing node handling | Error, not silent truncation |
| Storage cleanup | User-initiated (discard agent or export) |

§Four-row-Decisions-table — §single-list-shape (vs cycle 214's §Decisions-Made-vs-Tentative-Decisions two-table-shape). §Different-decision-categories-warrant-different-shapes: cycle 214's design was Complete-with-Phases-shipped (some decisions firmed up by implementation; others still tentative); this design is Not-Started (no decisions are yet field-tested), so the §single-table-of-named-decisions makes sense. §Borrowable-pattern: §shape-of-the-Decisions-section-tracks-the-Status-section.
