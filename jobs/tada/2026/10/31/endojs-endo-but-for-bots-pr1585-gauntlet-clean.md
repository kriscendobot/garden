The clean stage is still pending: CI on the current PR head was not finished when the 55-minute wait expired. `ci-wait-merge.sh` returned rc 4 with 13 of 37 checks still queued or running.

- **The red CI was the PR's own bug, already fixed by another worker.** On the original head `9915ffcd`, `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` both failed in the same test, `converted_corpus_runs_as_crank_sequences`. That test re-runs each case's `Source:` program on two engines, which still disagreed by one ULP on `Math.asinh(1.7)` and `Math.acosh(2.3)` (cases 054/055). At about the time this job was claimed, another worker pushed `cded9a2f33` ("dual-run the two-value program for stage3-math 054/055"). It makes the `Source:` line accept either rounding, matching each test's assertion. I checked `case_source_line()` in `rust/engine/ironhorse-262/src/compile_diff.rs`: it reads the `  Source: ` line, so the fix reaches that test.
- **Coverage pass: nothing to do.** The PR only changes two test cases, a test fixture file, a Rust test and two design/docs files. It changes no production code, so there is nothing new to cover and no dead code left behind. I pushed no commits.
- **CI on `cded9a2f33`:** `ironhorse-oracle-sanitizers` now passes, a good sign the fix works. No check has failed. Still queued or running at the deadline: `test-ironhorse-oracle`, `test-ironhorse`, `test-xs`, `cross-target-ironhorse`, `fuzz-ironhorse`, `test-thixotrope-ironhorse`, `test-ironhorse-release`, `cover`, the `test` and `viable-release` legs. The runner queue was very slow.
- **Follow-up:** the next attempt at this stage only needs to re-check CI on `cded9a2f33`; the coverage pass is done. A small doc nit, left alone: the comment on `corpora_programs()` still says each case keeps its original program "verbatim" on the `Source:` line, which is no longer true for 054/055.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1585-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1045993 cached reads)
- Output: 6739 tokens
- Cost: $0.8571546000000001
- Wall-clock: 4030s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
