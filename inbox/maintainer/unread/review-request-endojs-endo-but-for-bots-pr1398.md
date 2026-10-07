from_host: endolin-garden2-5bcdff64
from: gardener:compose-review-requests-budget-reached-20261007
reply_to: compose-review-requests-budget-reached-20261007
msg_key: review-request-endojs-endo-but-for-bots-pr1398
notice_count: 1
first_seen: 2026-10-07T22:12:52Z
last_seen: 2026-10-07T22:12:59Z
sent_at: 2026-10-07T22:12:59Z
---
Review request: endojs/endo-but-for-bots PR 1398 (gauntlet reached its review budget)
https://github.com/endojs/endo-but-for-bots/pull/1398
Arc: endo-ocapn-background (SturdyRef stack, layer 8 of 9; layer 5 is endojs/endo-but-for-bots#1394). Draft.

What it does: adds `makeFormulaSturdyRefKit` (packages/daemon/src/formula-sturdyref.js) so the daemon can mint a SturdyRef for a formula without incarnating it; nothing calls it until layer 9.
It also hardens `getFormulaForId`: after seeding, a memory miss now rejects instead of reading a persisted record back, so a lookup that races collection can't revive a collected formula (the git-remote state writer gets the same guard).

CI: head `afc5c25c1f`, 25 passed, 8 skipped, 0 failed. Base is the frozen layer-7 snapshot `build/sturdyref-ocapn-enliven-0e0b333`. +320/-13, 9 files, 3 commits (fix, feat, `chore: Update yarn.lock`).

Why it didn't converge: 6 panel rounds, each with 5 to 7 request-changes seats, and the set changed every round (packager/archivist/breaker in round 2, prover/purist/decomplector in round 3, integrator/saboteur/wire-watcher in round 4, and so on). The only seat that kept coming back was prover (tests), in rounds 3 to 6. Round 5 questioned whether the collection-tombstone module was needed at all; it was deleted.

Last panel round (round 6, head `87c7516d`): 6 request changes (breaker, changeset-auditor, integrator, packager, prover, releaser), 14 comment-only, 14 approve. Fix round 6 says it addressed all of these, but no panel has checked the result:
- prover: the collected-formula test didn't trigger the race, and nothing covered seeding or restart. Fix 6 added three daemon-level tests (collected id rejects without leaking the number; a record written back to disk is still refused; a pre-restart formula resolves after restart). It added no test for a lookup that arrives during seeding; it argues nothing outside the daemon can call it then and covers it with a comment.
- integrator: history added, reworked, then deleted collection-tombstones.js. Fix 6 rewrote the branch into the three commits listed above.
- packager / changeset-auditor / releaser: changeset scope and bump. Now `.changeset/daemon-collected-formula-lookup.md`, `patch`, user-visible fix only, one sentence per line.
- breaker (should-fix): `persistGitRemoteState` could still revive a collected formula. Fixed by dropping the captured-formula fallback.
- types: `DaemonCoreExternal` now lists `sturdyRefForFormula` and `formulaIdOf`.

Still open after fix 6:
- breaker (comment-only): formulation writes the record before setting `formulaForId`, so a lookup in that window now rejects. Fix 6 found no caller that can know the id that early.
- prover (should-fix): no test mints a SturdyRef through the real daemon core; deferred to layer 9, its first consumer.

Look at first: the `getFormulaForId` change and the `formulaGraphSeeded` gate in packages/daemon/src/manager.js. It changes behavior for every caller that looks up an id the daemon no longer holds (it now rejects), and `patch` depends on that path being unreachable from package exports. Then decide whether the fix commit should land with the layer-8 feature or go separately.

No GitHub review was requested and nothing was approved.
