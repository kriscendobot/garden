---
title: §The Edge Cases section as named cumulative discovery record
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
