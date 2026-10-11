## Fix round 8 for kriscendobot/minion.town#171: fix pushed and CI is green

Two seats asked for changes in round 8: pruner and decomplector. I addressed both, with one exception noted under the PR body change.

**Code change.** I pushed commit `dfa92f3` to `feat/claude-arc-prod-validation` with `safe-push-pr-head.sh` (advance mode, `b65b1f4..dfa92f3`). It adds two explanations to `DEPLOYMENT.md` § AWS/SSM, which decomplector asked for:
- **Why the probe's OIDC `sub` is keyed to the `prod-probe` environment and not to `ref:refs/heads/main`.** A `sub` keyed to `main` would be the same subject the deploy role trusts, so one token could take either role. That is why the environment's branch policy is what keeps the probe on `main`, and why `deploy-cd-iam.mjs` checks it before provisioning.
- **Why the observer's path list ships as code and not as an SSM parameter.** If the caller supplied the list, the grant could choose what root reads. That would undo what the fixed SSM document prevents.

**PR body.** Pruner flagged the body as too long at 354 words. I cut it to 281:
- The "Status" paragraph is now one short sentence, which also points to the new `DEPLOYMENT.md` explanations.
- The regression-evidence line now just says the ownership violation is regression-tested.
- **The phase ledger is shortened, not removed as pruner asked.** I kept it because `scripts/jobs/gardening/phase-evidence-gate.sh` reads it, and its "orchestrated-slice" entry keeps this PR draft until the live phases are done. I kept every row and trimmed each evidence note to a few words. Running the gate on the new body returned "clear" (exit 0).

**CI.** `ci-wait-merge.sh --no-merge` exited 0: all three checks passed (test, Claude harness amd64, Claude harness arm64). My first, backgrounded `ci-wait-merge.sh` call hit its time limit and was stopped; I polled the checks in the foreground and re-ran the script once they had finished.

**Follow-ups.** None from this stage. The decomplector and assessor comments that were not required are left for the panel-9 driver. Those include the two sanitizers that nearly duplicate each other, the uncaught `--version` throw in the observer, and its handling of `ENOTDIR`/`EACCES` errors.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr171-screen-ce06e2d3-gauntlet-fix-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1149357 cached reads)
- Output: 7130 tokens
- Cost: $0.8800714
- Wall-clock: 1363s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
