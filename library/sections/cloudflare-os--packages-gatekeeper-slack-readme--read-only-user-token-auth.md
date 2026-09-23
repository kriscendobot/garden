---
title: Slack read-only mediation and user-token scopes
source: packages/gatekeeper-slack/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, oauth-credentials, cloudflare-workers-agent-hosting]
status: current
---

The Slack Gatekeeper mediates read-only access to a user's Slack workspace using an OAuth 2.0 user token (`xoxp-…`) requested through `user_scope`, so the agent sees exactly what the connecting user can see — private channels, DMs, and search included — and never sends or modifies Slack data.

The connector runs as its own Cloudflare Worker auto-discovered from its `GATEKEEPER_SLACK` binding. It requests a user token rather than a bot token precisely so the agent's view matches the connecting user's. A Slack app supplies client credentials to the Worker as `CLIENT_ID` / `CLIENT_SECRET` (local dev maps `SLACK_CLIENT_ID` / `SLACK_CLIENT_SECRET`); the app's redirect URL must match `<BASE_URL>/oauth`. Token rotation should be enabled, making tokens short-lived (roughly 12 hours) and refreshed via `oauth.v2.access?grant_type=refresh_token`, though non-rotating tokens also work as a fallback and are returned as-is. `users:read` is always requested for connected-account display and user-name resolution.

Scopes are requested per granted resource. A workspace grant requests `team:read`, the conversation read scopes, and `search:read`; a conversation grant requests the conversation read scopes and `search:read`; a thread grant requests `channels:history`, `groups:history`, `im:history`, and `mpim:history`; and `users:read` is always requested. The conversation read scopes are `channels`, `groups`, `im`, and `mpim` each at `:read` and `:history`. This coupling of URL pattern to requested scopes drives both consent and routing.

Source: [packages/gatekeeper-slack/README.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/packages/gatekeeper-slack/README.md) at commit `657aa965`.
