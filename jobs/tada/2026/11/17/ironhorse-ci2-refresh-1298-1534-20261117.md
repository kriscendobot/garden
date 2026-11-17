---
handed-off: ironhorse-ci2-refresh-1298-1534-20261117-split
deliverable-complete: false
---
I refreshed both PRs onto current llm and pushed. The causes the job named are cleared on both. #1534 has only the expected reds left; #1298 still had three test lanes pending when the job hit its time limit. Per the overrun protocol, I split the final CI checks into an orchestration with one child per PR.

**#1534** (head `llm-endor-run-unit-tests-ci-lane`, base `llm-54d3d2a` kept)
- **Before:** red on build, cover 22/24, sandbox-drivers, test 22/24, and the two oracle lanes.
- **Build red:** `scripts/graph.sh: tred: command not found` in the dependency-cycle check. llm already fixes this in fc2b4719a3 by installing graphviz.
- **Pushed:** a clean rebase onto llm 0368767778, giving f67903d1c0 (one ci.yml commit). The new step's modules still exist, and that step already passed in build-xsnap.
- **After:** build, sandbox-drivers and all ubuntu test/cover lanes are green.
  - Two failures went green on rerun, so they were flakes:
    - cover(24.x): a bwrap process-group cleanup test; open PR #1591 targets it.
    - test(22.x, macos-15): a daemon durable-environment test.
  - test-ironhorse hit its 45-minute timeout and was cancelled. I reran it but haven't seen that rerun finish.
- **Expected reds left:**
  - test-xs: the base-wide Node 26 baseline flip, fixed by open PR #1646.
  - The two oracle lanes, plus compare-ironhorse-math, which depends on them.

**#1298** (head `kriscendobot/ironhorse-fuzz-findings`)
- **Before:** red on cover 22/24, sandbox-drivers, test 22/24, and the two oracle lanes.
- **Merge instead of rebase:** a plain rebase of the 97 commits would have stopped on conflicts about 37 times, so I merged llm into the head instead (761ab312fc).
  - Five files conflicted. I kept both sets of fields in the oracle result struct, and kept the PR's exact-double Number comparison, which replaces llm's string tie workaround. I restated llm's two tie tests to match.
  - The multi-crank check now uses the shared `result_agrees` rule.
  - The merge compiled, but 51 of the PR's regression tests broke. They pin raw fuzz input bytes, and llm's generator change (F040) turns those bytes into different programs.
- **Handoff and fixes:** I posted the successor job `ironhorse-1298-repin-fuzz-locks-20261117`, which re-pinned those tests (f71bf5412f) before it was later marked failed after too many requeues. I fixed format-ironhorse twice: rustfmt (51db417e46), and keeping `comparison.rs` free of other crates so it compiles alone (34bb071b2d).
- **Base moved, as the spec allows only when needed:** I moved the base from `llm-387ea66` to the frozen `llm-0368767`. format-ironhorse's row-schema check fails against the stale base and passes against `llm-0368767`; I checked both locally. I then re-triggered CI with a same-tree amend (a4f8aadd8c).
- **After:** format-ironhorse passes. The only reds are test-xs and the two oracle lanes. test(22.x, ubuntu-latest), test(22.x, macos-15) and test(24.x, macos-15) were still pending.

**Split:** orchestration `ironhorse-ci2-refresh-1298-1534-20261117-split` (parallel, continue on child failure) holds two parked children:
- `ironhorse-ci2-1298-verify-20261117`: wait for the pending lanes, rerun known flakes, fix anything the PR caused.
- `ironhorse-ci2-1534-verify-20261117`: confirm only the expected reds remain, including the test-ironhorse rerun.

Nothing was merged.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-ci2-refresh-1298-1534-20261117.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 10 tokens (928408 cached reads)
- Output: 4902 tokens
- Cost: $0.3838736 (1 engagement(s) unpriced)
- Wall-clock: 10968s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
