Clean stage for endojs/endo-but-for-bots PR #1425 ("fix(ses): sample XS compartment intrinsics at lockdown"): nothing needed changing. The PR was already in the right shape, so I pushed nothing.

- **CI:** The PR is a draft and still open. Its head is `3158064e5`. `ci-wait-merge.sh --no-merge` returned rc 0 (CI GREEN), with all 15 checks passing, including `test-xs` and `cover`.
- **Coverage:** The fix is that on XS, new compartments now get the global intrinsics as they stand at `lockdown()` instead of the ones sampled when SES was imported. `packages/ses/test/_xs.js` already has a regression test for it. Between importing SES and calling lockdown, the test deletes `TextEncoder` and replaces `TextDecoder`. It then checks that a new compartment does not see the deleted global, shares the replacement, and that the replacement and its prototype are frozen. I judged this coverage enough and did not run a separate local coverage pass.
- **Dead code:** None. `ShimStartCompartment` is still used, because `shimCompartmentPrototype` is built from it.

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1425-gauntlet-20261007-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (166797 cached reads)
- Output: 1368 tokens
- Cost: $0.3987914000000001
- Wall-clock: 19s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
