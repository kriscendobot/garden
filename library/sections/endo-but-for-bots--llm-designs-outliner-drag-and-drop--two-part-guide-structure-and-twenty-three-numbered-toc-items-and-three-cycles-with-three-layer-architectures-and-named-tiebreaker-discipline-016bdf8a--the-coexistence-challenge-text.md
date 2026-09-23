---
title: §The coexistence challenge — text selection vs block selection
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

Lines 42-44 carry the §named-coexistence-challenge:

> *An outliner needs two completely different selection systems: **text selection** within a single block (handled by the browser natively via `<textarea>`) and **block selection** across multiple blocks (handled by your code). The challenge is making these two coexist without fighting each other.*

§First-explicit-observation in library: **§the-coexistence-challenge-as-named-design-driver — §when-two-systems-must-coexist, §the-design's-first-job-IS-to-prevent-them-from-fighting + §the-challenge-IS-named-explicitly-in-the-opening-paragraph**.

§Two-named-selection-systems:
1. **Text selection** — browser-native; handled by `<textarea>`.
2. **Block selection** — application-code; spans multiple blocks.

§Sibling-pattern to capability-systems' multi-system-coexistence; §the-design-NAMES-the-systems + §the-design-NAMES-the-coexistence-challenge.
