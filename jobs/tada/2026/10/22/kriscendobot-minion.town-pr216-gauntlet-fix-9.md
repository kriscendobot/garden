Fix round 9 for kriscendobot/minion.town#216 is done. I pushed fixes for every must-fix item in the 22:34Z panel review, and CI is green on the new head `a864841e` (`ci-wait-merge` rc 0; both `test (typecheck + vitest)` and `clip frame browser gate` passed).

**What changed** (5 commits on `reland/pr200-settings-2`, `a01f5b17..a864841e`, pushed with `safe-push-pr-head.sh` in advance mode):
- **Backfill pagination** (`52ae8983`; prover, migrator, breaker): the ledger backfill in `deploy-accounts-store.sh` now keeps reading the DynamoDB scan until `LastEvaluatedKey` is gone. Before, accounts past the first page got no ledger entry, so deleting their guest left those recovery bonds open. The test now serves the scan in pages, one of them empty.
- **Deletion racing an invitation** (`87d4f8a1`; saboteur): `connectLocal` checks both guests again before inviting and again before accepting. A new race test failed before the fix and passes after. I left `send` and `inviteRemote` alone: they act as soon as `open` returns, and `open` already rechecks.
- **Cancel reason** (`87d4f8a1`; engine-realist): the error passed to `cancel` is now hardened when it is created, and a test checks CapTP can pass it. This was not causing a hang in production: `E` already hardens its arguments under lockdown, so the new test passes with or without the change. The fix just stops relying on that.
- **Direct link during a pending deletion** (`8a3ca894`; corner-prober): a fresh browser opening a guest link now keeps the credential when the server answers 409 `deletion-pending`, so it shows the *Finish deleting* card. This has a new test.
- **Docs** (`c2b1d76d`; archivist, surfacer): fixed the contradiction about the app role's `UpdateItem` in `DEPLOYMENT.md` and the script header. The 409 claim now covers only requests that present the pending guest's credential. I removed the stale placeholder comment in `minion-mcp.service`.
- **Rename** (`a864841e`; duality-auditor): `unbondIdentity` is now `unbondGuest`, the exact inverse of `bondGuest`. `bondGuest` already exists on `main`, so I renamed only the new half.
- **PR body** (pruner): removed the `provideHost` contrast paragraph and kept the one-line deferral to the maintainer.
- **Summary comment** (scribe): posted on the PR (issuecomment-6353479078). It lists the fixes, the declined items, and verification.

**Declined, with reasons in the PR comment:**
- Stylist's `lookupById` rename: it is the Endo daemon's own method, called over CapTP.
- Stylist's `guestId` rename: `home.js` on `main` already uses that name throughout.
- Releaser's changeset: the repo has no Changesets setup, and the upgrade steps are already in `DEPLOYMENT.md`.

**Local verification:** typecheck is clean. In the full suite, 1496 tests pass and 1 fails: `projectPartition > propagates a git failure`, a git-environment test this diff doesn't touch; it passed in CI.

Panel-10 is next, posted by the driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr216-gauntlet-fix-9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 120 tokens (6035327 cached reads)
- Output: 32307 tokens
- Cost: $2.885101399999999
- Wall-clock: 2341s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
