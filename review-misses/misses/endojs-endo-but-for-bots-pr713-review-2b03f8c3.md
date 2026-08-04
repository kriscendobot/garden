---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr713-review-2b03f8c3
verdict: miss
category: style-convention
pr: 713
cluster: avoid-this-in-exo-methods
cluster_pattern: Freshly-authored Endo code uses this in concise methods rather than lexical function expressions returning a bag of functions; no seat/skill/gate encodes the no-this house style.
review_at: 2026-07-29T00:00:13Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/713#pullrequestreview-4802848515
identity: endojs/endo-but-for-bots#713:review:4802848515
missed_by: purist
severity: major
consolidated_pass: review-retrospective-consolidated-20260804
---

Maintainer's only requested change: "We don't use `this`. Move all these concise methods into function expressions so they can call each other lexically and return a bag of functions." A standing Endo house style not encoded in any seat/skill/gate.
