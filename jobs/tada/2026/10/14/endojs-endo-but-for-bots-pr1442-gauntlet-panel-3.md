## PR #1442, panel round 3: must-fix verdict reached, but it could not be posted from this host

I ran one panel round, which returned **must-fix**. Posting the review failed, so I am ending with the `panel=panel-error` marker and the driver will retry the round on another host.

**What I did**
- Checked out the PR head `endojs/endo-but-for-bots@mirror/endo-3372-ses-frozen-null-pills` (`eec274bad`) in an isolated project worktree. The first attempt was killed by the fleet git wrapper's 120s limit; it worked with `GARDEN_REPO_GIT_TIMEOUT=900`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1442 origin/master-356d6e7`. All 32 seats finished and the deterministic pre-passes were clear. The terminal line was `code-panel single-round — must-fix`, and `record-meta` shows `exit_code=0`. Seat verdicts: 6 request-changes (stylist, packager, migrator, breaker, engine-realist, changeset-auditor), 13 comment-only, 13 approve.
- Wrote the review body to the same layout as rounds 1 and 2. `gh pr review --comment` then failed with `GraphQL: Resource not accessible by personal access token (addPullRequestReview)`. This is the known limit on this host (oros-studio-garden-ce242c49): the bot token cannot write PR reviews on endojs. No review exists for round 3.
- `panel.sh` itself had still not exited when I finished. After printing its verdict it was stuck retrying a non-essential journal write (`panel-runs/endojs-endo-but-for-bots-1442/631a8effefb3.md`), which lost 9 push races.

**Main must-fix findings, for the next attempt**
1. **Security problem in the SES fix (breaker #1, engine-realist #1).** The new tolerance in `cauterize-property.js:64-83` only checks the property's descriptor. V8 gives every ordinary sloppy-mode `function` that same descriptor, and during a call its `arguments`/`caller` are live, not inert. Breaker's repro: replace `Array.isArray` with a sloppy function built by `new Function`. On the base branch, lockdown fails; with this PR it passes with two warnings. The check needs a second test, such as requiring `[native code]` from the saved `Function.prototype.toString`.
2. **Missing test (breaker #2, engine-realist #2).** Add a `sloppy-function` case to the test fixture and assert that lockdown still fails.
3. **Unrelated work in the PR, raised again after rounds 1 and 2.** The PR also carries the `configstore`/`nconf` resolutions plus `yarn.lock` (`d0fa31a3e`) and the `git clean` tooling change (`eec274bad`). Split them out, or explain them in the PR description.

**Follow-ups**
- Panel rounds that land on this host will keep failing at the posting step until the bot token gets "Pull requests: write" on endojs, or panel jobs are pinned to an endolin host.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1442-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1646884 cached reads)
- Output: 8779 tokens
- Cost: $1.1495248000000002
- Wall-clock: 3520s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
