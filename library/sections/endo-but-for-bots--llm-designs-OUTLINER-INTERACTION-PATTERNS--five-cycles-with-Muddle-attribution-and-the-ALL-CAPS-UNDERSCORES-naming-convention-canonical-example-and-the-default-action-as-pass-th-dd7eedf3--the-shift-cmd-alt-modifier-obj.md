---
title: §the-`{ shift, cmd, alt }`-modifier-object-shape (first-explicit-observation)
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

```typescript
modifiers: { shift: boolean; cmd: boolean; alt: boolean };
```

**§three-named-keyboard-modifiers-in-one-typed-object** — exactly three; ctrl is absent (the design uses `cmd` to cover Mac AND Windows). **§the-`cmd`-IS-platform-abstracting-name** — even though Windows users press Ctrl, the design uses `cmd` consistently and abstracts the platform difference at the event-translation layer.

§the-modifier-object-IS-the-named-keyboard-context-shape; §two-cycles-with-`{ shift, cmd, alt }`-modifier-object-shape: ? — cycle 271 chat-keyboard-manual-parity may have had a similar pattern.
