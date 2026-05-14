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
---

> Abstract: **Five security considerations**: (1) **Token secrecy** — agent ID is 256-bit random hex; brute-force infeasible; primary risk is leakage via browser history (URL fragments may appear there) or shared links; users should treat URL as sensitive. (2) **TLS required** — in remote mode the WebSocket carries the bearer token; without TLS, token visible to network observers; gateway warns at startup. (3) **Rate limiting** — per-IP on failed `fetch()` (1 attempt/second after failure) prevents online brute force. (4) **No session tokens** — each WebSocket auths independently via CapTP `fetch(token)`; no session cookies or JWTs. (5) **Localhost bypass** — in local mode, localhost IP check remains the auth mechanism; backward-compat. **Files modified**: `packages/daemon/src/web-server-node.js` only. **Five design decisions**: (1) **No separate auth handshake** — CapTP provides authenticated channel; `GatewayBootstrap.fetch(token)` is the gate; JSON auth message protocol would duplicate. (2) **Agent ID as bearer token** — reuses existing 256-bit formula identifier; agent ID already represents full authority over the profile. (3) **URL fragment, not query parameter** — fragment never sent to server in HTTP requests; reduces accidental logging. (4) **No OAuth/OIDC** — formula identifier already scopes authority; OAuth adds redirect flows + token refresh + IdP config with no additional security benefit. (5) **Explicit opt-in** — `ENDO_GATEWAY=remote` required; binding to `0.0.0.0` alone doesn't imply remote access; avoids surprises when operator binds for LAN use. **Related designs**: `daemon-docker-selfhost` (Docker for self-hosting; depends on this); `familiar-gateway-migration` (gateway architecture this extends).

## Security Considerations

1. **Token secrecy.** The agent ID is a 256-bit random hex string. Brute-forcing is infeasible. The primary risk is token leakage through browser history (URL fragments may appear there) or shared links. Users should treat the URL as sensitive.
2. **TLS required.** In remote mode, the WebSocket carries the bearer token. Without TLS, the token is visible to network observers. The gateway warns at startup if remote mode is active.
3. **Rate limiting.** Per-IP rate limiting on failed `fetch()` attempts prevents online brute force (1 attempt per second after a failure).
4. **No session tokens.** Each WebSocket connection authenticates independently via CapTP `fetch(token)`. No session cookies or JWTs.
5. **Localhost bypass.** In local mode, the localhost IP check remains the authentication mechanism. This preserves backward compatibility.

## Files Modified

| File | Change |
|---|---|
| `packages/daemon/src/web-server-node.js` | `ENDO_GATEWAY=remote` mode, per-IP rate limiter on `fetch()`, TLS warning |

## Design Decisions

1. **No separate auth handshake.** CapTP already provides an authenticated channel. The `GatewayBootstrap.fetch(token)` method is the authentication gate — adding a JSON auth message protocol would duplicate what CapTP provides.
2. **Agent ID as bearer token.** Reuses the existing 256-bit formula identifier rather than introducing a separate credential. The agent ID already represents full authority over the profile.
3. **URL fragment, not query parameter.** The fragment is never sent to the server in HTTP requests, reducing accidental logging.
4. **No OAuth/OIDC.** Even in a multi-tenant scenario, the bearer token for the user's capabilities is sufficient and does not require validation from a third-party authenticator. OAuth adds redirect flows, token refresh, and IdP configuration with no additional security benefit — the formula identifier already scopes authority to the holder.
5. **Explicit opt-in.** Remote mode requires `ENDO_GATEWAY=remote` — binding to `0.0.0.0` alone does not imply remote access. This avoids surprises when an operator binds to all interfaces for LAN use without intending full remote access.

## Related Designs

- `daemon-docker-selfhost` — Docker image for self-hosting; depends on this design for remote access.
- `familiar-gateway-migration` — the gateway architecture that this design extends.

Source: [designs/gateway-bearer-token-auth.md](https://github.com/endojs/endo-but-for-bots/blob/069d5ecbf79d90409069cfe72ed0c54e79c7bc77/designs/gateway-bearer-token-auth.md) at commit `069d5ecb` on branch `llm`.
