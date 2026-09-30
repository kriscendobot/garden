**Fix round 2 for endojs/endo-but-for-bots#1349: done, CI green on the new head**

I applied all three must-fix items from the panel's round-2 review, pushed one follow-up commit, and CI passed (15/15 checks).

**Changes**
- **Commit `ea0889c799`** on `build/hardened-text-codecs-shim`, pushed with `safe-push-pr-head.sh` as a fast-forward from `9b3f9a9bd9`. It edits only `packages/ses/test/_xs.js`:
  - **prover:** the test now checks that the `TextEncoder`/`TextDecoder` constructors are frozen, not just their prototypes. This matches the sibling test `text-encoder-decoder.test.js`.
  - **engine-realist:** the test now prints the host's `typeof` for each codec before the conditional checks, so the XS log shows which branch ran. On the current `xst` both are `function`, so the identity and frozen checks do run.
- **PR body (prover):** Testing Considerations now describes a break-observe-revert run:
  - With the universal `TextEncoder` permit in `permits.js` commented out, `xst` failed with `RangeError: TextEncoder presence matches the host`.
  - After reverting it, the run passed.
  - I did not break the new constructor-frozen checks on their own. `lockdown()` freezes all intrinsics together, so there is no small source change that leaves only the constructor unfrozen; the PR body says this.
- **Summary comment (scribe):** posted at https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-5903549392. It covers the pushes `9b3f9a9bd9` and `ea0889c799`: what changed, how it was checked, and the CI result.

**Checks:** the XS smoke test passes locally. Prettier and eslint are clean on `_xs.js`. `ci-wait-merge.sh --no-merge` returned 0 (green).

**Follow-up (not blocking):** corner-prober and other panelists suggested an encode/decode round-trip called from inside the compartment. I left it out of this round.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20260930-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1496462 cached reads)
- Output: 8044 tokens
- Cost: $0.9681164000000001
- Wall-clock: 1256s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
