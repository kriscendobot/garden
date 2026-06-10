---
title: "endo-but-for-bots/designs/CLAUDE.md — the canonical design-doc-template spec + three required and two optional metadata fields + eight Status values + seven document sections + two-level progress tracking"
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
---

# `endo-but-for-bots/designs/CLAUDE.md` — the canonical design-doc-template spec

A 115-line **META-document** that prescribes the template every design doc in `endo-but-for-bots/designs/` follows. The library has now ingested **twelve design docs** from this directory (216 endoclaw + 222 skill-registry + 226 cluster + 232 channel-bridges + 234 OAuth + 244 timer + 246 familiar-app-ui-hosting + 253 notifications + 255 voice + 257 proactive-messages + 259 browser + 261 network-fetch substrate + 263 outliner-design-doc-2 fragment); cycle 265 ingests the spec they all derive from.

This closes the loop with **cycle 263's observation** that `outliner-design-doc-2.md` is the only design without the canonical metadata table. From the spec's perspective, that fragment is in **policy non-compliance**; from the fragment's perspective, the template implies a stability the in-flight design didn't have. The two perspectives stand side by side.

§First-explicit-observation in library: **§the-meta-document-that-prescribes-the-template-is-itself-a-template-instance-of-a-different-kind — §the-CLAUDE.md-IS-not-itself-a-design-doc-but-IS-a-named-policy-specification-with-its-own-conventions (metadata-table-format + Status-vocabulary + document-structure-list + progress-tracking-discipline)**.

## §The two-level CLAUDE.md hierarchy

The `designs/CLAUDE.md` cross-references the project's root `CLAUDE.md` at line 66 (*"Code examples use the project's Hardened JavaScript conventions (see the root `CLAUDE.md`)"*).

§Two-level-CLAUDE.md-hierarchy-in-the-repo:
- **Root `CLAUDE.md`** — repo-wide Hardened JavaScript conventions (already in scope per cycle 263's read-through).
- **`designs/CLAUDE.md`** (cycle 265) — design-doc-template conventions specific to the designs directory.

§the-nested-CLAUDE.md-IS-a-named-subset-of-the-policy-graph; §each-level-encodes-the-conventions-specific-to-its-scope; §when-a-policy-applies-to-a-subdirectory-only, §nest-the-CLAUDE.md-at-that-subdirectory; §sibling-pattern to Claude Code's own CLAUDE.md hierarchy (root + subproject); §first-explicit-observation in library of §the-nested-CLAUDE.md-IS-a-named-subset-of-the-policy-graph.

## §Metadata-table format — three required + two optional fields

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

## §The "(prompted)" author convention

Lines 26-29 specify the author convention:

> The author field uses the format `Name (prompted)` to indicate the document was authored by a human directing an LLM.

§The-`(prompted)`-suffix-IS-a-named-attribution-discipline for documents authored by a human directing an LLM. §named-attribution-of-human-LLM-collaboration; §the-author-field-encodes-the-mode-of-authorship-not-just-the-identity; §the-suffix-IS-machine-readable + §the-suffix-IS-human-readable; §first-explicit-observation in library of §the-`(prompted)`-suffix-as-named-attribution-discipline-for-human-LLM-collaboration.

§Sibling-pattern to academic conventions (e.g., `(transl.)` for translator; `(ed.)` for editor); §the-collaboration-mode-IS-recorded-as-a-paren-suffix; §two-attribution-modes-named-in-the-template: plain author (human only) + `Name (prompted)` (human directing LLM).

## §Status values — eight named members with synonyms acknowledged

Lines 36-50 specify the Status taxonomy:

| Status        | Meaning                                              | Notes                                          |
|---------------|------------------------------------------------------|------------------------------------------------|
| Not Started   | Design written, no implementation work begun         | Default for new designs                        |
| Proposed      | Design under discussion, not yet accepted            | Pre-acceptance                                 |
| In Progress   | Implementation underway                              | Active build phase                             |
| **Complete**  | Fully implemented (bolded)                           | §bolding-convention-for-visual-emphasis        |
| Implemented   | Synonym for Complete                                 | §synonym-explicitly-acknowledged-not-hidden    |
| Active        | Living document, continuously maintained             | Not implementation-bound                       |
| Reference     | Informational; not an implementation target          | Read-only documentation                        |
| Deprecated    | Superseded by another design                         | Replaced via `Supersedes` link                 |

§Eight-named-Status-values + §the-synonym-is-explicitly-acknowledged-not-hidden — *"Implemented | Synonym for Complete (some docs use this)"*; §the-template-acknowledges-its-own-historical-drift; §first-explicit-observation in library of §the-template-acknowledges-its-own-historical-drift-via-named-synonym-rows.

§The-bolding-convention (`**Complete**`) — §named-emphasis-for-the-success-state; §when-a-state-IS-the-goal, §the-template-allows-bolding-for-visual-emphasis; §the-emphasis-IS-instance-level-not-template-level — *"sometimes bolded"* gives the document author the choice; §first-explicit-observation in library of §the-bolding-convention-for-the-success-state-as-author-choice-not-template-mandate.

§Eight-status-values-suggest-a-state-machine — but the spec doesn't draw transitions. §the-states-ARE-named + §the-transitions-ARE-implicit + §the-template-doesn't-force-a-state-machine-shape; §the-flexibility-IS-the-point; §first-explicit-observation in library of §the-Status-values-are-eight-named-states-without-an-explicit-state-machine-transition-graph.

## §Document structure — seven named sections with explicit flexibility allowance

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

## §Status-prose-section-is-optional-and-conditional

Lines 56-59 — §the-`## Status`-prose-section-IS-only-for-partially-or-fully-implemented-designs:

- §designs-still-Not-Started-don't-need-the-prose-section.
- §designs-In-Progress-or-Complete-may-include-it.
- §when-included, §the-section-lists-built-paths + §the-design-deviations.

§The-Status-prose-section-IS-conditional-on-the-Status-field — §the-metadata-Status-field-IS-the-primary-indicator-of-implementation-state + §the-prose-section-IS-the-implementation-detail-companion + §the-relationship-IS-encoded-in-the-template; §first-explicit-observation in library of §the-Status-prose-section-and-the-Status-metadata-field-encode-the-same-axis-at-two-levels-of-detail.

## §"Capturing the prompt" — the LLM-collaboration-record discipline

Lines 81-86:
> Each design document should include the prompt that was used to generate it, typically as a blockquote or fenced block at the end of the document under a `## Prompt` heading. This preserves the intent and context behind the design for future readers.

§The-`## Prompt`-section-at-the-end IS the §LLM-collaboration-record — §the-prompt-IS-preserved-as-evidence-of-how-the-design-came-to-be; §two-presentation-styles-named (blockquote OR fenced block); §the-section-IS-at-the-end-not-the-beginning (the design comes first; the prompt is the appendix).

§First-explicit-observation in library: **§the-`## Prompt`-section-at-the-end-IS-the-LLM-collaboration-record — §when-a-design-was-authored-by-a-human-directing-an-LLM, §the-prompt-itself-is-preserved-in-the-design-doc-as-evidence-of-intent**.

§Sibling-pattern to academic conventions for "Methods" sections — §the-prompt-IS-the-method; §the-design-IS-the-result; §the-template-encodes-the-research-methodology + §the-LLM-collaboration-record-IS-the-methods-section-of-the-design-doc.

§the-author-convention-`(prompted)` + §the-`## Prompt`-section-at-end + §the-`Source`-metadata-field — §three-named-fields-encoding-the-design's-provenance; §three-cycles-with-named-provenance-discipline (would need cross-check; this is the first explicit observation of all three at once).

## §Progress Tracking — two-level discipline

Lines 88-114 specify a two-level progress-tracking discipline:

### Per-document level
- **Status** field is the primary indicator.
- **`## Status` prose section** is the detail companion.

### Cross-document level (lines 100-114)
- `designs/README.md` maintains a **summary table** of all designs with Created, Updated, Status columns.
- The README also contains:
  - **Mermaid dependency graph** — visual dep relationships.
  - **Milestone tables** with exit criteria.
  - **Size/time estimates** calibrated against observed velocity.
  - **Gantt timeline** — visual schedule.

§First-explicit-observation in library: **§the-cross-document-progress-tracking-IS-five-named-artifacts-in-one-README — §summary-table + §Mermaid-dependency-graph + §milestone-tables-with-exit-criteria + §size-and-time-estimates-calibrated-against-observed-velocity + §Gantt-timeline**.

§"calibrated against observed velocity" (line 103-104) — §empirical-estimate-discipline; §the-estimates-ARE-not-naive + §the-template-mandates-calibration; §sibling-pattern to evidence-based-planning conventions; §first-explicit-observation in library of §empirical-estimate-discipline-named-explicitly-in-the-CLAUDE.md.

## §Modification-synchronization discipline — bold-faced policy

Lines 105-108:
> **Any modification to a design document — especially its metadata — must be synchronized with `designs/README.md`.**

§Named-synchronization-discipline — §when-a-design-doc-is-modified, §the-README-summary-must-be-updated; §the-discipline-IS-bolded-in-the-CLAUDE.md-to-emphasize-its-importance; §sibling-pattern to git's two-step commit-and-push discipline (the design-doc IS the commit; the README IS the index).

§First-explicit-observation in library: **§the-modification-synchronization-discipline-IS-bold-faced-in-the-CLAUDE.md — §when-the-template-bolds-a-rule, §the-rule-IS-the-most-important-discipline-in-the-policy**.

§The-rule-encodes-a-data-flow: design-doc → README. §the-data-flow-IS-one-way: §the-design-doc-IS-authoritative + §the-README-IS-derived; §the-README-IS-a-summary-projection-of-the-design-docs.

## §New-designs-incorporation — five-step process

Lines 109-114 specify the five-step incorporation process for new designs:

1. Add a row to the **summary table**.
2. Assign the design to a **milestone**.
3. Add it to the appropriate **milestone table**.
4. Insert it into the **dependency graph** if it has dependencies or dependents.
5. Add a **per-design size/duration estimate**.
6. Update **milestone totals and timeline** if the new work changes the critical path.

§Five-or-six-named-incorporation-steps (the spec lists six bullets compressed into one paragraph) — §each-step-is-a-named-cross-document-update; §the-incorporation-IS-not-just-creating-the-design-doc + §the-design-doc-must-be-woven-into-the-existing-graph; §first-explicit-observation in library of §design-incorporation-IS-five-named-cross-document-updates-not-just-a-file-creation.

§The-explicit-`update timeline if the new work changes the critical path` discipline — §critical-path-awareness-named-explicitly-in-the-CLAUDE.md; §when-a-new-design-changes-the-critical-path, §the-timeline-must-be-updated; §sibling-pattern to project-management's critical-path-method discipline; §first-explicit-observation in library of §critical-path-awareness-named-explicitly-in-the-CLAUDE.md.

## §The directory-CLAUDE.md is itself a META-INSTANCE

The CLAUDE.md is NOT a design doc (it doesn't follow its own template — no metadata table, no Status, no Author, no `(prompted)`). It IS the **template specification**. §The-spec-IS-not-an-instance-of-itself — §the-template-template-is-different-from-the-template + §the-CLAUDE.md-IS-the-template + §the-design-docs-ARE-instances; §the-distinction-IS-load-bearing.

§First-explicit-observation in library: **§the-template-specification-is-not-itself-an-instance-of-the-template-it-specifies — §the-spec-stands-outside-the-rule-it-encodes**.

§Sibling-pattern to formal-language-theory's metalanguage-vs-object-language distinction; §the-CLAUDE.md-IS-the-metalanguage-and-the-design-docs-ARE-the-object-language; §the-CLAUDE.md-doesn't-have-to-obey-its-own-rules-because-it-IS-the-rule-source; §first-explicit-observation in library of §the-metalanguage-vs-object-language-distinction-named-explicitly-in-a-policy-specification.

§The-flexibility-of-the-CLAUDE.md (no fields required of it; no Status; no Created date) — §the-spec-can-be-anything-the-policy-author-wants + §the-spec's-shape-IS-author-choice; §sibling-pattern to cycle 263's design-fragment freedom — §both-the-spec-and-the-design-fragment-stand-outside-the-template + §from-different-directions: §the-spec-stands-outside-because-it-IS-the-source + §the-design-fragment-stands-outside-because-the-design-is-not-yet-stable.

§Two-named-template-deviations across cycles 263 + 265:
- **Cycle 263** — design-fragment that deviates because the design is in flight (informal authorship style).
- **Cycle 265** — template-specification that deviates because it IS the source of the template (metalanguage status).

§the-template-deviation-takes-two-named-forms — §the-in-flight-deviation (cycle 263) + §the-metalanguage-deviation (cycle 265); §first-explicit-observation in library of §two-named-forms-of-template-deviation-in-the-design-doc-cluster.

## §Cycle 265 first-explicit-observations roundup (eleven)

1. **§the-meta-document-that-prescribes-the-template-is-itself-a-template-instance-of-a-different-kind**.
2. **§the-nested-CLAUDE.md-IS-a-named-subset-of-the-policy-graph**.
3. **§the-metadata-table-encodes-three-named-relationship-types** (Source + Supersedes + Updated).
4. **§the-`(prompted)`-suffix-as-named-attribution-discipline-for-human-LLM-collaboration**.
5. **§the-template-acknowledges-its-own-historical-drift-via-named-synonym-rows** (Implemented = Complete).
6. **§the-bolding-convention-for-the-success-state-as-author-choice-not-template-mandate**.
7. **§the-Status-values-are-eight-named-states-without-an-explicit-state-machine-transition-graph**.
8. **§the-template-allows-section-omission-as-author-choice** (sibling to cycle 263's Use-Cases-omission-as-substrate-signal).
9. **§the-template-allows-section-title-variation-with-two-named-alternatives-for-the-Problem-statement-section** (`## What is the Problem Being Solved?` OR `## Motivation`).
10. **§the-`## Prompt`-section-at-the-end-IS-the-LLM-collaboration-record**.
11. **§the-template-specification-is-not-itself-an-instance-of-the-template-it-specifies**.

Plus: §the-cross-document-progress-tracking-IS-five-named-artifacts-in-one-README + §empirical-estimate-discipline-named-explicitly-in-the-CLAUDE.md + §the-modification-synchronization-discipline-IS-bold-faced-in-the-CLAUDE.md + §design-incorporation-IS-five-named-cross-document-updates-not-just-a-file-creation + §critical-path-awareness-named-explicitly-in-the-CLAUDE.md + §the-metalanguage-vs-object-language-distinction-named-explicitly-in-a-policy-specification + §two-named-forms-of-template-deviation-in-the-design-doc-cluster (cycles 263 + 265).

## §Recurring meta-pattern counters bumped at cycle 265

- §**two-cycles-with-section-omission-as-design-kind-signal** (257 no-Capability-Shape + 261 no-Use-Cases) **becomes three** with cycle 265's explicit-template-permission-for-section-omission as the policy-level companion.
- §**two-cycles-from-different-angles-meeting-the-same-pattern** (261 substrate-Use-Cases-omission + 265 explicit-template-permission-for-section-omission).
- §**two-cycles-with-template-deviation-from-different-directions** (263 in-flight + 265 metalanguage).
- §**thirteen-design-docs-from-endo-but-for-bots-designs-cluster** ingested counting cycle 265 itself.
- §**ninety-eighth consecutive designs-chat alternation cycles 166-250 + 252-265** (251 was out-of-band).

## §Synthesis target — slot machine library

§The-spec-instantiates-for-game-engine-as-a-named-CLAUDE.md-at-the-game-rule-directory:

- §**§game-rule-doc-template** with three required fields (Created + Author + Status) + two optional (Source + Supersedes).
- §**§the-`(prompted)`-suffix** for human-LLM-collaboration-authored game rules.
- §**§eight-named-Status-values** for game rules (Not Started + Proposed + In Progress + Complete + Implemented + Active + Reference + Deprecated).
- §**§seven-named-document-sections** with explicit omission allowance.
- §**§the-`## Prompt`-section-at-the-end** as the LLM-collaboration-record for game-rule-authorship.
- §**§the-modification-synchronization-discipline** — when a game rule doc is modified, §the-game-rule-README must be updated.
- §**§five-named-incorporation-steps** for new game rules.
- §**§the-game-rule-CLAUDE.md-IS-not-itself-an-instance** — §the-metalanguage-vs-object-language-distinction.

## §Tier-1 borrowing

§the-meta-document-that-prescribes-the-template-is-itself-a-template-instance-of-a-different-kind + §the-nested-CLAUDE.md-IS-a-named-subset-of-the-policy-graph + §the-metadata-table-encodes-three-named-relationship-types + §the-`(prompted)`-suffix-as-named-attribution-discipline + §the-template-acknowledges-its-own-historical-drift-via-named-synonym-rows + §the-template-allows-section-omission-as-author-choice + §the-template-allows-section-title-variation + §the-`## Prompt`-section-at-the-end-IS-the-LLM-collaboration-record + §the-template-specification-is-not-itself-an-instance-of-the-template-it-specifies + §the-modification-synchronization-discipline-IS-bold-faced-in-the-CLAUDE.md.

## §Tier-2 borrowing

§eight-named-Status-values + §the-bolding-convention-for-the-success-state-as-author-choice + §seven-named-document-sections + §the-cross-document-progress-tracking-IS-five-named-artifacts-in-one-README + §empirical-estimate-discipline-named-explicitly + §critical-path-awareness-named-explicitly + §design-incorporation-IS-five-named-cross-document-updates.

## §Tier-3 borrowing

§two-cycles-from-different-angles-meeting-the-same-pattern (261 + 265) + §two-cycles-with-template-deviation-from-different-directions (263 + 265) + §library-reaches-771-sections at cycle 265 + §ninety-eighth consecutive designs-chat alternation cycles 166-250 + 252-265.

## Pattern summary (tag-prefixed)

§the-canonical-design-doc-template-spec + §the-meta-document-that-prescribes-the-template-is-itself-a-template-instance-of-a-different-kind + §the-nested-CLAUDE.md-IS-a-named-subset-of-the-policy-graph + §three-required-and-two-optional-metadata-fields + §the-metadata-table-encodes-three-named-relationship-types (Source + Supersedes + Updated) + §the-`(prompted)`-suffix-as-named-attribution-discipline-for-human-LLM-collaboration + §eight-named-Status-values + §the-template-acknowledges-its-own-historical-drift-via-named-synonym-rows + §the-bolding-convention-for-the-success-state-as-author-choice-not-template-mandate + §the-Status-values-are-eight-named-states-without-an-explicit-state-machine-transition-graph + §seven-named-document-sections + §the-template-allows-section-omission-as-author-choice + §the-template-allows-section-title-variation-with-two-named-alternatives + §the-`## Prompt`-section-at-the-end-IS-the-LLM-collaboration-record + §the-cross-document-progress-tracking-IS-five-named-artifacts-in-one-README + §empirical-estimate-discipline-named-explicitly + §the-modification-synchronization-discipline-IS-bold-faced + §design-incorporation-IS-five-named-cross-document-updates + §critical-path-awareness-named-explicitly + §the-template-specification-is-not-itself-an-instance-of-the-template-it-specifies + §the-metalanguage-vs-object-language-distinction-named-explicitly + §two-named-forms-of-template-deviation-in-the-design-doc-cluster.
