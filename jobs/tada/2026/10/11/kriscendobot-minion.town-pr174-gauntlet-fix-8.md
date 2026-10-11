Round-8 fix for kriscendobot/minion.town#174: the panel's one must-fix is applied, pushed as `c9ac17a` on `build/credit-metering-no-ertp`, and CI on that commit is green.

**Must-fix (decomplector).** Billing used to be three separate methods, and callers had to remember to call either "charge" or "release" afterwards. `authorizePublish` now returns a single-use authorization with `settle()` (charge after success) and `cancel()` (return the hold on failure). Whichever runs first wins and the other does nothing, so the type now guarantees one or the other.
- **Why the hold stays in memory:** the reviewer asked why it isn't a durable ledger record. The answer is now written into `designs/ertp-credits.md` § 6a and the processor's doc comment. The hold lasts exactly as long as the publish it covers, and a restart ends both together. A durable hold would outlive a crashed publish and need an expiry or sweep to return it, which is the undo path this design avoids.
- **Files changed:** `src/endo/gateway/publish.ts`, `src/endo/clip-payment.ts` (both the stub and the metered processor), and the call sites and tests.

**Also fixed:**
- **Overdraw race (saboteur, should-fix):** a pending authorization could read the balance from before another publish's charge but the holds from after it, letting concurrent publishes overspend by one price. Authorizing and settling now run one at a time. A new regression test fails without this change and passes with it.
- **`DEPLOYMENT.md` (archivist):** now says `ledger.jsonl` is persistent state that belongs in backups.
- **PR body (pruner):** the "What changed" walkthrough is cut to a short summary that points to § 6a, and the Tests section mentions the new regression test.

**Tests:**
- Typecheck is clean, and the credit-metering, gateway and endo-clip-tools suites pass (174 tests).
- The full local suite had 3 failures in `test/git-remote/*`, and the failing tests differed between two runs. This PR doesn't touch that code, and CI passed.

**CI:** `ci-wait-merge.sh` never got a reading because `gh pr view` failed on every tick. This host's bot token can't read the PR's check status. I polled the GitHub Actions runs API instead: "test (typecheck + vitest)" on `c9ac17a` finished with success, and `c9ac17a` is still the PR head.

**Not done:** the remaining should-fixes are left for a later round:
- An unbilled-publish counter for when a charge fails to append after a successful publish.
- The rollback-truncate edge case in `makeFsLedgerLog.append`, where a failed write could cut off a grant the CLI appended at the same moment.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-fix-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 4 tokens (115302 cached reads)
- Output: 1179 tokens
- Cost: $2.2861155999999996
- Wall-clock: 41s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
