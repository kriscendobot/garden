---
title: Security considerations + design decisions + related designs
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
kind: index
section_count: 4
---

> Abstract: **Five security considerations**: (1) **Token secrecy** — agent ID is 256-bit random hex; brute-force infeasible; primary risk is leakage via browser history (URL fragments may appear there) or shared links; users should treat URL as sensitive. (2) **TLS required** — in remote mode the WebSocket carries the bearer token; without TLS, token visible to network observers; gateway warns at startup. (3) **Rate limiting** — per-IP on failed `fetch()` (1 attempt/second after failure) prevents online brute force. (4) **No session tokens** — each WebSocket auths independently via CapTP `fetch(token)`; no session cookies or JWTs. (5) **Localhost bypass** — in local mode, localhost IP check remains the auth mechanism; backward-compat. **Files modified**: `packages/daemon/src/web-server-node.js` only. **Five design decisions**: (1) **No separate auth handshake** — CapTP provides authenticated channel; `GatewayBootstrap.fetch(token)` is the gate; JSON auth message protocol would duplicate. (2) **Agent ID as bearer token** — reuses existing 256-bit formula identifier; agent ID already represents full authority over the profile. (3) **URL fragment, not query parameter** — fragment never sent to server in HTTP requests; reduces accidental logging. (4) **No OAuth/OIDC** — formula identifier already scopes authority; OAuth adds redirect flows + token refresh + IdP config with no additional security benefit. (5) **Explicit opt-in** — `ENDO_GATEWAY=remote` required; binding to `0.0.0.0` alone doesn't imply remote access; avoids surprises when operator binds for LAN use. **Related designs**: `daemon-docker-selfhost` (Docker for self-hosting; depends on this); `familiar-gateway-migration` (gateway architecture this extends).

Sections:

- [Security Considerations](endo-but-for-bots--llm-designs-gbta--security-and-design-decisions--security-considerations.md)
- [Files Modified](endo-but-for-bots--llm-designs-gbta--security-and-design-decisions--files-modified.md)
- [Design Decisions](endo-but-for-bots--llm-designs-gbta--security-and-design-decisions--design-decisions.md)
- [Related Designs](endo-but-for-bots--llm-designs-gbta--security-and-design-decisions--related-designs.md)

Source: [designs/gateway-bearer-token-auth.md](https://github.com/endojs/endo-but-for-bots/blob/069d5ecbf79d90409069cfe72ed0c54e79c7bc77/designs/gateway-bearer-token-auth.md) at commit `069d5ecb` on branch `llm`.
