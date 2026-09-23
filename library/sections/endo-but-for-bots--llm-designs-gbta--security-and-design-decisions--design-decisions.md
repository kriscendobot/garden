---
title: Design Decisions
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
notes: The five design decisions are canonical Endo capability-discipline choices: (1) "no JSON auth handshake on top of CapTP" (CapTP already provides the authenticated channel); (2) "agent ID as bearer token" (reuses existing 256-bit identifier, no separate credential); (3) "URL fragment, not query parameter" (RFC 3986 fragments not server-sent); (4) "no OAuth/OIDC" (formula identifier already scopes authority; OAuth adds complexity with no security benefit); (5) "explicit opt-in" (binding to 0.0.0.0 alone doesn't enable remote access).
parent: endo-but-for-bots--llm-designs-gbta--security-and-design-decisions
---

1. **No separate auth handshake.** CapTP already provides an authenticated channel. The `GatewayBootstrap.fetch(token)` method is the authentication gate — adding a JSON auth message protocol would duplicate what CapTP provides.
2. **Agent ID as bearer token.** Reuses the existing 256-bit formula identifier rather than introducing a separate credential. The agent ID already represents full authority over the profile.
3. **URL fragment, not query parameter.** The fragment is never sent to the server in HTTP requests, reducing accidental logging.
4. **No OAuth/OIDC.** Even in a multi-tenant scenario, the bearer token for the user's capabilities is sufficient and does not require validation from a third-party authenticator. OAuth adds redirect flows, token refresh, and IdP configuration with no additional security benefit — the formula identifier already scopes authority to the holder.
5. **Explicit opt-in.** Remote mode requires `ENDO_GATEWAY=remote` — binding to `0.0.0.0` alone does not imply remote access. This avoids surprises when an operator binds to all interfaces for LAN use without intending full remote access.

Source: [designs/gateway-bearer-token-auth.md](https://github.com/endojs/endo-but-for-bots/blob/069d5ecbf79d90409069cfe72ed0c54e79c7bc77/designs/gateway-bearer-token-auth.md) at commit `069d5ecb` on branch `llm`.
