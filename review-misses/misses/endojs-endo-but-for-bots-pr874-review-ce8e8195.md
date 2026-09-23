---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr874-review-ce8e8195
verdict: miss
category: correctness-bug
pr: 874
cluster: fetch-response-ok-ordering
cluster_pattern: HTTP client code checks response.ok after consuming the body (await response.json()), mis-ordering error handling; a control-flow bug the panel missed.
review_at: 2026-07-29T16:14:53Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/874#pullrequestreview-4810508061
identity: endojs/endo-but-for-bots#874:review:4810508061
missed_by: breaker
severity: minor
consolidated_pass: review-retrospective-consolidated-20260804
---

The google-sheets client checks response.ok AFTER awaiting response.json(), so an error body is consumed/parsed before the status is checked. A control-flow bug the panel missed.
