Round 5 of the panel on endojs/endo-but-for-bots#1100 ended **must-fix**. I posted the verdict as review 5299740264 on head `9936fb1488`.

- **Run:** 32 seats in single-round mode, compared against the pinned base `llm-f9cbcfc` (`f9cbcfc426`). `panel.sh` exited 0 and printed `must-fix`.
- **Review shape:** It went up as a comment, not a request-changes review, because GitHub won't let a PR author request changes on their own PR. Round 4 was posted the same way.
- **Round 4:** All round-4 items were addressed. The abort path now rejects the syn tail, the `@endo/sandbox` cascade was added, the PR body was refreshed, the docs were trimmed, and `BENCH.md` and `DESIGN.md` agree again.

**Items to fix:**
1. **breaker (must-fix), backed by purist:** the `OpenFile.write` and `File.write` sinks in `wrap-backend.js` limit each frame to 16 MiB but not the running total. A holder of a narrow write capability can keep streaming frames until host memory runs out. The fix is to copy the running-total `E2BIG` check that `xattrs-exo.js` already has, and add a test for it.
2. **purist:** the three sinks that buffer and then commit are separate copies of the same code and could share one helper. Also, `CloneFrameShape` and the `LayerOp` `write-bytes` payload still carry base64: convert them or document why they can't.
3. **releaser:** the changeset says four packages have "no source change beyond comments". That's wrong: three have no diff at all and one changes only a test fixture.
4. **stylist:** the new file `frame-limits.test.js` uses the abbreviations `oh` and `off`; rename them to `openHandle` and `offset`.
5. **scribe:** round 4 has no "Fix round" summary comment, and its proposed rules were never forwarded to `role/gardener`.

The review body lists the comment-only notes too; the main one is squashing the round-N fixup commits before a rebase-merge. To stay under GitHub's body size limit, the review has the five request-changes seats in full but leaves out 13 comment-only and approving seats' details. The full aggregate was in `$GARDEN_PANEL_RUNDIR/round-1.md`, which is scratch space and may already be gone.

I didn't fix anything or un-draft the PR, as this stage requires. The fix loop is the next stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-pr1100-gauntlet-20260923b-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (826821 cached reads)
- Output: 5672 tokens
- Cost: $0.8173562000000001
- Wall-clock: 758s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
