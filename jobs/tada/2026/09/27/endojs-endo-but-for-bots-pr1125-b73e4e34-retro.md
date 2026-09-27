The retro on endojs/endo-but-for-bots#1125 (primary `endojs-endo-but-for-bots-pr1125-b73e4e34`) is done. I recorded it as **not a review miss** and posted one follow-up job to fix the machinery gap behind it.

**The comment.** kriskowal asked (paraphrased): the PR is still a draft, so did the gauntlet finish or at least reach diminishing returns, and is any must-fix feedback still pending? It's a question about status and names nothing wrong in the code, so no juror seat, skill or pre-push gate could have caught it in advance.

**What the board shows.**
- **Gauntlet:** it ran all six panel/fix rounds (all in `jobs/tada/`) and ended on 2026-09-13 with `review-budget-reached`, its normal stopping point. The last fix round was pushed with CI green, and the PR was left in draft for a human on purpose.
- **What actually went wrong:** `finish_review_budget_reached` only messages the maintainer inbox (`gauntlet_notify`). Nothing was posted on the PR saying "gauntlet done, awaiting your decision". Four more days of fix pushes followed, so the maintainer had to ask.
- **Whose problem it is:** this is broken machinery, which belongs to the mentor loop, not a panel miss. That matches the earlier dismissal of the same status question on #796.
- **It has happened again:** #1310 hit the same thing on 2026-09-20 (job `endojs-endo-but-for-bots-pr1310-72fb67e9`).

**Checking the primary job's answer.** Its reply, kriscendobot comment 5706533705, exists and correctly answers all three questions. #1125 has since been closed and split into the stack #1304 → #1306 → #1305. The primary's report and the PR agree.

**What changed.**
- Recorded `review-misses/dismissed/endojs-endo-but-for-bots-pr1125-b73e4e34.md` (verdict not-a-miss, category new-direction) through `review-miss-record.sh`. The record is my paraphrase plus the comment URL, never the comment text.
- No cluster was created, so there was no threshold to check and no `review-improve-*` job.
- Posted builder job `gauntlet-terminal-status-pr-comment` (identity `garden:gauntlet-terminal-status-pr-comment`). When a gauntlet hits `review-budget-reached` or halts, it should post one status comment on the PR, without duplicates across ticks. The comment gives rounds run, head SHA, CI status and the next step. A failure to post only warns and must not block `finish_gauntlet`. The job also asks for tests and a docs note.

**Follow-up:** the new builder job owns the remaining work.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-b73e4e34-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1070985 cached reads)
- Output: 7721 tokens
- Cost: $0.9604489999999999
- Wall-clock: 109s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
