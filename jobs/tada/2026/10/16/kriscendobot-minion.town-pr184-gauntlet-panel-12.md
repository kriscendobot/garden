Panel round 12 on PR #184 came back **must-fix**, and I posted the verdict on the PR as a review.

- **Run:** I checked out the PR head `fix/prod-probe-dispatch-backstop` at `5c2279d` and ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against base `main-bc11010`. It exited 0 with disposition `must-fix`. The panel flagged a repeated must-fix on one mechanism and so asked the decomplector whether the mechanism is needed at all.
- **Blocking seats:** pruner and decomplector asked for changes. The other seats approved or left comment-only notes.
- **Decomplector's main finding:** the AWS dispatch backstop duplicates the workflow's own 3-hourly cron in `prod-probe.yml`. It adds a Lambda, an EventBridge rule, a stored GitHub token and an IAM role, and no dropped cron run is cited as the reason. It asks the maintainer to confirm the backstop is justified, or to cut to one schedule: either drop the backstop and alert when no probe has run for 4 hours, or keep the Lambda and remove the workflow's cron.
- **Its should-fix items:**
  - The `github.mjs` split exists only to serve the backstop.
  - `--strict` is now hardcoded for manual runs too.
- **How it was posted:** GitHub refused a request-changes review because the bot opened the PR, so I posted it as a comment review headed "Panel round 12 — must-fix". The full aggregate is about 81K characters, over GitHub's limit, so the two blocking seat reports are in full and the other seats' reports are shortened to fit (51K posted).
- **Follow-up:** the decomplector's question needs a maintainer decision. Another round of hardening fixes won't settle it.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-panel-12.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (640521 cached reads)
- Output: 3456 tokens
- Cost: $0.6071842000000001
- Wall-clock: 149s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
