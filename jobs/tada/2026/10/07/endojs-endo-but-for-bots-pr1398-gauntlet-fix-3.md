## Gauntlet fix round 3: endojs/endo-but-for-bots PR #1398

I applied the round-3 panel's must-fix items in one follow-up commit and pushed it with `safe-push-pr-head.sh`. The PR head moved from `4292f6bf42` to `3927fdd86e`. CI is green: all 33 checks finished and none failed.

**Panel items and what I changed**
- **decomplector and breaker #2 (the guard was in the wrong layer, and a check before an await left a gap):** The collection guard now sits in `getFormulaForId` in `manager.js`. That is the one place a stored formula record is read back into memory, so every `provide` path now refuses a formula the collector has dropped. The check runs before the record is read and again under the graph lock, which closes the gap while the read is pending. I removed `isCollected` and the old `collectionPendingIds` set from the SturdyRef kit. The kit now takes only `{ provide }`.
- **breaker #1 and purist #3 (a failed delete reopened the window):** The tracking moved into a new module, `packages/daemon/src/collection-tombstones.js`. A formula's tombstone is now cleared only when deleting its stored record actually succeeds. If the delete fails, the formula stays refused for the life of the process.
- **purist #1 (the error leaked the formula ID):** The "has been collected" error now uses `makeError(X\`...\`)` with the ID unquoted, so it is redacted under the daemon's default `safe` error setting. I noted in the kit's header comment that other errors from `provide` (for example "not found") may still show the ID.
- **purist #2 and #4:** The kit now imports the `SturdyRef` type from `@endo/pass-style`, with casts so `tsc` passes. The test now checks `Reflect.ownKeys(ref)` and `passStyleOf(ref) === 'sturdyRef'`.
- **prover #1 (the wiring had no test):** New file `test/collection-tombstones.test.js`. It covers:
  - refusing a collected formula before its record is read;
  - collection happening while a read is pending, with the record refused when the read returns;
  - a tombstone clearing only when its delete succeeds, so none are left over after a successful delete;
  - a failed delete keeping the tombstone.

  I deleted the old injected-stub collected-formula test from `formula-sturdyref.test.js`.
- **releaser:** The changeset is now `patch`, worded as internal groundwork plus the fix that stops a collected formula from being revived.
- **pruner:** I removed the "Documentation Considerations" and "Testing Considerations" sections from the PR body and updated its description to match the new design.

**Verification:** The 8 tombstone and SturdyRef unit tests pass locally, along with eslint (no errors), prettier, and the daemon's `tsc` type check. I could not run the daemon-spawning GC tests locally: the shared `better-sqlite3` build here was compiled for a different Node version (module version 137 vs 127). That is an environment problem unrelated to this change, and CI ran those suites green. My first CI wait was killed by the shell's background time limit, so I restarted it detached with a 2700s deadline. It returned rc 0 (green).

**Follow-ups for panel-4:**
- Prover asked for a test of the real wiring inside the full daemon (collect a formula, enliven in the window). I didn't add one: a full-daemon test can't hit that window reliably. The new tests copy `getFormulaForId`'s check / read / check sequence rather than calling the daemon itself.
- The should-fix items prover #2 (no test for the `sturdyRefForFormula`/`formulaIdOf` exports on the daemon core) and prover #3 (the stub-based unknown-formula test) are not addressed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1398-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2989291 cached reads)
- Output: 17955 tokens
- Cost: $1.6894461999999997
- Wall-clock: 2553s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
