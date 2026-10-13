I applied the round-4 panel fixes to kriscendobot/minion.town#184, pushed them, and CI is green on head `b52836a` (`ci-wait-merge` rc 0).

**Must-fix items (all three applied):**
1. **The backstop's clock is now EventBridge, not the CI host.**
   - I deleted `host/prod-probe-backstop.{sh,service,timer}` and reverted the PR's changes to `bootstrap.sh` and `deploy-ci-runner-host.sh`, so nothing changes on the host now.
   - `provision-ci-runner.sh` now creates an EventBridge rule, `minion-town-prod-probe-backstop`. Every five minutes it invokes a new Lambda of the same name with the fixed event `{"op":"prod-probe-backstop"}`.
   - That Lambda runs the same `index.mjs` as the runner minter, set to serve only the backstop op. Its role can read only the probe secret.
   - The minter now serves only mint and prune, can read only the runner secret, and rejects the backstop op. The host role can invoke only the minter, so it can no longer trigger the backstop.
   - This also takes the panel's non-blocking suggestion to split probe dispatch into its own function.
   - `teardown-ci-runner.sh` removes the new rule, function, role and policy.
2. **A run now counts only if the probe actually ran.** The Lambda lists the last 100 runs on `main` (it used to look at one). It counts a run only if:
   - a schedule, a deploy (`workflow_run`) or a manual dispatch started it;
   - it did not end skipped or cancelled;
   - it is running, finished, or has waited less than an hour for a runner;
   - it is dated no more than five minutes in the future.
3. **Banner comment:** the credentials comment line I touched is now plain: `# 0. the GitHub credentials (seed/rotate only on request)`.

**Also changed:**
- I renamed `PROBE_REF` to `PROBE_DISPATCH_BRANCH`, as the panel's typist suggested.
- The JSDoc now marks the optional `previous*` result fields.
- I rewrote the DEPLOYMENT.md "Dispatch backstop" section and its credentials notes, and trimmed the rationale the panel's pruner flagged.
- I updated the PR body to match the new design and kept its `garden-job` marker.

**Tests:** 29 of 29 Lambda unit tests pass. New cases cover which ops each Lambda serves, skipped, cancelled, long-queued and other-event runs not counting, choosing the newest run that counts, and running or recently queued runs counting. Both shell scripts pass `bash -n` and shellcheck with only the existing info notices.

**For the panel-5 round:**
- While the probe runner is offline, every five-minute check dispatches another run. The workflow's concurrency setting keeps at most one of those waiting, and DEPLOYMENT.md records this.
- There is still no guard against a second dispatch before GitHub lists the first one. That is documented as an accepted limit.
- Prettier reports formatting issues in DEPLOYMENT.md, `index.mjs` and the test file. CI doesn't enforce Prettier, and the files already failed the check before this round, so I left them alone.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2787510 cached reads)
- Output: 28597 tokens
- Cost: $2.0508580000000003
- Wall-clock: 1351s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
