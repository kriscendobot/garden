---
ts: 2026-06-03T05:43:47Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/03/054005Z-dispatch-liaison-e70021.md
---

Cache+retry-only ferry of endo-but-for-bots#411 complete -> **new upstream endojs/endo#3296 (DRAFT)** (boatman dispatch `e70021`).

**#3296** https://github.com/endojs/endo/pull/3296 — branch `kriskowal-browser-test-cache`, head `59e4e3a13`, base master, DRAFT. Single commit `ci(browser-test): cache Playwright browsers + retry install`, Kris Kowal author+committer, `interpret-trailers --parse` EMPTY (gate ran — the discipline reinforced by today's #3295 incident). Net diff: ONLY `.github/workflows/browser-test.yml` (+31/-2). NO Playwright pin (dropped stage 1 to avoid conflicting with / regressing naugtur's security PR #3254). No #3254 cross-ref in the upstream body. CI pending. Garden-side cross-link created on bots#411 (comment 4609459462).

Two-stage: fixer reshape (result earlier this turn) -> boatman first-time ferry. The bot-side #411 and upstream #3296 are now in sync (workflow-only), so the mirror stays faithful.

**Follow-up flagged (provisioning wrinkle):** the fixer worktree initially failed because dispatch-prepare resolves a bare `<branch>` arg from refs/heads/, but the encoded `+refs/heads/*:refs/remotes/origin/*` fetch refspec routes post-clone branches to refs/remotes/origin/*. Worked around by fetching the branch into refs/heads/. A gardener should reconcile dispatch-prepare's branch resolution with that refspec (accept `origin/<branch>`, or have dispatch-prepare fetch the branch into refs/heads/ before `worktree add`). Recorded for a later encode; not blocking.
