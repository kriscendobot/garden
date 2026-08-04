---
slug: prefer-endo-primitives
category: style-convention
status: open
count: 2
members:
  - endojs-endo-but-for-bots-pr671-review-9737517c
  - endojs-endo-but-for-bots-pr755-review-a0778b2e
prs: [671, 755]
---


Freshly-authored code hand-rolls or re-implements a primitive (hex, ascii, bytes, base64, sha256, error assertions) that an existing @endo/* package already provides; no juror seat or gate carries the @endo utility catalog, so the missed reuse reaches the maintainer.
