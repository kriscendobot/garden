---
title: "§the-`{ type: 'default' }`-action-as-named-pass-through-discipline (first-explicit-observation)"
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

Behavior functions return action descriptors. **One named action — `{ type: 'default' }` — means "let the browser handle this normally."** The doc names this as critical:

> "The `{ type: 'default' }` action is critical — it means 'let the browser handle this normally.' Most keystrokes fall through to default behavior. The behavior layer only intercepts keys at meaningful boundaries."

This is **§the-behavior-layer-only-intercepts-keys-at-meaningful-boundaries** as a named *minimal-intervention discipline*. The default action is the **enumerated identity** of the pass-through. Without naming it, the architecture would have either an early-return or a thrown exception; the explicit named action keeps the type union closed.

**§the-explicit-default-as-named-pass-through-IS-the-discriminated-union-discipline**: a closed union (every keystroke produces some named action) with one of the members explicitly being "do nothing app-level". §the-named-no-op-as-named-action shape — first-explicit-observation.
