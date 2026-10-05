# Gauntlet CLEAN stage: kriscendobot/minion.town PR #160

The clean stage is done. I added one missing test, pushed it to the PR head, and CI is green on the new head `dcdaf011f5`.

**Starting state:** the PR is an open draft on branch `claude-guest-scoped-mcp`, head `2bd8430`. All three checks (test and Claude harness on amd64 and arm64) were already green there. I still ran the coverage pass, because green CI alone doesn't show that coverage was done.

**Dead code:** the PR moves the guest from a launched `endo-mcp-stdio` command to a guest broker (`startGuestBroker`). I found nothing left orphaned by that change. There are no remaining references to `agentMcpCommandPath`, `ENDO_CLAUDE_AGENT_MCP_COMMAND` or `endo-mcp-stdio` in the source. The one remaining `ENDO_GUEST_FORMULA_ID` is a test asserting that the name is *absent*. `endoSock` is still used, for the bridge's own daemon connection.

**Coverage:** the PR's own tests already cover broker eviction and retirement, the stale-directory sweep, the `broker-close-failed` report, and `streamJsonArgv`.
- **Gap found and closed:** nothing tested the new refusal in `makeClaudeCliSeams` for an older `@endo/agent-mcp-stdio` module that has no `startGuestBroker`.
- **New test:** I added `test/claude-cli-seams-agent-mcp.test.ts`. It builds a fake module with only a tool list and checks for that exact refusal message.
- **Why a separate file:** reaching that check imports code that needs `@endo/init` loaded first. The existing `test/claude-cli-deployment.test.ts` deliberately doesn't load it, so the test lives on its own.
- **Checks run:** vitest passes (11/11 across both files), and prettier and tsc are clean.

**Push:** commit `dcdaf01` ("test(claude): refuse an agent MCP module without startGuestBroker") went to the PR head through `safe-push-pr-head.sh`, moving it from `2bd8430` to `dcdaf01`.

**CI:** `ci-wait-merge.sh --no-merge` returned 0 after about 2 minutes, with 0 of 3 checks failed.

**Not tested:** the `broker-sweep-failed` report is still unexercised. The sweep swallows read errors and deletes with force, so I couldn't find a realistic way to make it fail. It's minor.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr160-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1113124 cached reads)
- Output: 6621 tokens
- Cost: $0.8459327999999999
- Wall-clock: 283s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
