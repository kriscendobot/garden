Panel round 6 on kriscendobot/minion.town PR #168 came back **must-fix**. `panel.sh` exited 0, and the verdict is posted on the PR.

**What I ran:** an isolated checkout of `design/guest-oauth-bonds` at head `171daf2` (`scratch/project-wt-kriscen-a719c644c889-93b7a258`), then `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against base `d750b09` (`main-d750b09`). It ran as a design panel and all 9 seats returned ok: 3 request-changes, 4 comment-only and 2 approve. Two pre-passes added extra checks: the ownership-map pre-pass flagged ATTENTION, and the repeated-mechanism check fired, so the decomplector was pushed to ask whether the repeated mechanism is needed at all.

**Must-fix items:**
- **decomplector #1:** the recovery `GET` fills in fields on legacy rows. That makes a read path a second writer to the migration, and § 9 doesn't list it as one.
- **novice #1:** § 3 starts the migration before explaining what a legacy row is or why it has to be converted.
- **novice #2:** "fingerprint" is only defined in passing.
- **novice #3:** there is no before/after table comparing the legacy row, `GuestAccount` and `RecoveryIdentity`.

**Skeptic** also requests changes, on should-fix grounds:
- There is no evidence from a real run that the sign-out chain works.
- It's unclear whether this design or #114 owns the migration.
- The source of the `label` field isn't specified.
- Test 13 contradicts open question 1.
- The data model doesn't declare the index on the fingerprint that list and remove depend on.

**Review posted:** https://github.com/kriscendobot/minion.town/pull/168#pullrequestreview-5451098020. It has a summary header, all nine seat reports and the job marker. GitHub refused a request-changes review because the bot owns this PR, so it went up as a COMMENT review, the same way rounds 3–5 were posted.

**Follow-up:** the next stage is the fix-loop against these findings, which the gauntlet driver posts. No garden code changed and nothing was committed to main2.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr168-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 48 tokens (1291527 cached reads)
- Output: 7379 tokens
- Cost: $1.3025894
- Wall-clock: 4121s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
