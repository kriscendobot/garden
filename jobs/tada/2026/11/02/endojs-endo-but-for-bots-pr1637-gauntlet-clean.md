---
orchestration-failed: true
---
orchestration-failed: true

# PR #1637 clean stage: CI is red, so the stage failed

**Verdict:** `ci-wait-merge.sh` returned rc 3 (red). 6 of 39 checks failed at head `e81150d610`. The gauntlet should halt here. As far as I can tell none of the six failures comes from this PR's diff, but the gate did not pass.

**What I checked:**
- **The PR:** endojs/endo-but-for-bots#1637, still a draft. Head `ci/daemon-test-rust` goes into the pinned base `xs-manager-test-rust-840215a`. It touches three files:
  - `.github/workflows/ci.yml`: a new `test-daemon-rust` CI job.
  - `scripts/ci-changes.py`: makes `test-daemon-rust` run whenever `build-xsnap` runs.
  - `scripts/test-ci-changes.py`: a new test for that rule.
- **Coverage and dead code:** I ran `python3 scripts/test-ci-changes.py` locally and all 39 tests pass. The new `test_daemon_on_endor_follows_build_xsnap` test covers the new rule both ways (paths that should select the job and one that shouldn't). The change leaves no dead code behind. I changed nothing and pushed nothing.
- **The new CI job:** `test-daemon-rust` passed in CI (8m46s).

**The six failures.** Editing `ci.yml` makes CI run every job, so the PR picked up reds from code it doesn't touch:
- **`test-ironhorse-oracle` and `ironhorse-oracle-sanitizers`:** the `corpus_conversion_equivalence` test fails on `stage3-math/054.js` and `055.js` (last-digit float mismatches), and the sanitizer job also fails `generated_multi_crank`. This is the known ubuntu glibc red (fix is PR #1613). `test-ironhorse-oracle` also fails on the base commit `840215a144`.
- **`sandbox-drivers`, `cover (24.x, ubuntu-latest)` and `test (22.x, ubuntu-latest)`:** all fail one test, `bwrap › bwrap timeout and repeated cancellation reap process groups` ("process group survived bounded cleanup"). This matches the bwrap red already noted from earlier PRs (fix is #1566). On the base commit, `sandbox-drivers` and `cover` passed.
- **`test-xs`:** `@endo/hardened262#test:xs` exited 1. The log shows no further detail. This job was skipped on the base commit, so there's nothing to compare against. The PR doesn't touch hardened262 or anything XS.

**Follow-ups:** to get #1637 green, land or pick up the stage3-math fix (#1613) and the bwrap fix (#1566) on the base, then weave. Someone should look into the hardened262 `test:xs` failure separately.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1637-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1324631 cached reads)
- Output: 6912 tokens
- Cost: $0.9192062000000001
- Wall-clock: 2992s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
