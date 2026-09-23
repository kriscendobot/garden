---
slug: name-contradicts-value-type
category: naming
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr475-review-5b54f00b
prs: [475]
---

A parameter or variable keeps a name that denotes one type (buffer → ArrayBuffer) while now holding a value of a different, non-matching type (a Uint8Array/TypedArray) — usually a stale remnant after a type-narrowing refactor; no naming seat flags a name whose token contradicts the adjacent JSDoc/inferred type, even though the stylist's own surface already forbids "a name that lies about what the value is."
