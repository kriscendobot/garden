---
slug: named-imports-over-namespace
category: style-convention
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr615-review-330a01ca
prs: [615]
---

A namespace/wildcard import of a Node builtin (import * as fs from 'fs') used where only one or two members are needed — Endo prefers named imports (aids reviewers, narrows ambient authority per POLA) and the node: builtin-protocol prefix; no garden seat brief, skill, or gate encodes this yet.
