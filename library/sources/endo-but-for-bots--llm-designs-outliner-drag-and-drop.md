---
title: "outliner_drag_and_drop.md — third outliner cluster design (first §two-part-guide-structure)"
source-slug: endo-but-for-bots--llm-designs-outliner-drag-and-drop
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/outliner_drag_and_drop.md
authors: [Endo project (with attribution to Muddle project and Roam Research)]
repo: endojs/endo-but-for-bots
path: designs/outliner_drag_and_drop.md
total-lines: 1020
ingest-cycle: 277
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
---

# `outliner_drag_and_drop.md`

A 1020-line **standalone guide** — the **third outliner cluster design** ingested (after cycle 263's outliner-design-doc-2 and cycle 273's OUTLINER_INTERACTION_PATTERNS). Same Muddle + Roam Research attribution, same three-layer architecture, same "the most important architectural decision" phrase as cycle 273.

## Key moves

- **§The Part-1-and-Part-2 discipline as named document structure for large guides** — Part 1: Block Selection (9 items) + Part 2: Drag and Drop (14 items); 23-numbered ToC items span both Parts with monotonic numbering.
- **§The cluster now has four named naming conventions** — lowercase-with-hyphens + `-design-doc-2`-suffix + ALL_CAPS_UNDERSCORES + lowercase_underscores.
- **§Two cycles with the subtractive-guide deviation shape** (273 + 277) — the recurring deviation now confirmed not singleton.
- **§The comparison-points narrow with context** — cycle 273 had Roam + Obsidian + Workflowy; cycle 277 has Roam alone (topic-specific).
- **§The exact phrase "the most important architectural decision" recurs across two outliner cluster guides** (273 + 277).
- **§Three cycles with the explicit named central decision** (269 + 273 + 277).
- **§The exact three-layer ASCII-art diagram recurs** across two outliner cluster guides (273 + 277).
- **§Three cycles with three-layer architectures as named design rationale** (271 + 273 + 277).
- **§The coexistence challenge as named design driver** — text selection vs block selection; *"the challenge is making these two coexist without fighting each other"*.
- **§The named tiebreaker discipline with named rationale** — *"into is the hardest zone to hit, so it deserves the tiebreaker"*; difficulty-of-target-determines-tiebreaker-winner.
- **§The Edge Cases section as named cumulative discovery record** — seven named edge cases including `(CRDT-specific)` and Mobile.
- **§Three named rationale sections in design documents** — Design-Decisions (prospective) + Lessons-Learned (retrospective) + Edge-Cases (discovered-during-impl).
- **§Inline testing examples in prose design doc** — actual `it(...)` test cases embedded; sibling-pattern to literate-programming.
- **§Alt-drag as named reference creation modifier** — *"All three placements share the same content"*.

## Section files

- [§Two-part guide structure + §23 numbered ToC items + §three cycles with three-layer architectures + §named tiebreaker discipline + §the coexistence challenge](../sections/endo-but-for-bots--llm-designs-outliner-drag-and-drop--two-part-guide-structure-and-twenty-three-numbered-toc-items-and-three-cycles-with-three-layer-architectures-and-named-tiebreaker-discipline-and-the-coexistence-challenge.md) — structural pattern observations (1020-line file ingested in pattern-scope).

## Ingest scope

Cycle 277 (designs-lane after cycle 276's chat-lane source-map-node-pair). 1020-line file ingested in pattern-scope. **First-explicit-observations (twelve plus secondary)**: the-Part-1-and-Part-2-discipline-as-named-document-structure-for-large-guides + the-cluster-now-has-four-named-naming-conventions + two-cycles-with-the-subtractive-guide-deviation-shape + the-comparison-points-narrow-with-context + the-exact-phrase-"the-most-important-architectural-decision"-recurs + three-cycles-with-the-explicit-named-central-decision + the-exact-three-layer-ASCII-art-diagram-recurs + three-cycles-with-three-layer-architectures-as-named-design-rationale + the-coexistence-challenge-as-named-design-driver + the-numbered-ToC-spans-both-Parts-with-monotonic-numbering + the-named-tiebreaker-discipline-with-named-rationale + the-Edge-Cases-section-as-named-cumulative-discovery-record + three-named-rationale-sections-in-design-documents. Plus: inline-testing-examples-in-prose-design-doc + Alt-drag-as-named-reference-creation-modifier + the-`(CRDT-specific)`-parenthetical-tag.
