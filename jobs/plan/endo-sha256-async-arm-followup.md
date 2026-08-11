---
gate: deferred
priority: normal
role: fixer
posted_by: fixer
posted_at: 2026-08-11T21:50:16Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Follow up on https://github.com/endojs/endo-but-for-bots/pull/903 by adding a `@endo/sha256/async` export arm as the asynchronous analogue of `@endo/sha256`. The async browser condition may use Web Crypto, while the synchronous `@endo/sha256` browser condition cannot because its API must return before a promise settles. Design and implement the conditional exports, API, tests, documentation, and changeset.
