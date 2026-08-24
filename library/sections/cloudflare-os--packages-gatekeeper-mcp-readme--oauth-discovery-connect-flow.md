---
title: OAuth discovery connect flow and token handling
source: packages/gatekeeper-mcp/README.md
source_repo: cloudflare/cloudflare-os
source_commit: bd0aa2dcde02008bb6170341fe2c574fd3ace275
source_date: 2026-08-18
source_authors: [Dan Carter, Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, oauth-credentials, cloudflare-workers-agent-hosting]
status: current
---

An MCP connection starts by validating the user-supplied endpoint against a host blocklist, opens a Streamable HTTP session, and on a `401` runs the official MCP client's standards-based OAuth discovery chain; tokens live in a per-account Durable Object and refresh proactively.

The connect form validates the endpoint against the `endpoint.ts` host blocklist (no private, loopback, or metadata hosts; HTTPS required unless `MCP_ALLOW_INSECURE`) and says plainly that connecting a server is a decision to trust it. The gatekeeper then calls `initialize`; a server that completes the handshake unauthenticated is recorded as public and no token is demanded of it later. A `401` starts the discovery chain: protected resource metadata (RFC 9728) to authorization server metadata (RFC 8414) to dynamic client registration (RFC 7591) to authorization code plus PKCE (RFC 7636) with a resource indicator (RFC 8707). The SDK falls back to the conventional `/authorize`, `/token`, and `/register` paths, so a server that does not implement dynamic client registration is not detected up front — the synthesized `/register` is tried and refuses, reading as a rejected registration rather than a missing capability; the remedy is to connect a server that supports registration or reach it through an administrator-configured portal with a preissued token.

Tokens are stored in the `McpAccount` Durable Object and refreshed before the recorded expiry, and nothing outside the Worker can obtain one. A `401` mid-session is not a refresh trigger: it means the server rejected a token the Worker believed valid, so the account is marked as needing attention and the user is asked to reconnect — refreshing would paper over a revoked grant. Refresh failures are classified so that only the authorization server's own verdict on the credential (`invalid_grant` and friends) marks the account expired, while transport and unrecognised failures leave it alone to be retried. The endpoint is fixed at first connect: reconnecting an account cannot point it at a different server because the binding's props still name the original (the portal connector is the exception, since its endpoint comes from deployment configuration).

Source: [packages/gatekeeper-mcp/README.md](https://github.com/cloudflare/cloudflare-os/blob/bd0aa2dcde02008bb6170341fe2c574fd3ace275/packages/gatekeeper-mcp/README.md) at commit `bd0aa2dc`.
