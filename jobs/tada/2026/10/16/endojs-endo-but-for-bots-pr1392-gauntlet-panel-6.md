**Gauntlet panel round 6, endojs/endo-but-for-bots PR #1392: the verdict is must-fix, but I couldn't post it, so this round reports as panel-error.**

- **Panel run:** I checked out the PR head (`build/sturdyref-pass-style-recognition` at `b404d4452`) in an isolated worktree and ran `panel.sh` in single-round mode against base `origin/build/sturdyref-ses-accommodation-a10a201`. It exited 0 with disposition **must-fix**. The run is saved in the durable record `panel-runs/endojs-endo-but-for-bots-1392/434853e0d847.md`.
- **Seats asking for changes:** breaker, integrator, migrator, pruner, purist, releaser, saboteur and wire-watcher voted request-changes. The other 23 seats voted comment-only or approve.
- **Decomplector's must-fix:** the same rank-order mechanism has been flagged as must-fix for several rounds, so the decomplector was forced to ask whether it is needed at all. It says no: drop it and reuse the existing `promise`/`error` tie path in `rankOrder.js`. That means giving `parcel` a reserved prefix and a tie arm, then deleting `getPassStyleRank`, the `nested` flag on `compareParts`, the patterns-side guards and the `Exclude<>` types. It also found that whether a comparison throws depends on which container holds the Parcel, not on the values.
- **Posting failed:** I split the 97 KB aggregate into two parts that fit GitHub's limit, with the request-changes seats first and bare `#N` references qualified. `gh pr review --request-changes` and `--comment` both returned 403 `Resource not accessible by personal access token (addPullRequestReview)`. This is the known bot-token permission gap on this host (oros-studio) for endojs repos.
- **Marker choice:** the panel did produce a real verdict, but the job needs it posted as a review on the PR, and that didn't happen. Reporting `panel=must-fix` would claim a review exists when it doesn't. I used `panel=panel-error` so the driver retries this round on a host that can post. Because the head hasn't moved, the retry should reuse the recorded seat verdicts instead of re-running them.

**Follow-up:** the permanent fix is giving the bot token pull-request read/write on the endojs org. Until then, panel rounds for endojs PRs on this host will keep failing at the posting step. The memory note on this already covers this job, so I didn't change it.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1392-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 98 tokens (2578435 cached reads)
- Output: 16426 tokens
- Cost: $2.135951
- Wall-clock: 2935s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
