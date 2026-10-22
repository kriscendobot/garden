Clean stage report for endojs/endo-but-for-bots PR #1531 (endor `--zip`/`--dir`/`--cas-dir`).

**Outcome:** CI is green at head `b4aa3d1cb87`: 35 checks, 0 failed, `ci-wait-merge` rc 0. That head's code is identical to the original head `14af3028a`. I added a CI step and then reverted it, so the PR keeps only its own change. The PR is still a draft.

**Coverage pass (Rust, `rust/endo`):**
- The 47 unit tests in `cas_archive::` and `run_input::` all pass locally. They cover directory ingest, the ZIP and directory forms giving the same root hash, determinism, symlink and missing-map rejection, form-flag parsing and the override rules. I found no gaps that needed new tests.
- In `tests/endor_run_cli.rs`, 1 of 3 tests passes here (`contradictory_flags_are_usage_errors`). The other two fail because XS segfaults on this aarch64 Linux container. The PR is not the cause: the `--no-cas` ZIP path, which the PR doesn't touch, segfaults the same way.
- **Dead code:** none. Every new or changed function has a caller, and the old `classify_run_input` is still used through `resolve_run_input`.

**What changed on the PR head:**
- `6e1d6eb62` added a step to the `build-xsnap` CI job that runs the `cas_archive::`/`run_input::` unit tests. No CI lane runs them at the moment. That job went green with the step.
- The ci.yml edit made every CI lane run, including `fuzz-ironhorse`. That lane failed with a fuzzer timeout (a hang) in the Ironhorse `bytecode_decoder` target, which this PR doesn't touch.
- `b4aa3d1cb` reverts that step with a new commit; nothing was force-pushed. CI then went green and `fuzz-ironhorse` was skipped again.

**Follow-ups posted to the board:**
- `endojs-endo-but-for-bots-endor-run-unit-tests-ci-lane` (builder): add the CI step as its own PR, using the YAML I already tested. It also notes that `endor_run_cli.rs` shouldn't be added to CI until the existing XS segfault in `xsnap::Machine::eval` (named in the `build-xsnap` comments) is fixed.
- `ironhorse-bytecode-decoder-fuzz-timeout-1015c4e9` (fixer): reproduce and triage the `bytecode_decoder` hang. The input is saved as `timeout-1015c4e9cf8a361f98c929653d2023bb8cb70515` in the artifacts of Actions run 39727404537.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1531-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (3730983 cached reads)
- Output: 18300 tokens
- Cost: $1.8338366000000001
- Wall-clock: 5542s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
