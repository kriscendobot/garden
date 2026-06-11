---
title: "endo-but-for-bots/packages/chat/designs/outliner_drag_and_drop.md — same-name-different-directory-with-different-content (vs cycle 277's top-level 1020-line file); fractional sort order via (A+B)/2; move reply-type as named modifier; the 4th named design-doc-opening-section name (Features)"
section-slug: endo-but-for-bots--pkg-chat-designs-outliner-drag-and-drop--same-name-different-directory-with-different-content-and-fractional-sort-order-and-move-reply-type
source-slug: endo-but-for-bots--pkg-chat-designs-outliner-drag-and-drop
url: https://github.com/endojs/endo-but-for-bots/blob/master/packages/chat/designs/outliner_drag_and_drop.md
authors: [Endo project (collective)]
status: (no explicit metadata table)
ingest-cycle: 289
ingest-date: 2026-06-11
lane: designs
scope: full
total-lines: 48
---

# `endo-but-for-bots/packages/chat/designs/outliner_drag_and_drop.md` (full design)

A 48-line implementation-guide-style design fragment for the chat package's outliner drag-and-drop feature. **The second file with the same name as a previously-ingested design** — cycle 277 ingested `designs/outliner_drag_and_drop.md` (1020 lines at the top-level); this file lives at `packages/chat/designs/outliner_drag_and_drop.md` and is much smaller (48 lines) with markedly different scope (implementation-level + persistence-protocol vs the top-level's exhaustive UI-pattern guide).

## §two-cycles-with-the-same-design-file-name-in-different-directories (first-explicit-observation)

The endo-but-for-bots repository contains **two files named `outliner_drag_and_drop.md` in different directories**:

- **`designs/outliner_drag_and_drop.md`** (1020 lines, cycle 277) — the comprehensive UI pattern guide attributed to Muddle, Part 1 + Part 2 structure, 23 ToC items, three-layer architecture.
- **`packages/chat/designs/outliner_drag_and_drop.md`** (48 lines, cycle 289) — the chat-package implementation-guide-fragment with code examples and file references.

**Same name, different scope, different audience**. The top-level design is the *cluster-wide* spec; the package-level design is the *chat-package-specific* implementation guide. **§the-same-name-in-two-directories IS the named cross-directory-content shape** — extends cycle 273's §cross-directory-drift (which was a *broken reference*) into a *deliberate-shared-naming* pattern: the package-level file IS named after the cluster-level file it implements.

**§three-cycles-with-cross-directory-naming-evidence in the outliner cluster**: cycle 263 (fragment references `docs/OUTLINER_INTERACTION_PATTERNS.md` — broken cross-directory ref) + cycle 273 (confirms the actual file lives at `designs/...` not `docs/...`) + cycle 289 (same filename in two different `designs/` directories, both valid). §the-outliner-cluster-IS-cross-directory-rich.

## §the-`Features`-section-as-named-design-doc-opening-section-name (first-explicit-observation)

The design opens with `## Features` — yet another opening-section convention, distinct from the prior trio:

- **`## Objective`** (cycle 287 subpath-pattern-replacement)
- **`## Motivation`** (canonical Endo)
- **`## What is the Problem Being Solved?`** (canonical Endo)
- **`## Features`** (cycle 289 chat-outliner-drag-and-drop) ← NEW

**§four-named-opening-section-conventions in the cluster** (extends cycle 287's three-named-opening-section-conventions). The `## Features` naming IS distinctly *catalog-style* — names what the design *provides* in declarative terms; sibling-pattern to product-management feature lists.

§the-Features-naming IS more inventory-than-motivation: it lists *what exists* rather than *why it's wanted*.

## §the-fragment-design-doc-shape-WITH-implementation-details (first-explicit-observation)

Cycle 263's `outliner-design-doc-2.md` was a **tentative fragment** — short prose with hedges, no code, marked-as-incomplete. This file is a **different fragment shape**: **implementation-detail-fragment** with:

- Numbered subsections under `## Features`.
- A code block showing `E(channel).post(...)` API usage with aligned comments.
- A `## Files Modified` section naming source files.
- No prose hedges (no "my current recommendation").
- No `## Status` field but content reads as decided-and-implemented.

**§two-named-design-fragment-shapes-in-the-cluster** (first-explicit-observation): tentative-fragment (cycle 263) + implementation-detail-fragment (cycle 289). The cluster has more than one *kind* of fragment.

§the-fragment-shape-IS-determined-by-its-purpose: tentative-fragment for design-in-flight; implementation-detail-fragment for design-as-implementation-record.

## §the-`Files Modified`-section-at-the-bottom (first-explicit-observation)

The design closes with:

```markdown
## Files Modified
- `outliner-component.js` — Selection state, drag handlers, move processing, DOM reordering
- `index.css` — Selection highlighting, drop indicator, drag ghost, rubber-band rectangle
```

**§the-Files-Modified-section-as-named-blast-radius shape** (first-explicit-observation): a section that *names the files this design touches* with one-line summaries of WHAT each file's role is. This is **§four-cycles-with-named-implementation-blast-radius-shapes**:

- cycle 275 `Affected packages` list (package-set granularity)
- cycle 281 `What changes in the existing library` (library-shape narrative)
- cycle 283 `Affected Designs` table (design-document granularity with per-design relationship)
- cycle 289 `Files Modified` bulleted list (source-file granularity with per-file role summary)

**§four-named-shapes-for-naming-implementation-blast-radius**. Each cycle's design names its blast radius at a *different granularity*: package-set, library-narrative, design-doc, source-file. The granularity matches the design's scope.

## §the-fractional-sort-order-via-`(A+B)/2` (first-explicit-observation)

> "When dropping between nodes with sort orders A and B, the new order = (A + B) / 2."

**§the-`(A+B)/2` insertion-between-existing-items as named-canonical-sort-order pattern** (first-explicit-observation): a classic technique for inserting between items in a sorted list **without renumbering anything**. The fractional value sits between A and B; further insertions sit between adjacent fractional values, ad infinitum (modulo floating-point precision).

**§the-named-floating-point-as-named-insertion-key**: the design uses *floating-point arithmetic* as a stand-in for *insertion order without rebuilds*. Sibling-pattern to many database-row-ordering schemes; sibling-pattern to fractional-indexing crates in collaborative editors.

§the-precision-limit-IS-the-named-trade-off: at some point, `(A + B) / 2` returns A or B due to floating-point precision, but the design names this as not-the-current-concern.

## §the-`MODIFIER_REPLY_TYPES`-named-constant-reference (first-explicit-observation)

> "Reordering is persisted via `move` reply type messages (already declared in `MODIFIER_REPLY_TYPES` in `edit-queue.js`)."

**§the-`MODIFIER_REPLY_TYPES`-as-named-existing-vocabulary**: the design *references an existing constant* in the codebase as the authoritative source for what reply types are valid. The design doesn't *define* the constant; it *invokes* it. §the-design-defers-to-existing-named-vocabulary.

§the-`(already declared in X)`-parenthetical-as-named-existing-implementation-marker: when the design references prior implementation work, the parenthetical names *where* that work lives. §the-named-existing-work-as-context.

## §the-`E(channel).post(...)`-code-example-with-named-comment-aligned-arguments (first-explicit-observation)

```javascript
E(channel).post(
  [String(newSortOrder)],  // fractional sort order
  [],                       // no names
  [],                       // no petNames
  String(targetNodeNumber), // replyTo = node being moved
  [],                       // no ids
  'move'                    // replyType
)
```

**§the-comment-aligned-arguments shape** (first-explicit-observation): each argument has a trailing `//`-comment naming what role it plays in this specific call. **§the-call-site-IS-self-documenting-via-trailing-comments**.

§the-empty-arrays-IS-named-explicitly-by-comment: `[]` arguments have comments saying "no names" + "no petNames" + "no ids" — making the *intentional emptiness* visible. §the-empty-IS-not-the-missing-empty-IS-the-deliberate-empty.

§the-six-positional-parameters-with-trailing-comments IS sibling-pattern to keyword-arguments in languages that lack them; the comments *simulate* named parameters at the call site.

## §five-named-selection-modes (first-explicit-observation)

The Group Selection section enumerates **five named selection modes**:

1. **Click**: Selects a single node (clears other selection).
2. **Cmd/Ctrl+Click**: Toggles individual node in selection.
3. **Shift+Click**: Range-selects between last-clicked and clicked node.
4. **Rubber-band**: Click and drag on empty space to draw a selection rectangle; all nodes whose rows intersect are selected.
5. **Escape**: Clears selection.

**§five-named-keyboard-and-mouse-selection-modes as named-UX-spec-shape**. Compare cycle 285's `OUTLINER_INTERACTION_PATTERNS.md` §the-contiguous-only-selection-IS-a-named-simplification (which deliberately *forbids* non-contiguous Ctrl+Click) — this file *allows* Cmd/Ctrl+Click as a toggle. **§two-cycles-with-different-Cmd/Ctrl+Click-treatment in the outliner cluster** (285 forbids + 289 allows). §convention-divergence-within-the-cluster (third such observation alongside §the-cluster-has-four-named-naming-conventions and cycle 277's into-zone divergence).

## §the-same-parent-constraint as named UI invariant (first-explicit-observation)

> "Same-parent constraint: Nodes can only be reordered among their siblings (same parent). Use Tab/Shift-Tab for reparenting."

**§the-reorder-vs-reparent-as-named-distinct-operations**: drag-and-drop handles ONLY same-parent reordering; reparenting requires Tab/Shift-Tab. **§the-operation-IS-the-named-input**: same-parent-reorder maps to drag; reparenting maps to keyboard. **§the-input-modality-IS-the-named-discriminator**.

§the-tradeoff-IS-named-explicitly: drag-IS-for-reordering + Tab-IS-for-reparenting. Sibling-pattern to cycle 285's interaction-pattern *deliberate-feature-omission* (contiguous-only selection); §three-cycles-with-named-deliberate-omission-disciplines (259 confinement-by-omission + 285 contiguous-only-selection + 289 same-parent-only-drag).

## §the-group-drag-preserves-relative-order as named invariant (first-explicit-observation)

> "Group drag: If multiple nodes are selected, dragging any of them drags the whole selection, preserving relative order."

**§the-named-multi-item-drag-invariant**: dragging-with-selection preserves the order *within* the selection. **§the-relative-order-IS-the-named-preserved-property**. Sibling-pattern to cycle 285's §the-tree-IS-the-unit-not-the-node (drag-moves-subtree); but here it's *flat selection*, not subtree.

§named-the-property-that-must-survive-the-operation: relative-order within the selection. §the-named-invariant IS distinct from §the-explicit-confinement-by-omission — here it's preserving *something* across an operation, not refusing *something else*.

## §the-drag-handle-IS-the-bullet discipline (first-explicit-observation)

> "Drag handle: The bullet point (or collapse handle) on each committed node acts as the drag handle."

**§the-existing-visual-element-IS-the-drag-affordance**: the bullet (already present as a marker) becomes the drag-handle. **§the-affordance-IS-not-new-it-IS-repurposed**. §the-design-avoids-adding-new-UI by reusing existing elements for new purposes.

§the-named-repurposing-discipline IS sibling-pattern to overloading-existing-keys-for-new-modes. Cycle 285's Cmd/Ctrl+Click *adds* a modifier role; cycle 289's bullet-as-drag-handle *adds* a behavior to an existing visual.

## §the-`moveOverrides`-Map-as-named-sort-order-override-mechanism (first-explicit-observation)

> "A `moveOverrides` map tracks `nodeKey → sortOrder` from the latest move message for each node. `getSortedVisibleChildren` uses `moveOverrides` values instead of message numbers when available."

**§the-named-override-Map as-named-sort-state shape** (first-explicit-observation): a Map that *overrides* a default sort key with a per-node fractional value. **§the-default-IS-message-number + the-override-IS-the-fractional-value**.

§the-fallback-chain-IS-named-explicitly: `moveOverrides[nodeKey] ?? messageNumber[nodeKey]`. **§the-`??`-or-the-named-fallback**.

## §the-move-reply-type-as-named-channel-message-shape (first-explicit-observation)

The design uses the **channel's existing reply-type vocabulary** to express the new "move" operation:

- `move` reply type
- `replyTo` = the node being moved
- `String(newSortOrder)` = the new sort order in the message body

**§the-named-channel-API-reuse**: the design doesn't invent a new channel-method or message-format; it extends the existing reply-type vocabulary. **§the-named-extension-IS-via-an-existing-vocabulary**.

§the-`replyTo`-IS-overloaded-as-target-node: in `move` messages, `replyTo` names *what the move targets* (which node is being moved). This is a *semantic overload* of the field that originally meant "this message is a reply to this node". §the-existing-field-IS-repurposed-for-the-new-operation.

§the-three-named-fields-encode-the-move (newSortOrder + targetNodeNumber + 'move'-replyType); §minimal-encoding-via-existing-vocabulary.

## §the-modifier-type-IS-not-visible-as-children named invariant (first-explicit-observation)

> "Move messages are `modifier` type (not visible as children), consistent with edit/deletion."

**§the-`modifier`-type-as-named-message-category**: messages of type `modifier` are *invisible* in the tree view; they only *affect* other messages. Sibling-pattern to git's amend-commits or database UPDATE rows — modifications are not new entities but adjustments to existing ones.

**§three-named-modifier-types-in-the-channel-protocol**: edit + deletion + move. **§the-modifier-category-IS-the-named-class-of-non-content-changes**.

§the-`consistent with X`-as-named-cluster-discipline: the design names the *existing convention* it's joining. §the-explicit-claim-of-consistency-with-prior-work.

## Patterns from prior cycles, reaffirmed

- **§three-cycles-with-no-metadata-table-shape** (285 + 287 + 289).
- **§twenty-one-design-docs-from-endo-but-for-bots-designs-cluster-ingested** (extends 277's 19 + 285's no-bump + 287's 20 = now 21).
- **§the-cluster-has-two-named-designs-trees** (top-level + per-package; cycle 287 named this; cycle 289 instantiates again with a chat-package example).
- **§convention-divergence-within-the-cluster** — three named convergence-divergence pairs now: §four-naming-conventions (cycle 277) + §into-zone-divergence (277 vs 285) + §Cmd/Ctrl+Click-divergence (285 vs 289).
- **§the-outliner-cluster-IS-cross-directory-rich** — same-name-in-two-directories pattern (cycles 263 + 273 + 289).

## Borrowing tiers

- **Tier 1 (direct, exact-shape)**: §two-cycles-with-the-same-design-file-name-in-different-directories + §the-`Features`-section-as-named-design-doc-opening-section-name + §the-fragment-design-doc-shape-WITH-implementation-details + §two-named-design-fragment-shapes-in-the-cluster + §the-`Files Modified`-section-at-the-bottom + §the-Files-Modified-section-as-named-blast-radius-shape + §the-fractional-sort-order-via-`(A+B)/2` + §the-named-floating-point-as-named-insertion-key + §the-`MODIFIER_REPLY_TYPES`-named-constant-reference + §the-design-defers-to-existing-named-vocabulary + §the-`(already declared in X)`-parenthetical-as-named-existing-implementation-marker + §the-`E(channel).post(...)`-code-example-with-named-comment-aligned-arguments + §the-call-site-IS-self-documenting-via-trailing-comments + §the-empty-IS-not-the-missing-empty-IS-the-deliberate-empty + §five-named-selection-modes + §the-same-parent-constraint + §the-reorder-vs-reparent-as-named-distinct-operations + §the-input-modality-IS-the-named-discriminator + §the-group-drag-preserves-relative-order + §the-named-multi-item-drag-invariant + §the-drag-handle-IS-the-bullet + §the-existing-visual-element-IS-the-drag-affordance + §the-affordance-IS-not-new-it-IS-repurposed + §the-`moveOverrides`-Map-as-named-sort-order-override-mechanism + §the-default-IS-message-number-the-override-IS-the-fractional-value + §the-move-reply-type-as-named-channel-message-shape + §the-named-channel-API-reuse + §the-`replyTo`-IS-overloaded-as-target-node + §the-modifier-type-IS-not-visible-as-children + §three-named-modifier-types-in-the-channel-protocol — all thirty first-explicit-observations.
- **Tier 2 (clear analogue, named-shape)**: §four-named-opening-section-conventions (Features + Objective + Motivation + Problem) + §the-Features-naming-IS-more-inventory-than-motivation + §four-named-shapes-for-naming-implementation-blast-radius (275 + 281 + 283 + 289) + §two-cycles-with-different-Cmd/Ctrl+Click-treatment (285 forbids + 289 allows) + §three-cycles-with-named-deliberate-omission-disciplines (259 + 285 + 289).
- **Tier 3 (multi-cycle pattern recognition)**: §three-cycles-with-no-metadata-table-shape (285 + 287 + 289) + §the-outliner-cluster-IS-cross-directory-rich + §convention-divergence-within-the-cluster (multiple instances now) + §twenty-one-design-docs-from-endo-but-for-bots-designs-cluster-ingested.

## Synthesis target

Slot machine library `@game/ui/designs/bet-drag-and-drop.md` (a per-package design fragment, located at `packages/ui/designs/...`): 48-line implementation-detail-fragment with `## Features` opening section + numbered subsections + `E(channel).post(...)`-style code example with comment-aligned arguments + `## Files Modified` section at the bottom naming source files with per-file role summary. The bet-drag-and-drop persistence uses fractional sort orders via `(A+B)/2` for between-bet insertions; `moveOverrides` Map for override-vs-default-sort; bet-bullet as the drag-handle; same-parent-constraint (can only reorder among siblings; Tab/Shift-Tab for reparenting); group-drag preserves relative order within selection; five named selection modes (Click + Cmd/Ctrl+Click + Shift+Click + Rubber-band + Escape); modifier-type messages (edit + deletion + move) are invisible-in-the-tree.

## Single most structurally interesting move

**§two-cycles-with-the-same-design-file-name-in-different-directories** — the repository contains two files named `outliner_drag_and_drop.md`: a 1020-line cluster-wide UI pattern guide at `designs/` (cycle 277) and a 48-line chat-package implementation-detail-fragment at `packages/chat/designs/` (cycle 289). **Same name, different audiences, different scope, distinct purposes**.

This IS the natural shape of layered designs in a monorepo: the cluster-wide design names the pattern; the package-level design names the implementation. The shared name IS NOT a mistake — it's a *deliberate cross-directory naming convention* that links the cluster-spec to its package-implementation by filename alone. **§the-cross-directory-shared-name-IS-the-named-link-mechanism**.

The pattern generalizes to any layered architecture: a top-level *what* document at the cluster level, and a per-package *how* document with the *same filename* at the package level. The reader looking at `outliner_drag_and_drop.md` in the chat package KNOWS to look up the same filename at the top level for the pattern guide. §the-filename-IS-the-cross-document-anchor.

§the-naming-IS-the-navigation: in a repository with this convention, file-name-based search across directories yields the related-documents-at-different-scales.
