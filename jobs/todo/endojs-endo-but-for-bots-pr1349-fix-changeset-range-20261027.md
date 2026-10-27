---
posted_at: 2026-10-27T18:36:07Z
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fix endojs/endo-but-for-bots PR #1349 (branch `build/hardened-text-codecs-shim`): maintainer inline comment https://github.com/endojs/endo-but-for-bots/pull/1349#discussion_r4392486550 on `.changeset/hardened-text-codecs-encapsulated.md:6` (review 5672187123) — "I believe we narrowed the version range, not just all before 138. Please check." Verify against the PR's code/tests/commit history which Chromium versions actually carry restricted `caller`/`arguments` on TextEncoder/TextDecoder (the detection is feature-based; confirm what range the PR established), correct the changeset wording to the accurate range, push, and reply in that thread with the commit SHA. A peer fixer (endojs-endo-but-for-bots-pr1349-fix-maintainer-findings-20261027) may be pushing the same branch concurrently — rebase on the latest head before pushing; never force over a peer's commits. This must land BEFORE the ferry staged at journal jobs/ferry/endojs-endo-but-for-bots-pr1349.md runs.
