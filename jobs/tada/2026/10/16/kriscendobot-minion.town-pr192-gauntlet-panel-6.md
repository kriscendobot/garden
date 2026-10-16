Panel round 6 on kriscendobot/minion.town PR #192 finished with a **must-fix** verdict. The verdict is posted to the PR as a review.

**What I did**
- I checked out the PR head into its own worktree for this job. The head is `kriscendobot/minion.town@fix/node-install-root-ownership`, at commit `0969cf9`.
- I ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh` against base `main-30a4c62`. It exited 0 and printed "code-panel single-round — must-fix". All 34 seats came back ok.
- I posted the aggregate as a `gh pr review` at 13:55:15Z. GitHub refuses a request-changes review from the bot on its own PR, so it went up as a comment review. Rounds 3–5 were posted the same way. The body starts with a header: "Garden panel — round 6: **must-fix**", then the deduplicated must-fix and should-fix themes. The full write-ups from the request-changes seats follow, then the other seats until the body hit GitHub's size limit, then a one-line verdict list for the rest.

**Seats requesting changes (8):** assessor, locksmith, saboteur, breaker, purist, wire-watcher, scribe, pruner. The decomplector seat approved the new design that installs Node into `/opt/node`, keyed by the tarball's sha256. That redesign answers round 5's must-fixes.

**Must-fix themes**
1. **`corepack` can't find `node`.** `corepack` runs through `#!/usr/bin/env node`, but the root PATH and the `sudo` wrapper leave out `/opt/node/current/bin`. That breaks `corepack` in:
   - `deploy-endo-daemon.sh` lines 163 and 168
   - `deploy-npm-registry.sh` lines 155 and 158
2. **Root still runs or writes absolute paths under `/usr/local`.** On older boxes that directory is still owned by the tarball's build uid, which is exactly the threat the PR describes:
   - `deploy-oauth2-proxy.sh` lines 103 and 110 run `/usr/local/bin/oauth2-proxy` as root.
   - `deploy-npm-registry.sh` lines 119–126 have root writing into `/usr/local/lib/npm-minion-registry/`.

   This contradicts the PR's own "nothing root runs resolves through /usr/local" claim. The regression test only looks for Node binaries, so it doesn't catch either case.

**Should-fix themes**
- The `sudo` shell-function wrapper only treats `-u` and `-g` as taking a value. It isn't exported, so child shells started with `bash <file>` call the real `sudo` and skip it.
- No summary comment explains the round-4 and round-5 pushes.
- The pruner seat asked for shorter comments and a shorter PR body.

I made no fixes, no garden commits, and no un-draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (744228 cached reads)
- Output: 5579 tokens
- Cost: $0.8224336000000001
- Wall-clock: 289s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
