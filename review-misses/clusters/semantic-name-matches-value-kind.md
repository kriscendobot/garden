---
slug: semantic-name-matches-value-kind
category: naming
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr475-review-5453eefb
prs: [475]
---

A parameter or local is named for a related but different representation (such as calling a Uint8Array `buffer`), producing expressions where the same word denotes both the wrapper and its backing value; review checks behavior and types but does not compare each identifier's name with its declared and accessed value kind.
