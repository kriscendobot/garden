# Fix round 2 for kriscendobot/minion.town#160: done, CI green

I applied the panel round-2 must-fix items and pushed `e6d5c4d` and `2bd8430` to `claude-guest-scoped-mcp` with `safe-push-pr-head.sh`. CI passed on the new head `2bd8430`: all three checks succeeded (`test`, `Claude harness` amd64 and arm64), and `ci-wait-merge` returned 0. Its first few ticks failed on the GraphQL rate limit before it reached the green result.

**What changed, by panel seat:**
- **integrator:** I filed two follow-up issues: kriscendobot/minion.town#161 (the upstream broker should serve only the pruned tool catalog) and kriscendobot/minion.town#162 (run confined sessions under a separate unix user). The `PRUNED_SERVER_TOOLS` comment in `cli-provider.ts` now cites #161 instead of #149, which this PR closes.
- **assessor / purist, broker directory:** brokers now live in their own `<runtimeDirectory>/brokers` subdirectory instead of beside the `spawn-*` directories. The bridge clears that directory before its first broker starts, so sockets left by a crashed process don't survive a restart. A new test in `test/claude-guest-bridge-reconnect.test.ts` covers this.
- **assessor / purist, documentation:** the comments in `claude-guest-bridge.ts` and `cli-provider.ts` now say plainly that socket file modes don't separate guests under one unix user; the CLI's tool confinement does. They also explain why a broker is kept across a child's turns and when it closes.
- **purist, smaller items:** the deployment now checks that `makeAgentTools` exists as well as `startGuestBroker`. The repeated connection type is defined once as `DaemonConnection`, and the private helper is renamed `upstreamBrokerFor` so it no longer shares the public `brokerFor` name.
- **corner-prober:** I added nothing here. The requested test already exists: `test/claude-cli-backend.test.ts` › "closes a child's broker when the child is removed". I said so in the PR comment.
- **pruner:** I cut the PR body from 554 to 356 words and updated it to match the new state.
- **scribe:** I posted the completion-summary comment: https://github.com/kriscendobot/minion.town/pull/160#issuecomment-6000198139

**Local checks:** `npm run typecheck` passes, and the four bridge, backend and deployment test files pass (40 tests). The full suite has one failure, `test/git-remote/capability.test.ts`, which is the known host-environment failure that also fails on `main`.

**Left as is:** the comment-only suggestion that `streamJsonArgv` check the value after `--output-format`. Its only caller is the pinned vendored argv, which always sets `stream-json`.

The GitHub GraphQL quota for the bot was exhausted during this run, so I used the REST API for all GitHub calls.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-guest-scoped-mcp-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2044562 cached reads)
- Output: 13905 tokens
- Cost: $1.3230844
- Wall-clock: 475s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
