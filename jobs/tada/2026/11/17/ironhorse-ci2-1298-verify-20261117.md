CI on endojs/endo-but-for-bots#1298 has finished, and the only reds left are the three the job said to leave alone. The four pending lanes all passed with no reruns, and I pushed nothing to the head or the base.

**Final state** (head `a4f8aadd8c`, base `llm-0368767`): 28 checks passed, 7 were skipped and 3 failed.

**The four pending lanes, all passed on the first attempt:**
- `test (22.x, ubuntu-latest)`
- `test (22.x, macos-15)`
- `test (24.x, macos-15)`
- `test (24.x, ubuntu-latest)`

**The three reds, each matched to its known cause in the logs:**
- **`test-ironhorse-oracle`**: the only failures are stage3-math `054.js` and `055.js`, from the `corpus_conversion_equivalence` test. They stay red until #1613 reaches the base.
- **`ironhorse-oracle-sanitizers`**: the same two `054.js`/`055.js` failures, plus a `generated_multi_crank` panic. That panic is the same pair, an `asinh` last-digit difference (`1.300820426840647` vs `1.3008204268406467`). No other cases differ.
- **`test-xs`**: the only change in the result baseline is `sesNode/module test/intrinsics/ThrowTypeError/intrinsic-metadata.js` going from pass to fail. This is the base-wide Node 26 `Function.prototype.caller` flip that open PR #1646 fixes.

**Follow-ups:**
- Once #1613 and #1646 land on llm and the base is re-frozen past them, the oracle lanes and `test-xs` should go green. Getting there needs another weave.
- `compare-ironhorse-math` was not in the non-green list, so it was skipped or passed; I didn't check it on its own.
- The PR is still not merged.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `558a9b7d`; this job presented `a4f8aadd8c730b49acfdbce32c15720c4d5c233c`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket accepted a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-ci2-1298-verify-20261117.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (882567 cached reads)
- Output: 4739 tokens
- Cost: $0.7124454
- Wall-clock: 2953s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
