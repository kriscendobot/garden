## Completion report: fu-endojs-endo-but-for-bots-pr1594-gauntlet-fix-4-1

The fix is done and up for review as draft PR https://github.com/endojs/endo-but-for-bots/pull/1598 (`xs-manager-test-rust` → `llm-9a14ddf`). An earlier claimant of this job opened that PR and pushed all of the work but never sent the completion signal. This run did not change any code. I checked that the earlier work is complete and pushed, and that the review pipeline (the "gauntlet") is already queued for it.

**What I checked:**
- The PR carries this job's `<!-- garden-job: ... -->` marker, so it belongs to this job.
- The project worktree has no uncommitted changes. Its HEAD (`840215a14`) is the same commit as the remote branch, so nothing is unpushed.
- The diff (9 files) covers everything the job named:
  - **Load-time crash:** serial tests now use `testNeedsNodeWorkerSerial`, which fixes `testNeedsNodeWorker.serial is not a function`.
  - **31 failing tests:** fixed in the XS manager and Rust supervisor. Host byte buffers are now fixed-length, `harden` handles typed arrays, empty UTF-8/base64 codecs return `''`, timers honor their delays (this was what made ava time out), and the bundle now gets the host's `URL`.
  - **Remaining gaps:** tests that need powers the XS side doesn't have yet are skipped explicitly rather than left failing. They use `testNeedsNodeManagerPowers` and `testNeedsNodeWorker`.
- The PR reports a local `test:rust` result of 197 passed, 0 failed, 95 skipped, run to completion. I did not re-run it, since it needs a release build of `endor` plus about 35 minutes.
- The board already holds `endojs-endo-but-for-bots-pr1598-gauntlet` and `-gauntlet-clean`, so the clean → review → fix → un-draft steps will follow without anything more from me.

**CI on head `840215a`:** 13 checks pass, 5 are still running (lint and the test 22.x/24.x matrix), and 1 fails:
- **`test-ironhorse-oracle`:** fails in `ironhorse-262` `corpus_conversion_equivalence::generated_cases_reproduce_corpus_coverage` ("stale engine-versioned raw pins"). That matches the known ubuntu-26.04 runner/base breakage already seen on unrelated PRs (#1534 changed only CI YAML, and #1535 failed the same way). One gap: I found no oracle run on base `llm` itself to compare against. Base PR #1594 skipped that job.

**Follow-ups:**
- Running `test:rust` in CI (the end goal the job named) is still not done. The PR leaves that out on purpose, because a full run takes about 35 minutes plus the release build. Whether it should be a required CI check is a decision for the maintainer.
- Once the base runner breakage is fixed, the ironhorse-oracle failure will need re-checking (it may need a weave onto a newer base).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr1594-gauntlet-fix-4-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 40 tokens (1120176 cached reads)
- Output: 6416 tokens
- Cost: $0.7811712 (1 engagement(s) unpriced)
- Wall-clock: 11308s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
