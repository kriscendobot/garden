## Completion report: fu-endojs-endo-but-for-bots-pr1298-gauntlet-fix-5-1

**PR:** https://github.com/endojs/endo-but-for-bots/pull/1298 (head `kriscendobot:ironhorse-fuzz-findings`, still a draft). I pushed one commit, `898ded58c`, and the PR head now points at it.

**The false-divergence problem was already fixed before I started.** This finding was raised against the older fuzz rule (commits `fef22cc4d`/`4adb8f633`), which allowed either last digit when a number sits exactly halfway between two spellings. Two commits already on the branch (`07507ac9b`, `68c477f37`) changed both number spellers to always pick the even digit in that case. They also dropped the allowance, so the fuzz comparator now requires an exact match. The three `ironhorse-262` checks the finding names (`lib.rs:598`, `lib.rs:950–962`, `xst.rs:1782`) already did an exact match. So on the current branch they no longer report false differences on exact ties, and there was no tie allowance left to copy into them.

**What I changed:** the job's other request, one shared helper.
- **New helper:** I added `xs_oracle::completion_agrees(oracle_result, oracle_number, ironhorse_result)`. If the oracle's result was a number, IronHorse's output must equal the spec spelling of that exact number, with ties going to the even digit. Any other result must match XS's output exactly. The doc comment explains why.
- **Call sites:** `build_dual_run` (test262 dual run), `CompartmentDualRun::result_agrees` (checks both compartments) and `module_dual_run` in `xst.rs` now all call the helper. The inline copies of the rule are gone.
- **Fuzz comparator:** `ironhorse-fuzz`'s `results_agree` stays as it is, because that module must build without dependencies for CI. The helper's doc says it uses the same rule.
- **New test:** `completion_agrees_with_the_exact_spec_spelling_only` checks that the even digit passes and the odd one fails even when XS itself printed the odd one. It also checks that `"1e2"` does not match `100`, and that non-number results must match exactly.

**Verification:**
- `cargo test -p xs-oracle --lib`: 30 passed.
- `cargo test -p ironhorse-262 --lib`: 155 passed.
- rustfmt 1.88 applied to the three files.
- To build, I had to fetch the `c/moddable` submodule (the XS sources) in my job checkout.

**Follow-ups:** none required.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `558a9b7d`; this job presented `898ded58cabab96db213dd3e82ca5a21d5ff5c4b`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr1298-gauntlet-fix-5-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1268084 cached reads)
- Output: 9521 tokens
- Cost: $0.9015487999999999
- Wall-clock: 1054s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
