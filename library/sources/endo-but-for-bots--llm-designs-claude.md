---
source: designs/CLAUDE.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 60a63bc404ce8b28c11021d622c0c65ef1f73e00
source_date: 2026-03-13
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 4
status: current
notes: First section files in the library with source_repo: endojs/endo-but-for-bots and source_branch: llm. The branch field is new — endo-but-for-bots' design corpus lives on the non-default llm branch. Convention update for the future ingest of this corpus: idempotency checks must pass <branch> to git log -- <path> rather than defaulting to HEAD.
---

> Abstract: The agent-conventions file for the `designs/` directory of `endo-but-for-bots`' `llm` branch. Authoritative on metadata-table shape (Created / Updated / Author / Status, with optional Source / Supersedes), the 8-value status taxonomy (Not Started / Proposed / In Progress / **Complete** / Implemented / Active / Reference / Deprecated), the 7-section document structure (Status / Problem / Design / Dependencies / Phased implementation / Design Decisions / Known Gaps and TODOs), and the two-level progress tracking (per-document Status field + cross-document `designs/README.md` summary table with mermaid graph). Any design-doc modification must be synchronized with the README's summary table — this is the load-bearing operating rule for the directory.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [metadata-table](../sections/endo-but-for-bots--llm-designs-claude--metadata-table.md) | agent-conventions, repository-governance | current |
| [status-values](../sections/endo-but-for-bots--llm-designs-claude--status-values.md) | agent-conventions, repository-governance | current |
| [document-structure](../sections/endo-but-for-bots--llm-designs-claude--document-structure.md) | agent-conventions | current |
| [progress-tracking](../sections/endo-but-for-bots--llm-designs-claude--progress-tracking.md) | agent-conventions, repository-governance | current |

## Cross-references

- Analog of `endo--agents--*` and `agoric-sdk--agents--*` but for design-doc authorship specifically.
- The "author = Name (prompted)" convention names the human-directs-LLM authorship pattern as the default.

## Source

[designs/CLAUDE.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/CLAUDE.md) at commit `60a63bc4` on branch `llm`.
