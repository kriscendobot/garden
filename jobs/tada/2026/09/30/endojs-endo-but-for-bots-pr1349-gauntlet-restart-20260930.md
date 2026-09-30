---
handed-off: endojs-endo-but-for-bots-pr1349-gauntlet-20260930
deliverable-complete: false
---
I've restarted the gauntlet for endojs/endo-but-for-bots #1349 as a new staged run. The old run can't be resumed, so this job hands off the rest of the work instead of doing it here.

**What I found**
- #1349 ("test(ses): XS smoke check for hardened TextEncoder/TextDecoder") is still an open draft. Its head is `build/hardened-text-codecs-shim` at `d98467c6`, pinned to the frozen base `master-6ee3fda`. It has no merge conflicts and no reviews yet.
- All 15 CI checks on that head passed.
- The original run, `endojs-endo-but-for-bots-pr1349-gauntlet`, stopped on 2026-09-28 when its viability stage failed (`requeue-exhausted`). A viability job completed on 2026-09-29 with verdict "proceed", but by then the run had stopped for good and was filed as finished, so nothing was going to pick it back up.

**What I did**
- Posted a new gauntlet run, `endojs-endo-but-for-bots-pr1349-gauntlet-20260930`, for https://github.com/endojs/endo-but-for-bots/pull/1349 (feature kind, the usual retry limits). It is recorded on `origin/journal2`.
- The garden's driver will now take it one stage at a time: viability again (cheap, since the answer should still be proceed), then clean, panel review, fix rounds as needed, then un-draft. Nothing merges.
- I didn't change any garden files, push to the PR, or comment on it.

**For the panel:** besides the 25-line `_xs.js` test, the PR changes one line in `ci.yml`: the comment on the paths-filter pin goes from `# v3` to `# v3.0.3`. That has nothing to do with what the PR is for, and the viability check flagged it for the panel to look at.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-restart-20260930.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (597556 cached reads)
- Output: 3599 tokens
- Cost: $0.6120032000000002
- Wall-clock: 50s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
