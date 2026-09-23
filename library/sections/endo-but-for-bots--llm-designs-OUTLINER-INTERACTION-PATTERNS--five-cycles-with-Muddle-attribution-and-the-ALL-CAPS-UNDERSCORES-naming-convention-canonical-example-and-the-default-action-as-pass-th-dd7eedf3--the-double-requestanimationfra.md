---
title: §the-double-`requestAnimationFrame`-for-mobile-DOM-settling (first-explicit-observation)
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
requestAnimationFrame(() => {
  requestAnimationFrame(() => {
    textarea.focus();
    textarea.setSelectionRange(position, position);
  });
});
```

> "This ensures the DOM has fully settled, particularly on mobile browsers where layout may be deferred."

**§the-double-rAF-as-named-cross-browser-DOM-settling-discipline** (first-explicit-observation): one rAF is not enough on mobile; **two nested rAFs ensure the DOM has fully settled** before applying focus. This is a named cross-platform-empirically-discovered fix — a workaround that survives in the design because the alternative (one rAF) silently breaks on mobile.

Listed as Lesson Learned #7: "**`requestAnimationFrame` nesting for mobile.**" — the design knows this is a workaround and surfaces it as such.
