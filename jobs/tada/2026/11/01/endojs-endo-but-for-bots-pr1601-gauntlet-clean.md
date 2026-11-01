---
orchestration-failed: true
---
orchestration-failed: true

## Gauntlet clean stage: endojs/endo-but-for-bots PR #1601. Result: CI red

**Clean pass: nothing to change, nothing pushed.**
- I checked out the PR head in an isolated worktree, at `8fd0ff108` on branch `ironhorse-test262-ratchet-with-binding-deleted-20261101`. The first checkout attempt hit the 120s git limit; it worked with `GARDEN_REPO_GIT_TIMEOUT=900`.
- **Dead code:** the change leaves none behind. The old comment it replaced in `dispatch/environment.rs` pointed at an `oracle_loses_with_reference` exclusion in `xst.rs`, but that exclusion was already gone on the base. The PR only removed the outdated comment. `mop_has_with_recursions` and `mop_has_ordinary_levels`/`HasLevels` are still used.
- **Test coverage:** the new test file `ironhorse-262/tests/with_binding_deleted.rs` covers every new branch:
  - a strict store throws `ReferenceError`, for plain assignment, compound assignment and update operators
  - nothing gets recreated after that throw
  - a sloppy store falls through and recreates the property
  - a read throws in both sloppy and strict mode
  - `typeof` is exempt
  - a Proxy `with` object is exempt

**CI: `ci-wait-merge.sh --no-merge` returned 3 (red).** 36 of 38 checks passed; 2 failed:
- **`test-ironhorse-oracle`** fails in `ironhorse-262` `corpus_conversion_equivalence::generated_cases_reproduce_corpus_coverage` with "2 failure(s) (observable divergences or stale engine-versioned raw pins)".
- **`ironhorse-oracle-sanitizers`** fails the same test. It also fails `generated_multi_crank::converted_corpus_runs_as_crank_sequences` on last-digit float mismatches in the Math corpus:
  - `Math.asinh(1.7)`: oracle `1.300820426840647`, Ironhorse `1.3008204268406467`
  - `Math.acosh(2.3)`: oracle `1.475044781241425`, Ironhorse `1.4750447812414251`

**The PR's change probably isn't the cause.** These match the known breakage since 2026-10-22, when CI's `ubuntu-latest` image moved to Ubuntu 26.04 and the ironhorse-oracle corpus tests started failing. The same "IronHorse oracle sanitizers" workflow is red on every ironhorse ratchet PR run today: resource-disposal, typedarray-change-by-copy, and async-from-sync (twice). Its recent passing runs are all on non-ironhorse branches. The Math failures involve code this PR doesn't touch. I didn't confirm it against a base-branch run.

**Follow-up:** the gauntlet halts here. The oracle corpus pins or the runner image need a fix on the base, and then this PR needs a weave onto it. I didn't chase it inside this PR.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1601-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1269904 cached reads)
- Output: 5827 tokens
- Cost: $0.9465528000000002
- Wall-clock: 2045s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
