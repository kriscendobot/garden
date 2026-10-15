Panel round 4 on kriscendobot/minion.town PR #188 ran once and came back **must-fix**. I posted the verdict to the PR and did no fixing or un-drafting.

- **Run:** I used an isolated checkout of the head branch `clip-gutter-live-refresh` at `3b5bb8f`, against base `origin/main-ad0257e`. I ran `panel.sh` in single-round mode and it exited 0. Its last line was `code-panel single-round — must-fix`. Two pre-passes fired along the way: a new-mechanism probe and a repeated-must-fix check, both of which put the decomplector seat on the panel.
- **Seats:** 4 request-changes (decomplector, integrator, pruner, saboteur), 13 comment-only, 17 approve.
- **Review:** posted as a COMMENT, https://github.com/kriscendobot/minion.town/pull/188#pullrequestreview-5536516799, on commit `3b5bb8f`. GitHub won't accept request-changes from the bot on its own PR, so the header states the must-fix verdict, the same way earlier rounds did. The full aggregate was 82 KB, over GitHub's 65 KB limit for a review body, so the posted review has the four request-changes blocks and 12 of the 13 comment-only blocks in full. Approve blocks and one comment-only block are named but left out.
- **Main must-fix points:**
  - The PR description is out of date. It still says failed reads keep the last list, but since `bb62cc5` a failed refresh clears the gutter (integrator rated this must-fix).
  - If an old `index.html` without `#refresh-clips` is served with the new `shell.js`, startup throws and the shell never boots.
  - The refresh mechanism has redundant parts:
    - a `null`-vs-`[]` split left over from the old policy;
    - two trackers (a generation counter and an abort controller) for which read is current;
    - `invalidate`, which mixes selection policy into the scheduler.
  - A code comment cites the design's § 3 when the reasoning is in Open questions #3.
  - The pruner asked for a few small prose cuts.
- **Follow-up:** the panel-run record push to the journal failed twice (best effort) because the producer journal lock was busy. The run directory still has the details.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr188-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (888878 cached reads)
- Output: 5276 tokens
- Cost: $0.7333116000000001
- Wall-clock: 580s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
