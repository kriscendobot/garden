---
ts: 2026-06-03T05:35:40Z
kind: dispatch
role: liaison
repo: endojs/endo-but-for-bots
project: endo
refs: []
---

Dispatched fixer (dispatch-root `dispatches/fixer--04ea20`) to **reshape** endo-but-for-bots#411 to workflow-only — stage 1 of "ferry #411, cache+retry only" (maintainer chose to drop the conflicting Playwright pin). Stage 2 (boatman first-time ferry) follows.

Why: #411 as authored = cache + retry + exact-pin `@playwright/test` 1.49.1. The pin conflicts with naugtur's open upstream #3254 (which bumps to 1.59.1 for security) and would regress to the vulnerable version. The unique, non-conflicting value is the workflow cache+retry (.github/workflows/browser-test.yml). Drop browser-test/package.json + browser-test/package-lock.json; keep the workflow.

Fixer brief: tag pre-rework `b82249e1c`; `git reset --mixed origin/master-ba26f4c`; `git checkout origin/master-ba26f4c -- browser-test/package.json browser-test/package-lock.json` (revert the pin files to base); stage ONLY `.github/workflows/browser-test.yml`; **reword the in-workflow comment that claims "the pin is now exact, not a caret range"** (no longer true — say the cache key on package-lock.json invalidates when the resolved Playwright version changes); commit `ci(browser-test): cache Playwright browsers + retry install` (drop "+ pin version"); verify net diff is ONLY the workflow file; force-with-lease push to `ci/cache-playwright-browsers`. Then update the bot-side PR title+body (gh pr edit on endo-but-for-bots, the garden's own repo) to the cache+retry scope, noting the Playwright version pin is intentionally left to the upstream security PR. Bot identity; no kriskowal.

Provisioning note: the fixer worktree initially failed because `ci/cache-playwright-browsers` existed only as a remote-tracking ref in the bot bare clone (created post-clone; the +refs/heads/*:refs/remotes/origin/* refspec from the last gardener encode routes new branches to refs/remotes/origin/*, but dispatch-prepare resolves bare branch names from refs/heads/). Worked around by fetching the branch into refs/heads/. **Follow-up: a gardener should reconcile dispatch-prepare's branch resolution with the encoded fetch refspec** (e.g. dispatch-prepare should accept origin/<branch> or fetch the branch into refs/heads/ first).

Expected report: new #411 head, workflow-only net-diff confirmation, the comment reword, force-with-lease push, updated title/body.
