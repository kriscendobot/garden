Gauntlet panel round 2 on endojs/endo-but-for-bots#1124 came back **must-fix**, and the verdict is posted as a review on the PR.

**What I did**
- Made an isolated checkout of the PR head (`kriscendobot/endo-but-for-bots`, branch `build/ocapn-nonce-locator-mechanism`, commit `b20669cb4`).
- Ran `panel.sh` in single-round mode against the PR's exact base commit (`f1e306582cb…`, `llm-f1e3065`), detached from my session so a reap couldn't kill it. All 34 seats finished ok and panel.sh exited 0 (`exit_code=0` in its run metadata). The run record was pushed to `panel-runs/kriscendobot-endo-but-for-bots-1124/cf88fede0948.md`.
- Posted the verdict as review 5445159748 on head `b20669cb4`. It is **COMMENTED**, not REQUEST_CHANGES, because GitHub doesn't let the bot request changes on its own PR. The review body says "REQUEST CHANGES (must-fix)".
- The full aggregate was 95KB, more than a GitHub review body can hold. The posted review has a must-fix summary, the full 34-seat verdict table, and the full text of 20 seat reviews, with the two must-fix seats first. The other 14 seats' text is left out, and the review points to the run record for it. All 14 are approve or comment-only except the saboteur and transplanter, whose verdicts are blank in the aggregate.

**Must-fix items**
1. **decomplector:** the bound and non-oracularity guarantees can't hold under the composition the design recommends, because an existing path to the same authority stays open.
2. **integrator:** the PR body doesn't follow `.github/PULL_REQUEST_TEMPLATE.md` (it has no `Closes:`/`Refs:` line and none of the template's headings). The integrator also rated the history of one feature commit plus seven fixups a should-fix and suggested regrouping it.

**Also flagged:**
- assessor (should-fix): a throwing `makeLocatorForSession` factory leaves session setup half-built.
- One seat's review lists several missing edge-case tests, each marked summary-fix: a never-settling lookup, session replacement in `endSession`, and `peerPublicKey` on the resume path.

**Follow-ups:** none from me. Under the single-round contract, the fix stage belongs to the gauntlet driver.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1124-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (849012 cached reads)
- Output: 5685 tokens
- Cost: $0.7079104
- Wall-clock: 660s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
