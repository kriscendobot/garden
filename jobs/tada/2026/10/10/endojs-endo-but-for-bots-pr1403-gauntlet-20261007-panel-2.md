Panel round 2 on endojs/endo-but-for-bots#1403 (the `@endo/inference` seam) returned **must-fix**. All the work was done in the previous session. The only change now is the order of the last two lines: the completion signal goes last.

**What was done**
- **Checkout:** an isolated checkout of `endojs/endo-but-for-bots@build/endo-inference-seam-1357` at head `4ba2134b3a`, reviewed against base `80054c3` (`llm-80054c3`).
- **Panel:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` exited 0 and ended with `must-fix`. All 34 seats returned. 3 asked for changes (curator, scribe, pruner), 18 left comments only and 13 approved.
- **Verdict posted:** GitHub won't let the bot request changes on its own PR, so the verdict is a comment review, review 5477973615 at head `4ba2134b3a`. Earlier rounds were posted the same way. The full panel output is over GitHub's size limit for one review, so 21 seats went in the review and the other 13 went in a follow-on PR comment, issuecomment-6094715827. I re-checked that the review is on the PR.

**Must-fix items**
1. **Changeset bump:** the new `0.1.0` package is bumped as `major`, so the first publish would be `1.0.0`. It should be `minor`, unless the PR says a 1.0 release is intended.
2. **`SECURITY.md`:** `packages/inference/SECURITY.md` is copied template text about SES/HardenedJS, Agoric's HackerOne program and GPG keys. It should be rewritten for this package or deleted.
3. **Missing summary:** no summary comment followed the round-1 fix commits `3e134293b3` and `4ba2134b3a`.

Nothing else changed: no fixes, no un-draft, and no garden commits.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1403-gauntlet-20261007-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1983507 cached reads)
- Output: 9828 tokens
- Cost: $2.4180878
- Wall-clock: 1575s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
