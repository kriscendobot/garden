The panel round on endojs/endo-but-for-bots#1419 is done: the verdict is **must-fix**, and it is posted on the PR. The last session did the work but put the stage marker after the completion signal, so the job wasn't recorded. I re-checked that the review is on the PR and the script fix is on `main2`; nothing was redone.

- **Panel run:** all 33 seats ran against head `45c6d8cd73`, compared with the PR's base commit `0bdf8951cb`. `panel.sh` exited 0 with disposition `must-fix`.
- **Review:** posted as review 5400389891 on that head. It is a comment review marked must-fix because GitHub won't accept a request-changes review from the PR's own author; round 1 was posted the same way. The full set of seat verdicts was over GitHub's size limit for a review, so 14 of the seat blocks are in a follow-up PR comment (issuecomment-5968456215).
- **Must-fix items:**
  - **XS archive format:** the `node_modules` capture builds archives with modules precompiled to `pre-mjs-json`. The XS loader skips that format, so these trees would fail on locked XS workers, and no test runs one.
  - **PR body:** it is missing the Documentation Considerations section.
  - **Commit history:** the review fix-up commits should be folded into the commits they amend.
  - **Cleanups:** the purist and pruner seats asked for typing fixes, a trimmed description and shorter docstrings.
- **Panel script fix:** on the first attempt, the script that turns seat verdicts into pass or must-fix failed on both tries, before reaching a verdict. It passed all 194 KB of verdicts to `claude -p` as one command-line argument, and Linux caps a single argument at 128 KiB. Every retry would have failed the same way. Commit `13a68691c90` on `main2` makes `scripts/jobs/gardening/panel.sh` send that prompt, and the appellate pass's prompt, on stdin. A new test, `scripts/jobs/test/panel-large-aggregate-decider-test.sh`, covers it: it passes with the fix and fails against the old script.

Next is the gauntlet's fix loop for the must-fix items above. Other hosts still running the old `panel.sh` will hit the same failure on large panels until the rolling deploy reaches them.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p2-makefromtree-20261003-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2102749 cached reads)
- Output: 16192 tokens
- Cost: $2.700833
- Wall-clock: 1613s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
