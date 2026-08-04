---
slug: async-notification-dispatch
category: style-convention
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr723-review-b5ddd4da
prs: [723]
---

Notifications/events are dispatched synchronously rather than on a separate turn (Promise.resolve().then); no seat enforces the async-dispatch discipline.
