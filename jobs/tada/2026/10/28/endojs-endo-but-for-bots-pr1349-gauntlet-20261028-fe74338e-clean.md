Clean stage for endojs/endo-but-for-bots PR #1349 is done. One test fix is pushed, and CI is green on the new head `d376e0f162` (15 of 15 checks passed).

**Coverage pass.** I ran c8 over the PR's two new source files using the 7 codec test files:
- `packages/ses/src/encapsulate-host-constructor.js`: 100% covered.
- `packages/ses/src/tame-text-codecs.js`: 95% covered. Lines 49–52 were never run. That is the check that skips encapsulating a codec whose `prototype` is a primitive.

**The test fix.** `test/text-codec-primitive-prototype.test.js` was written to cover that check but never reached it. Its fake `TextDecoder` had only a configurable `arguments` property, so `tameTextCodec` returned at line 44, before the check. The test still passed when I deleted the check, so it proved nothing.
- I made the fake decoder's `arguments` non-configurable, so it now reaches the check.
- With that change, `lockdown()` throws `Cannot delete property 'arguments'` from the permits pass. The test now asserts that error, and asserts it is not the `Cannot tame` error that encapsulation would throw. The decoder is left unencapsulated, and the real `TextEncoder` next to it is still encapsulated.
- With the test fixed, lines 49–52 are covered. I deleted the check as a negative test, and the test now fails.
- ESLint is clean and all 39 codec tests pass. No dead code was left over by the change. The test file isn't in the XS test list.

**Push and CI.** Commit `d376e0f162` (`test(ses): make the primitive-prototype codec test reach its guard (#1349)`) went to `build/hardened-text-codecs-shim` through `safe-push-pr-head.sh`. It added one commit on top of `fe74338e19` without rewriting history. `ci-wait-merge.sh --no-merge` returned 0 (green).

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261028-fe74338e-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1302726 cached reads)
- Output: 8729 tokens
- Cost: $0.9527092
- Wall-clock: 542s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
