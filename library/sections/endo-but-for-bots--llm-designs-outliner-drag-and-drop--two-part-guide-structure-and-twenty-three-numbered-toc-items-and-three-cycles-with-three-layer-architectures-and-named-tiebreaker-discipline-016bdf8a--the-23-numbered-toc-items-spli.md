---
title: §The 23-numbered ToC items split across two Parts
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
