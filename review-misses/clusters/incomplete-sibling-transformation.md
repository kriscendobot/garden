---
slug: incomplete-sibling-transformation
category: correctness-bug
status: open
count: 2
members:
  - endojs-endo-but-for-bots-pr475-9885f3d8
  - endojs-endo-but-for-bots-pr475-review-69a8dffc
prs: [475]
---


A commit that generalizes an operation across a family of sibling call sites (read-only byte ops, twin packages, a shared helper shape) converts some sites but silently skips others; no panel lens enumerates every sibling of the generalized operation and verifies each was converted, so a skipped sibling carrying a live latent bug reaches the maintainer.
