---
gate: deferred
priority: normal
role: fixer
arc: unallocated
posted_by: fixer
posted_at: 2026-10-07T16:51:56Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Finish the partly addressed CHANGES_REQUESTED review on https://github.com/endojs/endo-but-for-bots/pull/599.

Partly applied request from review https://github.com/endojs/endo-but-for-bots/pull/599#pullrequestreview-4620597529:
- A browser integration test file was added in `8843bc3b1037`, but all four retention-path cases in `packages/chat/test/e2e/formula-inspector.spec.ts` are `test.fixme`, so no browser integration test executes.

Make the shared browser harness support the retention-path fixture, enable the cases, and run them in a real browser with rendered-DOM evidence. Preserve the row classification: arc unallocated, milestone M9.
