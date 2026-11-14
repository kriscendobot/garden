# Shepherd PR #1504: zizmor fixed; test-xs still red, caused by the base

CI on #1504 is not fully green. I fixed zizmor in the PR and resumed the gauntlet. The test-xs red comes from the base branch and will clear once #1646 merges.

**zizmor: fixed, now green.** The `peter-evans/create-pull-request` floating `v8` tag moved to v8.1.3, so zizmor flagged the `# v8` comment on the `5f6978fa` pin. That SHA is tag `v8.1.1`. I pushed commit `a2e4309dc6` ("ci: pin create-pull-request version comment to its exact tag"), which changes the comment in `update-action-pins.yml` and `update-action-pins-major.yml`. #1659 makes the same change, so the commit will drop out cleanly when the PR is next rebased.

**test-xs: still red, not caused by this PR.** The `@endo/hardened262` baseline entry for `sesNode/module test/intrinsics/ThrowTypeError/intrinsic-metadata.js` flips from passed to failed.
- **Cause:** `.node-version` is `lts/*`, which now resolves to Node 26.13.1 in CI. Under Node 26, `Function.prototype.caller` is no longer `%ThrowTypeError%`.
- **Deterministic, not a flake:** a rerun failed the same way, and so did the new head.
- **Not this PR:** the same red shows on #1649 and #1654 (others on `llm`, #1655 and #1657, are red too). The base `llm-9a14ddf` passed on 2026-10-28 under the previous LTS.
- **Fix in flight:** #1646 pins Node 24. Its CI is green and it is waiting on maintainer review and merge.

**Other CI on `a2e4309dc6`:** 21 checks pass and 10 are skipped. Four test legs (22.x and 24.x on ubuntu and macos-15) were still running when I stopped. They passed on the previous head `cfa346534e`, and my commit only changes workflow comments.

**Gauntlet resumed.** I ran `gauntlet.sh --resume-from-stage endojs-endo-but-for-bots-pr1504-gauntlet-20261114 panel --iteration 1 --add-rounds 2`. It was accepted, the child `…-20261114-panel-1` was posted, and max review rounds went from 6 to 8. The earlier clean-stage halt was caused only by these two base-side reds.

**Follow-up parked:** `weave-endojs-endo-but-for-bots-pr1504-after-pr1646` (weaver, gate blocked on #1646). Once #1646 lands, it confirms Node is no longer 26 and waits for any in-flight gauntlet fix stage. Then it weaves #1504 onto a fresh `llm` snapshot and drives test-xs to green.

**Cleanup:** the stale doom-parked `plan/endojs-endo-but-for-bots-pr1504-gauntlet-panel-4.md` from the old gauntlet can be withdrawn.

Verdict: `next: none` for the PR's own diff. The remaining red will clear once #1646 merges and the parked weave runs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1504.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2766909 cached reads)
- Output: 14386 tokens
- Cost: $1.5534057999999995
- Wall-clock: 2189s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
