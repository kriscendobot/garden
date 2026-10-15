Panel round 7 on kriscendobot/minion.town PR #184 came back **must-fix**, and the verdict is posted on the PR.

- **Panel run:** `panel.sh` ran in single-round mode on the PR head `3253475` (branch `fix/prod-probe-dispatch-backstop`) against base `main-bc11010`, using an isolated project worktree. It exited 0 with disposition **must-fix**. All 34 seats returned: 12 approve, 20 comment-only and 2 request changes (decomplector and pruner).
- **Repeated-mechanism check:** this check, which looks for the same problem flagged in back-to-back rounds, fired on the `strict` input. The decomplector was asked whether that input is needed at all.
  - **Decomplector:** says it is not. Make every probe run strict, or default `strict` to `true`. The backstop could then dispatch with `{ref:'main'}` alone, which removes the 422 cutover ordering, the two-term `STRICT` expression and the non-strict exception. It also points out that `ran()` counts a non-strict manual run that ends `incomplete` as fresh, which holds off the strict backstop for 3.5 hours.
  - **Pruner:** `DEPLOYMENT.md` repeats itself. The one-hour queued-run rule appears four times and the non-strict default twice. The comment in `prod-probe.yml` restates the expression on the line below it.
- **Review posted:** GitHub refuses a request-changes review on the bot's own PR, so it went up as a COMMENTED review titled "Panel verdict — round 7: **must-fix**", the same shape as rounds 5 and 6. It carries both seats' findings in full and a collapsed tally of all 34 seats. The full seat output is 88 KB, over GitHub's review size limit, so the comment-only seats' text is not in the review.
- **Panel-run record:** recorded in the journal at `panel-runs/kriscendobot-minion.town-184/9fe548032318.md`. It took four push attempts because three lost the push race.

Nothing in the garden repo changed. No follow-ups beyond the gauntlet's next fix stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-panel-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (724136 cached reads)
- Output: 3950 tokens
- Cost: $0.6403871999999999
- Wall-clock: 530s

<!-- garden-usage-end -->
