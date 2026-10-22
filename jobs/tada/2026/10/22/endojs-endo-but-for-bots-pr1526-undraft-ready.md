# Completion report: endojs-endo-but-for-bots-pr1526-undraft-ready

I marked endojs/endo-but-for-bots PR #1526 ready for review. The head guard matched before I did it.

- **Before:** the PR was `OPEN`, `isDraft: true`, and `headRefOid` was `ee8abe16961bcb36912bb54f090469434400905d`. That is exactly the head the job expected, so the guard passed.
- **Action:** ran `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1526`. It exited with rc=0 and reported "marked as ready for review". This host's bot token did not get the 403 that blocked the undraft stage on oros-studio.
- **After:** re-reading the PR shows `isDraft: false` and `headRefOid` still `ee8abe16961bcb36912bb54f090469434400905d`.

Nothing else changed: no garden commits and no edits to the project repo. There are no follow-ups. The waiting gauntlet stage (`endojs-endo-but-for-bots-pr1526-gauntlet-undraft`) should now see `isDraft: false` on its next poll and go on from there.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1526-undraft-ready.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (118141 cached reads)
- Output: 705 tokens
- Cost: $0.36524019999999996
- Wall-clock: 16s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
