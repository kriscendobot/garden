---
slug: incomplete-rename-old-name-sweep
category: naming
status: open
count: 2
members:
  - endojs-endo-but-for-bots-pr475-review-c85b88c9
  - kriscendobot-minion.town-pr62-review-353e723b
prs: [475, 62]
---


A rename lands the new identifiers but review does not sweep the whole PR for the old names, so stale references to the pre-rename byte API survive in code.
