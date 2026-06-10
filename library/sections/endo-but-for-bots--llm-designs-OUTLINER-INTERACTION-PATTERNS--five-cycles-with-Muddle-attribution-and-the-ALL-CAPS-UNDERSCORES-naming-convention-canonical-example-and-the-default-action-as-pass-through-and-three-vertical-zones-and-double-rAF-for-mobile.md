---
title: "endo-but-for-bots/designs/OUTLINER_INTERACTION_PATTERNS.md — five-cycles-with-Muddle-attribution + the canonical ALL_CAPS_UNDERSCORES naming convention + the `{ type: 'default' }` pass-through action + three vertical drop zones + the double-rAF mobile-DOM-settling discipline"
section-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--five-cycles-with-Muddle-attribution-and-the-ALL-CAPS-UNDERSCORES-naming-convention-canonical-example-and-the-default-action-as-pass-through-and-three-vertical-zones-and-double-rAF-for-mobile
source-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/OUTLINER_INTERACTION_PATTERNS.md
authors: [Endo project (with attribution to Muddle project)]
status: (no explicit metadata table)
ingest-cycle: 285
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 996
---

# `OUTLINER_INTERACTION_PATTERNS.md` (full design)

A 996-line comprehensive guide to the interaction patterns required to make a block-based outliner feel like a real editable document in the browser. The 5th outliner-cluster design ingested (joining cycles 263 + 273 + 275 + 277). Attributed to the Muddle project — making this **§five-cycles-with-Muddle-attribution-in-the-outliner-cluster** (263 + 273 + 275 + 277 + 285). The file's name uses the **ALL_CAPS_UNDERSCORES** naming convention — the canonical example of one of the four naming-conventions cycle 277 enumerated.

## The shape

11 numbered sections in a single ToC (NOT split into Parts; the §two-part-guide-structure observed in cycle 277 is one outliner-cluster shape; this is another):

1. Architecture Overview
2. The Behavior Layer: Pure Functions Over DOM Events
3. DOM Structure & Why We Use Textareas
4. Keyboard Interactions (with five sub-sections)
5. Drag-to-Select (Bounding Box Selection)
6. Multi-Block Selection Model
7. Drag and Drop
8. Focus Management
9. Paste Handling
10. Testing Strategies
11. Lessons Learned

No metadata table (no `**Created**` + `**Author**` + `**Status**` fields). The file opens with a one-paragraph blurb instead. **§the-no-metadata-table-shape-as-named-design-doc-variant** (first-explicit-observation in design pattern terms): not every design in this cluster follows the canonical metadata table convention (per cycle 265's `designs/CLAUDE.md`); this file is the first ingested design that omits it entirely. §convention-deviation-within-cluster — the third such observation alongside cycle 277's four-named-naming-conventions.

## §the-ALL_CAPS_UNDERSCORES naming convention as canonical example (first-explicit-observation)

Cycle 277 named **four naming conventions** observed in the cluster:
- lowercase-with-hyphens (e.g., `chat-color-schemes.md`)
- `-design-doc-2` suffix
- ALL_CAPS_UNDERSCORES
- lowercase_underscores (e.g., `outliner_drag_and_drop.md`)

This file IS the **canonical example** of `ALL_CAPS_UNDERSCORES`. **§the-cluster-now-has-five-design-docs-with-ALL_CAPS_UNDERSCORES-naming**? — actually, this is the first such file ingested. The naming-convention enumeration from cycle 277 cited this file by name as the example.

§five-cycles-with-named-naming-convention-observed-in-the-outliner-cluster: 263 (lowercase-with-hyphens) + 273 (`-design-doc-2`-suffix) + 275 (lowercase-with-hyphens) + 277 (four-conventions-enumerated) + 285 (ALL_CAPS_UNDERSCORES-canonical-instance).

## §the-three-layer-architecture-with-the-canonical-three-name-choice (first-explicit-observation; fourth cycle in cluster)

```
Behavior Layer (pure functions; editing.ts + navigation.ts + selection.ts + dragDrop.ts)
Component Layer (React; BlockContent + Block + BlockTree + BoundingBoxSelection)
Data Layer (Automerge CRDT; BlockHandle + BlockTreeContext)
```

**§four-cycles-with-three-layer-architectures-as-named-design-rationale** (extends cycle 277's three-cycle pattern; 271 + 273 + 277 + 285). The three layer names are slightly different across the cluster's instances:

- Cycle 271 instance: (TBD; not extracted here)
- Cycle 273 instance: behavior + component + data (TBD by name)
- Cycle 277 instance: behavior + component + data
- Cycle 285 instance: Behavior + Component + Data (canonical-three-name-choice)

The naming converges. **§the-three-layer-architecture-IS-the-cluster-canonical-shape**.

## §the-`{ type: 'default' }`-action-as-named-pass-through-discipline (first-explicit-observation)

Behavior functions return action descriptors. **One named action — `{ type: 'default' }` — means "let the browser handle this normally."** The doc names this as critical:

> "The `{ type: 'default' }` action is critical — it means 'let the browser handle this normally.' Most keystrokes fall through to default behavior. The behavior layer only intercepts keys at meaningful boundaries."

This is **§the-behavior-layer-only-intercepts-keys-at-meaningful-boundaries** as a named *minimal-intervention discipline*. The default action is the **enumerated identity** of the pass-through. Without naming it, the architecture would have either an early-return or a thrown exception; the explicit named action keeps the type union closed.

**§the-explicit-default-as-named-pass-through-IS-the-discriminated-union-discipline**: a closed union (every keystroke produces some named action) with one of the members explicitly being "do nothing app-level". §the-named-no-op-as-named-action shape — first-explicit-observation.

## §the-textarea-not-contentEditable-decision with four named reasons (first-explicit-observation)

The doc enumerates **four named reasons** for choosing `<textarea>` over `contentEditable`:

1. **Predictable cursor behavior** — `textarea.selectionStart`/`selectionEnd` give exact numeric cursor positions; ContentEditable uses Range/Selection APIs that are notoriously inconsistent across browsers.
2. **No HTML injection surface** — Textareas only contain plain text. No XSS concerns from paste, no unexpected formatting.
3. **Simpler event model** — `onChange` gives you the new value; no `beforeinput`/`input` event circus.
4. **Auto-resize is trivial** — Set `height: auto`, then `height = scrollHeight + 'px'` on every change.

**§the-four-named-reasons-for-rejecting-the-richer-API pattern** (first-explicit-observation): the design names the seductive alternative and itemizes why it was rejected. Compare cycle 283's §three-named-rejected-alternatives-with-reasons (loopback TCP + kernel credential check; cryptographic attestation); this is the same shape applied to web APIs.

**§the-tradeoff-IS-explicitly-named**: "The tradeoff is that rich text formatting (bold, links) must be rendered separately — we use markdown rendering for display and raw text for editing." This is **§the-name-the-rejected-feature pattern** — the design says what it loses, not just what it gains.

## §the-`data-url`-on-`.block-row`-not-`.block` as named measurement-decision (first-explicit-observation)

> "**Critical detail**: `data-url` is placed on `.block-row`, NOT on the outer `.block` div. The outer `.block` div includes children, so its bounding rect encompasses the entire subtree. Placing `data-url` on `.block-row` ensures that when we measure block positions for drag-select, a parent block's rect doesn't overlap its children's rects."

**§the-place-the-attribute-on-the-element-whose-rect-IS-the-measurement-target shape** (first-explicit-observation): a small DOM-attribute decision that determines whether parent-rects encompass child-rects (and so whether drag-select selects unintended parents). The doc explicitly names this as a "**Critical detail**" — flagging that an attribute placement choice IS a correctness invariant.

§the-attribute-placement-IS-the-correctness-invariant. The first Lesson Learned ("**Measure `.block-row`, not `.block`.**") reaffirms this from the retrospective angle: "Our most persistent drag-select bug was parent blocks being selected when only children were in the selection box."

## §the-padding-left-per-depth-IS-the-indentation-mechanism (first-explicit-observation)

Indentation IS `padding-left: ${depth * 24}px` on the bullet container — **not** CSS nesting rules. **The tree structure is real (nested DOM), but visual indentation is controlled by this padding rather than CSS nesting rules.** A vertical guide line is drawn with a `::before` pseudo-element on `.block-children`.

§the-DOM-tree-IS-nested-but-the-visual-indentation-IS-controlled-by-padding-not-CSS-nesting — a named separation of structural-tree vs visual-tree. The DOM tree carries semantic structure (parent-child); the padding carries visual layout. They could be made consistent by relying on CSS nested-margin; instead, the design uses the padding mechanism for predictable layout-math.

**§the-`::before`-pseudo-element-as-named-tree-depth-indicator**: the vertical guide line that visually connects parent-to-children. Named CSS-only architecture component, not a JS-managed visual.

## §the-double-`requestAnimationFrame`-for-mobile-DOM-settling (first-explicit-observation)

```typescript
requestAnimationFrame(() => {
  requestAnimationFrame(() => {
    textarea.focus();
    textarea.setSelectionRange(position, position);
  });
});
```

> "This ensures the DOM has fully settled, particularly on mobile browsers where layout may be deferred."

**§the-double-rAF-as-named-cross-browser-DOM-settling-discipline** (first-explicit-observation): one rAF is not enough on mobile; **two nested rAFs ensure the DOM has fully settled** before applying focus. This is a named cross-platform-empirically-discovered fix — a workaround that survives in the design because the alternative (one rAF) silently breaks on mobile.

Listed as Lesson Learned #7: "**`requestAnimationFrame` nesting for mobile.**" — the design knows this is a workaround and surfaces it as such.

## §the-pending-focus-queue-as-named-cross-remount-state (first-explicit-observation)

> "When a block is created (e.g., Enter creates a sibling), the new block doesn't exist in the DOM yet. The focus manager queues the focus request: `focusBlock(newUrl, 'start');` // The block with newUrl hasn't mounted yet. // When it mounts and registers its textarea, the pending focus fires."

**§the-focus-request-queued-against-a-future-DOM-element shape**: the focus manager IS a state machine that can hold a "you should focus this URL when it appears" claim *before* the URL has any DOM representation. **§the-pending-focus-IS-the-bridge-across-the-remount-gap**.

Listed as Lesson Learned #4: "**Focus management is a state machine.** The pattern of 'queue focus for a block that doesn't exist yet' is essential. Any operation that changes tree structure (Enter, Backspace merge, indent, unindent) will destroy and recreate DOM nodes. The focus manager must handle the gap."

§the-tree-structural-operations-destroy-and-recreate-DOM-nodes shape: the design explicitly names this DOM-volatility as the constraint that drives the state-machine design.

## §the-three-vertical-zones-of-the-drop-target (first-explicit-observation)

| Mouse Position | Zone | Visual Indicator | Result |
|---------------|------|------------------|--------|
| Top 25% | Before | Horizontal blue line above | Insert as sibling before |
| Middle 50% | Into | Blue outline around block | Insert as first child |
| Bottom 25% | After | Horizontal blue line below | Insert as sibling after |

**§the-25%-50%-25%-as-named-asymmetric-three-zone-partition** (first-explicit-observation): the middle "into" zone gets **half** the vertical space; the two edges get a quarter each. This is **§the-largest-target-IS-the-default-action** — "into" is the most-common intent for nested outliners and gets the most pixels.

This contrasts with cycle 277's outliner_drag_and_drop.md which named "into" as **the-hardest-zone-to-hit-deserves-the-tiebreaker"** — *the same target was treated as the hard one in one design, and the easy one in another*. §two-cycles-with-different-treatment-of-the-`into`-zone in the same cluster (277 hardest + 285 easiest); §convention-divergence-within-the-cluster.

## §the-Alt-drag-as-named-reference-creation-modifier reaffirmed (cycle 277 first-explicit-observation; second cycle)

> "**Alt/Option + drag**: Create a reference (link) instead of moving"

```typescript
export function getDragMode(altKey: boolean): 'move' | 'reference' {
  return altKey ? 'reference' : 'move';
}
```

**§two-cycles-with-Alt-drag-as-named-reference-creation-modifier** (277 + 285). The shared name across two cluster designs IS the canonicalization.

## §the-auto-expand-on-hover-500ms (first-explicit-observation)

```typescript
export function shouldExpandOnDragHover(
  isCollapsed: boolean,
  hoverDuration: number,
  expandDelay: number = 500
): boolean {
  return isCollapsed && hoverDuration >= expandDelay;
}
```

**§the-named-affordance-with-a-500ms-default-delay** (first-explicit-observation): hovering over a collapsed block during drag auto-expands it after 500ms so you can drop into its children. The default parameter `expandDelay: number = 500` makes the delay overridable but defaults to the empirically-tuned value.

§the-default-parameter-IS-the-canonical-tuning + §the-parameter-IS-named-`expandDelay`-not-`timeout`-or-`delay` — domain-name precision.

## §the-same-parent-index-adjustment (first-explicit-observation)

```typescript
export function adjustDropIndexForSameParent(
  sourceIndices: number[],
  targetIndex: number
): number {
  const countBefore = sourceIndices.filter(i => i < targetIndex).length;
  return targetIndex - countBefore;
}
```

**§the-removal-shifts-the-index pattern** — when moving blocks within the same parent, removing source blocks shifts indices; the design names a dedicated helper that accounts for this. **§the-named-index-adjustment-helper** (first-explicit-observation): a small but non-obvious correctness concern surfaced as its own named function rather than buried in the move logic.

## §the-shift-click-removes-block-AND-descendants from selection (first-explicit-observation)

> "**Shift+Click on selected block:** Remove that block and its descendants from selection"

**§the-batch-operation-treats-block-and-descendants-as-one-unit pattern**: shift-click-deselect doesn't just remove the clicked block — it removes the subtree. This is **§the-tree-IS-the-unit-not-the-node** for selection operations.

§the-named-subtree-aware-operation pattern: deselect-removes-descendants + indent-applies-to-subtree + drag-moves-subtree. Three named operations that treat the subtree as one unit, not the node.

## §the-block-position-registry as named position-data-structure (first-explicit-observation)

```typescript
interface BlockPosition {
  url: BlockId;
  parentUrl: BlockId | null;
  indexInParent: number;
  depth: number;
}
```

**§the-four-named-fields-of-a-block-position** (URL + parentUrl + indexInParent + depth): the *flattened* position record that batch operations use. Compare cycle 282's typedef vocabulary (ArchivedStat = type + mode + date + comment). **§named-position-records-as-named-data-vocabulary** — every batch operation in this design takes a `BlockPosition[]` as input.

## §the-`canBatchIndent`-validation-before-batch-operation discipline (first-explicit-observation)

```typescript
export function canBatchIndent(...): boolean {
  if (direction === 'indent') {
    return selectedBlocks[0].indexInParent > 0;
  } else {
    return selectedBlocks.every(b => b.parentUrl !== null && b.depth > 0);
  }
}
```

**§the-`can`-prefixed-validation-function-before-the-batch-operation pattern**: a named `canX` predicate that checks the operation's validity *for the entire selection* before any change is applied. **§the-batch-validation-IS-all-or-nothing**.

§the-`can`-prefix-as-named-predicate-convention. §the-validation-IS-decoupled-from-the-execution.

## §the-bullet-pattern-regex for paste handling (first-explicit-observation)

```typescript
const BULLET_PATTERN = /^(\s*)(•|-|\*|\+|\d+\.)\s+(.*)$/;
```

**§the-five-bullet-marker-variants-in-one-regex**: `•` (typographic bullet) + `-` (hyphen) + `*` (asterisk) + `+` (plus) + `\d+\.` (numbered). The design tolerates **five named bullet-marker shapes** when parsing pasted text. §the-regex-IS-the-bullet-vocabulary-enumeration.

§the-bullet-pattern-IS-named-as-a-top-level-constant: not buried in a function; the named pattern IS the public-API-shape of the paste parser.

## §the-`{ shift, cmd, alt }`-modifier-object-shape (first-explicit-observation)

```typescript
modifiers: { shift: boolean; cmd: boolean; alt: boolean };
```

**§three-named-keyboard-modifiers-in-one-typed-object** — exactly three; ctrl is absent (the design uses `cmd` to cover Mac AND Windows). **§the-`cmd`-IS-platform-abstracting-name** — even though Windows users press Ctrl, the design uses `cmd` consistently and abstracts the platform difference at the event-translation layer.

§the-modifier-object-IS-the-named-keyboard-context-shape; §two-cycles-with-`{ shift, cmd, alt }`-modifier-object-shape: ? — cycle 271 chat-keyboard-manual-parity may have had a similar pattern.

## §the-7-numbered-Lessons-Learned-with-bold-leading-sentence pattern (first-explicit-observation)

Seven Lessons Learned, each starting with a bolded short sentence summarizing the lesson, followed by explanation:

1. **Measure `.block-row`, not `.block`.**
2. **Textareas over contentEditable.**
3. **Pure behavior functions are the best testing investment.**
4. **Focus management is a state machine.**
5. **Global mouse listeners for drag operations.**
6. **Contiguous-only selection simplifies everything.**
7. **`requestAnimationFrame` nesting for mobile.**

**§the-bold-leading-sentence-as-named-Lesson-Learned-discipline** (first-explicit-observation): each lesson can be cited by its bolded headline alone. This is **§the-citation-form-IS-the-bolded-sentence** — like a paper abstract embedded inline.

§three-named-cumulative-discovery-shapes (cycle 277's Edge-Cases-section as cumulative-discovery-record + cycle 285's Lessons-Learned as numbered-with-bold-citation-form): two shapes for the same goal (preserving discovered-during-implementation knowledge).

## §the-What-Unit-Tests-Catch-vs-E2E-table as named testing-taxonomy-shape (first-explicit-observation)

| Concern | Unit Tests | E2E Tests |
|---------|------------|-----------|
| Decision logic (what action to take) | Yes | — |
| Edge cases in behavior functions | Yes | — |
| Focus actually moves to correct block | — | Yes |
| Cursor position after operations | — | Yes |
| Textarea auto-resize | — | Yes |
| Drag-to-select visual behavior | — | Yes |
| Block creation renders in DOM | — | Yes |
| Cross-browser keyboard handling | — | Yes |

**§the-explicit-taxonomy-of-what-each-test-tier-catches as named testing-discipline-document** (first-explicit-observation). The table explicitly says **"Decision logic" goes to unit + "Visual + state-effect" goes to E2E**. This is **§the-pure-functions-IS-where-the-unit-tests-go + §the-DOM-effects-IS-where-the-E2E-tests-go** as named two-tier testing strategy with a table-based assignment of concerns.

## §the-global-mouse-listeners-on-window-not-container (first-explicit-observation)

> "**5. Global mouse listeners for drag operations.** Always attach mousemove and mouseup to `window` during drag. If you attach them to the container, the drag breaks when the mouse leaves the container boundary."

**§the-event-listener-attached-to-window-IS-the-drag-survival-mechanism** (first-explicit-observation): attaching to the container would limit drag-detection to within container bounds; attaching to window survives mouse-leave-container. This is **§the-listener-scope-IS-the-event-coverage-area** — a named browser-quirk-workaround.

## §the-contiguous-only-selection-IS-a-named-simplification (first-explicit-observation)

> "**6. Contiguous-only selection simplifies everything.** Supporting non-contiguous selection (Ctrl+Click) adds significant complexity to every batch operation. Contiguous ranges are simple to compute, validate, and operate on."

**§the-constraint-IS-the-feature pattern** (first-explicit-observation): the design *deliberately* refuses to support a common spreadsheet/file-manager feature (non-contiguous Ctrl+Click) because supporting it would balloon complexity in batch operations. §two-cycles-with-named-constraint-IS-the-feature: cycle 259 (Page-three-named-non-exposures: §confinement-by-omission as security feature) + cycle 285 (contiguous-only-selection as named-simplification-feature). §the-feature-IS-what-you-DON'T-support.

§twenty-design-docs-from-endo-but-for-bots-designs-cluster-ingested (extends cycle 277's nineteen).

## Patterns from prior cycles, reaffirmed

- **§five-cycles-with-Muddle-attribution-in-the-outliner-cluster** (263 + 273 + 275 + 277 + 285).
- **§four-cycles-with-three-layer-architectures-as-named-design-rationale** (271 + 273 + 277 + 285).
- **§the-Alt-drag-as-named-reference-creation-modifier** (277 + 285) — two cycles in the cluster.
- **§the-cluster-has-four-named-naming-conventions** (cycle 277); this design IS the canonical example of `ALL_CAPS_UNDERSCORES`.
- **§twenty-design-docs-from-endo-but-for-bots-designs-cluster-ingested** (extends 19).

## Borrowing tiers

- **Tier 1 (direct, exact-shape)**: §the-no-metadata-table-shape-as-named-design-doc-variant + §the-three-layer-architecture-with-the-canonical-three-name-choice + §the-`{ type: 'default' }`-action-as-named-pass-through-discipline + §the-explicit-default-as-named-pass-through + §the-textarea-not-contentEditable-decision + §the-four-named-reasons-for-rejecting-the-richer-API + §the-name-the-rejected-feature + §the-`data-url`-on-`.block-row`-not-`.block` + §the-place-the-attribute-on-the-element-whose-rect-IS-the-measurement-target + §the-padding-left-per-depth-IS-the-indentation-mechanism + §the-`::before`-pseudo-element-as-named-tree-depth-indicator + §the-double-`requestAnimationFrame`-for-mobile-DOM-settling + §the-pending-focus-queue-as-named-cross-remount-state + §the-three-vertical-zones-of-the-drop-target + §the-25%-50%-25%-asymmetric-three-zone-partition + §the-largest-target-IS-the-default-action + §the-auto-expand-on-hover-500ms + §the-same-parent-index-adjustment + §the-shift-click-removes-block-AND-descendants + §the-block-position-registry-four-named-fields + §the-`canBatchIndent`-validation-before-batch-operation + §the-bullet-pattern-regex + §the-five-bullet-marker-variants-in-one-regex + §the-`{ shift, cmd, alt }`-modifier-object-shape + §the-7-numbered-Lessons-Learned-with-bold-leading-sentence + §the-What-Unit-Tests-Catch-vs-E2E-table + §the-global-mouse-listeners-on-window-not-container + §the-contiguous-only-selection-IS-a-named-simplification — all twenty-six first-explicit-observations.
- **Tier 2 (clear analogue, named-shape)**: §the-tree-IS-the-unit-not-the-node + §two-cycles-with-different-treatment-of-the-`into`-zone (277 hardest + 285 easiest) + §convention-divergence-within-the-cluster + §the-`cmd`-IS-platform-abstracting-name + §the-citation-form-IS-the-bolded-sentence + §the-pure-functions-IS-where-the-unit-tests-go + §the-DOM-effects-IS-where-the-E2E-tests-go + §the-feature-IS-what-you-DON'T-support + §three-named-cumulative-discovery-shapes (277 Edge-Cases + 285 Lessons-Learned).
- **Tier 3 (multi-cycle pattern recognition)**: §five-cycles-with-Muddle-attribution-in-the-outliner-cluster + §four-cycles-with-three-layer-architectures-as-named-design-rationale + §two-cycles-with-Alt-drag-as-named-reference-creation-modifier + §twenty-design-docs-from-endo-but-for-bots-designs-cluster-ingested + §the-ALL_CAPS_UNDERSCORES-naming-convention-canonical-example-instantiated (cycle 277 enumerated; cycle 285 instantiates).

## Synthesis target

Slot machine library `@game/ui/INTERACTION_PATTERNS.md` (ALL_CAPS_UNDERSCORES naming): three-layer architecture (Behavior + Component + Data) with pure-function behavior layer that returns `GameAction` descriptors including the named `{ type: 'default' }` pass-through; textarea-not-contentEditable for the bet-input field with four named reasons; `data-bet-id` on `.bet-row` not `.bet` for correct rect measurement; padding-left per nesting depth for sub-bets; double-rAF for mobile DOM settling on payout-animation completion; pending-focus queue for the next-spin button; three vertical drop zones for re-ordering bet slips (25%-50%-25% with "into" as easiest target); Alt-drag for copying a bet rather than moving; 500ms hover-to-auto-expand for collapsed parlay groups; same-parent-index-adjustment for re-ordered bets; shift-click on selected bet removes bet AND derived bets; block-position-registry four-named-fields (betId + parentBetId + indexInParent + depth); `canBatchPlace` validation before batch placement; bullet-pattern regex with five named bullet shapes for paste-import of bet histories; `{ shift, cmd, alt }` modifier object with cmd as platform-abstracting name; 7 numbered Lessons Learned with bold-leading-sentence at the end of the document; What-Unit-Tests-Catch-vs-E2E table for game-rule logic vs game-UI effects; global mouse listeners on window for drag-to-reorder-bets; contiguous-only bet selection as named simplification.

## Single most structurally interesting move

**§the-`{ type: 'default' }`-action-as-named-pass-through-discipline** — the design treats "do nothing app-level; let the browser handle it" as **one of the named cases in a closed type union**, not as the absence of a case. This makes the behavior layer a *total function* over keystrokes: every key produces some named action; one of those named actions is "fall through". The total-function discipline means:

1. The type system catches "did you forget to handle this key?" because the union is exhaustive.
2. Tests can assert `{ type: 'default' }` explicitly — a test for "Enter at end + cmd-pressed returns default" is a positive test, not a negative one.
3. The architecture is explicit about its non-interception, not implicit. Every keystroke is *consciously* either intercepted or passed through.

This is **§the-named-no-op-as-named-action** — a discipline that turns "absence of a decision" into "an explicit decision". The pattern generalizes far beyond outliners: any layer that selectively intercepts events can use a `default`-typed action to make pass-through explicit.

§the-closed-discriminated-union-with-an-explicit-no-op-member-IS-the-architectural-discipline. §total-function-over-input-events.
