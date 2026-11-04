Panel round 4 on [PR #236](https://github.com/kriscendobot/minion.town/pull/236) ended in **must-fix**. I did not fix anything or un-draft the PR.

- **Pinned pair:** base `919689231495f6b62fd5a7a80c712acd667881a2`, head `823bf9d1fcf3475f66594fff72d17c92d61c4f92` (`kriscendobot:feat/remote-invitation-hints`). The checkout was detached at head and `git rev-parse HEAD` matched. The PR head had not moved when I checked after the panel.
- **Style pre-pass:** `pre-push-gates.sh --no-auto-fix --probes-only` exited 0. It gave one non-blocking advisory: the pruner comment-concision check flagged a 5-line prose comment at `src/endo/guest-locator.ts:244`.
- **Panel:** `panel.sh` ran in single-round mode and exited 0. The decomplector and pruner were forced on because the new-mechanism, PR-body concision and repeated-must-fix probes fired.
- **Review post:** it posted its own review at 2026-11-04T12:22:52Z on commit `823bf9d1`. The state is `COMMENTED` because the PR is self-authored, and the `Must-fix before merge` heading is kept.

I read only the first part of the review, so these two breaker findings are not the full list:
1. **Lost connection strands the name:** at `src/web/guest-web-socket-service.ts:498`, `cancel` goes over the same dead CapTP reference and rejects, so the name stays bound and every retry answers 409. Before this PR, the retry succeeded. The sibling `src/endo/guest-tools.ts:937-946` already handles this case with a fresh-facet fallback.
2. **409 misread on pending deletion:** the 409 branch at `deploy/aws/www/settings.js:105` assumes an earlier invitation holds the name. `GuestDeletionPendingError` is also a 409, so the UI misreads a pending deletion.

**Follow-up:** the gauntlet driver routes this to the next fix stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr236-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (323062 cached reads)
- Output: 3270 tokens
- Cost: $0.46410039999999997
- Wall-clock: 1131s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
