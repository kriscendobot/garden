---
title: §"The single most important architectural decision"
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

Line 54:
> *The single most important architectural decision: **all interaction logic lives in pure functions that are independent of React, the DOM, and the data layer.***

§First-explicit-observation in library: **§the-"single-most-important-architectural-decision"-as-named-design-prose-discipline — §the-prose-EXPLICITLY-NAMES-the-most-important-decision + §the-reader-knows-which-decision-IS-load-bearing-without-having-to-infer**.

§Sibling-pattern to cycle 269's "single most structurally interesting move" — both designs name the central insight explicitly; §two-cycles-with-the-explicit-named-central-decision (269 + 273).

§"all interaction logic lives in pure functions that are independent of React, the DOM, and the data layer" — §the-three-named-independences-IS-the-testability-claim; §sibling-pattern to many functional-architecture conventions.
