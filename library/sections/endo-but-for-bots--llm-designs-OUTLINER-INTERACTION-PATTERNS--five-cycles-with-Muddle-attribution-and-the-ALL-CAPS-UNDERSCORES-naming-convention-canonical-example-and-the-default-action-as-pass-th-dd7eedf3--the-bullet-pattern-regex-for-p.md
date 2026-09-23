---
title: §the-bullet-pattern-regex for paste handling (first-explicit-observation)
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
const BULLET_PATTERN = /^(\s*)(•|-|\*|\+|\d+\.)\s+(.*)$/;
```

**§the-five-bullet-marker-variants-in-one-regex**: `•` (typographic bullet) + `-` (hyphen) + `*` (asterisk) + `+` (plus) + `\d+\.` (numbered). The design tolerates **five named bullet-marker shapes** when parsing pasted text. §the-regex-IS-the-bullet-vocabulary-enumeration.

§the-bullet-pattern-IS-named-as-a-top-level-constant: not buried in a function; the named pattern IS the public-API-shape of the paste parser.
