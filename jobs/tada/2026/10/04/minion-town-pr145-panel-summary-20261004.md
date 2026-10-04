I sent the maintainer one message on kriscendobot/minion.town#145 (`inbox/maintainer/unread/msg-minion-town-pr145-panel-summary-20261004-473a0f0c87a7.md`, confirmed on `origin/journal2`). I did not push to the PR or stage another gauntlet.

**The message says:**
- **State:** the PR is still draft at head `31577bd`. CI is green: all 3 checks passed, and they ran on the self-hosted `ci-minion-town` runner.
- **Panel coverage:** the latest head has none. Round 6 reviewed `a3c861f`. `31577bd` answered it, mainly by rewriting the controller's scrub (+82/−28) to keep only entries recorded in a once-per-boot snapshot. No panel has read that rewrite, and it is not deployed: the live host still runs the older controller, so the green CI does not test the new scrub. It was only tested in a sandbox.
- **Round 6 objections:** the fix-6 report says all must-fix and should-fix items landed in `31577bd`.
- **Still open, as classed in the message:**
  - Follow-up-worthy: possible defects in the unreviewed scrub (a hygiene measure, not a security boundary — jobs can act as root through docker), and the lack of an automatic fallback to hosted runners when the single host is down.
  - Taste: the small race between the private-repo check and the mint, the missing JSDoc, and the suggested property tests.
  - Noise: spec-keeper, duality-auditor, coverage-auditor, releaser and warden, whose checks don't apply to this repo.
- **Security posture:** the secret `minion/ci-runner-github-token` still holds the bot's broad GitHub OAuth token (scopes `repo`, `workflow`, `gist`, `read:org`), which reaches every repo the bot can. The original build report flagged this on 2026-09-30. Secrets Manager shows the secret has not changed since it was created that day, so it was never replaced. The intended replacement is a fine-grained token with Administration: write on minion.town only, and only a person can create it. The repo is still private, which the design depends on.
- **Recommendation: merge after named small steps.** No code fix is needed.
  1. The maintainer replaces the token with the fine-grained one.
  2. Roll out in this order: `provision-ci-runner.sh`, then `deploy-ci-runner-host.sh`, then reboot the host, then run the selftest.
  3. Squash-merge.

  If the maintainer wants the new scrub reviewed before merging, the message suggests a single panel pass on `31577bd` rather than a seventh fix round.

**Follow-ups:** none are posted. The token swap and the rollout are for the maintainer to do.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `37b05e87595aab2d4132c6bbe674707d5bdcd372`; this job presented `31577bd76e3886d6717a09e8ca5bff5b50bd4fc5`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr145-panel-summary-20261004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1352629 cached reads)
- Output: 7122 tokens
- Cost: $1.0125978
- Wall-clock: 118s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
