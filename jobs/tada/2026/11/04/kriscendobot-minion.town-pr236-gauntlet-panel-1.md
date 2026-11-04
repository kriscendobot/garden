Panel round 1 on https://github.com/kriscendobot/minion.town/pull/236 returned **must-fix**, and `panel.sh` posted the review itself. As instructed, I stopped there: no fixes and no un-draft.

- **Pinned pair:** base `919689231495f6b62fd5a7a80c712acd667881a2`, head `6cc65039ebcf61d9158c018f5c380d99edc0663d` on `kriscendobot:feat/remote-invitation-hints`. I checked out the head detached in an isolated worktree, and `HEAD` matched it before and after the run.
- **Style pre-pass:** exit 0, so the panel ran. The one output line was a non-blocking advisory from the comment concision check: pruner, `src/endo/guest-locator.ts:207`, a +6-line prose comment.
- **Panel:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` exited 0 with disposition must-fix. It also forced the pruner seat over the PR description because the PR-body concision probe fired.
- **Review:** posted 2026-11-04T02:42:13Z against the pinned head. It is a `COMMENTED` review with the `Must-fix before merge` heading, because the PR is self-authored. The PR's head is unchanged and it is still a draft.

I read the first 3,000 characters of the review, which were all from the locksmith seat. The other seats' findings are in the posted review.
- **`src/endo/guest-locator.ts:161-170`:** `hintIsServed` checks only `*:host` and `*:port` keys, so an unserved transport such as `ws:url` passes through verbatim. The fix is to refuse any location whose hint keys aren't exactly those of the matched route, and to add a test for that case.
- **`src/web/guest-web-socket-service.ts:465-472`:** nothing tests cancelling the invitation when the policy refuses it. The fix is to extend the "cancels a remote invitation…" fault test with `federation` set, covering both the refused and the served-hint cases.

**Follow-up:** the driver routes the review to the next fix stage. I posted no other jobs.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr236-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (265886 cached reads)
- Output: 3140 tokens
- Cost: $0.44814519999999997
- Wall-clock: 528s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
