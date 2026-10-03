PR #1391's clean stage is still pending: CI didn't finish within the 1-hour deadline (`ci-wait-merge.sh` rc=4). One check, `test (22.x, macos-15)`, has been waiting for a GitHub macOS runner since 06:27Z and never started.

**Why CI was red:** at head `008820366e`, only the two macOS test jobs had failed. Both failed on the same daemon test, `daemon-teardown › an orphaned daemon shuts itself down instead of lingering`. This PR only changes `packages/ses`. The same test also failed on the `llm` branch's own macOS legs (CI runs 36886282492 and 36837442037), so it's an existing flake, not caused by this PR. I reran the failed jobs of run 36888178299:
- `test (24.x, macos-15)` passed on the rerun.
- `test (22.x, macos-15)` was still queued at the deadline. The other 31 checks are green or skipped.

**Coverage pass (`packages/ses`):** I ran c8 over the new SturdyRef tests and `global-locked-universal.test.js`, and all 14 tests passed. Every new line and branch is covered:
- the `assertSturdyRefShape` guard in `intrinsics.js`, which rejects an accessor, a non-function, or a function missing the expected statics;
- the "leave the shim's locked binding in place" path in `global-object.js`.

The only uncovered lines in those files are in older code this PR doesn't touch. The diff only adds code, so nothing is left dead.

**Changes:** nothing was pushed to the PR head; the only action on GitHub was the failed-jobs rerun.

**Next:** the re-posted clean stage only needs to wait for the queued 22.x macOS job. If it fails again on `daemon-teardown`, that's the same flake and should be retried, not fixed in the PR's code.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261003-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1367148 cached reads)
- Output: 6544 tokens
- Cost: $0.9018456
- Wall-clock: 3738s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
