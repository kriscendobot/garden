PR #241 (kriscendobot/minion.town) failed this panel round with a must-fix verdict.

- **Pinned pair:** base `919689231495f6b62fd5a7a80c712acd667881a2`, head `f2bdecafefba2d2f596a23db0c5f205613d57c82`. The head is on branch `kriscendobot:garden/build-api-key-agents-p0-freeze-onboarding`. I checked it out detached in the isolated worktree `/home/kris/garden/scratch/project-wt-kriscen-d894df4e09f2-9bcc8ba3`, and `git rev-parse HEAD` matched the head ID.
- **Style pre-pass:** the read-only probes (`pre-push-gates.sh --no-auto-fix --probes-only`) exited 0. There was one non-blocking warning: the pruner should check a 3-line prose comment at `src/endo/claude/types.ts:51`.
- **Panel:** I ran one round with `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` and it exited 0. It added the decomplector because new code mechanisms were detected, and forced the pruner over the PR description. It posted its own review at 2026-11-04T18:39:13Z under the heading "Must-fix before merge". The review is a COMMENTED review, not a changes-requested one, because the bot authored the PR.
- **Leading finding (migrator):** freezing onboarding also removes the way to re-authenticate. Once an account's status is `needs-auth`, `connect()` returns `onboarding-frozen` and the account page drops the connect link. So a deployment with an expired credential can't get a new setup token, and the PR's claim that existing credentials keep running is partly false.
- **A process note:** I stopped my first panel launch a few seconds in because its background time limit (10 minutes) might have been too short. It had only logged its first line and posted nothing; the rerun is the only round that posted a review.

I made no fixes, did not un-draft the PR, and committed nothing to the garden. Next, the gauntlet driver routes this result to fix round 2.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr241-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (552391 cached reads)
- Output: 2983 tokens
- Cost: $0.5997941999999999
- Wall-clock: 210s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
