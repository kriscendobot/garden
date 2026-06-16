---
title: §Inline testing examples in prose design doc
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

Lines 944-972 carry §two-inline-testing-examples — actual JavaScript `it(...)` test cases embedded in the prose:

```javascript
it('Shift+Click on selected block removes it and descendants', () => { ... });
it('middle of block returns into zone', () => { ... });
```

§First-explicit-observation in library: **§inline-testing-examples-in-prose-design-doc — §the-design-doesn't-just-DESCRIBE-the-pure-functions + §it-SHOWS-them-being-tested + §the-example-IS-the-evidence-of-testability + §sibling-pattern to literate-programming conventions**.

§Sibling-pattern to many engineering documents' "show, don't tell" discipline; §the-design-doc-IS-its-own-testing-tutorial.
