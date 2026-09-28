The maintainer's request on kriscendobot/garden#114 (expand the three demos into verified step-by-step instructions) was already fully answered before this job reached me. This job was a second delivery of that same comment, so there was nothing new to fold in.

**What I found:**
- kriskowal posted comment 5864051232 at 2026-09-28T05:28Z.
- The issue doer answered it with three replies between 14:31 and 14:38Z, one per demo:
  - **Demo 1** (5872215010): runs only on a dev bench with three workarounds.
  - **Demo 2** (5872132557): runs on a two-daemon bench. Production is still blocked behind kriscendobot/minion.town#117 and the PRs it depends on.
  - **Demo 3** (5872080033): the git half works locally from draft kriscendobot/minion.town#86. The "show it inside the Endo directory" half isn't built.
- This dead-lettered copy was sent at 18:07Z, after the doer had finished.

**What I did:**
- Posted one short index comment on the issue that links the three replies with a one-line status each, and asks which demo to take further: https://github.com/kriscendobot/garden/issues/114#issuecomment-5875813255
- I did not re-run any verification. No repo, PR, or board state changed, and I did not close the issue.

**Follow-ups:**
- **Maintainer's choice:** the next steps already recommended on the issue are to run the gauntlet on kriscendobot/minion.town#86, build the missing Endo-directory binding for demo 3, and resolve the blockers for kriscendobot/minion.town#117.
- **Possible watcher bug:** I didn't confirm why the comment was delivered again 13 hours later. I searched the journal once for the comment id and job base and found nothing. If more copies of already-answered comments show up, the issue-inbox watcher's de-duplication is worth checking.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/deadmail-issue-comment-5864051232.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (368860 cached reads)
- Output: 2661 tokens
- Cost: $0.559008
- Wall-clock: 37s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
