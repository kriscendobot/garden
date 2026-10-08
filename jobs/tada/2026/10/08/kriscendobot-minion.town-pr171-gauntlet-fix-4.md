Round 4's must-fix items were already done on the PR head before this job started. I pushed nothing and CI is green.

The panel reviewed `e49f49f`. The head is now `3418e13`, which includes `19f6c27` (rest the harness upgrade policy on ownership, not `DISABLE_UPDATES`). I checked each must-fix against that head:
- **`DISABLE_UPDATES` leg:** it no longer appears in the probe code. `prod-objectives.mjs:458` now reports `upgradePolicy: "root-owned read-only artifact and parent directories"`. The `DEPLOYMENT.md` table row (line 1472) describes the check by ownership and digests. The remaining `DISABLE_UPDATES` mentions are unrelated provisioning and Dockerfile text.
- **Terminology:** `DEPLOYMENT.md:1457` says "The checked production objectives". No "primary-phase objectives" wording remains in `DEPLOYMENT.md`. The one other "primary phase" hit, `deploy/aws/daemon/README.md:3`, is a reference to the agenda, not this section.
- **PR body:** "Not in this PR" is a single sentence citing #167 and kriscendobot/garden#89. The trailing "does not harden the workflow further" clause is gone from § Least privilege. The body also explains the `DISABLE_UPDATES` change.

I did not touch the should-fix items. These remain for the next panel or the maintainer:
- **integrator:** reuse `validateRelease` from `tools/claude-harness/release-verifier.mjs` instead of the local `expectedHarness`; regroup the commits so the added-then-removed `deferred` machinery drops out of history; rerun the probe at the new head and cite that run. The only cited run is the 2026-10-08T05:49:59Z one, which predates the new `upgradePolicy` string.
- **engine-realist:** add a test that parses the generated on-box program with `new vm.Script(harnessObservationProgram(...))`.
- **decomplector:** collapse the harness layout, currently declared in `deploy-app.sh`, `cli-deployment.ts` and `claude-harness.mjs`, into one tracked data file.
- **saboteur:** keep the first line of the swallowed `ssm wait` error so an `InProgress` failure says it was a wait timeout.

`ci-wait-merge.sh --no-merge` returned rc 0: all 3 checks green, none failed. The driver can re-post panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr171-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 44 tokens (1305488 cached reads)
- Output: 9252 tokens
- Cost: $1.1323756
- Wall-clock: 193s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
