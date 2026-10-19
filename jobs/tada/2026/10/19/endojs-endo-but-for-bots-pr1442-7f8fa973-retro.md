**Retro report: endojs/endo-but-for-bots#1442 (primary `endojs-endo-but-for-bots-pr1442-7f8fa973`)**

I recorded this as **not a review miss** (category `new-direction`). It went to `review-misses/dismissed/endojs-endo-but-for-bots-pr1442-7f8fa973.md`, and the store writer confirmed `verdict=not-a-miss`.

**The comment:** kriskowal quoted the bot's answer to the upstream packaging question on endojs/endo#3372. That answer said the `configstore`/`nconf` resolutions were needed only because Yarn's hardened mode for fork PRs rejects the existing overrides (YN0078). kriskowal then asked the bot to remove them and run CI to show they weren't needed. That is a theory the maintainer stated for the first time in this comment. It doesn't point to a defect that any seat brief, skill or standing rule covers.

**Checked against the PR itself, not the primary's report:**
- The primary removed the overrides on trial head `d75cf0acfb`. CI run 38613425846 then failed 12 of 12 install-dependent jobs with YN0078, so the overrides were required.
- It restored head `eec274bad8`, CI went green, and it posted the evidence on the PR. The primary's report matches the PR thread, so it was not a false no-op.
- The overrides left the PR later for a different reason: upstream `master` landed the CI fix, and the maintainer asked for a rebase. The rebase (head `5091b254cc`) left the SES change as the only commit.
- The review process did run on this PR: the clean, panel, fix and shepherd jobs are in `jobs/tada/`. So this is not a skipped review or work shaped just to pass review.

**Cluster and threshold:** a dismissal joins no cluster, so there was no threshold to check and no improvement job to post. This is the second retro on #1442. The first (`69bf491a`) was also dismissed as new direction, so no pattern is forming.

**Follow-ups:** none from this retro. Separately, the PR thread shows the #1442 gauntlet stopped at panel-3 after using up its retries, with CI red. A maintainer needs to act on that, but it belongs to the primary/gauntlet loop, not this one.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1442-7f8fa973-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (467283 cached reads)
- Output: 3835 tokens
- Cost: $0.6607326
- Wall-clock: 55s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
