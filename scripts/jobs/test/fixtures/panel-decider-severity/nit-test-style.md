**Verdict:** request-changes

**Findings:**
- `test/queue.test.js:55` — the drain-order test asserts each element with three `t.is` calls; prefer one `t.deepEqual` against the expected array. The behavior is already pinned either way. [rule: skills/test-title-spec-spelling/SKILL.md]
- `test/queue.test.js:12` — test title "works" should describe the behavior, for example "drainQueue returns items in insertion order". [rule: skills/test-title-spec-spelling/SKILL.md]
