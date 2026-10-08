## Gauntlet fix round 2: kriscendobot/minion.town PR #171

I applied all four must-fix items from panel round 2 (review 5452908419) and pushed one follow-up commit. The PR head moved from `ec6c927` to `4aec293`, and CI is **GREEN** on that head (test, Claude harness amd64 and arm64; `ci-wait-merge.sh` rc 0).

**Must-fix items:**
1. **prover (the strict-run test also passed on the base code):** I rewrote the test in `deploy/probe/prod-objectives.test.mjs` to go through `runCheck`. It runs a passing check and an `awaiting` check that throws `CheckSkipped`, and asserts `deferred` with a strict exit of 0. It also asserts that the same skip without `awaiting` exits 1. To confirm the test catches the bug, I removed the `deferred` mapping in `runCheck`: the test failed, then I put the mapping back. The probe suite passes 30/30.
2. **integrator (the production evidence showed `SKIPPED`):** I edited the PR body to say that production run predates the `deferred` status. It now quotes the line the current code prints and notes that only the unit suite has run the `deferred` path, not production. I did not re-run the probe live.
3. **integrator, pruner (review-round narration and mixed test counts):** I removed the "Fix round 1" narration from the PR body. The Verification list now gives each suite once: the probe suite 30/30 and the `tools/claude-harness` suite 30/30 (I re-ran it). The regression-evidence paragraph is updated too. I kept the stacking caveat because the PR is still a draft stacked on #166.
4. **scribe (no completion-summary comment):** I posted one (https://github.com/kriscendobot/minion.town/pull/171#issuecomment-6054647794). It goes through each round-1 and round-2 must-fix item as addressed or declined. Two round-1 items are declined:
   - **Probe-only role:** it needs an IAM change in `deploy-cd-iam.mjs`, so it stays a follow-up.
   - **Repo variables for the role ARN and instance ID:** the workflow matches `deploy.yml`, which also uses literals.

I also fixed one small should-fix: `DEPLOYMENT.md` now spells out the deferred reason with the full #167 URL instead of `…#167`.

**Follow-ups (should-fix items still open):**
- `DISABLE_UPDATES` is checked on the parent Node service, not on the `claude` process it spawns, so the check doesn't observe the binary it claims to pin.
- A run with a deferred check still reports `overall: pass`, the same as a run where everything was checked.
- If the service restarts between reading its `MainPID` and reading `/proc/<pid>/environ`, the whole observation fails with an unclear message.
- `observationError` is duplicated, and the deployed file layout is defined in two places.
- The probe-only role should be recorded as a blocking follow-up before merge.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr171-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1593953 cached reads)
- Output: 9637 tokens
- Cost: $1.0357225999999997
- Wall-clock: 397s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
