---
orchestration-failed: true
---
orchestration-failed: true

**Clean stage for #1646 failed: CI is red at head `224852cb18`, with one failing check. I pushed nothing.**

**Failing check:** `test (24.x, ubuntu-latest)`, [run 41584227374, job 125745982842](https://github.com/endojs/endo-but-for-bots/actions/runs/41584227374/job/125745982842)
- **Step and package:** "Run yarn test (affected set)", in `packages/sandbox`.
- **Test:** `bwrap › bwrap timeout and repeated cancellation reap process groups`, which reported 1 test failed.
- **Error:** `process group 51058 survived bounded cleanup`, at `packages/sandbox/test/bwrap.test.js:266` and `:1099`.
- **Overall result:** `ci-wait-merge.sh` returned rc 3, with 1 of 36 checks failed. The other 35 passed or were skipped, including `test-xs`, `sandbox-drivers` and both `cover` jobs. The `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` jobs were skipped.

**Likely cause: not this PR.** The diff only changes `.node-version` from `lts/*` to `24`, and the job already ran on Node 24.22.1 because the matrix sets it.
- **Known failure:** the same error has already hit #1586, #1476 and #1643, each time only in `cover (22.x, ubuntu-latest)`. #1476's previous head was fully green, so it looks intermittent.
- **Open fix:** #1591 (bwrap process-group sweep) targets this failure and is still open. Once it merges, this PR will need a weave to pick it up.
- **Not tested:** I didn't reproduce the failure locally or rerun the job, because no garden skill authorizes a rerun at this stage.

**Coverage pass:** nothing to do. The PR touches no package source or tests, so there is nothing to measure and no code it could orphan.

**Also changed:** I added this sighting to the `ebfb-ci-ubuntu-2604-sandbox-ulimit` memory, since it shows the failure also reaches `test` jobs, not just `cover`.

**Follow-ups for the maintainer:**
- **Get past the red check:** either land #1591 and weave, or rerun the failed job. A pass on rerun would allow the gauntlet to resume.
- **Priority:** #1646 is the proposed fix for the Node 26 `test-xs` failure on other PRs, so this flake is also holding that fix back. `test-xs` passes here.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1646-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (404606 cached reads)
- Output: 5485 tokens
- Cost: $0.6027412
- Wall-clock: 1906s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
