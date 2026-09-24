---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Design push projection of followed streams for the agent MCP stdio server

Repo: endojs/endo-but-for-bots. Tracking: https://github.com/endojs/endo-but-for-bots/issues/1339 (section "Also noted from the same review"). Origin: kriskowal review comment https://github.com/endojs/endo-but-for-bots/pull/1336#discussion_r4098195295 ("note where our plan is incomplete ... post jobs to design unfinished parts").

The agent MCP server (`@endo/agent-mcp-stdio`, PR #1336) pulls from followers in bounded reads (`followMessages`, `followNameChanges`, `followLocatorNameChanges`, `followStream`, then `readFollower` and `closeFollower`). It does not push. Design whether and how a followed stream should be projected as MCP push, through `resources/subscribe` plus `notifications/resources/updated`, or through server notifications. Cover backpressure, bounding, cancellation (use the `cancelled` promise pattern), what Claude Code actually consumes, and how this interacts with the static catalog and `tools.listChanged: false`. Write `designs/agent-mcp-follower-push.md` on a draft PR against a frozen llm snapshot. Comment on #1339 with the PR.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-24T21:02:14Z
