---
title: §The "deliberate choice — into deserves the tiebreaker" pattern
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

Lines 980 (in Edge Cases):
> *At exactly 25% or 75%, the middle "into" zone wins (because the conditions are `< 0.25` and `> 0.75`). This is a deliberate choice — "into" is the hardest zone to hit, so it deserves the tiebreaker.*

§First-explicit-observation in library: **§the-named-tiebreaker-discipline-with-named-rationale — §when-two-zones-touch-at-a-boundary, §one-wins-by-deliberate-choice + §the-rationale-IS-"the-hardest-zone-deserves-the-tiebreaker" + §the-discipline-IS-difficulty-of-target-determines-tiebreaker-winner**.

§Sibling-pattern to many UI conventions where the harder-to-hit target gets the larger hit-zone (Fitts's Law applied to boundary-tiebreakers).

§The-`< 0.25`-and-`> 0.75`-conditions encode the tiebreaker structurally — §when-the-conditions-are-strict-inequalities, §the-equality-falls-through-to-the-middle-(into)-case + §the-code-encodes-the-design-choice-without-needing-an-explicit-else-branch.
