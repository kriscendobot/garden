---
title: §Same three-layer architecture diagram
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
parent: endo-but-for-bots--llm-designs-outliner-drag-and-drop--two-part-guide-structure-and-twenty-three-numbered-toc-items-and-three-cycles-with-three-layer-architectures-and-named-tiebreaker-discipline-and-the-coexistence-challenge
---

Lines 919-936 carry the **same** three-layer ASCII-art architecture diagram as cycle 273:

- **Behavior Layer (pure functions)** — selection.ts + dragDrop.ts.
- **Component Layer (React)** — SelectionProvider + DragContext + BoundingBoxSelection + Block + BlockBullet.
- **Data Layer (Automerge CRDT)** — BlockHandle.addChild() + removeChild() + tree mutations + sync.

§Three-cycles-with-three-layer-architectures-as-named-design-rationale (271 endor-bus-tui + 273 OUTLINER_INTERACTION_PATTERNS + 277 outliner_drag_and_drop); §the-three-layer-shape-IS-now-canonical-across-three-cycles.

§the-cluster-has-two-named-diagram-conventions confirmed: Mermaid (cycle 267 README) + ASCII-art (cycles 273 + 277).

§First-explicit-observation in library: **§the-exact-three-layer-ASCII-art-diagram-recurs-across-two-outliner-cluster-guides — §the-discipline-IS-shared-substrate-across-two-guides-in-the-same-cluster + §the-author-doesn't-re-derive-the-architecture + §the-cluster-converges-on-one-named-architecture**.
