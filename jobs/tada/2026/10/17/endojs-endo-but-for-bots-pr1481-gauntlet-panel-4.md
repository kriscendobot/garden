Panel round 4 on endojs/endo-but-for-bots#1481 came back **must-fix**. I posted the verdict to the PR as a review.

**What I did**
- Checked out the PR head (`endojs/endo-but-for-bots@build/ocapn-noise-session-reconnect-rekey`, commit 413c992de9) into this job's own project worktree.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh` against base `2a16357eaa`, which is the PR's base and also the merge-base. It exited 0 with disposition `must-fix`. All 34 seats returned and the decider had no errors.
- Posted the result as review 5556815432: https://github.com/endojs/endo-but-for-bots/pull/1481#pullrequestreview-5556815432. GitHub won't let the bot request changes on its own PR, so it went up as a COMMENTED review with a "Panel round 4 — must-fix" header, the same form as rounds 1–3. The full text of the two request-changes seats is in it. GitHub limits a review to 65,536 characters, so 14 seats that had nothing blocking are listed by verdict only. The complete aggregate is in the run dir, `round-1.md`.

**Request-changes seats (2):**
- **archivist** (must-fix): `designs/ocapn-noise-session-reconnect.md:414` says `SESSION_HARD_TIMEOUT` goes "up to `Infinity`". The code caps it at `MAX_TIMER_MS = 2**31-1` and refuses `Infinity`. The design row should state the ceiling as 2³¹−1 ms. The seat also says the `packages/ocapn-noise/README.md` should mention the new `reconnect` option and the wire-compatibility break (should-fix), plus some JSDoc nits.
- **pruner** (summary-fix): the PR body is 507 words against a threshold of about 300. It names specific sentences to cut, two test comments in `test/reconnect.test.js` that only restate their assertions, and one redundant cross-reference line in design § 7.

Of the other seats, 21 were comment-only and 11 approved. The panel also flagged that the same mechanism has drawn must-fix in more than one round, and it forced the decomplector's "is it needed" question this round. The fix stage is next.

**Follow-ups:** none from this stage. I didn't fix anything or un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1481-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (859642 cached reads)
- Output: 4664 tokens
- Cost: $0.7522564
- Wall-clock: 221s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
