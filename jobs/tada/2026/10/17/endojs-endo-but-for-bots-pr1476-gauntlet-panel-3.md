Panel round 3 for endojs/endo-but-for-bots#1476 came back **must-fix**, but I couldn't post it from this host, so I'm completing with the panel-error marker so the round reruns on a host that can post.

**The panel run**
- Project checkout: `/Users/dom/garden/scratch/project-wt-endojs--63d7f35bffda-bd4f2d1f`, at head `bf0d59985f` on `build/ocapn-noise-session-reconnect-heartbeat`, compared against `origin/llm-61cd656`.
- `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` exited 0 with disposition **must-fix**. All 34 seats returned ok. The run is recorded at `panel-runs/endojs-endo-but-for-bots-1476/6ae6d103ede3.md`.
- Seats asking for changes:
  - **integrator:** the PR body has no `Documentation Considerations` section. The template check makes this alone enough for must-fix.
  - **pruner:** the PR body is too long (563 words).
  - **decomplector:** rounds 1 and 2 both raised must-fix on the same read-ahead pump. It asks whether the pump needs to exist at all, or whether the heartbeat can be handled inside the reader.
  - **breaker:** a `heartbeat` option with no upper bound on `intervalMs` or `sessionTimeoutMs` can overflow Node's timers, which then fire after 1 ms and drop a healthy session.
  - **corner-prober:** the liveness timer isn't reset when the pump resumes, and the interval and timeout boundaries are untested.
  - **purist:** should-fix items on naming, layering and an unchecked epoch.
- Approve: warden, duality-auditor, benchmarker, gateway, transplanter, thesaurus, procurer, reexport-auditor. All others: comment-only.

**Posting failed**
- `gh pr review` returned 403 `Resource not accessible by personal access token (addPullRequestReview)` with both `--request-changes` and `--comment`. On `oros-studio-garden-ce242c49` the bot token can't write PR reviews or comments on endojs, and I couldn't work around it here. Rounds 1 and 2 were posted from `endolin-garden-ece02cb4`.
- The verdict is real but was never posted, so the next stage can't see it. Under step 4 of the job this is an infrastructure failure, so I'm using `panel=panel-error` rather than reporting must-fix.
- The retry should reuse the recorded seat verdicts if the head is still `bf0d59985f`. The record is keyed by the checkout folder name, so a retry on another host may re-run the seats instead.
- I split the aggregate into a 59 KB review and a 40 KB continuation comment (marked `panel round 3 (cont.)`), because the full 98 KB is over GitHub's limit. The split files are in `/tmp/p1476r3/` on this host only and will be lost.

**Follow-ups**
- The lasting fix is to give the bot token Pull requests: write on the endojs org (it may need org approval). Until then, panel rounds for endojs PRs on this host will keep failing to post and being retried.
- I added this failure to the existing memory note `bot-pat-no-pr-write-endojs.md`. Nothing was committed to the garden repo.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1476-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1709902 cached reads)
- Output: 8734 tokens
- Cost: $1.0585084000000002
- Wall-clock: 593s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
