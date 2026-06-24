---
title: §Metadata-table format — three required + two optional fields
source-slug: endo-but-for-bots--llm-designs-CLAUDE-md
section-slug: the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/CLAUDE.md
source-repo: endojs/endo-but-for-bots
source-path: designs/CLAUDE.md
source-author: Endo project (collective)
total-lines: 115
ingest-cycle: 265
ingest-date: 2026-06-10
lane: designs
parent: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking
---

Lines 5-24 specify the canonical metadata-table:

```markdown
# Title

| | |
|---|---|
| **Created** | YYYY-MM-DD |
| **Updated** | YYYY-MM-DD |
| **Author** | Name (prompted) |
| **Status** | Not Started |
```

§Three-required-fields: **Created** + **Author** + **Status**.
§One-conditional-required-field: **Updated** (required when document has been revised).
§Two-optional-fields-with-named-provenance-relationships:
- **Source** — `Extracted from packages/chat/DESIGN.md` (provenance relationship).
- **Supersedes** — `designs/chat-reply-chain-visualization.md` (replacement relationship).

§First-explicit-observation in library: **§the-metadata-table-encodes-three-named-relationship-types — `Source` (extraction) + `Supersedes` (replacement) + `Updated` (revision); §each-relationship-type-IS-a-named-link-in-the-design-doc-graph; §the-graph-IS-readable-without-running-the-tooling**.
