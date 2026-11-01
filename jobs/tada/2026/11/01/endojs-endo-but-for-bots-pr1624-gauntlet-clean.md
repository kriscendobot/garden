---
orchestration-failed: true
---
orchestration-failed — CI is RED on PR #1624 (rc 3). The cause is not this PR.

# Gauntlet CLEAN stage for endojs/endo-but-for-bots#1624: CI red on a known oracle problem, not this PR

**What I did**
- **Starting point:** the PR is a draft on frozen base `llm-9a14ddf`, head `c3f37d9eb4`. `test-ironhorse-oracle` was already red, so this stage was not a no-op.
- **Coverage pass:** I worked in an isolated project worktree. Two new branches in `classify_run` (`rust/engine/ironhorse-262/src/test262.rs`) had no test: the `ironhorse-aborted-limit` skips for a RegExp-limit `RangeError` under `BothAbort` and under `OracleOnlyComplete`. The PR's other new code already has tests: quantifier clamping and the min>max order check, `is_regexp_limit_error`, the catchable compile and match `RangeError`s, and the `evaluate_positive` arms.
- **Change:** I added `classify_run` assertions to the PR's existing test `a_regexp_limit_range_error_stays_the_engine_limit_skip` in `xst.rs`, reusing its two synthetic runs.
- **Dead code:** none found. The removed `value > 0x7FFF_FFFF` → `ResourceLimit` path left no orphans, and `CompileError::ResourceLimit` is still produced by the compile storage limit.
- **Local checks:** the new test passes, as do `reference_totality`, `regexp_limits_are_catchable` and the `halt_labels` unit tests. `cargo fmt --check` is clean. Clippy's only warnings are in code the PR doesn't touch.
- **Push:** commit `45ed604e64`, "test(ironhorse-262): cover the classify_run RegExp-limit skip branches", pushed with `safe-push-pr-head.sh` (fast-forward from `c3f37d9eb42`).

**CI result: rc 3, RED.** Of 38 checks, 2 failed and everything else passed:
- `test-ironhorse-oracle`: FAILURE
- `ironhorse-oracle-sanitizers`: FAILURE

Both fail only in `corpus_conversion_equivalence` on `stage3-math/054.js` and `055.js`. Ironhorse and the XS oracle disagree on the last digit of an `asinh`/`acosh` result, e.g. `«1.300820426840647»` vs `«1.3008204268406467»`. This is the known problem where `ubuntu-latest` became ubuntu-26.04, whose glibc rounds those functions differently from the values the tests were pinned against. The same failure was already red at the PR's original head, before my push. The fix, PR #1613 ("run the XS oracle lanes on Ubuntu 24.04"), is still **OPEN** and not merged into `llm-9a14ddf`, so no change to #1624 can turn these checks green.

The job spec asks for a leading `orchestration-failed: true` line, but the harness says to use the failure signal below instead of typing that field. I followed the harness. Per the spec, there is no `clean=done` marker.

The first background CI waiter was stopped at its 10-minute limit. I restarted it with a longer limit; the second hit its 3000s deadline (rc 4) with only the two macOS legs pending, and a third run reached the terminal rc 3.

**Follow-ups**
- Land #1613, re-weave #1624 onto a base that includes it, then re-run the gauntlet. There's no defect in #1624 to fix.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1624-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2646804 cached reads)
- Output: 11718 tokens
- Cost: $1.4265928000000003
- Wall-clock: 3934s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
