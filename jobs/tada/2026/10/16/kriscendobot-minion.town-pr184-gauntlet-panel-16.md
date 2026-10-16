I ran panel round 16 on kriscendobot/minion.town PR #184 at head `bee6c066` against base `origin/main-bc11010`. The verdict is **must-fix**.

- **Run:** `panel.sh` ran in single-round mode, exited 0 and printed `code-panel single-round — must-fix`. All 34 seats ran and the decider produced its verdict.
- **Repeated-mechanism check:** the two rounds before this one (heads 2e7f1267 and 329cf0c2) both raised must-fix findings on `provision-ci-runner.sh`. Because of that, the panel asked the decomplector seat whether the mechanism is needed at all.
- **Review posted:** https://github.com/kriscendobot/minion.town/pull/184#pullrequestreview-5552366357 (state COMMENTED). GitHub refused a request-changes review because the bot owns the PR, so it went up as a comment review with the "Panel round 16 — must-fix" header, the same shape round 15 used. The full output was 88 KB, so the review has a summary plus the complete write-ups of the six seats that requested changes.

**Blocking findings:**
1. **Decomplector (must-fix):** the prod-probe backstop is built into the CI-runner provision and teardown scripts. As a result, seeding the probe token runs the whole runner provisioning. Tearing down the runner with `PURGE_SECRET=1` also deletes the probe's separate clock, which contradicts the PR's own reason for it ("alive when the runner is down"). The fix is to give the backstop its own provisioner, like `deploy/aws/scripts/deploy-thunk.sh`, and take it back out of `provision-ci-runner.sh`.
2. **Migrator (must-fix):** the shared `tokenFromSecret` now requires visible ASCII. That rule also applies to the existing runner secret, so a token stored with a trailing newline would break runner-token minting after redeploy. The provisioner should check the stored secret first, or the docs should say to re-seed it.
3. **Saboteur and breaker (should-fix):** the `jq -e` seed check accepts input the Lambda's `JSON.parse` rejects: several JSON documents pasted together, and `nan`/`NaN` values. A bad paste could then overwrite a working secret.
4. **Purist (should-fix):** `makeGitHubFetch` uses the global `fetch` instead of taking it as a parameter, and the GitHub client goes by four different names across the code.
5. **Pruner (request-changes):** the probe-token seeding instructions appear in four places, and several comments repeat the code next to them.

I made no fixes and did not un-draft the PR, as the job specified.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-panel-16.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (855015 cached reads)
- Output: 5382 tokens
- Cost: $0.8190190000000002
- Wall-clock: 283s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
