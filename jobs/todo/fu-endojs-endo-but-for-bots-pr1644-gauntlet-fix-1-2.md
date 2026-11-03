---
posted_at: 2026-11-03T07:38:43Z
handler-timeout: 10800
tier: mentor
fallback-tier: minion
dispatch: automatic
---

In endojs/endo-but-for-bots, PR 1644 (https://github.com/endojs/endo-but-for-bots/pull/1644), check whether `Fail` redacts the substituted values in `requestSummary`'s error message before it reaches the host's `/compact failed:` reply. Reproduce this with a small test. If it is a real bug, fix it on the PR branch with a regression test. If it is not, report that and change nothing.
