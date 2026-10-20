Verdict: proceed. PR #200 is open, is not superseded, and the reason it was opened still holds, so the gauntlet can start. I spent nothing on the clean, panel, fix, CI-wait or un-draft stages.

**Deciding question:** Is PR #200 still the only change bringing the settings menu down to three items (Connect CLI, Connect MCP, Invite a Friend) with Log out shown only when a recovery sign-in is bonded and account deletion, and is the closed-beta product pass it belongs to still current upstream? **Answer: yes.**

**Evidence:**
- **PR state:** open, unmerged and still a draft. The head is `feat/beta-settings-simplify` and the base is `main-6c66c2f`.
- **Its prerequisite has landed:** PR #200 was stacked on #198 ("one landing at /, closed-beta splash and waitlist"). #198 merged at 2026-10-20T12:12:53Z as merge commit `6c66c2f`. PR #200's base was then moved to the frozen `main-6c66c2f`. A compare of `main...main-6c66c2f` shows the two are identical, so the base matches today's `main`.
- **Rebased, no gap:** the head is 20 commits ahead of that base and 0 behind. Its latest commits are the audit HMAC fix, the docs that bring the shell design and `DEPLOYMENT.md` in line with the code, and the settings-module browser gate.
- **Nothing on `main` replaces it:**
  - `deploy/aws/www/settings.js` does not exist on `main`, so the settings work has not landed by another route.
  - The last 15 commits on `main` are all #198's landing/waitlist work.
  - The other open PRs cover different features: #199 is guest coupons, a declared sibling still in draft that #200 deliberately works without via an interface. #201 is New Clip, #202 is Chat, and #180/#181/#183/#186 are git-remote and canary work. None of them touches the settings menu or account deletion.
- **The motivation still holds:** the PR serves kriskowal's 2026-10-17 closed-beta product pass, and that pass is still moving (#198 merged today). Nobody except the bot has commented or reviewed on PR #200, so there is no maintainer veto or redirect. The previous gauntlet (`kriscendobot-minion.town-pr200-gauntlet`) stopped as `review-budget-reached` after 6 rounds on head `d8d3f2c`. It did not stop because the PR was superseded.

Nothing was committed or posted, and there are no follow-ups beyond the gauntlet's own next stages.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr200-gauntlet-20261020-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (163589 cached reads)
- Output: 2349 tokens
- Cost: $0.4314258
- Wall-clock: 64s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
