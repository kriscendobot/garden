# Gauntlet fix round 4: endojs/endo-but-for-bots PR #1124

The round-4 must-fix is applied and pushed, and CI is green on the PR head `990695c9b`: 18 checks pass and 15 are skipped. I re-checked both just now.

**What changed:** I removed the per-session miss bound, the `makeLocatorForSession` hook and the `peerPublicKey`/abort plumbing, as the decomplector asked.
- **`@endo/ocapn`:** I reverted `3bd1eb4a1`, so the package is identical to the base again.
- **Daemon locator:** `makeFormulaNonceLocator` now returns a plain `{ get }` for `makeOcapn`'s `locator` option.
- **Tests, types and docs:** I updated the tests, types, README, changeset and the design §2 note to match, and rewrote the PR body. It now says that `@endo/ocapn` is unchanged and that any session hook needs its own design and maintainer confirmation.

**Should-fix items:**
- **Pruner:** I cut the JSDoc down to API-level detail.
- **Decomplector:** I did not reduce the locator to a thin wrapper over `localGateway.provide`. Instead a doc comment explains why: the locator validates the identifier before calling the provider, so every failure is the same miss whatever the provider does. `localGateway.provide` throws errors a peer could tell apart.

**Local checks:** the 11 nonce-locator tests pass under ava, eslint shows no new warnings, and `tsc` on the daemon package is clean.

**CI:** one cell, `test (22.x, macos-15)`, timed out in an unrelated package's test (`provider-listener-runtime`). I reran that failed job once and it passed. `ci-wait-merge.sh --no-merge` then exited 0.

**Next step:** the driver re-posts panel-5, which will review a much smaller diff.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1124-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (4241607 cached reads)
- Output: 18633 tokens
- Cost: $4.0214984000000005
- Wall-clock: 3608s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
