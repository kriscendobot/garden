---
title: "endo-but-for-bots/packages/chat/designs/outliner_drag_and_drop.md — same-name-different-directory-with-different-content (vs cycle 277's top-level 1020-line file); the 48-line chat-package implementation guide"
source-slug: endo-but-for-bots--pkg-chat-designs-outliner-drag-and-drop
url: https://github.com/endojs/endo-but-for-bots/blob/master/packages/chat/designs/outliner_drag_and_drop.md
authors: [Endo project (collective)]
repo: endojs/endo-but-for-bots
path: packages/chat/designs/outliner_drag_and_drop.md
total-lines: 48
ingest-cycle: 289
ingest-date: 2026-06-11
lane: designs
---

# `endo-but-for-bots/packages/chat/designs/outliner_drag_and_drop.md`

A 48-line implementation-guide-style design fragment for the chat package's outliner drag-and-drop feature. **The second file with the same name as a previously-ingested design** — cycle 277 ingested the 1020-line top-level `designs/outliner_drag_and_drop.md`; this is the per-package chat implementation-fragment.

## Key moves

- **§two-cycles-with-the-same-design-file-name-in-different-directories** — same name + different scope + different audience; cluster-spec vs package-implementation.
- **§the-`Features`-section-as-named-design-doc-opening-section-name** — fourth opening-section convention alongside Objective + Motivation + Problem.
- **§the-fragment-design-doc-shape-WITH-implementation-details** — §two-named-design-fragment-shapes-in-the-cluster (tentative-fragment cycle 263 + implementation-detail-fragment cycle 289).
- **§the-`Files Modified`-section-at-the-bottom** — names source files + per-file role summary; §four-named-shapes-for-naming-implementation-blast-radius (275 + 281 + 283 + 289).
- **§the-fractional-sort-order-via-`(A+B)/2`** — classic insertion-between-existing-items pattern; named floating-point as insertion-key.
- **§the-`MODIFIER_REPLY_TYPES`-named-constant-reference** — design defers to existing named vocabulary.
- **§the-`(already declared in X)`-parenthetical-as-named-existing-implementation-marker** — design names where prior work lives.
- **§the-`E(channel).post(...)`-code-example-with-named-comment-aligned-arguments** — call-site-IS-self-documenting-via-trailing-comments; empty-IS-not-the-missing-empty-IS-the-deliberate-empty.
- **§five-named-selection-modes** (Click + Cmd/Ctrl+Click + Shift+Click + Rubber-band + Escape); §two-cycles-with-different-Cmd/Ctrl+Click-treatment (285 forbids + 289 allows).
- **§the-same-parent-constraint as named UI invariant** — drag-IS-for-reordering + Tab-IS-for-reparenting; the-input-modality-IS-the-named-discriminator.
- **§the-group-drag-preserves-relative-order as named multi-item invariant** — the-relative-order-IS-the-named-preserved-property.
- **§the-drag-handle-IS-the-bullet** — the-existing-visual-element-IS-the-drag-affordance; the-affordance-IS-not-new-it-IS-repurposed.
- **§the-`moveOverrides`-Map-as-named-sort-order-override-mechanism** — the-default-IS-message-number + the-override-IS-the-fractional-value.
- **§the-move-reply-type-as-named-channel-message-shape** — design extends existing channel API rather than inventing new.
- **§the-`replyTo`-IS-overloaded-as-target-node** — semantic-overload of existing field for new operation.
- **§the-modifier-type-IS-not-visible-as-children** — three named modifier-types-in-the-channel-protocol (edit + deletion + move); modifications-are-not-new-entities.
- **§three-cycles-with-no-metadata-table-shape** (285 + 287 + 289).
- **§the-outliner-cluster-IS-cross-directory-rich** — same-name-in-two-directories pattern (cycles 263 + 273 + 289).
- **§twenty-one-design-docs-from-endo-but-for-bots-designs-cluster-ingested**.

## Section files

- [§Same-name-different-directory + §fractional-sort-order-via-(A+B)/2 + §move-reply-type + §the-4th-named-design-doc-opening-section-name (Features) + 27 more first-explicit-observations](../sections/endo-but-for-bots--pkg-chat-designs-outliner-drag-and-drop--same-name-different-directory-with-different-content-and-fractional-sort-order-and-move-reply-type.md) — full 48-line design in scope.

## Ingest scope

Cycle 289 (designs-lane after cycle 288 chat-lane @endo/zip/src/{deflate,inflate}.js pair + correction-cycle). Full 48-line design in scope. **First-explicit-observations (thirty)**: two-cycles-with-the-same-design-file-name-in-different-directories + the-`Features`-section-as-named-design-doc-opening-section-name + the-fragment-design-doc-shape-WITH-implementation-details + two-named-design-fragment-shapes-in-the-cluster + the-`Files Modified`-section-at-the-bottom + the-Files-Modified-section-as-named-blast-radius-shape + the-fractional-sort-order-via-`(A+B)/2` + the-named-floating-point-as-named-insertion-key + the-`MODIFIER_REPLY_TYPES`-named-constant-reference + the-design-defers-to-existing-named-vocabulary + the-`(already declared in X)`-parenthetical + the-`E(channel).post(...)`-code-example + the-call-site-IS-self-documenting-via-trailing-comments + the-empty-IS-not-the-missing-empty-IS-the-deliberate-empty + five-named-selection-modes + the-same-parent-constraint + the-reorder-vs-reparent-as-named-distinct-operations + the-input-modality-IS-the-named-discriminator + the-group-drag-preserves-relative-order + the-named-multi-item-drag-invariant + the-drag-handle-IS-the-bullet + the-existing-visual-element-IS-the-drag-affordance + the-affordance-IS-not-new-it-IS-repurposed + the-`moveOverrides`-Map-as-named-sort-order-override-mechanism + the-default-IS-message-number-the-override-IS-the-fractional-value + the-move-reply-type-as-named-channel-message-shape + the-named-channel-API-reuse + the-`replyTo`-IS-overloaded-as-target-node + the-modifier-type-IS-not-visible-as-children + three-named-modifier-types-in-the-channel-protocol.
