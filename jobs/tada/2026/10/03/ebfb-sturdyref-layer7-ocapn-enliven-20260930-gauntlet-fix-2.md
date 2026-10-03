FIX round 2 for endojs/endo-but-for-bots#1397: I applied the panel's must-fix items and pushed them as `c022e70170`. CI was still running at the one-hour deadline: 31 of 33 checks finished with nothing failing, and only `test (22.x, macos-15)` and `test (24.x, macos-15)` were still pending. `ci-wait-merge.sh` returned rc 4.

**How I handled each must-fix item:**
- **prover (the copy step added in round 1 had no test):** I confirmed the step did nothing. `swissnumFromBytes` (which calls `frozenBytes`) already copies both a normal byte array and the frozen array the CBOR reader produces, and removing the step left every test passing. So I removed it and the import it needed. A new test checks that a frozen byte secret resolves exactly like a normal one, on both sides of the 0x7f/0x80 ASCII boundary.
- **corner-prober (does the locator get the caller's array or a copy):** the code at `376a462af4` already passed a fresh copy, so the reviewer's claim that it passed the original array was wrong. I added a test that pins the copy behavior: the locator's array is not the caller's array, and changing it leaves the caller's bytes unchanged. When I made the code pass the original array instead, this test failed in all three test configurations, so it does catch the regression.
- **pruner:** removed the empty "Documentation Considerations" section from the PR body and cut "Testing Considerations" down to what the tests cover. I also corrected the description's line about the old copy step.
- **scribe:** posted the missing summary comment (https://github.com/endojs/endo-but-for-bots/pull/1397#issuecomment-5966323590). It covers both the round-1 push `376a462af4` and this push, says what changed and what I declined, and gives the verification status.
- **Declined:** typist's suggestion to switch the inline locator type to the shared `NonceLocator` type. That problem existed before this PR, so I left it out of scope.

**Local checks:**
- The two SturdyRef test files pass under all three test configurations (23 tests).
- Prettier and the package-level type check are clean.
- eslint reports one warning about a nested `await`; it comes from code that was already in the PR before this round.
- The repo-wide type check that CI runs crashed locally (aborted), so I couldn't run it. CI covers it, and that check passed.

The PR stays a draft. Next up: the driver re-posts this stage.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (2943767 cached reads)
- Output: 13601 tokens
- Cost: $1.5387174
- Wall-clock: 3830s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
