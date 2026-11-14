I didn't take the issue status pass live: the dry-run logs turned up a false positive, so I fixed the bug and left dry run on. The day of observation starts over once the fix deploys.

**What the logs showed.** The leader has dry-run logs from Nov 9 to Nov 14. Only one arrival ever produced a "DRY RUN would post" line: kriscendobot/garden#51, arrival 6859154429. It was logged 21 times, from 17:06 to 17:45Z on Nov 13. The rest of the ticks were silent or skipped because of the API rate-limit pause ("REST cooldown live").

**Why it failed the check.** That arrival was kriskowal's comment at 16:44:16Z, starting with `@kriscendobot`. The bot had already replied at 16:56:19Z, 12 minutes later, so the pass should never have flagged it. The job's rule is that nothing answered in time may appear in the would-post lines.

**The cause.** The function that reads comments from GitHub (`gh_api_retry`) returns them without a final line break. The script reads them line by line, and that kind of loop silently drops a last line that doesn't end in a line break. The newest comment, usually the bot's own reply, is always that last line, so the pass never saw the reply. I confirmed this by fetching #51's comments the same way the script does: the output really does end without a line break.

**The fix (commit 66ab9cc2018, pushed to main2):**
- `scripts/jobs/issue-status-pass.sh`: both the comment loop and the issue loop now keep an unfinished last line.
- `scripts/jobs/test/issue-status-pass-test.sh`: new regression cases for a bot reply on that last line and for an issue row on that last line. The test fails against the old script and passes with the fix.
- `GARDEN_ISSUE_STATUS_DRY_RUN=1` is still set in the unit file, and the script default is still 1.

**Follow-up.** I scheduled a one-time job, `issue-status-pass-go-live-20261116`, for 2026-11-16T06:00Z (it's on journal2). It will:
1. Check that the leader is running 66ab9cc2018, and push itself back if it hasn't had a full day since that deploy.
2. Compare only the post-deploy would-post lines against the issue threads.
3. If they match, remove the environment line, flip the script default to 0, update the docs and run the test.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/issue-status-pass-go-live.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1331511 cached reads)
- Output: 8518 tokens
- Cost: $1.0712622
- Wall-clock: 788s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
