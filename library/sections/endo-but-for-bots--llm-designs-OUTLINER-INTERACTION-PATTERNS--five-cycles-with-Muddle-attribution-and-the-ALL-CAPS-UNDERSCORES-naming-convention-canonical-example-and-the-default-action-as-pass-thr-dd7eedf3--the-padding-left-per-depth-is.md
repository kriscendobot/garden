---
title: §the-padding-left-per-depth-IS-the-indentation-mechanism (first-explicit-observation)
section-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--five-cycles-with-Muddle-attribution-and-the-ALL-CAPS-UNDERSCORES-naming-convention-canonical-example-and-the-default-action-as-pass-through-and-three-vertical-zones-and-double-rAF-for-mobile
source-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/OUTLINER_INTERACTION_PATTERNS.md
authors: [Endo project (with attribution to Muddle project)]
status: (no explicit metadata table)
ingest-cycle: 285
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 996
parent: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--five-cycles-with-Muddle-attribution-and-the-ALL-CAPS-UNDERSCORES-naming-convention-canonical-example-and-the-default-action-as-pass-through-and-three-vertical-zones-and-double-rAF-for-mobile
---

Indentation IS `padding-left: ${depth * 24}px` on the bullet container — **not** CSS nesting rules. **The tree structure is real (nested DOM), but visual indentation is controlled by this padding rather than CSS nesting rules.** A vertical guide line is drawn with a `::before` pseudo-element on `.block-children`.

§the-DOM-tree-IS-nested-but-the-visual-indentation-IS-controlled-by-padding-not-CSS-nesting — a named separation of structural-tree vs visual-tree. The DOM tree carries semantic structure (parent-child); the padding carries visual layout. They could be made consistent by relying on CSS nested-margin; instead, the design uses the padding mechanism for predictable layout-math.

**§the-`::before`-pseudo-element-as-named-tree-depth-indicator**: the vertical guide line that visually connects parent-to-children. Named CSS-only architecture component, not a JS-managed visual.
