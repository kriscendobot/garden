---
orchestration-failed: true
---
orchestration-failed: true

# Clean stage report: endojs/endo-but-for-bots PR #1614

**Result: the clean stage fails because CI is RED.** `ci-wait-merge.sh` returned rc=3 at head `0035e6d1b3`. All three red checks match known breakage on the base and the runner image, not this PR's diff.

**Coverage and dead code:** I made no changes and pushed nothing.
- The PR removes inline global-declaration logic from `environment.rs` and moves eval framing in `lib.rs`/`xst.rs`. None of that left code orphaned.
  - `interp_with_source_bridge` and `build_dual_run` are still called.
  - `ironhorse_eval_goal_error` is a public wrapper that tests still use.
- `cargo check --all-targets` on `ironhorse-262` and `ironhorse-vm` gives no dead-code warnings. The only warning is an unused `Result` in `ironhorse-vm/src/bulk.rs:1259`, a file this PR doesn't touch.
- The PR's new test file, `tests/eval_global_function_bindings.rs`, covers the new branches, and `test-ironhorse` is green.

**Red checks (35 of 38 are green):**
1. **`test-ironhorse-oracle`** fails in `corpus_conversion_equivalence::generated_cases_reproduce_corpus_coverage`. Only `stage3-math/054.js` (`Math.asinh(1.7)`) and `055.js` (`Math.acosh(2.3)`) fail, flagged as "over-acceptance". The values differ in the last bit, which comes from the Ubuntu 26.04 math library.
2. **`ironhorse-oracle-sanitizers`** fails the same corpus test, plus `generated_multi_crank::converted_corpus_runs_as_crank_sequences`, on the same two cases.
3. **`cover (22.x, ubuntu-latest)`** fails on the sandbox test "bwrap timeout and repeated cancellation reap process groups". That is the known flake on the Ubuntu 26.04 runner.

These are the same failures seen on every `ironhorse-test262-ratchet-*-20261101` PR, including #1607.

**Follow-ups:** none of the fixes on the base has merged yet:
- #1585 accepts both roundings for the two `stage3-math` cases.
- #1613 runs the XS oracle lanes on Ubuntu 24.04.
- #1591 sweeps the bwrap process group when the leader exits, for the sandbox failure.

Once those land, PR #1614 needs a **weave** onto a new frozen base, then a re-run of this gauntlet. Nothing needs fixing inside PR #1614 itself. I added these fix-PR pointers to the existing note on this CI breakage in the garden's memory.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1614-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 100 tokens (3185075 cached reads)
- Output: 21981 tokens
- Cost: $2.053395
- Wall-clock: 4957s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
