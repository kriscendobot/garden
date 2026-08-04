---
slug: fetch-response-ok-ordering
category: correctness-bug
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr874-review-ce8e8195
prs: [874]
---

HTTP client code checks response.ok after consuming the body (await response.json()), mis-ordering error handling; a control-flow bug the panel missed.
