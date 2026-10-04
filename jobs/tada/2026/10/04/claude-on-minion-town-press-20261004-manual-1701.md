## Press of the Claude-on-minion.town arc, 2026-10-04 ~17:05Z

There was new state this time. The production canary failed, so I updated the issue body and replied with a press comment: https://github.com/kriscendobot/garden/issues/89#issuecomment-5982364253

**What I found:**
- **Canary failed.** The canary `minion-town-claude-cli-production-canary-20261003` ran at about 15:50Z and reported `orchestration-failed`. The code from kriscendobot/minion.town#148 is deployed, but the Claude provider is off:
  - the service has no `ENDO_CLAUDE_*` variables;
  - its memory limit is 256M;
  - `/account/claude/<nonce>` returns 404;
  - `agentsFor` is not wired into anything.
- **Fix in progress.** The fix is draft kriscendobot/minion.town#150. CI is green and its gauntlet is in fix round 2.
  - The merge job `minion-town-pr150-conduct-20261004` is parked until the gauntlet finishes.
  - The job that checks the host and re-posts the canary, `minion-town-claude-cli-production-enable-verify-20261004`, is parked until #150 merges.
- **Unanswered question.** kriscendobot/minion.town#149 (the root-socket relay gap) still has no maintainer answer.
- **PRs the job named:**
  - kriscendobot/minion.town#87 and endojs/endo-but-for-bots#1015 are merged.
  - endojs/endo-but-for-bots#1125 is closed.
  - None of the three blocks anything now.

**What I changed:**
- **Issue body.** I added a 17:0xZ evidence note at the top of the checklist. No boxes changed, and the architecture text and item specs are untouched.
- **Comment.** It has two review asks, which replace the 15:52Z ones:
  1. Decide #149 first, because #150 turns production on without fixing it.
  2. Approve #150 once its gauntlet takes it out of draft. That merge leads to the re-posted canary, which sends the maintainer the `claude setup-token` connect link.
- **No new jobs.** The whole chain after #150 is already on the board.
- **No maintainer-inbox message.** An earlier press job today (`claude-on-minion-town-completion-press-20261004-162011`) already messaged the maintainer about #149, so a second message would only repeat it. Later presses should just check whether #149 has been answered and whether #150 has been approved.

**Follow-ups:** none new. The gauntlet on #150 is still running.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-press-20261004-manual-1701.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1018322 cached reads)
- Output: 6182 tokens
- Cost: $0.8737923999999999
- Wall-clock: 74s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
