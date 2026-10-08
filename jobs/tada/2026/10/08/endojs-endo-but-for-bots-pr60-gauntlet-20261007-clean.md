Clean stage done for endojs/endo-but-for-bots PR #60, with nothing changed and nothing pushed.

- **PR state:** open, not a draft. The head is `488646a2b3` on branch `design/issue-390-intrinsics-test`, based on `master-46d4edf`.
- **What the PR changes:** it adds one file, `packages/ses/test/get-intrinsics.test.js`. This test replaces the one deleted in endojs/endo#372 (tracked in endojs/endo#390). It touches no source code.
- **Coverage and dead-code pass:** there was nothing to do. A test-only change adds no new code paths to cover and cannot leave any code unused, so I made no project checkout and pushed no commits. I didn't run the new test locally.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 (GREEN). The PR has only one check, `copilot-setup-steps`, and it passed.

**Follow-up:** that one check is the whole CI signal. The main test workflow likely doesn't trigger on the frozen `master-46d4edf` base, so the new test has never actually run in CI. The panel stage should keep this in mind.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr60-gauntlet-20261007-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (164134 cached reads)
- Output: 1194 tokens
- Cost: $0.3793388
- Wall-clock: 20s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
