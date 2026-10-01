# Gauntlet fix, round 1: endojs/endo-but-for-bots#1396

I applied all five must-fix items from the panel-1 review and two of its should-fix items, then pushed. CI is green (`ci-wait-merge` rc 0, 33 checks, 0 failed), but only after I reran the two ubuntu test legs once.

**Pushed** to `build/sturdyref-captp-construct` with `safe-push-pr-head.sh` (advance mode, 14e9810335 → b0778fab75):
- `95f2122c0a` fix(ocapn): scope SturdyRef data to the minting client, check hint strings
- `b0778fab75` test(captp): spell out Options in the SturdyRef test helper

**Must-fix items:**
1. **Per-client SturdyRef data (locksmith):** each `makeSturdyRefTracker` now remembers the refs it minted and has a new `getDetails` method. The client's `getSturdyRefData` goes through it, so a client can no longer read the data (including the secret) of a ref another client minted. This also covers refs a client decodes off the wire, because those are minted through the same tracker. A new test checks that client B gets `undefined` for both kinds of ref client A made. The changeset and docstrings now say this.
2. **The two `SturdyRefData` shapes (curator, surfacer, spec-keeper):** the ocapn doc no longer calls the shape "the vocabulary every CapTP layer shares". It now states the differences from captp: `designator` is required and `objectId` may be raw bytes. I also took the should-fix on hints: the type is now `Record<string, string>`, and `sturdyRefDataToDetails` rejects non-string hint values, matching captp and the wire codec. A test covers that.
3. **Abbreviated names (stylist):** `makeOptsPair` / `leftOpts` / `rightOpts` are now `makeOptionsPair` / `leftOptions` / `rightOptions`.
4. **Wrong frozen base in the PR body (integrator):** it now names `build/sturdyref-captp-wire-2d2a656`.
5. **No xs statement (coverage-auditor):** the PR body now explains that `test:xs` is `exit 0` in both `@endo/captp` and `@endo/ocapn`. I also replaced the inline test counts with that statement, and the "shared vocabulary" wording became "same field names".

**Local checks:** the `ses-ava` suites pass (ocapn 566, captp 47). Lint and the repo-root `tsc` show no errors for either package.

**CI:** both ubuntu `test` legs failed on the first run. Each failed the same way: `packages/daemon` `test/endo.test.js` exited with an unhandled `Error: Termination requested` rejection during daemon teardown. The previous head (14e9810335) passed every leg, and run 36758282366 on `build/sturdyref-ses-accommodation` failed with the same rejection. That branch doesn't touch ocapn or captp, so I treated it as an existing daemon flake. My first `ci-wait-merge` hit its 3600s deadline (rc 4) with the macOS leg still queued. When the run finished I ran `gh run rerun --failed`; every leg passed, and a second `ci-wait-merge` returned rc 0.

**Not done:** the remaining should-fix items are left for panel-2: renaming `designator`, copying and hardening `Uint8Array` values, `peerId` vs `ourId`, re-exporting `SturdyRefData`, captp's `locate` returning `undefined` for an unknown id, and further trimming of the PR body. The flaky `endo.test.js` teardown rejection may need its own job.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (4026476 cached reads)
- Output: 18769 tokens
- Cost: $1.9475472000000005
- Wall-clock: 6163s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
