---
title: "OUTLINER_INTERACTION_PATTERNS.md — cross-directory drift from cycle 263 confirmed + three-layer architecture (Behavior + Component + Data) + pure-functions-over-DOM-events + eight Lessons Learned + named criticism of contentEditable"
source-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS
section-slug: cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-of-contentEditable
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/OUTLINER_INTERACTION_PATTERNS.md
source-repo: endojs/endo-but-for-bots
source-path: designs/OUTLINER_INTERACTION_PATTERNS.md
source-author: Endo project (with attribution to Muddle project)
total-lines: 997
ingest-cycle: 273
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
---

# `OUTLINER_INTERACTION_PATTERNS.md` — the guide that closes cycle 263's cross-directory-drift loop

A 997-line **comprehensive guide** (named genre at line 3). **Closes the loop with cycle 263's `outliner-design-doc-2.md`** observation: that fragment references *"docs/OUTLINER_INTERACTION_PATTERNS.md"*; the actual file is at `designs/OUTLINER_INTERACTION_PATTERNS.md` — §the-cross-directory-drift-IS-confirmed.

§First-explicit-observation in library: **§the-cross-directory-drift-observed-in-cycle-263-IS-now-confirmed-in-cycle-273 — §the-design-fragment-named-`docs/OUTLINER_INTERACTION_PATTERNS.md` + §the-actual-file-IS-at-`designs/OUTLINER_INTERACTION_PATTERNS.md` + §two-cycles-of-drift-evidence (named in 263; confirmed in 273)**.

## §The ALL-CAPS-FILENAME distinguishes this from sibling design docs

The filename `OUTLINER_INTERACTION_PATTERNS.md` IS ALL CAPS — distinct from the canonical lowercase-with-hyphens design-doc naming convention (e.g., `endor-tui.md` + `endoclaw-network-fetch.md` + `outliner-design-doc-2.md`).

§First-explicit-observation in library: **§the-ALL-CAPS-FILENAME-as-named-distinction-from-sibling-design-docs — §the-file-naming-convention-DIVERGES-from-the-cluster's-discipline + §the-divergence-IS-the-evidence-of-a-different-genre (guide-not-design)**.

§The-cluster-now-has-three-named-naming-conventions:
1. **lowercase-with-hyphens** — canonical design-doc filenames.
2. **`-design-doc-2`-suffix** — cycle 263's follow-up naming convention.
3. **ALL_CAPS** — this guide and possibly other "comprehensive guides" in the cluster.

§the-naming-convention-IS-genre-evidence; §sibling-pattern to academic conventions distinguishing journal articles from textbook chapters.

## §No metadata table — the file is a guide, not a design

Lines 1-3 carry no canonical metadata table:
```
# Building a Browser-Based Outliner: HTML Interaction Patterns

A comprehensive guide to the interaction patterns required to make a block-based outliner feel like a real editable document in the browser. Based on patterns converged upon in the [Muddle](https://github.com/nicedland/muddle) project — a local-first collaborative knowledge graph.
```

§First-explicit-observation in library: **§two-cycles-with-template-deviation-in-the-outliner-cluster — §cycle-263's-outliner-design-doc-2-deviates-because-it-IS-a-fragment + §cycle-273's-OUTLINER_INTERACTION_PATTERNS-deviates-because-it-IS-a-guide-not-a-design + §the-outliner-cluster-has-two-named-deviation-shapes-(fragment + guide)**.

§The-genre-named-at-the-top — *"A comprehensive guide to the interaction patterns required to make a block-based outliner feel like a real editable document in the browser"* — §the-first-line-of-the-prose-IS-the-genre-declaration; §sibling-pattern to academic abstract conventions.

§First-explicit-observation in library: **§the-genre-named-at-the-top-as-named-design-discipline — §when-a-document-IS-not-a-design-doc, §the-first-line-of-prose-declares-the-genre-explicitly + §the-reader-knows-immediately-which-template-not-to-expect**.

## §Named prior-art attribution — the Muddle project

Line 3: *"Based on patterns converged upon in the [Muddle](https://github.com/nicedland/muddle) project — a local-first collaborative knowledge graph"*.

§First-explicit-observation in library: **§named-prior-art-attribution-with-named-related-project (Muddle); §the-patterns-IS-not-claimed-as-original + §the-source-IS-named-with-a-URL + §the-attribution-IS-the-first-line-of-prose-not-buried-in-a-footnote**.

§Sibling-pattern to academic citation conventions; §the-acknowledgment-IS-explicit-and-the-attribution-IS-load-bearing-for-the-design's-justification.

## §Three-layer architecture — sibling to cycle 271's three-layers-not-one

Lines 30-46 carry an ASCII-art architecture diagram with three named layers:

```
┌──────────────────────────────────────────────────────┐
│  Behavior Layer (pure functions)                     │
│  editing.ts, navigation.ts, selection.ts, dragDrop.ts│
│  Input: context object → Output: action descriptor   │
├──────────────────────────────────────────────────────┤
│  Component Layer (React)                             │
│  BlockContent, Block, BlockTree, BoundingBoxSelection│
│  Translates DOM events → contexts, actions → effects │
├──────────────────────────────────────────────────────┤
│  Data Layer (Automerge CRDT)                         │
│  BlockHandle, BlockTreeContext                       │
│  Tree mutations, content updates, sync               │
└──────────────────────────────────────────────────────┘
```

§Three named layers:
1. **Behavior Layer** (pure functions) — context object → action descriptor.
2. **Component Layer** (React) — DOM events → contexts; actions → effects.
3. **Data Layer** (Automerge CRDT) — tree mutations + content updates + sync.

§Two-cycles-with-three-layer-architectures-as-named-design-rationale (271 endor-bus-tui's bus-verbs + XS-handles + Exo-wrapper; 273 outliner's Behavior + Component + Data); §the-three-layers-IS-the-canonical-shape-for-decoupling-concerns-in-the-cluster.

§First-explicit-observation in library: **§the-ASCII-art-architecture-diagram-as-named-visual-design-discipline — §the-diagram-IS-NOT-a-Mermaid-graph (cycle 267's README's discipline) + §the-ASCII-art-IS-self-contained-and-readable-in-source + §sibling-pattern-to-RFCs-and-Linux-kernel-documentation**.

§Sibling-pattern to cycle 267's Mermaid graph in README.md; §the-cluster-has-two-named-diagram-conventions (Mermaid + ASCII-art); §first-explicit-observation in library of §the-cluster-has-two-named-diagram-conventions.

## §"The single most important architectural decision"

Line 54:
> *The single most important architectural decision: **all interaction logic lives in pure functions that are independent of React, the DOM, and the data layer.***

§First-explicit-observation in library: **§the-"single-most-important-architectural-decision"-as-named-design-prose-discipline — §the-prose-EXPLICITLY-NAMES-the-most-important-decision + §the-reader-knows-which-decision-IS-load-bearing-without-having-to-infer**.

§Sibling-pattern to cycle 269's "single most structurally interesting move" — both designs name the central insight explicitly; §two-cycles-with-the-explicit-named-central-decision (269 + 273).

§"all interaction logic lives in pure functions that are independent of React, the DOM, and the data layer" — §the-three-named-independences-IS-the-testability-claim; §sibling-pattern to many functional-architecture conventions.

## §The pure-functions-test-without-browser discipline

Line 48: *"This makes the interaction logic trivially testable without a browser."*

§First-explicit-observation in library: **§the-pure-functions-test-without-browser-discipline-as-named-testability-driver — §when-the-component-and-data-layers-IS-removed-from-the-test, §the-behavior-layer-tests-IS-fast + §reliable + §browser-independent**.

§Sibling-pattern to many functional-architecture conventions; §the-discipline-IS-NOT-novel + §the-design-NAMES-it-as-load-bearing.

§Three-named-test-axes in the design (lines 850-980):
1. **Unit Tests for Behavior Functions** (line 852).
2. **E2E Tests for Browser Integration** (line 906).
3. **What Unit Tests Catch vs. E2E** (line 966).

§First-explicit-observation in library: **§three-named-test-axes-with-explicit-comparative-section ("What Unit Tests Catch vs. E2E") — §sibling-pattern to cycle 267's two-named-update-disciplines but applied to testing rather than to documentation maintenance**.

## §Eight Lessons Learned with named bug-and-fix pairs

Lines 981-997 carry **eight numbered Lessons Learned**:

1. **Measure `.block-row`, not `.block`** — *"Our most persistent drag-select bug was parent blocks being selected when only children were in the selection box. The fix: measure the row element (bullet + content) not the outer block container (which includes children)."*
2. **Textareas over contentEditable** — *"ContentEditable is seductive but treacherous. Cursor position tracking, paste handling, and cross-browser consistency are all dramatically simpler with textareas. The tradeoff (no inline rich text editing) is worth it for an outliner where structure matters more than formatting."*
3. **Pure behavior functions are the best testing investment**.
4. **Focus management is a state machine** — *"The pattern of 'queue focus for a block that doesn't exist yet' is essential. Any operation that changes tree structure (Enter, Backspace merge, indent, unindent) will destroy and recreate DOM nodes."*
5. **Global mouse listeners for drag operations** — *"Always attach mousemove and mouseup to `window` during drag."*
6. **Contiguous-only selection simplifies everything**.
7. **`requestAnimationFrame` nesting for mobile** — *"A single rAF is not enough on mobile browsers. Two nested rAF calls ensure the DOM has fully settled before applying focus."*
8. **The `{ type: 'default' }` action is load-bearing** — *"Most keystrokes should fall through to browser defaults. The behavior layer must explicitly opt-in to intercepting a key, never opt-out. Get this wrong and you break basic typing."*

§First-explicit-observation in library: **§eight-numbered-Lessons-Learned-with-named-bug-and-fix-pairs — §the-richest-Lessons-Learned-section-cycle-ingested + §each-lesson-IS-a-named-named-bug-fix-or-discipline + §the-section-IS-the-cumulative-experience-record-of-the-design**.

§Sibling-pattern to cycle 269's eleven-numbered-Design-Decisions; §the-Lessons-Learned-section-IS-the-retrospective-companion-to-the-Design-Decisions-section; §two-named-rationale-sections in design-documents: §Design-Decisions (prospective rationale) + §Lessons-Learned (retrospective discoveries).

§First-explicit-observation in library: **§two-named-rationale-sections-in-design-documents (Design-Decisions for prospective + Lessons-Learned for retrospective)**.

## §"ContentEditable is seductive but treacherous" — named criticism of an existing browser API

Line 985 carries a §named-pejorative on the standard browser `contentEditable` API:

> *ContentEditable is seductive but treacherous.*

§First-explicit-observation in library: **§"X-is-seductive-but-treacherous"-as-named-pejorative-shape — §the-API-LOOKS-like-the-right-tool + §USING-it-leads-to-trouble; §the-prose-IS-rhetorically-amplified + §the-evidence-IS-named-in-the-next-sentence (cursor position tracking + paste handling + cross-browser consistency)**.

§Three-cycles-with-named-criticism-of-existing-API-as-design-justification (245 panic-cluster on `eval` + 272 isWellFormed on `String.prototype.isWellFormed` + 273 contentEditable); §the-discipline-IS-now-canonical-across-three-cycles; §the-cluster-has-a-NAMED-tradition-of-criticizing-platform-APIs-by-name.

§First-explicit-observation in library: **§three-cycles-with-named-criticism-of-existing-API-as-design-justification (245 + 272 + 273) — §the-discipline-IS-now-canonical**.

§The-fix (line 985): *"Cursor position tracking, paste handling, and cross-browser consistency are all dramatically simpler with textareas. The tradeoff (no inline rich text editing) is worth it for an outliner where structure matters more than formatting."*

§Named-tradeoff-acknowledged — §the-design-EXPLICITLY-acknowledges-what-IS-given-up + §the-tradeoff-IS-justified-by-domain-priority (structure matters more than formatting); §sibling-pattern to many engineering-tradeoff conventions.

§First-explicit-observation in library: **§the-domain-priority-as-tradeoff-justification — §"X-matters-more-than-Y"-pattern as named-rationale-shape**.

## §"The fix: ..." pattern — named bug-and-remedy as testimony

Lines 983, 989, 991 carry §the-"the fix"-pattern:

> *Our most persistent drag-select bug was parent blocks being selected when only children were in the selection box. The fix: measure the row element (bullet + content) not the outer block container (which includes children).*

§First-explicit-observation in library: **§the-"the-fix"-pattern-as-named-bug-and-remedy-testimony — §the-bug-IS-named-(parent-blocks-being-selected) + §the-fix-IS-named-explicitly (measure the row element) + §the-prose-IS-a-testimony-not-just-a-recommendation**.

§Sibling-pattern to many post-mortem conventions; §the-pattern-encodes-the-history-of-the-design-as-stored-knowledge.

## §"opt-in to intercepting a key, never opt-out" — the load-bearing discipline

Lesson 8 (line 997):
> *Most keystrokes should fall through to browser defaults. The behavior layer must explicitly opt-in to intercepting a key, never opt-out. Get this wrong and you break basic typing.*

§First-explicit-observation in library: **§the-opt-in-not-opt-out-discipline-for-event-interception — §the-default-IS-fall-through + §interception-IS-explicit + §"get-this-wrong-and-you-break-basic-typing"-IS-the-failure-mode-named-explicitly**.

§Sibling-pattern to capability-systems' principle-of-least-authority (the worker doesn't need to control everything; default IS no-authority); §the-discipline-applied-to-keyboard-event-handling.

§the-`{ type: 'default' }`-action-shape — §the-named-action-IS-the-fall-through; §the-shape-IS-explicit-in-the-action-descriptor-not-implicit-in-the-absence-of-action; §sibling-pattern to many state-machine conventions.

§First-explicit-observation in library: **§the-`{ type: 'default' }`-action-as-named-fall-through-shape**.

## §"requestAnimationFrame nesting for mobile" — named-platform-specific-workaround

Lesson 7 (line 995): *"A single rAF is not enough on mobile browsers. Two nested rAF calls ensure the DOM has fully settled before applying focus."*

§First-explicit-observation in library: **§named-platform-specific-workaround-with-named-platform (mobile browsers) and named-cardinality-fix (two nested rAF calls)**.

§Sibling-pattern to many browser-specific workarounds in JS UI libraries; §the-discipline-IS-the-acknowledgment-IS-the-workaround.

## §"Focus management is a state machine" — named architectural style

Lesson 4 (line 989):
> *The pattern of "queue focus for a block that doesn't exist yet" is essential. Any operation that changes tree structure (Enter, Backspace merge, indent, unindent) will destroy and recreate DOM nodes. The focus manager must handle the gap.*

§First-explicit-observation in library: **§the-pending-focus-queue-pattern — §when-an-operation-changes-tree-structure, §the-DOM-nodes-are-destroyed-and-recreated + §the-focus-target-must-survive-this-gap + §a-queue-of-pending-focus-targets-IS-the-architectural-pattern**.

§Sibling-pattern to many DOM-mutation-and-restore patterns; §the-discipline-IS-the-named-state-machine.

## §Cycle 273 first-explicit-observations roundup (twelve)

1. **§the-cross-directory-drift-observed-in-cycle-263-IS-now-confirmed-in-cycle-273**.
2. **§the-ALL-CAPS-FILENAME-as-named-distinction-from-sibling-design-docs**.
3. **§two-cycles-with-template-deviation-in-the-outliner-cluster** (263 fragment + 273 guide).
4. **§the-genre-named-at-the-top-as-named-design-discipline** ("A comprehensive guide").
5. **§named-prior-art-attribution-with-named-related-project** (Muddle).
6. **§two-cycles-with-three-layer-architectures-as-named-design-rationale** (271 + 273).
7. **§the-ASCII-art-architecture-diagram-as-named-visual-design-discipline** (alternative to Mermaid).
8. **§the-cluster-has-two-named-diagram-conventions** (Mermaid + ASCII-art).
9. **§the-"single-most-important-architectural-decision"-as-named-design-prose-discipline**.
10. **§the-pure-functions-test-without-browser-discipline-as-named-testability-driver**.
11. **§three-named-test-axes-with-explicit-comparative-section** ("What Unit Tests Catch vs. E2E").
12. **§eight-numbered-Lessons-Learned-with-named-bug-and-fix-pairs** (the richest Lessons Learned section ingested).

Plus: §two-named-rationale-sections-in-design-documents (Design-Decisions + Lessons-Learned) + §"X-is-seductive-but-treacherous"-as-named-pejorative-shape + §three-cycles-with-named-criticism-of-existing-API-as-design-justification (245 + 272 + 273) + §the-domain-priority-as-tradeoff-justification ("X matters more than Y") + §the-"the-fix"-pattern-as-named-bug-and-remedy-testimony + §the-opt-in-not-opt-out-discipline-for-event-interception + §the-`{ type: 'default' }`-action-as-named-fall-through-shape + §named-platform-specific-workaround (mobile + two nested rAF) + §the-pending-focus-queue-pattern.

## §Recurring meta-pattern counters bumped at cycle 273

- §**two-cycles-with-template-deviation-in-the-outliner-cluster** (263 + 273).
- §**two-cycles-with-three-layer-architectures-as-named-design-rationale** (271 endor-bus-tui + 273 outliner).
- §**three-cycles-with-named-criticism-of-existing-API-as-design-justification** (245 + 272 + 273).
- §**the-cluster-has-two-named-diagram-conventions** (Mermaid + ASCII-art).
- §**seventeen-design-docs-from-endo-but-for-bots-designs-cluster-ingested** (cycle 271's count + cycle 273 OUTLINER_INTERACTION_PATTERNS).
- §**one-hundred-and-sixth consecutive designs-chat alternation cycles 166-250 + 252-273** (251 was out-of-band).

## §Closing the cycle 263 loop

Cycle 263 made three observations about `outliner-design-doc-2.md`:
1. The fragment references `docs/OUTLINER_INTERACTION_PATTERNS.md` (cross-directory).
2. The references suggests file movement without reference update.
3. The cross-directory drift IS named-evidence-of-design-doc-drift.

Cycle 273 confirms all three by reading the actual `designs/OUTLINER_INTERACTION_PATTERNS.md`:
1. ✓ The file IS at `designs/...` not `docs/...`.
2. ✓ Likely file movement happened; reference not updated.
3. ✓ The drift IS real evidence of design-doc maintenance debt.

§First-explicit-observation in library: **§a-cycle-confirms-a-prior-cycle's-tentative-observation — §cycle-263-NAMED-a-tentative-drift + §cycle-273-CONFIRMS-it-by-ingesting-the-referenced-file + §the-pair-IS-the-named-confirmation-pattern**.

§Two-cycles-from-different-angles-meeting-the-same-pattern (263 named-tentative + 273 confirmed); §sibling-pattern to cycle 269 + 271's symmetric-non-duplication-discipline but applied to evidence-confirmation rather than design-deferral.

## §Synthesis target — slot machine library

§The-pure-functions-test-without-browser-discipline applies to the §game-engine-cluster:

- §**§game-behavior-layer** as pure functions over game-action-events — testable without a runtime.
- §**§game-component-layer** as the UI rendering and event translation.
- §**§game-data-layer** as the CRDT-backed game-state-tree.
- §**§ASCII-art architecture diagram** as named visual discipline.
- §**§named-criticism-of-an-existing-game-API** when the standard API does the wrong thing for the game.
- §**§"the-fix" testimony pattern** for named-bug-and-remedy recording in game-rule design docs.
- §**§eight Lessons Learned section** as retrospective companion to Design Decisions.
- §**§opt-in-not-opt-out discipline** for game-event interception.
- §**§the `{ type: 'default' }` action** as named fall-through shape for game-rule actions.

## §Tier-1 borrowing

§the-cross-directory-drift-observed-in-cycle-263-IS-now-confirmed-in-cycle-273 + §the-ALL-CAPS-FILENAME-as-named-distinction-from-sibling-design-docs + §the-genre-named-at-the-top + §named-prior-art-attribution + §two-cycles-with-three-layer-architectures-as-named-design-rationale + §the-ASCII-art-architecture-diagram-as-named-visual-design-discipline + §the-"single-most-important-architectural-decision"-prose-discipline + §the-pure-functions-test-without-browser-discipline + §three-named-test-axes-with-explicit-comparative-section + §eight-numbered-Lessons-Learned-with-named-bug-and-fix-pairs + §two-named-rationale-sections-in-design-documents (Design-Decisions + Lessons-Learned) + §the-opt-in-not-opt-out-discipline-for-event-interception.

## §Tier-2 borrowing

§the-cluster-has-two-named-diagram-conventions (Mermaid + ASCII-art) + §"X-is-seductive-but-treacherous"-as-named-pejorative-shape + §the-domain-priority-as-tradeoff-justification + §the-"the-fix"-pattern-as-named-bug-and-remedy-testimony + §the-`{ type: 'default' }`-action-as-named-fall-through-shape + §named-platform-specific-workaround (mobile + two nested rAF) + §the-pending-focus-queue-pattern.

## §Tier-3 borrowing

§two-cycles-with-template-deviation-in-the-outliner-cluster (263 + 273) + §three-cycles-with-named-criticism-of-existing-API-as-design-justification (245 + 272 + 273) + §seventeen-design-docs-from-endo-but-for-bots-designs-cluster-ingested + §library-reaches-779-sections at cycle 273 + §one-hundred-and-sixth consecutive designs-chat alternation cycles 166-250 + 252-273.

## Pattern summary (tag-prefixed)

§the-guide-that-closes-cycle-263's-cross-directory-drift-loop + §two-cycles-of-drift-evidence (263 named-tentative + 273 confirmed) + §the-ALL-CAPS-FILENAME-as-named-distinction-from-sibling-design-docs + §the-cluster-now-has-three-named-naming-conventions (lowercase-with-hyphens + `-design-doc-2`-suffix + ALL_CAPS) + §the-genre-named-at-the-top ("A comprehensive guide") + §named-prior-art-attribution (Muddle) + §three-named-layers (Behavior + Component + Data) + §pure-functions-over-DOM-events + §two-cycles-with-three-layer-architectures + §the-ASCII-art-architecture-diagram-as-named-visual-design-discipline + §the-cluster-has-two-named-diagram-conventions (Mermaid + ASCII-art) + §the-"single-most-important-architectural-decision"-prose-discipline + §the-pure-functions-test-without-browser-discipline + §three-named-test-axes-with-explicit-comparative-section + §eight-numbered-Lessons-Learned + §"X-is-seductive-but-treacherous"-as-named-pejorative-shape (contentEditable) + §three-cycles-with-named-criticism-of-existing-API-as-design-justification (245 + 272 + 273) + §the-domain-priority-as-tradeoff-justification + §the-"the-fix"-pattern-as-named-bug-and-remedy-testimony + §the-opt-in-not-opt-out-discipline-for-event-interception + §the-`{ type: 'default' }`-action-as-named-fall-through-shape + §named-platform-specific-workaround (mobile + two nested rAF) + §the-pending-focus-queue-pattern + §two-named-rationale-sections-in-design-documents (Design-Decisions + Lessons-Learned) + §a-cycle-confirms-a-prior-cycle's-tentative-observation.
