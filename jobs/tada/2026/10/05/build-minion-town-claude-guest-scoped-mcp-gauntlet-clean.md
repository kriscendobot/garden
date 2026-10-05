Clean stage for kriscendobot/minion.town#160: I added the missing tests and pushed them, and CI is green on the new head `004d905` (3 of 3 checks pass).

**What the pass found.** CI was already green at the starting head `e6d9a17`, but two code paths in the new per-guest broker code in `src/endo/claude/claude-guest-bridge.ts` had no tests:
- a broker whose start fails must not be cached, so the next turn tries again;
- a broker must be closed when its daemon connection closes, and the next turn must start a new one.

Broker reuse across turns and closing a broker when its child is removed were already tested.

**Dead code.** None found. Nothing still refers to the removed `endoSock` option, `agentMcpCommandPath`, `ENDO_CLAUDE_AGENT_MCP_COMMAND` or `endo-mcp-stdio` (searched `src`, `test`, deploy scripts, docs and `.env.example`).

**What I pushed** (one commit, through `safe-push-pr-head.sh`, which only adds commits):
- `test/claude-guest-bridge-reconnect.test.ts`: a new `claude guest bridge brokers` block with three tests: a failed start is not cached, one broker serves every turn for its guest, and a closed connection retires the broker so a fresh one starts. I also updated the file's header comment to mention them.
- `test/claude-cli-deployment.test.ts`: renamed the test "lacks either agent MCP entry" to "lacks the agent MCP entry", since the PR leaves only one entry to check.

**Local checks.** Prettier and the TypeScript check pass. The full suite has one failure locally: `test/git-remote/capability.test.ts > propagates a git failure rather than reporting the ref absent`. This PR doesn't touch that file and it passes in CI, so it looks like a quirk of this machine's git setup.

**Follow-up.** The deployment's refusal when the pinned Endo checkout has no `startGuestBroker` still has no test. Testing it needs a module that passes the pinned-commit check, so I left it alone.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-guest-scoped-mcp-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (963180 cached reads)
- Output: 6437 tokens
- Cost: $0.8527039999999999
- Wall-clock: 398s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
