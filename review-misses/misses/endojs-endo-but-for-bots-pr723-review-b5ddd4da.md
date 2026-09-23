---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr723-review-b5ddd4da
verdict: miss
category: style-convention
pr: 723
cluster: async-notification-dispatch
cluster_pattern: Notifications/events are dispatched synchronously rather than on a separate turn (Promise.resolve().then); no seat enforces the async-dispatch discipline.
review_at: 2026-07-29T02:35:02Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/723#pullrequestreview-4803487425
identity: endojs/endo-but-for-bots#723:review:4803487425
missed_by: purist
severity: minor
consolidated_pass: review-retrospective-consolidated-20260804
---

Notifications should always be dispatched on a separate turn (e.g. Promise.resolve().then), not synchronously — an Endo async-dispatch discipline the panel did not enforce on an http-client.
