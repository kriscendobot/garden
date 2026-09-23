---
title: "outliner-design-doc-2.md — free-form design fragment without metadata table"
source-slug: endo-but-for-bots--llm-designs-outliner-design-doc-2
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/outliner-design-doc-2.md
authors: [Endo project (unattributed; design fragment style)]
repo: endojs/endo-but-for-bots
path: designs/outliner-design-doc-2.md
total-lines: 10
ingest-cycle: 263
ingest-date: 2026-06-10
lane: designs
---

# `outliner-design-doc-2.md`

A **10-line** prose-only design fragment. **The only design in `endo-but-for-bots/designs/` without the canonical metadata table** (no Status / Created / Updated / Author / Parent fields). Reads as a §design-conversation-not-a-design-doc — a sequence of architectural recommendations and open questions about the outliner UI's protocol-broadcast behavior.

## Key design moves

- **§The template deviation IS the pattern** — the cluster's only design-without-metadata-table; §the-format-IS-evidence-of-the-design's-maturity.
- **§The "-design-doc-2" suffix** — a named follow-up convention; sibling designs are `outliner_drag_and_drop.md` (1020 lines) and `OUTLINER_INTERACTION_PATTERNS.md` (997 lines).
- **§Three named comparison points** — Roam Research + Obsidian + Workflowy as UX-positioning shorthand.
- **§Postpone node creation until cursor leaves or debounced timer expires** — the protocol-broadcast timing is a three-way choice (cursor-leaves OR debounced-timer OR represent-as-edits-later), not an immediate broadcast.
- **§The cursor position IS the natural edit boundary for broadcast timing** — the cursor is the user's focus of attention; when it leaves, the edit is conceptually complete.
- **§Indent/dedent decompose into named protocol edits** — affecting `replyTo` (parent-pointer) + order-of-nodes (visible-order).
- **§Two orderings coexist** — creation-order implicit (via timestamps) + visible-order explicit (via the sidecar).
- **§Sidecar table within the outliner channel** for visible-order without modifying the message schema; §augment-via-named-sidecar-not-by-mutation.
- **§`channel.moveNodeToAfter(node, newPrecursor)`** — capability-based mutation; holding the node IS the authorization to mutate its placement.
- **§Three prose hedges** — *"my current recommendation"*, *"presumably"*, *"or something"* — evidence of active design discussion; §the-fragment-form-IS-the-right-form-for-design-in-flight-because-the-template-implies-stability-the-design-doesn't-have.
- **§A preserved typo** (`or something.f`) — evidence of design-fragment's informal status.

## Section files

- [§Design fragment breaks template + §postpone broadcast until cursor leaves + §sidecar table for visible order + §moveNodeToAfter capability-based mutation](../sections/endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation.md) — full 10-line fragment in scope.

## Ingest scope

Cycle 263 (designs-lane after cycle 262's chat-lane copyArray.js). Full 10-line fragment ingested. **First-explicit-observations (twelve)**: the-template-deviation-IS-the-pattern + the-`-design-doc-2`-suffix-as-named-follow-up + three-named-comparison-points-as-UX-positioning-shorthand + cross-directory-relative-path-as-evidence-of-design-doc-drift + postpone-broadcast-until-correction-window-closes-using-cursor-position-OR-time-as-boundary + "my-current-recommendation"-as-named-tentativeness-marker + the-cursor-position-IS-the-natural-edit-boundary + decompose-atomic-UI-operation-into-named-protocol-edits-on-named-fields + two-orderings-coexist + the-sidecar-lives-within-the-channel + three-prose-hedges-in-one-design-fragment + a-preserved-typo-as-evidence-of-informal-status.
