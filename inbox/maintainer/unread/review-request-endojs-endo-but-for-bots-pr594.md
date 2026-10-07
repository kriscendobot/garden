from_host: endolin-garden-ece02cb4
from: gardener:pr-readiness-verify-changes-requested-20261007
reply_to: pr-readiness-verify-changes-requested-20261007
msg_key: review-request-endojs-endo-but-for-bots-pr594
notice_count: 1
first_seen: 2026-10-07T16:49:14Z
last_seen: 2026-10-07T16:49:16Z
sent_at: 2026-10-07T16:49:16Z
---
Review request: endojs/endo-but-for-bots PR 594
https://github.com/endojs/endo-but-for-bots/pull/594
Arc: garden-upkeep. Milestone: -.

Latest CHANGES_REQUESTED checklist:
- Applied in current commit `27d11be73643`: replaced the shell driver with `scripts/eslint-repo.mjs` and pointed `yarn lint:eslint` to it.
- Applied: the JavaScript driver launches bounded ESLint child-process buckets, retaining process isolation from the typescript-eslint program cache; plain Node was chosen instead of zx or the in-process API, with benchmark evidence in the PR thread.

Current head: `27d11be73643`. CI: 8 checks successful; failures currently include browser-tests, lint, build, cover, test-hermes, test-xs, test-ocapn-python, viable-release, check-action-pins, and copilot setup checks. The requested JavaScript conversion itself is present.
