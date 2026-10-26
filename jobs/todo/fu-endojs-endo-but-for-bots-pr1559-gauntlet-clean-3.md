---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

In endojs/endo-but-for-bots, rerun the failed `test (24.x, macos-15)` leg (the floot failure) on PR https://github.com/endojs/endo-but-for-bots/pull/1559 with `gh run rerun --failed`. Do not touch the PR diff. If it fails again, report the failure and don't loop.
