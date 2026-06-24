---
source: designs/gateway-bearer-token-auth.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 069d5ecbf79d90409069cfe72ed0c54e79c7bc77
source_date: 2026-03-07
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 3
status: current
notes: Per the README this design is **Implemented** (M1; gateway-bearer-token-auth, agent ID as bearer token, rate limiting, CIDR filtering). Bridges to capability-security via the "agent ID as bearer token" pattern — reuses the existing 256-bit formula identifier rather than introducing a separate credential. Same authority model as SSH keys / API tokens.
---

> Abstract: Design for remote daemon access via bearer-token auth. **Problem**: gateway currently accepts only localhost (127.0.0.1 / ::1); a self-hosted daemon on a VPS can't be controlled remotely. **Authentication model**: already implemented via CapTP. The `GatewayBootstrap` exo exposes `fetch(token) → agent powers`; the token is the agent's formula identifier (256-bit hex, 64 chars) — knowing it grants full control of that agent's profile. Chat UI receives the agent ID via **URL fragment** (`#gateway=<host>&agent=<id>`) — fragments are never sent in HTTP requests (RFC 3986), so the client extracts from `window.location.hash` and passes to `GatewayBootstrap.fetch()` over CapTP WebSocket. **No additional JSON auth handshake** — CapTP provides the authenticated channel; `fetch(token)` is the gate. **Three sections**: problem + auth model; design (remote mode opt-in via `ENDO_GATEWAY=remote`, optional `ENDO_GATEWAY_ALLOWED_CIDRS`, per-IP rate limiting on failed fetches with accruing 1-second penalty, startup TLS warning); security + design decisions (5 considerations + 5 numbered design decisions including "agent ID as bearer token" reuses the existing formula identifier; "URL fragment, not query parameter" prevents accidental logging).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-and-auth-model](../sections/endo-but-for-bots--llm-designs-gbta--problem-and-auth-model.md) | daemon, capability-security | current |
| [design-remote-mode-and-rate-limiting](../sections/endo-but-for-bots--llm-designs-gbta--design-remote-mode-and-rate-limiting.md) | daemon, tooling | current |
| [security-and-design-decisions](../sections/endo-but-for-bots--llm-designs-gbta--security-and-design-decisions.md) | daemon, capability-security | current |

## Cross-references

- `daemon-docker-selfhost.md` — Docker image for self-hosting; depends on this design for remote access.
- `familiar-gateway-migration.md` — the gateway architecture this design extends.
- Cap-discipline analog: TOFB (cycle 40's `trust-on-first-bind.md`) — both use capability-based auth without a JSON auth handshake.

## Source

[designs/gateway-bearer-token-auth.md](https://github.com/endojs/endo-but-for-bots/blob/069d5ecbf79d90409069cfe72ed0c54e79c7bc77/designs/gateway-bearer-token-auth.md) at commit `069d5ecb` on branch `llm`.
