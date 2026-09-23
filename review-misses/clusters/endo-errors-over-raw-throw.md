---
slug: endo-errors-over-raw-throw
category: style-convention
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr160-review-9858a782
prs: [160]
---

Freshly-authored Endo package code throws raw `new Error(...)` (or hand-rolls a raw-JS equivalent like `new TextDecoder`) where the pervasive Endo house convention is the idiomatic `@endo/errors` `Fail`/`assert`/`q` (and sibling `@endo/*` utilities); no garden seat brief, skill, or gate encodes this yet.
