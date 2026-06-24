---
title: §Synthesis target — slot machine library
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

§The-Part-1-and-Part-2-discipline-for-large-guides applies to the §game-engine-cluster:

- §**`game-engine-mechanics-and-betting.md`** as a §two-part-guide-structure (Part 1: Game Mechanics + Part 2: Betting Mechanics).
- §**23-numbered ToC** items spanning both Parts with monotonic numbering.
- §**Same three-layer architecture** as the cluster's other guides — game-behavior-layer + game-component-layer + game-data-layer.
- §**Named tiebreaker discipline** for boundary cases (e.g., when a bet falls at exactly the edge of a roll's payout zone).
- §**Edge Cases section** as the third named rationale section (alongside Design Decisions and Lessons Learned).
- §**Inline testing examples** in the prose design doc — `it('...')` test cases showing pure-function testability.
- §**The coexistence challenge** — when two game systems must coexist without fighting each other (e.g., game-rule + game-UI).
- §**Alt-drag-as-named-modifier** for game-rule reference creation (vs. game-rule movement).
