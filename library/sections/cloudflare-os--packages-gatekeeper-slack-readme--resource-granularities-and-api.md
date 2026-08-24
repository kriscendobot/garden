---
title: Slack resource granularities and session API
source: packages/gatekeeper-slack/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, cloudflare-workers-agent-hosting]
status: current
---

Slack access is granted at one of three granularities — whole workspace, a conversation, or a thread — each mapped to a URL pattern, and a conversation-scoped session hard-restricts its search to the bound conversation regardless of query.

The whole workspace maps to the framework's account-wide `https://*` catch-all (session type `SlackWorkspaceSession`); a conversation (channel, DM, or group DM) maps to `https://app.slack.com/client/:teamId/:conversationId` (`SlackConversation`, with channels and DMs sharing one "Conversation" grant); and a thread maps to `https://*.slack.com/archives/:conversationId/:messageId` (`SlackThread`). More-specific conversation and thread URLs take precedence over the workspace catch-all.

The full Session API lives in `src/types.d.ts`. `SlackWorkspaceSession` offers `getInfo`, `listChannels`, `listDirectMessages`, `listUsers`, `getUser`, `getConversation`, and `search`. `SlackConversation` offers `getInfo`, `members`, `listMessages`, `getThread`, and `search` — where conversation-scoped search is hard-restricted to the bound conversation regardless of query, so the grant's boundary cannot be widened by a crafted search. `SlackThread` offers `getRoot` and `listReplies`. List and search methods return paginated `Cursor` objects, and known mentions are rendered with readable names.

Source: [packages/gatekeeper-slack/README.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/packages/gatekeeper-slack/README.md) at commit `657aa965`.
