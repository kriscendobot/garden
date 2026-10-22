---
orchestration-failed: true
---
orchestration-failed: true

# Clean stage for endojs/endo-but-for-bots PR #1535: CI is red, but not because of this PR's diff

**Result:** The clean stage failed. I pushed nothing, and the CI wait (`ci-wait-merge.sh`) ended red with rc=3 at head `1bd23548c4`. All 7 red checks come from the ubuntu-26.04 runner switch and a break in the base branch, not from this PR.

**Coverage pass:** There was nothing to clean. The PR is a small Rust change in `ironhorse-vm`: a new `store_chain_tail` helper caps the store-chain walk in bounded runs, with callers in `environment.rs` and `dispatch.rs`. The only lines removed are the old inline walk, which the new helper replaces, so no code is left unused. The new test `tests/finding_1015c4e9cf8a361f_store_chain_walk.rs` reproduces the fuzz timeout and checks that a bounded run now stops with `Halt::StepLimit`.

**The 7 red checks:**
- **`sandbox-drivers`, `test (22.x/24.x, ubuntu-latest)`, `cover (22.x/24.x, ubuntu-latest)`:** these fail on the `packages/sandbox` bwrap tests. One is "prlimit nproc cap is enforced inside the slice", which errors with `/bin/sh: 1: ulimit: Illegal option -u`. The other is "bwrap parent death leaves no owned process group". `ubuntu-latest` became 26.04 on 2026-10-22, and these tests break there on every PR, including Rust-only ones.
- **`test-ironhorse-oracle`, `ironhorse-oracle-sanitizers`:** these fail in `ironhorse-262`. The test `corpus_conversion_equivalence::generated_cases_reproduce_corpus_coverage` panics with "2 failure(s) (observable divergences or stale engine-versioned raw pins…)", and the sanitizers job also fails `generated_multi_crank`. PR #1534 has the same base (`llm-54d3d2a`) and only changes `.github/workflows/ci.yml`, and both checks fail there too. So the base is broken, not this diff.
- The macOS test jobs, `test-ironhorse`, `fuzz-ironhorse`, lint, and the build checks all pass.

**Follow-ups (outside this PR):**
- Someone needs to fix the sandbox bwrap tests for 26.04, or pin the runner to `ubuntu-24.04`.
- Someone needs to fix the stale engine-versioned corpus pins on the base, or weave this PR onto a fixed base.
- The maintainer was already told about the runner breakage from the PR #1527 gauntlet. Once a fix lands, re-run this gauntlet.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1535-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 90 tokens (3155861 cached reads)
- Output: 17559 tokens
- Cost: $2.0821602
- Wall-clock: 4206s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
