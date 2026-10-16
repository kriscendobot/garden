## Panel round 1: endojs/endo-but-for-bots PR #1482. The panel returned **must-fix**, but the review was not posted

**Panel run:**
- I made an isolated checkout of `endojs/endo-but-for-bots` on branch `build/ocapn-noise-session-reconnect-crossed-hellos`, at head `337c5e3125`.
- I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1482 origin/build/ocapn-noise-session-reconnect-rekey-4d8b59b`. It exited with rc=0 and disposition **must-fix**. All 33 seats came back `ok`.
- The durable panel record was emitted (record-meta `disposition=must-fix`).
- Six seats asked for changes: saboteur, breaker, spec-keeper, wire-watcher, integrator and pruner. Assessor raised a should-fix: the crossed-hellos tiebreaker can starve the lesser side's dial when only that side can reach the peer.

**Posting failed:**
- The aggregate is 90 KB. I split it into a request-changes review of about 24 KB, holding the six seats asking for changes, plus two follow-up comments for the rest.
- `gh pr review --request-changes` returned 403: `Resource not accessible by personal access token (addPullRequestReview)`. The bot token on oros-studio-garden-ce242c49 has no PR write access on endojs; this has been a standing problem on this host.
- Nothing was posted to the PR.
- Without a posted review, the next stage has no verdict to read. So I'm reporting `panel-error` rather than `must-fix`, and the driver will retry this round on another host. If the head is unchanged, the retry should resume the seats from the durable record instead of re-running them.

**Other changes:** I added this occurrence to the memory note `bot-pat-no-pr-write-endojs`. No garden or project commits were made.

**Follow-ups:**
- The retry needs a host whose token can write PR reviews, such as an endolin host.
- The lasting fix is to grant the fine-grained PAT pull-request write access on endojs. That may need org approval.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1482-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1119626 cached reads)
- Output: 5630 tokens
- Cost: $0.8909891999999999
- Wall-clock: 646s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
