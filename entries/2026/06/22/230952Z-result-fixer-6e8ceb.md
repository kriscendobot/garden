---
ts: 2026-06-22T23:09:52Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/22/230500Z-dispatch-liaison-6e8ceb.md
---

PR #290 — swap `@mariozechner/pi-*` to `@earendil-works/pi-*` per
0xpatrickdev comment 3453444108.

Files touched:
- `packages/lal/package.json`: `@mariozechner/pi-agent-core@^0.73.1` and
  `@mariozechner/pi-ai@^0.73.1` replaced by `@earendil-works/pi-agent-core@^0.79.0`
  and `@earendil-works/pi-ai@^0.79.0`
- `packages/lal/agent.js`: import statements and `@import` JSDoc tags updated
- `packages/lal/test/pi-agent-tools.test.js`: import statements and file-level
  comment updated
- `packages/lal/test/smallcaps-footgun.test.js`: import statements updated
- `packages/lal/README.md`: package names in prose updated
- `packages/lal/LAL-ARCHITECTURE.md`: package names in prose updated
- `yarn.lock`: regenerated (lockfile in separate commit)

Commits:
- `a2a52c4b6` — refactor(lal): swap pi-agent-core/pi-ai to @earendil-works per llm convention (#290 patrickdev)
- `a57e6a3f5` — chore: Update yarn.lock

Lease anchor: `8bc4fa95e`. Force-pushed to `feat/lal-pi-harness`.

Tests: `corepack yarn workspace @endo/lal test` — 17 passed, 1 skipped (LAL_HOST env not set; unrelated to this change).

Inline reply posted on comment 3453444108:
https://github.com/endojs/endo-but-for-bots/pull/290#discussion_r3456014254

Comment 3453545144 (vendoring restoration) was out of scope and not addressed.

Self-improvement: nothing this time.
