## Fix round 11: kriscendobot/minion.town PR #184, done and CI green

I applied the round-11 must-fix items from the scribe and pruner seats, pushed commit `5c2279d` to `fix/prod-probe-dispatch-backstop` (fast-forward from `4d0012b`) with `safe-push-pr-head.sh`, and CI passed (`ci-wait-merge.sh` rc 0).

**Pruner items:**
- **JSDoc:** in `deploy/aws/ci-runner/lambda/prod-probe-backstop.mjs`, I removed the `@param` descriptions for `options.repo` and `options.getToken`, which only restated the parameter names. The `githubRequest` description and the "options exist for tests" sentence stay.
- **Token scope:** in `DEPLOYMENT.md`, the `minion/prod-probe-dispatch-token` row in the secrets table no longer repeats the token's scope. It now points to the § CI runner Credentials bullet, which still has the full statement.
- **Item 3** (design rationale in § Dispatch backstop) was acknowledge-only, so I left it unchanged.

**Decomplector note:** the § Dispatch backstop text said the concurrency group "holds at most one pending run", which implied every dispatch is kept. It now says that with `cancel-in-progress: false` a newer dispatch replaces an older pending run, and that nothing is lost because both would run the same probe on `main`.

**Scribe item:** I posted a summary comment, https://github.com/kriscendobot/minion.town/pull/184#issuecomment-6203379954. It gives the new head SHA and explains the `4d0012b` redesign: the backstop now dispatches on a fixed three-hour schedule instead of reading run history, and the cooldown and freshness threshold are gone. It also lists what was declined: replacing the Lambda with an EventBridge API destination, and adding a CloudWatch alarm on Lambda errors, which stays a documented follow-up. It ends with how this was verified.

**Verification:**
- The backstop's two test files (`deploy/aws/ci-runner/lambda/test/*.test.mjs`) pass locally: 21 passed, 0 failed.
- The bot's token can't read the PR's combined check status, so `ci-wait-merge.sh` fell back to the Actions runs API. That API showed one run on `5c2279d` and it succeeded. Any commit statuses or checks that don't come from Actions were not visible to it.

**Follow-ups:** none from this round. The panel-12 stage reviews next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-fix-11.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (984177 cached reads)
- Output: 6014 tokens
- Cost: $0.7579874
- Wall-clock: 1283s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
