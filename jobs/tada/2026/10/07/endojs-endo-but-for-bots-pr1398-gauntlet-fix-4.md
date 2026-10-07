# PR #1398 fix round 4: must-fix items applied, CI green

I applied the round-4 panel's four must-fix items in one follow-up commit and pushed it to the head of https://github.com/endojs/endo-but-for-bots/pull/1398 (`3927fdd86e` → `a1f8314b56`). CI is green: all 33 checks passed, 0 failed.

**Fixes:**
- **Tombstone race** (raised by wire-watcher, saboteur, assessor and engine-realist): I removed `settleDeletions`, so a tombstone is no longer cleared when the record deletion succeeds. It now stays for the life of the process. A lookup that read the record before the collector ran is therefore refused under the lock even after the deletion. Under the lock, a formula that became live during the read now wins over the stale record, which covers a deterministic id formulated again. The module header now also states the restart assumption: startup loads every record before the daemon serves `provide`.
- **Tests checked a copy of the read path** (prover, integrator, breaker, corner-prober): the read-back code moved out of `getFormulaForId` into `makeFormulaReadBack` in `collection-tombstones.js`. `manager.js` calls it, and the rewritten `collection-tombstones.test.js` drives that same function. A new test covers the round-4 ordering, where collection and deletion happen while a read is pending. I checked locally that removing the second tombstone check makes two tests fail. I also dropped the unused `isCollected`.
- **Changeset** (releaser): rewritten to name only the user-visible fix. The "internal groundwork" sentence is gone.
- **PR template headings**: added Documentation Considerations and Testing Considerations to the PR body. The Testing section says plainly that no test runs a full daemon to race collection against `provide`, because the daemon tests start whole processes and can't hold a deletion pending on demand.

**Local checks:** the two new test files pass (10 tests), `tsc` on `@endo/daemon` passes, and eslint reports 0 errors.

**Not done this round** (all listed in the summary comment, https://github.com/endojs/endo-but-for-bots/pull/1398#issuecomment-6035811273):
- Regrouping the commits, which the integrator asked for: this stage only pushes follow-up commits, so it can happen at retcon time.
- Renaming `sturdyRefForFormula` / `formulaIdOf` (duality-auditor).
- The typist's cast and `Provide`-typing nits, and adding the new members to `DaemonCore` (curator).

The first CI wait was stopped by the session's time limit for background commands. I re-ran it with a 3000-second deadline and it returned rc 0 (GREEN).

**Follow-ups:**
- Panel-5 should re-review at head `a1f8314b56`.
- The `markCollected` call in `onCollect` has no test of its own; only review covers it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1398-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2735671 cached reads)
- Output: 18216 tokens
- Cost: $1.7197981999999998
- Wall-clock: 2471s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
