---
title: Authentication Model
source: designs/gateway-bearer-token-auth.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 069d5ecbf79d90409069cfe72ed0c54e79c7bc77
source_date: 2026-03-07
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, capability-security]
status: current
notes: The "agent ID as bearer token" pattern reuses the formula identifier (256-bit hex, 64 chars) as the authentication credential — knowing it grants full control. The URL-fragment-not-query-param choice is the load-bearing secrecy detail: HTTP fragments per RFC 3986 are never sent to the server in HTTP requests. CapTP's `GatewayBootstrap.fetch(token)` is the only gate; no JSON auth handshake.
parent: endo-but-for-bots--llm-designs-gbta--problem-and-auth-model
---

Authentication is already implemented via CapTP. The `GatewayBootstrap` exo exposes a single method:

```js
fetch(token) → agent powers
```

The `token` is the agent's formula identifier — a 256-bit hex string (64 characters). Knowing the identifier grants full control of that agent's profile, the same authority model as SSH keys or API tokens.

The Chat UI already receives the agent ID via URL fragment (`#gateway=<host>&agent=<id>`). The fragment is never sent to the server in HTTP requests (per RFC 3986). The client extracts the agent ID from `window.location.hash` and passes it to `GatewayBootstrap.fetch()` over the CapTP WebSocket connection.

No additional JSON auth handshake is needed — CapTP provides the authenticated channel, and `fetch(token)` is the gate.

Source: [designs/gateway-bearer-token-auth.md](https://github.com/endojs/endo-but-for-bots/blob/069d5ecbf79d90409069cfe72ed0c54e79c7bc77/designs/gateway-bearer-token-auth.md) at commit `069d5ecb` on branch `llm`.
