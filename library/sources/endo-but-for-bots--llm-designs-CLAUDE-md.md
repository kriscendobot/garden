---
title: "endo-but-for-bots/designs/CLAUDE.md — the canonical design-doc-template spec"
source-slug: endo-but-for-bots--llm-designs-CLAUDE-md
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/CLAUDE.md
authors: [Endo project (collective)]
repo: endojs/endo-but-for-bots
path: designs/CLAUDE.md
total-lines: 115
ingest-cycle: 265
ingest-date: 2026-06-10
lane: designs
---

# `endo-but-for-bots/designs/CLAUDE.md`

A 115-line **META-document** that prescribes the template every design doc in `endo-but-for-bots/designs/` follows. This closes the loop with cycle 263's observation that `outliner-design-doc-2.md` is the only design without the canonical metadata table.

## Key moves

- **§The meta-document that prescribes the template is itself a template-instance of a different kind** — the CLAUDE.md isn't a design doc (no metadata table); it IS the template specification.
- **§The nested CLAUDE.md is a named subset of the policy graph** — root `CLAUDE.md` carries repo-wide Hardened JS conventions; `designs/CLAUDE.md` carries design-doc conventions; the relationship is cross-referenced explicitly.
- **§Three required + two optional metadata fields** — Created + Author + Status (required); Source + Supersedes (optional, named provenance + replacement).
- **§The `(prompted)` suffix** — named attribution discipline for human-LLM collaboration; sibling-pattern to academic `(transl.)`/`(ed.)` conventions.
- **§Eight named Status values** with explicit synonym acknowledgment (Implemented = Complete); §the-template-acknowledges-its-own-historical-drift.
- **§Bolding convention for the success state** — `**Complete**` for visual emphasis; author choice, not template mandate.
- **§Seven named document sections** with explicit flexibility allowance.
- **§The `## Prompt` section at the end** — LLM-collaboration-record discipline.
- **§Modification-synchronization discipline** — bold-faced: any modification to a design doc must be synchronized with `designs/README.md`.
- **§Five named cross-document updates** for new-design incorporation (summary table + milestone assignment + dep graph + estimate + critical-path timeline).
- **§Five named README artifacts** for cross-document progress tracking (summary table + Mermaid dep graph + milestone tables + size/time estimates + Gantt timeline).
- **§Empirical estimate discipline** — "calibrated against observed velocity".
- **§Critical-path awareness named explicitly**.
- **§The metalanguage-vs-object-language distinction** — the CLAUDE.md is metalanguage; the design docs are object-language.

## Closing the cycle 263 loop

Cycle 263 ingested `outliner-design-doc-2.md` as the only design that deviates from the canonical template. Cycle 265 ingests the template spec itself. The two perspectives stand side by side: **§two-named-forms-of-template-deviation** — §the-in-flight-deviation (cycle 263) + §the-metalanguage-deviation (cycle 265).

## Section files

- [§The canonical design-doc-template spec + three required and two optional metadata fields + eight Status values + seven document sections + two-level progress tracking](../sections/endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking.md) — full 115-line spec.

## Ingest scope

Cycle 265 (designs-lane after cycle 264's chat-lane copyRecord.js). Full 115-line meta-document ingested. **First-explicit-observations (eleven)**: the-meta-document-that-prescribes-the-template-is-itself-a-template-instance-of-a-different-kind + the-nested-CLAUDE.md-IS-a-named-subset-of-the-policy-graph + the-metadata-table-encodes-three-named-relationship-types + the-`(prompted)`-suffix-as-named-attribution-discipline + the-template-acknowledges-its-own-historical-drift + the-bolding-convention-as-author-choice + the-Status-values-are-eight-named-states-without-state-machine-transitions + the-template-allows-section-omission-as-author-choice + the-template-allows-section-title-variation + the-`## Prompt`-section-IS-the-LLM-collaboration-record + the-template-specification-is-not-itself-an-instance-of-the-template-it-specifies.
