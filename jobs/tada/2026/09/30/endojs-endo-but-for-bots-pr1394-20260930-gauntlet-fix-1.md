Fix round 1 for endojs/endo-but-for-bots#1394 is complete, and CI is green on the PR head.

The panel reviewed head `c2d1f93e` and listed 20 must-fix items, all from the breaker seat. They reduce to two should-fix findings, one comment-only finding and one confirmed mitigation. An earlier claim of this job had already pushed follow-up commits for both should-fix findings to `build/sturdyref-captp-wire`, so I checked those commits against the verdict and pushed nothing new:

- **`47735f3e3a` fix(ocapn): keep the enliven-binding SturdyRef mint internal.** The public `makeSturdyRef` now takes only `(location, secret)`, and the version that accepts a custom enliven function is internal to the client tracker. This closes the decoy-enliven attack and the always-rejecting two-argument ref. It adds tests in `packages/ocapn/test/sturdyref.test.js`.
- **`9a9aa310f9` fix(captp): allocate and import SturdyRef slots outside the tables.** `s+` slots are now allocated in `convertValToSlot` alongside the `t+` trap slots, and `makeSturdyRefForSlot` handles importing them. Previously this lived only in the default import/export tables, so custom tables would send a SturdyRef as an `o+` slot and the peer would import a Remotable presence. It adds tests in `packages/captp/test/sturdyref.test.js`.

Not done: I did not add a check that a slot's kind prefix matches the encoding that decoded it. The panel marked that finding comment-only and noted that `passStyleOf` still reports the correct type. The fourth group of items only confirms that forged enliven targets are already rejected, so it needed no change.

CI: `ci-wait-merge.sh endojs/endo-but-for-bots 1394 --no-merge` returned rc 0, with 33 checks and 0 failed on head `9a9aa310f9`.

For panel round 2: the panel posted its review as COMMENTED, not REQUEST_CHANGES, because the PR is the bot's own.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1394-20260930-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 84 tokens (2591446 cached reads)
- Output: 16380 tokens
- Cost: $1.7734572000000002
- Wall-clock: 5080s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
