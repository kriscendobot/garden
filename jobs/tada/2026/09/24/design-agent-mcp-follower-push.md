I wrote the design `designs/agent-mcp-follower-push.md` and opened it as draft PR **endojs/endo-but-for-bots#1341**. It targets a frozen snapshot of `llm`, the new branch `llm-6726b0f`. The diff is the design file plus one index row in `designs/README.md`. The diagram parses. I posted a link to the PR on #1339: https://github.com/endojs/endo-but-for-bots/issues/1339#issuecomment-5822273461.

**What the design decides:**
- **What Claude Code does with pushed messages.** I checked the Claude Code 2.1.280 client installed on the garden hosts. Only the Claude Code "channel" notification (`notifications/claude/channel`) reaches the model, and it does so by starting a new turn. It only works when channels are turned on with a client flag, and it is an experimental feature. The client never subscribes to resources, so `resources/updated` reaches no model. Progress and logging messages are not model input either. This check needs repeating against whichever Claude Code version the harness pins before anyone builds this.
- **Pull stays the default.** The `@endo/claude` harness runs one `claude -p` per inference and expects exactly one final result per prompt. A pushed event starts an extra turn, so the harness would record a good inference as a failure. Also, a follower lives only as long as its inference, so there is no later time for a push to be useful. Push is therefore turned on per spawn with `ENDO_MCP_PUSH=channel`, and the harness never sets it.
- **Phase 1 (fixes a current gap, no push needed).** In #1336, a client's `notifications/cancelled` is ignored, so a waiting `readFollower` keeps running until its 30 s timeout. The design makes that cancel work, using `cancelled` promises per request, per follower and per connection. An item that arrives after the cancel is kept for the next read.
- **Phase 2 (push).** A new `pushFollower` tool is always listed, so the tool list stays fixed and `tools.listChanged` stays false. Without the opt-in it returns a visible `push-unavailable` error. The server only takes the next item from the stream when it has budget to deliver it, so it keeps no local queue and drops nothing. It also waits for stdout to drain, and caps events per follower and per connection. When a follower runs out of budget it goes back to pull mode.
- **Phase 3 (deferred).** A resource-subscription version (`endo-follower:///{follower}`) waits until some client in use actually consumes `resources/updated`.

The design includes the required ownership map. It lists five open questions for the maintainer: whether to ship push before a long-lived consumer exists, whether to depend on the experimental channel feature, what happens when the budget runs out, the default limits, and JSON vs Justin rendering.

The PR is left draft. When you want the design panel to review it, say **run the gauntlet #1341**.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-agent-mcp-follower-push.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2152360 cached reads)
- Output: 18145 tokens
- Cost: $1.5148519999999999
- Wall-clock: 362s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
