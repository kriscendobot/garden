---
slug: prefer-endo-primitives
category: style-convention
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr671-review-9737517c
prs: [671]
---

Freshly-authored code hand-rolls or re-implements a primitive (hex, ascii, bytes, base64, sha256, error assertions) that an existing @endo/* package already provides; no juror seat or gate carries the @endo utility catalog, so the missed reuse reaches the maintainer.
