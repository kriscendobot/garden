---
title: §Document structure — seven named sections with explicit flexibility allowance
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

Lines 52-79 specify the document structure as a seven-section template:

1. **Status section** (optional) — prose `## Status` with file paths and deviations.
2. **Problem statement** — `## What is the Problem Being Solved?` or `## Motivation`.
3. **Design** — the main body with subsections, tables, code blocks.
4. **Dependencies** — table of related designs.
5. **Phased implementation** — numbered phases when incremental.
6. **Design Decisions** — numbered list of key choices and rationale.
7. **Known Gaps and TODOs** — checklist items (`- [ ]`) for remaining work.

§The-explicit-flexibility-allowance (line 78-79): *"Not every document uses all sections. Simpler designs may omit phases, dependencies, or gaps."*

§First-explicit-observation in library: **§the-template-allows-section-omission-as-author-choice — §when-a-simpler-design-doesn't-need-phases-or-dependencies, §the-template-explicitly-permits-omission + §the-template-doesn't-mandate-stubbed-empty-sections**.

§Sibling-pattern to cycle 263's §the-Use-Cases-omission-as-substrate-signal — cycle 261's network-fetch substrate omitted the Use-Cases section, and that omission was the signal of substrate-status. The template here at the CLAUDE.md level **authorizes** the omission discipline by stating it as policy. §two-cycles-from-different-angles-meeting-the-same-pattern (261 substrate-Use-Cases-omission + 265 explicit-template-permission-for-section-omission).

§Two-named-section-titles-for-the-Problem-statement (`## What is the Problem Being Solved?` OR `## Motivation`) — §the-template-allows-section-title-variation; §two-cycles-with-named-section-title-alternatives (218 + 265 — actually this is the first explicit observation); §first-explicit-observation in library of §the-template-allows-section-title-variation-with-two-named-alternatives-for-the-Problem-statement-section.
