---
orchestration-failed: true
---
orchestration-failed — CI on PR #1534 finished RED (`ci-wait-merge` rc=3). The failures come from the CI runner image, not from this PR's change.

**Clean stage for endojs/endo-but-for-bots PR #1534** ("ci(endo): run endor run input-handling unit tests in build-xsnap"; head `a2157494`, draft, base `llm-54d3d2a`)

**Coverage and dead code:** nothing to do. The PR changes only `.github/workflows/ci.yml`: it adds a `cargo test ... --lib -- cas_archive:: run_input::` step to `build-xsnap`. There is no package source to cover and nothing left unused. I pushed nothing.

**CI:** 8 of 37 checks failed. The new "Test endor run input handling (endo crate)" step passed, and so did `build-xsnap`. Each failure traces to `ubuntu-latest` switching to the ubuntu-26.04 image around 10:24Z today:
- **`sandbox-drivers`, `test (22.x/24.x, ubuntu-latest)`, `cover (22.x/24.x, ubuntu-latest)`:** the bwrap tests in `packages/sandbox` fail with `/bin/sh: 1: ulimit: Illegal option -u` ("prlimit nproc cap is enforced inside the slice" and "bwrap parent death leaves no owned process group"). This was already known from PR #1527.
- **`build`:** the "Check for cycles" step fails with `scripts/graph.sh: line 32: tred: command not found` (exit 127). The 26.04 image seems to lack graphviz.
- **`test-ironhorse-oracle` and `ironhorse-oracle-sanitizers`:** two `ironhorse-262` test targets fail. In `corpus_conversion_equivalence`, `generated_cases_reproduce_corpus_coverage` reports "2 failure(s) (observable divergences or stale engine-versioned raw pins)". In `generated_multi_crank`, `converted_corpus_runs_as_crank_sequences` fails. These jobs logged `Image: ubuntu-26.04`, and PR #1535 fails `test-ironhorse-oracle` too. A YAML-only change can't cause these.

**Follow-up for the maintainer:** every PR stays red until someone fixes the base or pins the runner. The options are pinning `runs-on` to ubuntu-24.04, or making the sandbox tests portable, installing graphviz, and re-checking the ironhorse-262 corpus pins. Once that lands, rerun this PR's gauntlet. The PR's own change is sound.

**Other:** I added the `tred` and ironhorse-oracle failure signatures to the garden memory note on the ubuntu-26.04 breakage, so later stages can recognize them quickly.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1534-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (681827 cached reads)
- Output: 6146 tokens
- Cost: $0.6858854
- Wall-clock: 139s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
