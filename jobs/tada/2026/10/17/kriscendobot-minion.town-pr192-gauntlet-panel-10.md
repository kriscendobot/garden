Round 10 of the review panel on minion.town PR #192 came back **must-fix**, and I posted the verdict on the PR. GitHub won't let the bot request changes on its own PR, so the verdict went up as a comment-only review: https://github.com/kriscendobot/minion.town/pull/192#pullrequestreview-5556738386. Rounds 7–9 were posted the same way.

**The run:**
- I reviewed head `240a5b9` against base `main-30a4c62` in an isolated checkout of `kriscendobot/minion.town@fix/node-install-root-ownership`.
- The panel ran in single-round mode and exited 0 with verdict must-fix. My first launch was stopped within seconds of starting, before it produced anything, because a background time limit could have killed it partway. The restart is the run that counts.
- Of the 34 seats, four requested changes: breaker, wire-watcher, pruner and decomplector. Eight approved and 22 left comments only.

**Main findings:**
- **decomplector (must-fix):** the one-time `/usr/local` ownership repair (`reclaim_usr_local`) does the same job as the new `/opt/node` layout, so it may not be needed. The panel raised this question because rounds 8 and 9 hit the same parts of the change: `reclaim_usr_local`, `system-path.sh`, `deploy-endo-daemon.sh` and `deploy-oauth2-proxy.sh`.
- **breaker:** the smoke test checks `claude` with PATH set to `/opt/node/current/bin`, but `minion-mcp.service` still uses systemd's default PATH. On that PATH, Node is reachable only through a compatibility link at `/usr/local/bin/node`, which isn't always created. So the smoke test can pass while the service can't find `node`.
- **wire-watcher:** `deploy-oauth2-proxy.sh` now downloads and installs the oauth2-proxy binary as root on every deploy, with no checksum. The Node install checks a pinned sha256; this path should too.
- **pruner:** small cuts to the code, and the PR description is too long.

**What's in the review:** the full aggregate is 85 KB, over GitHub's 65 KB limit for a review. The review has the four request-changes seats in full and lists the other 30 seats with their verdicts only; their full text is in the panel run record.

Nothing changed in the garden repo or the PR branch. As instructed, I didn't fix anything or take the PR out of draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-panel-10.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1224152 cached reads)
- Output: 5044 tokens
- Cost: $0.8412064000000001
- Wall-clock: 209s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
