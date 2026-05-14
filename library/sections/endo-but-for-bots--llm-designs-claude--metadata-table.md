---
title: Metadata table (Created / Updated / Author / Status + optional Source / Supersedes)
source: designs/CLAUDE.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 60a63bc404ce8b28c11021d622c0c65ef1f73e00
source_date: 2026-03-13
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [agent-conventions, repository-governance]
status: current
---

> Abstract: Every design doc opens with a level-1 heading (the title) followed by a 2-column metadata table. **Required fields**: Created, Author, Status. **Optional**: Updated (added when revised), Source (provenance if extracted), Supersedes (path to superseded design). **Author format**: `Name (prompted)` to indicate human-directs-LLM authorship. **Date format**: ISO 8601 (`YYYY-MM-DD`); update Updated whenever the doc is materially revised.

## Metadata Table

Every design document begins with a level-1 heading (the title), followed immediately by a metadata table using this format:

```markdown
# Title

| | |
|---|---|
| **Created** | YYYY-MM-DD |
| **Updated** | YYYY-MM-DD |
| **Author** | Name (prompted) |
| **Status** | Not Started |
```

Required fields: **Created**, **Author**, **Status**.
**Updated** is included when the document has been revised after creation.

Optional fields (used when applicable):
- **Source** — provenance if extracted from another document (e.g., `Extracted from packages/chat/DESIGN.md`).
- **Supersedes** — path to the design this one replaces (e.g., `designs/chat-reply-chain-visualization.md`).

### Author convention

The author field uses the format `Name (prompted)` to indicate the document was authored by a human directing an LLM.

### Date format

All dates use ISO 8601 (`YYYY-MM-DD`). Update the **Updated** field whenever the document is materially revised.

Source: [designs/CLAUDE.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/CLAUDE.md) at commit `60a63bc4` on branch `llm`.
