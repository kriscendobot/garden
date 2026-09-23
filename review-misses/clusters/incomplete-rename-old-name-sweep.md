---
slug: incomplete-rename-old-name-sweep
category: naming
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr475-review-c85b88c9
prs: [475]
---

A rename lands the new identifiers but review does not sweep the whole PR for the old names, so stale references to the pre-rename byte API survive in code.
