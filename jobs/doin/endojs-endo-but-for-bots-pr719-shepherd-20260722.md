# shepherd endojs/endo-but-for-bots#719 (maintainer directive)

Maintainer @kriskowal directive on the PR:
https://github.com/endojs/endo-but-for-bots/pull/719#issuecomment-5042851038 — "Shepherd."

Drive #719 (hardened `URL`/`URLSearchParams` `%URL%`/`%SharedURL%` shim) toward a
green, mergeable state. Re-fetch live PR/CI state before acting.

## Known context (from the prior #719 shepherd — verify it still holds)
- **#719's OWN diff is fine** — its 21 URL tests pass; the cbor `@endo/eventual-send`
  devDep and prettier/eslint were already fixed.
- The remaining red is **pre-existing master/repo debt, NOT in #719's diff**:
  1. jsdoc lint warnings (daemon `directory.js`/`pet-*`, compartment-mapper) — trivial.
  2. 3 test failures from the errant direct-push `536f82d18` ("tame
     TextEncoder/TextDecoder") whose permits strip getters — resolved by the pending
     **M2 decision (revert `536f82d18` + merge #259)**, a maintainer/security call.
  3. zizmor: `setup-node` v6 tag moved → 16 stale workflow pins.

## What to do
Drive to green what is **legitimately #719's own** (rebase onto current master,
any of its own lint/format). For the **master-debt** items, do NOT smuggle unrelated
fixes into this URL feature PR — classify each as in-diff vs master-debt, and
**surface** the master-greening needs (they tie to the pending M2 revert-`536f82d18`
/ merge-#259 decision) rather than fixing them inside #719. If the honest conclusion
is "#719 is green on its own diff and blocked only on master-debt + the M2 decision,"
report exactly that with the evidence. Follow the shepherd CI-failure-classification
loop; cite real command output, no unverified "green" claims.


---
claim:
  host: endolin-garden-ece02cb4
  gardener: 23
  worker_kind: cleric
  claimed_at: 2026-07-22T15:16:58Z
