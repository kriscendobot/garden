PR #1559 is now fully green on head `d82988084a`: 20 checks passed, 16 skipped as unaffected, none failed, and the PR is still mergeable. Neither failure came from the PR's own code; both came from changes outside the repo.

**zizmor.** zizmor checks that each pinned action's version comment matches its tag. The `create-pull-request` action moved its `v8` tag to a newer commit (`3ffccacd4605`), so the `# v8` comment on our older pin (`5f6978faf089`, which is `v8.1.1`) no longer matched. This affected two workflow files nobody had edited: `update-action-pins.yml` and `update-action-pins-major.yml`.
- **Fix** (commit `22580d5a4d`): changed the comment to `# v8.1.1`. The pinned action itself is unchanged.

**test-xs.** The repo's `.node-version` says `lts/*`, and CI now resolves that to Node 26.13.1 instead of 24. On Node 26, `Function.prototype.caller` has its own getter and setter instead of the shared `%ThrowTypeError%` function the spec describes. That flipped one hardened262 test, `ThrowTypeError/intrinsic-metadata.js`, from passed to failed in the `sesNode/module` scenario (SES on Node, without lockdown). With lockdown it still passes, because SES deletes those accessors.
- **Reproduced** with a downloaded Node 26.13.1. Node 22 doesn't show the failure.
- **Fix** (commit `d82988084a`): moved that test from the scenario's `passed.txt` to `failed.txt` in the baseline. Re-running the `sesNode` tests under Node 26 matched the updated baseline exactly.
- **This is not deleting a test.** The baseline records which tests each host passes and fails, so this records the host's behaviour, and the test still runs.
- **Other PRs are hit too:** #1590 and #1504 failed test-xs the same way today. The `llm` branch hasn't changed in 13 days, so it still lacks both fixes.

I pushed both commits as a fast-forward to `daemon-worker-import-from-mount`. The xs benchmark also printed a "❌ Failed" timing message in the old run, but it didn't fail the job, and the new run is green.

Follow-ups:
- **#1590 and #1592:** #1590's base is still the frozen `daemon-worker-import-from-mount-69cafe1`, so it doesn't have these fixes. It needs a weave onto the new #1559 head (`d82988084a`), and #1592 then needs a weave onto #1590. That's how the stack can proceed.
- **The `llm` branch:** cherry-picking these two commits onto `llm` (or onto PRs based on it) would stop every PR that runs test-xs, and any PR checked by zizmor, from hitting the same failures. Pinning `.node-version` instead is a broader decision for the maintainer.
- **Memory:** I saved a note on this failure pattern (`hardened262-node26-lts-caller-drift`).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1559.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3070328 cached reads)
- Output: 15147 tokens
- Cost: $1.6501096
- Wall-clock: 3050s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
