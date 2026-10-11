Round 6 of the panel on kriscendobot/minion.town PR #179 came back **must-fix**: the panel script exited 0 and all 34 seats returned ok, against head `bbf1c71` and base `main-c7bdf20`.

**How the run went:** I first started the panel as a background task. That task could have been killed partway through by the tool's 10-minute limit, so I stopped it, killed the seat processes it had left running, and relaunched it detached. The relaunch finished cleanly.

**Votes:** 12 approve, 21 comment-only, and 1 request-changes, from the decomplector.

**What I posted:**
- **Seat detail:** the full output was 86 KB, over GitHub's size limit for one review, so I split it into two PR comments at seat boundaries (issuecomment-6114509979 and issuecomment-6114510204).
- **Verdict review:** posted as a COMMENT review (pullrequestreview-5485273151, on commit `bbf1c71`). GitHub won't let the bot request changes on its own PR, so this is the same review shape rounds 3–5 used. It carries the marker `<!-- garden-panel: … round=6 disposition=must-fix head=bbf1c711… -->`.

**The one must-fix item:** store the clip name on the record when the clip is published, instead of reading the title every time clips are listed.
- The design doc itself admits a stored name "would remove the read for new clips".
- Reading at list time is what requires the concurrency limiter, the timeouts, the cache and the in-flight lookup handling in `clip-title.ts`.
- The panel's pre-check flagged the title reader as the mechanism behind repeated must-fixes; rounds 3–5 each raised must-fixes on it.

**Fixed since round 5:** a mutation test confirmed that a clip is now named from the page the gateway actually serves (`contentRoot`). The flaky test round 5 flagged is not named among this round's must-fix or should-fix items.

**Should-fix items to take along** (some disappear if the must-fix is done):
- An empty-string `contentRoot` makes clips share one cache key, so a clip can show another clip's title.
- A page author can pick the gutter icon through a leading emoji in the title.
- On large listings, later clips can show as "Clip N" on first load because of the queue deadline.
- Errors reading a clip's directory on the title path are dropped without a log entry.
- Title extraction and entity decoding don't follow the HTML spec exactly.
- Unicode corner cases are untested; the reviewers suggest property-based tests for them.
- A test hardcodes ports 9227/3227.
- Fix-summary comments are still missing for the round 1 and round 3 pushes.

I made no code changes and did not fix or un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr179-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1479829 cached reads)
- Output: 7865 tokens
- Cost: $1.0477618
- Wall-clock: 300s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
