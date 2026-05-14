---
title: Document structure (7-section template + prompt-capture)
source: designs/CLAUDE.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 60a63bc404ce8b28c11021d622c0c65ef1f73e00
source_date: 2026-03-13
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [agent-conventions]
status: current
notes: The 7 sections are a template, not a contract — simpler designs may omit phases, dependencies, or gaps. The Status section uses `## Status` (prose) — distinct from the Status field in the metadata table. The Prompt section at end captures the directive that generated the design.
---

> Abstract: After the metadata table, design docs follow a 7-section template. **(1) Status** (optional prose section for partially/fully implemented designs — file paths, deviations); **(2) Problem statement** (`## What is the Problem Being Solved?` or `## Motivation`); **(3) Design** (main body); **(4) Dependencies** (table of related designs); **(5) Phased implementation** (numbered phases when work is incremental); **(6) Design Decisions** (numbered rationale list); **(7) Known Gaps and TODOs** (`- [ ]` checklist, used sparingly). Simpler designs may omit sections. Each design also captures its originating **Prompt** at the end as a blockquote under `## Prompt`.

## Document Structure

After the metadata table, documents follow this general structure:

1. **Status section** (optional) — a prose `## Status` section appears after the metadata table in documents that have been partially or fully implemented. It lists what has been built, file paths, and any deviations from the original design.

2. **Problem statement** — typically `## What is the Problem Being Solved?` or `## Motivation`. Explains why the work is needed.

3. **Design** — the main body. Uses subsections, tables, and code blocks as needed. Code examples use the project's Hardened JavaScript conventions (see the root `CLAUDE.md`).

4. **Dependencies** — table of related designs and their relationship.

5. **Phased implementation** — numbered phases when the work can be delivered incrementally.

6. **Design Decisions** — numbered list of key choices and their rationale.

7. **Known Gaps and TODOs** — checklist items (`- [ ]`) for remaining work. Used sparingly; most documents do not have open checklists.

Not every document uses all sections. Simpler designs may omit phases, dependencies, or gaps.

### Capturing the prompt

Each design document should include the prompt that was used to generate it, typically as a blockquote or fenced block at the end of the document under a `## Prompt` heading. This preserves the intent and context behind the design for future readers.

Source: [designs/CLAUDE.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/CLAUDE.md) at commit `60a63bc4` on branch `llm`.
