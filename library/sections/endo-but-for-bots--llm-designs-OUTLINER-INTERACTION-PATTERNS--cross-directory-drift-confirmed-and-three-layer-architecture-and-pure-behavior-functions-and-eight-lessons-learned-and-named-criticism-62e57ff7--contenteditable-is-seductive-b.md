---
title: §"ContentEditable is seductive but treacherous" — named criticism of an existing browser API
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

Line 985 carries a §named-pejorative on the standard browser `contentEditable` API:

> *ContentEditable is seductive but treacherous.*

§First-explicit-observation in library: **§"X-is-seductive-but-treacherous"-as-named-pejorative-shape — §the-API-LOOKS-like-the-right-tool + §USING-it-leads-to-trouble; §the-prose-IS-rhetorically-amplified + §the-evidence-IS-named-in-the-next-sentence (cursor position tracking + paste handling + cross-browser consistency)**.

§Three-cycles-with-named-criticism-of-existing-API-as-design-justification (245 panic-cluster on `eval` + 272 isWellFormed on `String.prototype.isWellFormed` + 273 contentEditable); §the-discipline-IS-now-canonical-across-three-cycles; §the-cluster-has-a-NAMED-tradition-of-criticizing-platform-APIs-by-name.

§First-explicit-observation in library: **§three-cycles-with-named-criticism-of-existing-API-as-design-justification (245 + 272 + 273) — §the-discipline-IS-now-canonical**.

§The-fix (line 985): *"Cursor position tracking, paste handling, and cross-browser consistency are all dramatically simpler with textareas. The tradeoff (no inline rich text editing) is worth it for an outliner where structure matters more than formatting."*

§Named-tradeoff-acknowledged — §the-design-EXPLICITLY-acknowledges-what-IS-given-up + §the-tradeoff-IS-justified-by-domain-priority (structure matters more than formatting); §sibling-pattern to many engineering-tradeoff conventions.

§First-explicit-observation in library: **§the-domain-priority-as-tradeoff-justification — §"X-matters-more-than-Y"-pattern as named-rationale-shape**.
