---
ts: 2026-06-15T06:41:36Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/04/034622Z-dispatch-liaison-8714f0.md
---

Dispatched boatman (dispatch-root `dispatches/boatman--230994`) for a **first-time ferry** of the pivoted bots#411 to a NEW endojs/endo PR. The old upstream #3296 (cache+retry+DEBUG workaround) was CLOSED (not merged); bots#411 pivoted to the minimal real fix. Maintainer chose: new PR (not reopen #3296).

Source: kriscendobot/endo-but-for-bots#411, branch `chore/shellcheck-ci`... NO - branch is for browser-test; head `a54f033e8`, base `master-07aff33`, DRAFT, 2 commits (endolinbot): `ba9d11b33` ci(browser-test): pin @playwright/test to 1.60.0 (browser-test/package.json `^1.49.1`->`1.60.0`) + `a54f033e8` chore: Update browser-test/package-lock.json (43 lines). Root cause (per body): Playwright 1.57-1.59.x hangs extracting the Chrome archive on Node 24.16; 1.60.0 fixes it. So the prior cache/retry/DEBUG stack is obsoleted by this minimal pin.

Boatman brief (Shape 1, NEW PR): fetch the source via `refs/pull/411/head` (verify FETCH_HEAD==`a54f033e8`); detach at current endo master `315533fff`; cherry-pick the 2 commits and **squash into ONE** `ci(browser-test): pin @playwright/test to 1.60.0` (pin + its lockfile - one logical change); if the package-lock.json cherry-pick conflicts from the 07aff33->315533fff base gap, regenerate via `cd browser-test && npm install --package-lock-only`; author+committer `Kris Kowal <kriskowal@kriskowal.com>`; strip (#411)/Co-Authored-By/Generated-with/Refs trailers (use commit --amend -F file for the body); RUN `interpret-trailers --parse` EMPTY; **new branch `kriskowal-playwright-1.60`** (do NOT reuse the closed #3296 branch kriskowal-browser-test-cache); open the upstream PR **--draft** (source is draft) with a pr-formation body telling the root-cause story (1.57-1.59.x archive-extraction hang on Node 24.16, fixed in 1.60.0; pin to stabilize browser-test) - behavior over diff, no fork refs, no mention of the closed #3296; **repoint the garden-side cross-link 4609459462 on bots#411** (currently -> closed #3296) to the new PR via PATCH. `identity_switch_authorized: true`.

Expected report: new upstream PR URL + number, branch + head, squash/lockfile outcome, Kris Kowal + trailers-empty, mergeable, CI, repointed cross-link.
