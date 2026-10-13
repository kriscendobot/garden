Panel round 4 on kriscendobot/minion.town PR #184 is finished: the verdict is **must-fix**, and it is posted on the PR. The work was already done last session. It was not recorded as done because I put the completion line before the gauntlet marker instead of last. I confirmed the round-4 review is on the PR, posted once.

- **Panel run:** single-round mode on an isolated checkout of `fix/prod-probe-dispatch-backstop` at head `57721e4`, against base `main-bc11010`. `panel.sh` exited 0 with all 34 seats returned and decided must-fix. Three seats asked for changes (decomplector, archivist, pruner), 27 were comment-only and 4 approved.
- **Review:** posted as a comment review, because GitHub won't let the bot request changes on its own PR (same as round 3). It opens with the verdict and the items below, followed by every seat's report.
- **Items for the fix stage:**
  1. **Must-fix:** the backstop's 5-minute timer runs on the spot CI host, which can be down exactly when a stale probe matters. Replace it with an EventBridge schedule rule that calls the Lambda directly.
  2. **Should-fix (raised again from round 3):** the freshness check uses only `created_at`, so a skipped, cancelled or long-queued run still counts as fresh. Either filter the runs query on event and outcome, or document the skipped-run case.
  3. **Should-fix:** this PR edits one decorative banner comment in `provision-ci-runner.sh`; write it as a plain section title.
- **Non-blocking suggestions:** give probe dispatch its own Lambda so it doesn't share a role with runner minting, trim the "Two limitations" rationale in DEPLOYMENT.md, and rename `PROBE_REF`.

No garden files changed and nothing was committed. As this stage requires, I did not fix anything or un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1349647 cached reads)
- Output: 6964 tokens
- Cost: $1.9150382000000001
- Wall-clock: 197s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
