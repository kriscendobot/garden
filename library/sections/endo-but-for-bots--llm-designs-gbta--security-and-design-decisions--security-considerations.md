---
title: Security Considerations
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

1. **Token secrecy.** The agent ID is a 256-bit random hex string. Brute-forcing is infeasible. The primary risk is token leakage through browser history (URL fragments may appear there) or shared links. Users should treat the URL as sensitive.
2. **TLS required.** In remote mode, the WebSocket carries the bearer token. Without TLS, the token is visible to network observers. The gateway warns at startup if remote mode is active.
3. **Rate limiting.** Per-IP rate limiting on failed `fetch()` attempts prevents online brute force (1 attempt per second after a failure).
4. **No session tokens.** Each WebSocket connection authenticates independently via CapTP `fetch(token)`. No session cookies or JWTs.
5. **Localhost bypass.** In local mode, the localhost IP check remains the authentication mechanism. This preserves backward compatibility.

Source: [designs/gateway-bearer-token-auth.md](https://github.com/endojs/endo-but-for-bots/blob/069d5ecbf79d90409069cfe72ed0c54e79c7bc77/designs/gateway-bearer-token-auth.md) at commit `069d5ecb` on branch `llm`.
