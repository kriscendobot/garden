---
title: §"requestAnimationFrame nesting for mobile" — named-platform-specific-workaround
source-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS
section-slug: cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-of-contentEditable
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/OUTLINER_INTERACTION_PATTERNS.md
source-repo: endojs/endo-but-for-bots
source-path: designs/OUTLINER_INTERACTION_PATTERNS.md
source-author: Endo project (with attribution to Muddle project)
total-lines: 997
ingest-cycle: 273
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
parent: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-of-contentEditable
---

Lesson 7 (line 995): *"A single rAF is not enough on mobile browsers. Two nested rAF calls ensure the DOM has fully settled before applying focus."*

§First-explicit-observation in library: **§named-platform-specific-workaround-with-named-platform (mobile browsers) and named-cardinality-fix (two nested rAF calls)**.

§Sibling-pattern to many browser-specific workarounds in JS UI libraries; §the-discipline-IS-the-acknowledgment-IS-the-workaround.
