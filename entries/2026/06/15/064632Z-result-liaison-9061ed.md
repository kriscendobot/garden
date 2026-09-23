---
ts: 2026-06-15T06:46:32Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/15/064136Z-dispatch-liaison-230994.md
---

Boatman first-time ferry of the pivoted bots#411 -> **new upstream endojs/endo#3303** (DRAFT) complete (dispatch `230994`).

#3303 https://github.com/endojs/endo/pull/3303 - branch `kriskowal-playwright-1.60` (fresh; NOT the closed #3296's branch), head `765760f0c`, base master 315533fff, MERGEABLE. ONE commit `ci(browser-test): pin @playwright/test to 1.60.0` (Kris Kowal author+committer, trailer gate EMPTY): pin browser-test/package.json `^1.49.1`->`1.60.0` + folded lockfile (cherry-picked clean, no regen). Body tells the root-cause story (Playwright 1.57-1.59.x archive-extraction hang on Node 24.16, fixed in 1.60.0); no mention of closed #3296. CI pending.

**The #411 arc:** opened DRAFT #3296 (cache+retry workaround) -> 5 rounds of ff-appends (timeout/pin-1.58.2/DEBUG/retry-timeout) -> maintainer CLOSED #3296 -> bot found the real root cause (a Playwright bug, fixed in 1.60) and pivoted to a 2-commit minimal pin -> maintainer chose a NEW PR -> #3303. Cross-link 4609459462 repointed #3296 -> #3303. The workaround stack is obsoleted by the upstream-version fix.
