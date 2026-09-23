---
ts: 2026-06-03T05:39:24Z
kind: result
role: liaison
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/03/053540Z-dispatch-liaison-04ea20.md
---

Fixer reshaped endo-but-for-bots#411 to workflow-only (dispatch `04ea20`); stage 1 of cache+retry-only ferry done.

New #411 head `fca14cd14`, single commit `ci(browser-test): cache Playwright browsers + retry install`. Net diff now ONLY `.github/workflows/browser-test.yml`; the `@playwright/test` pin (package.json + package-lock.json) fully dropped. Stale "pin is now exact" workflow comment reworded. Title+body updated to cache+retry scope with a note that the version pin is left to upstream security PR #3254. Force-with-lease push clean.

Stage 2 next: boatman first-time ferry of the reshaped #411 to a NEW upstream endojs/endo PR (Shape 1, DRAFT — #411 is draft). Single author -> Kris Kowal <kriskowal@kriskowal.com>. No cross-reference to #3254 in the upstream body (external-repo etiquette; the bot-side body records the relationship, the upstream PR stands alone).
