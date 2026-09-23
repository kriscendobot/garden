---
title: §the-auto-expand-on-hover-500ms (first-explicit-observation)
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
export function shouldExpandOnDragHover(
  isCollapsed: boolean,
  hoverDuration: number,
  expandDelay: number = 500
): boolean {
  return isCollapsed && hoverDuration >= expandDelay;
}
```

**§the-named-affordance-with-a-500ms-default-delay** (first-explicit-observation): hovering over a collapsed block during drag auto-expands it after 500ms so you can drop into its children. The default parameter `expandDelay: number = 500` makes the delay overridable but defaults to the empirically-tuned value.

§the-default-parameter-IS-the-canonical-tuning + §the-parameter-IS-named-`expandDelay`-not-`timeout`-or-`delay` — domain-name precision.
