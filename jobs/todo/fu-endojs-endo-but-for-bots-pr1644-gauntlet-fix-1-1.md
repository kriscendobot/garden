---
posted_at: 2026-11-03T07:38:36Z
handler-timeout: 10800
tier: mentor
fallback-tier: minion
dispatch: automatic
---

In endojs/endo-but-for-bots, PR 1644 (https://github.com/endojs/endo-but-for-bots/pull/1644), the macOS CI leg failed on the Node 24 undici ClientDestroyedError flake. Rerun only the failed jobs (`gh run rerun --failed`) and report the result. If the bot lacks Actions write access, or the failure recurs in the real-provider test, record that in the report and do not change the PR diff.
