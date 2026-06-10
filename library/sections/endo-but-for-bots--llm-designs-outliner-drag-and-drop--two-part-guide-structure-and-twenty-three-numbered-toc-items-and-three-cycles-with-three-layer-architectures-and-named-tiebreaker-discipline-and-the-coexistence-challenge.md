---
title: "outliner_drag_and_drop.md — two-part guide structure (Block Selection + Drag and Drop) + 23 numbered ToC items + three cycles with three-layer architectures + named tiebreaker discipline + the-coexistence-challenge between text selection and block selection + four named naming conventions in the outliner cluster"
source-slug: endo-but-for-bots--llm-designs-outliner-drag-and-drop
section-slug: two-part-guide-structure-and-twenty-three-numbered-toc-items-and-three-cycles-with-three-layer-architectures-and-named-tiebreaker-discipline-and-the-coexistence-challenge
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/outliner_drag_and_drop.md
source-repo: endojs/endo-but-for-bots
source-path: designs/outliner_drag_and_drop.md
source-author: Endo project (with attribution to Muddle project and Roam Research)
total-lines: 1020
ingest-cycle: 277
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
---

# `outliner_drag_and_drop.md` — the third outliner cluster design + first §two-part-guide-structure

A 1020-line **standalone guide** (named genre at line 3). **The third outliner cluster design ingested** (after cycle 263's outliner-design-doc-2 and cycle 273's OUTLINER_INTERACTION_PATTERNS). Same Muddle + Roam Research attribution as cycle 273; same three-layer architecture; SAME phrase "the most important architectural decision" as cycle 273.

§First-explicit-observation in library: **§the-Part-1-and-Part-2-discipline-as-named-document-structure-for-large-guides — §the-document-splits-into-two-named-Parts (Part 1: Block Selection + Part 2: Drag and Drop) + §the-numbered-ToC-items-span-both-Parts (9 in Part 1 + 14 in Part 2 = 23 total) + §the-discipline-IS-rare-in-the-cluster-because-most-designs-are-single-topic**.

## §The four-named-naming-conventions in the outliner cluster

Cycle 277 confirms a **fourth** naming convention in the outliner cluster:

1. **lowercase-with-hyphens** — canonical design-doc convention (e.g., `endoclaw-browser.md`).
2. **`-design-doc-2`-suffix** — follow-up naming (cycle 263 `outliner-design-doc-2.md`).
3. **ALL_CAPS_UNDERSCORES** — cycle 273 `OUTLINER_INTERACTION_PATTERNS.md`.
4. **lowercase_underscores** — cycle 277 `outliner_drag_and_drop.md`.

§First-explicit-observation in library: **§the-cluster-now-has-four-named-naming-conventions — §the-outliner-cluster-instantiates-three-of-the-four (lowercase-with-hyphens for the first design + `-design-doc-2`-suffix + ALL_CAPS + lowercase_underscores)**.

§the-naming-convention-IS-genre-evidence (cycle 273's observation extended): §the-design-doc-cluster has hyphens; §guides-and-extended-references have either ALL_CAPS or lowercase_underscores; §the-cluster's-discipline-IS-loose-not-strict.

## §Three-cycles-with-template-deviation-in-the-outliner-cluster

Cycle 277 IS the **third** outliner design in the cluster — all three deviate from the canonical template, but in different ways:

| Cycle | File                              | Deviation shape       | Reason                  |
|-------|-----------------------------------|------------------------|-------------------------|
| 263   | `outliner-design-doc-2.md`        | subtractive-fragment   | in-flight thinking      |
| 273   | `OUTLINER_INTERACTION_PATTERNS.md`| subtractive-guide      | comprehensive guide     |
| 277   | `outliner_drag_and_drop.md`       | subtractive-guide      | standalone guide        |

§First-explicit-observation in library: **§two-cycles-with-the-subtractive-guide-deviation-shape (273 + 277) — §the-subtractive-guide-shape-IS-now-confirmed-as-a-recurring-deviation-not-a-singleton**.

§The-cluster-now-has-§four-cycles-with-template-deviation (263 + 273 + 275 + 277 — counting cycle 275's daemon-weblet-application's additive-extension); §the-deviation-shapes-are-now-four (subtractive-fragment + subtractive-guide × 2 + additive-extension).

§three-named-template-deviation-shapes-confirmed-once-each-plus-the-subtractive-guide-twice; §sibling-pattern to engineering documents where deviation-shapes recur but each-instance-IS-its-own-reason.

## §The same Muddle + Roam Research attribution

Line 5:
> *Based on patterns developed in the [Muddle](https://github.com/nicedland/muddle) project and informed by the state of the art in tools like Roam Research.*

§Compare to cycle 273's line 3:
> *Based on patterns converged upon in the [Muddle](https://github.com/nicedland/muddle) project — a local-first collaborative knowledge graph.*

§Two-cycles-with-Muddle-attribution-in-the-outliner-cluster (273 + 277); §the-attribution-pattern-IS-now-canonical-across-the-cluster's-guides.

§Cycle 277's variant also names **Roam Research** as the named comparison-point (cycle 263's three-named-comparison-points observation): Roam Research alone, not the three Roam + Obsidian + Workflowy from cycle 273. §the-comparison-points-narrow-with-context — when the topic is drag-and-drop specifically, Roam Research IS the single named comparison; when the topic is general interaction patterns, three points are named.

§First-explicit-observation in library: **§the-comparison-points-narrow-with-context — §when-a-guide's-topic-IS-narrower, §fewer-named-comparison-points-are-cited + §the-cluster's-comparison-naming-IS-context-dependent**.

## §Same "the most important architectural decision" phrase

Line 916:
> *The most important architectural decision: **all selection and drag-drop logic is pure functions, independent of React, the DOM, and the data layer.***

§Compare to cycle 273's line 54:
> *The single most important architectural decision: **all interaction logic lives in pure functions that are independent of React, the DOM, and the data layer.***

§Three-cycles-with-the-explicit-named-central-decision (269 endor-tui + 273 OUTLINER_INTERACTION_PATTERNS + 277 outliner_drag_and_drop); §the-discipline-IS-now-canonical-across-three-cycles; §the-outliner-cluster-uses-the-SAME-phrase-twice + §the-three-cycles-share-the-pattern-but-not-the-exact-phrase.

§First-explicit-observation in library: **§the-exact-phrase-"the-most-important-architectural-decision"-recurs-across-two-outliner-cluster-guides (273 + 277) — §the-phrase-IS-the-canonical-form + §the-author-uses-it-verbatim-across-related-documents + §sibling-pattern to engineering authors who develop a stable rhetorical vocabulary**.

## §Same three-layer architecture diagram

Lines 919-936 carry the **same** three-layer ASCII-art architecture diagram as cycle 273:

- **Behavior Layer (pure functions)** — selection.ts + dragDrop.ts.
- **Component Layer (React)** — SelectionProvider + DragContext + BoundingBoxSelection + Block + BlockBullet.
- **Data Layer (Automerge CRDT)** — BlockHandle.addChild() + removeChild() + tree mutations + sync.

§Three-cycles-with-three-layer-architectures-as-named-design-rationale (271 endor-bus-tui + 273 OUTLINER_INTERACTION_PATTERNS + 277 outliner_drag_and_drop); §the-three-layer-shape-IS-now-canonical-across-three-cycles.

§the-cluster-has-two-named-diagram-conventions confirmed: Mermaid (cycle 267 README) + ASCII-art (cycles 273 + 277).

§First-explicit-observation in library: **§the-exact-three-layer-ASCII-art-diagram-recurs-across-two-outliner-cluster-guides — §the-discipline-IS-shared-substrate-across-two-guides-in-the-same-cluster + §the-author-doesn't-re-derive-the-architecture + §the-cluster-converges-on-one-named-architecture**.

## §The coexistence challenge — text selection vs block selection

Lines 42-44 carry the §named-coexistence-challenge:

> *An outliner needs two completely different selection systems: **text selection** within a single block (handled by the browser natively via `<textarea>`) and **block selection** across multiple blocks (handled by your code). The challenge is making these two coexist without fighting each other.*

§First-explicit-observation in library: **§the-coexistence-challenge-as-named-design-driver — §when-two-systems-must-coexist, §the-design's-first-job-IS-to-prevent-them-from-fighting + §the-challenge-IS-named-explicitly-in-the-opening-paragraph**.

§Two-named-selection-systems:
1. **Text selection** — browser-native; handled by `<textarea>`.
2. **Block selection** — application-code; spans multiple blocks.

§Sibling-pattern to capability-systems' multi-system-coexistence; §the-design-NAMES-the-systems + §the-design-NAMES-the-coexistence-challenge.

## §The 23-numbered ToC items split across two Parts

Lines 9-38 carry the §numbered-ToC across §two-named-Parts:

**Part 1: Block Selection** (9 numbered items):
1. Selection Model: Anchor, Focus, and Contiguous Ranges
2. Block Position Registry
3. Bullet Click: Single Block Selection
4. Shift+Click: Range Selection and Deselection
5. Shift+Arrow Keys: Keyboard Range Extension
6. Drag-to-Select: Bounding Box Selection
7. Selection Visual Feedback
8. Batch Operations on Selected Blocks
9. Selection Clearing

**Part 2: Drag and Drop** (14 numbered items):
10. Data Model
11. HTML Structure That Makes Drag Work
12. Drag Initiation
13. Drop Zone Calculation
14. Drop Visual Feedback
15. Executing the Drop
16. Modifier Keys: Move vs. Reference
17. Selection and Multi-Block Drag
18. Validation: Preventing Circular Drops
19. Same-Parent Index Adjustment
20. Auto-Expand Collapsed Blocks
21. Architecture: Separating Behavior from DOM
22. Edge Cases and Pitfalls
23. Browser Compatibility

§First-explicit-observation in library: **§the-numbered-ToC-spans-both-Parts-with-monotonic-numbering — §Part 1 items 1-9 + §Part 2 items 10-23; §the-numbering-IS-continuous-across-the-Parts + §the-discipline-IS-the-document-IS-one-document-not-two**.

§Sibling-pattern to textbook conventions where chapters number-across-parts; §the-Parts-are-an-organizing-axis-not-a-separation.

## §The "deliberate choice — into deserves the tiebreaker" pattern

Lines 980 (in Edge Cases):
> *At exactly 25% or 75%, the middle "into" zone wins (because the conditions are `< 0.25` and `> 0.75`). This is a deliberate choice — "into" is the hardest zone to hit, so it deserves the tiebreaker.*

§First-explicit-observation in library: **§the-named-tiebreaker-discipline-with-named-rationale — §when-two-zones-touch-at-a-boundary, §one-wins-by-deliberate-choice + §the-rationale-IS-"the-hardest-zone-deserves-the-tiebreaker" + §the-discipline-IS-difficulty-of-target-determines-tiebreaker-winner**.

§Sibling-pattern to many UI conventions where the harder-to-hit target gets the larger hit-zone (Fitts's Law applied to boundary-tiebreakers).

§The-`< 0.25`-and-`> 0.75`-conditions encode the tiebreaker structurally — §when-the-conditions-are-strict-inequalities, §the-equality-falls-through-to-the-middle-(into)-case + §the-code-encodes-the-design-choice-without-needing-an-explicit-else-branch.

## §The Edge Cases section as named cumulative discovery record

Lines 976-1007 carry §seven-named-edge-cases with named handling:

1. **Dropping at exact zone boundaries** — into wins as tiebreaker.
2. **Dragging a block with children** — moves atomically; no special handling.
3. **Reference to a reference** — valid and intentional; three placements share content.
4. **Empty blocks** — (not shown but listed in TOC).
5. **Root-level constraints** — (not shown but listed in TOC).
6. **Concurrent edits (CRDT-specific)** — (named with parenthetical CRDT-specific).
7. **Mobile** — (named platform-specific edge case).

§First-explicit-observation in library: **§the-Edge-Cases-section-as-named-cumulative-discovery-record + §three-named-rationale-sections-in-design-documents (Design-Decisions for prospective + Lessons-Learned for retrospective + Edge-Cases for discovered-during-impl)**.

§Cycle 277 extends the §two-named-rationale-sections (cycle 273) to §three-named-rationale-sections; §the-design-doc-cluster-has-three-named-places-for-rationale.

§The-`(CRDT-specific)`-parenthetical-tag — §named-tag-for-platform-specific-edge-cases; §sibling-pattern to many systems' platform-specific-marker conventions.

## §Inline testing examples in prose design doc

Lines 944-972 carry §two-inline-testing-examples — actual JavaScript `it(...)` test cases embedded in the prose:

```javascript
it('Shift+Click on selected block removes it and descendants', () => { ... });
it('middle of block returns into zone', () => { ... });
```

§First-explicit-observation in library: **§inline-testing-examples-in-prose-design-doc — §the-design-doesn't-just-DESCRIBE-the-pure-functions + §it-SHOWS-them-being-tested + §the-example-IS-the-evidence-of-testability + §sibling-pattern to literate-programming conventions**.

§Sibling-pattern to many engineering documents' "show, don't tell" discipline; §the-design-doc-IS-its-own-testing-tutorial.

## §"All three placements share the same content" — Alt-drag as reference creation

Line 988 (Edge Case 3):
> *When Alt+dragging a block that is itself a reference (appears in multiple places), you create another reference to the same underlying block. All three placements share the same content. This is valid and intentional.*

§First-explicit-observation in library: **§Alt-drag-as-named-reference-creation-modifier — §the-modifier-key-IS-the-discriminator-between-move-and-reference + §"reference to a reference"-IS-explicitly-allowed + §"all-three-placements-share-the-same-content"-IS-the-canonical-form-of-the-reference-relationship**.

§Sibling-pattern to many file-system reference conventions (symlinks + Aliases); §the-block-IS-the-canonical-target + §the-references-IS-the-fan-out-from-the-canonical-target.

## §Cycle 277 first-explicit-observations roundup (twelve)

1. §the-Part-1-and-Part-2-discipline-as-named-document-structure-for-large-guides.
2. §the-cluster-now-has-four-named-naming-conventions (lowercase-with-hyphens + `-design-doc-2`-suffix + ALL_CAPS + lowercase_underscores).
3. §two-cycles-with-the-subtractive-guide-deviation-shape (273 + 277).
4. §the-comparison-points-narrow-with-context (cycle 273 had Roam + Obsidian + Workflowy; cycle 277 has Roam alone).
5. §the-exact-phrase-"the-most-important-architectural-decision"-recurs-across-two-outliner-cluster-guides (273 + 277).
6. §three-cycles-with-the-explicit-named-central-decision (269 + 273 + 277).
7. §the-exact-three-layer-ASCII-art-diagram-recurs-across-two-outliner-cluster-guides.
8. §three-cycles-with-three-layer-architectures-as-named-design-rationale (271 + 273 + 277).
9. §the-coexistence-challenge-as-named-design-driver (text selection vs block selection).
10. §the-numbered-ToC-spans-both-Parts-with-monotonic-numbering.
11. §the-named-tiebreaker-discipline-with-named-rationale (into deserves the tiebreaker because hardest to hit).
12. §the-Edge-Cases-section-as-named-cumulative-discovery-record + §three-named-rationale-sections-in-design-documents (Design-Decisions + Lessons-Learned + Edge-Cases).

Plus: §inline-testing-examples-in-prose-design-doc + §Alt-drag-as-named-reference-creation-modifier + §the-`(CRDT-specific)`-parenthetical-tag.

## §Recurring meta-pattern counters bumped at cycle 277

- §**four-cycles-with-template-deviation-in-the-cluster** (263 subtractive-fragment + 273 subtractive-guide + 275 additive-extension + 277 subtractive-guide).
- §**two-cycles-with-the-subtractive-guide-deviation-shape** (273 + 277).
- §**three-cycles-with-three-layer-architectures-as-named-design-rationale** (271 + 273 + 277).
- §**three-cycles-with-the-explicit-named-central-decision** (269 + 273 + 277).
- §**two-cycles-with-Muddle-attribution-in-the-outliner-cluster** (273 + 277).
- §**the-cluster-now-has-four-named-naming-conventions** (lowercase-with-hyphens + `-design-doc-2`-suffix + ALL_CAPS + lowercase_underscores).
- §**three-named-rationale-sections-in-design-documents** (Design-Decisions + Lessons-Learned + Edge-Cases).
- §**nineteen-design-docs-from-endo-but-for-bots-designs-cluster-ingested**.
- §**one-hundred-and-tenth consecutive designs-chat alternation cycles 166-250 + 252-277** (251 was out-of-band).

## §Synthesis target — slot machine library

§The-Part-1-and-Part-2-discipline-for-large-guides applies to the §game-engine-cluster:

- §**`game-engine-mechanics-and-betting.md`** as a §two-part-guide-structure (Part 1: Game Mechanics + Part 2: Betting Mechanics).
- §**23-numbered ToC** items spanning both Parts with monotonic numbering.
- §**Same three-layer architecture** as the cluster's other guides — game-behavior-layer + game-component-layer + game-data-layer.
- §**Named tiebreaker discipline** for boundary cases (e.g., when a bet falls at exactly the edge of a roll's payout zone).
- §**Edge Cases section** as the third named rationale section (alongside Design Decisions and Lessons Learned).
- §**Inline testing examples** in the prose design doc — `it('...')` test cases showing pure-function testability.
- §**The coexistence challenge** — when two game systems must coexist without fighting each other (e.g., game-rule + game-UI).
- §**Alt-drag-as-named-modifier** for game-rule reference creation (vs. game-rule movement).

## §Tier-1 borrowing

§the-Part-1-and-Part-2-discipline-as-named-document-structure-for-large-guides + §the-cluster-now-has-four-named-naming-conventions + §two-cycles-with-the-subtractive-guide-deviation-shape + §the-comparison-points-narrow-with-context + §the-exact-phrase-recurs + §three-cycles-with-the-explicit-named-central-decision + §the-exact-three-layer-ASCII-art-diagram-recurs + §three-cycles-with-three-layer-architectures-as-named-design-rationale + §the-coexistence-challenge-as-named-design-driver + §the-numbered-ToC-spans-both-Parts-with-monotonic-numbering + §the-named-tiebreaker-discipline-with-named-rationale + §the-Edge-Cases-section-as-named-cumulative-discovery-record + §three-named-rationale-sections-in-design-documents (Design-Decisions + Lessons-Learned + Edge-Cases).

## §Tier-2 borrowing

§inline-testing-examples-in-prose-design-doc + §Alt-drag-as-named-reference-creation-modifier + §the-`(CRDT-specific)`-parenthetical-tag.

## §Tier-3 borrowing

§four-cycles-with-template-deviation-in-the-cluster (263 + 273 + 275 + 277) + §two-cycles-with-Muddle-attribution-in-the-outliner-cluster (273 + 277) + §nineteen-design-docs-from-endo-but-for-bots-designs-cluster-ingested + §library-reaches-783-sections at cycle 277 + §one-hundred-and-tenth consecutive designs-chat alternation cycles 166-250 + 252-277.

## Pattern summary (tag-prefixed)

§the-third-outliner-cluster-design + §the-Part-1-and-Part-2-discipline-as-named-document-structure-for-large-guides + §two-cycles-with-the-subtractive-guide-deviation-shape (273 + 277) + §four-cycles-with-template-deviation-in-the-cluster (263 + 273 + 275 + 277) + §the-cluster-now-has-four-named-naming-conventions (lowercase-with-hyphens + `-design-doc-2`-suffix + ALL_CAPS + lowercase_underscores) + §the-comparison-points-narrow-with-context (cycle 273 Roam + Obsidian + Workflowy → cycle 277 Roam alone) + §the-exact-phrase-"the-most-important-architectural-decision"-recurs + §three-cycles-with-the-explicit-named-central-decision (269 + 273 + 277) + §the-exact-three-layer-ASCII-art-diagram-recurs + §three-cycles-with-three-layer-architectures-as-named-design-rationale (271 + 273 + 277) + §the-coexistence-challenge-as-named-design-driver (text selection vs block selection) + §the-23-numbered-ToC-spans-both-Parts-with-monotonic-numbering + §the-named-tiebreaker-discipline-with-named-rationale ("into" deserves the tiebreaker because hardest to hit) + §the-Edge-Cases-section-as-named-cumulative-discovery-record + §three-named-rationale-sections-in-design-documents (Design-Decisions + Lessons-Learned + Edge-Cases) + §inline-testing-examples-in-prose-design-doc + §Alt-drag-as-named-reference-creation-modifier + §the-`(CRDT-specific)`-parenthetical-tag + §two-cycles-with-Muddle-attribution-in-the-outliner-cluster (273 + 277).
