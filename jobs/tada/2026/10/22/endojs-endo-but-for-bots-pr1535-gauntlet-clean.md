The clean stage on PR #1535 is not finished: CI hadn't reached a terminal state by the 3600 s deadline (`ci-wait-merge` rc 4). One macOS job was still running. Seven checks on the new head are red, so the stage will come back as RED (rc 3) once that job finishes, unless the base is fixed first. None of the seven failures comes from this PR.

**Coverage pass (pushed):**
- The PR adds the store-chain guard in two places: `store` (through `store_chain_tail`) and `exec_store_arrow` in `dispatch.rs`. The existing regression test only reached the `store` path; the `store_arrow` guard had no test.
- I added `store_arrow_into_a_long_chain_halts_under_the_same_ceiling` to `rust/engine/ironhorse-vm/tests/finding_1015c4e9cf8a361f_store_chain_walk.rs`. It pushes two objects and then runs 5,000 `store_arrow` ops, each adding one link to the same chain, so the walk crosses the 4096 ceiling and must halt with `StepLimit`.
- With the `dispatch.rs` guard removed, the new test fails (the run returns normally). With the guard in place, all three tests in the file pass.
- `cargo fmt --check` and clippy (1.88, `-D warnings`) are clean on the library and this test target. Clippy over all of the package's tests fails on a lint in the library's own unit tests (`chunks.set_ceiling` result left unused); that lint is outside this diff and I didn't change it.
- The change leaves no dead code: the old walk inside `store` was replaced by `store_chain_tail`, not left orphaned.
- Commit `1bd23548c` ("test(ironhorse-vm): cover the store_arrow store-chain ceiling") was pushed with `safe-push-pr-head.sh`, a fast-forward from `a61dffa38`.

**The seven red checks:** they failed identically on the old head `a61dffa38` and on `1bd23548c`.
- **`test-ironhorse-oracle`, `ironhorse-oracle-sanitizers`:** `ironhorse-262` corpus tests `stage3-math/054.js` (`Math.asinh(1.7)`) and `055.js` (`Math.acosh(2.3)`) fail because ironhorse's result is off by one ULP from the oracle's (`1.300820426840647` vs `1.3008204268406467`). This PR doesn't touch the math code. PR #1534, on the same base `llm-54d3d2a`, fails the same way.
- **`sandbox-drivers`, `test (22.x/24.x, ubuntu)`, `cover (22.x/24.x, ubuntu)`:** two `packages/sandbox` bwrap tests fail. One gets `/bin/sh: ulimit: Illegal option -u`; the other is "bwrap parent death leaves no owned process group", which finishes without running any assertions. PR #1527, on the same base, has the same red set for these checks.

**Follow-ups:**
- The base `llm-54d3d2a` needs a fix for the stage3-math ULP mismatch and the sandbox `ulimit -u` test, either directly or through a weave onto a fixed base. Until then the gauntlet for every PR on this base will stop here.
- When this stage is re-posted, `ci-wait-merge` will most likely return rc 3, because the red checks don't depend on this PR's change.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1535-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2727252 cached reads)
- Output: 14140 tokens
- Cost: $1.4856904000000002
- Wall-clock: 4133s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
