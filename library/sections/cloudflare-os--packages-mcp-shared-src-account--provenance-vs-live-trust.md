---
title: Connect-time provenance versus live trust configuration
source: packages/mcp-shared/src/account.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/mcp-shared/src/account.ts
source_line_range: "1-13, 48-73, 128-178"
source_commit: 50ac3efa2ddf98edf44393916b3f3688667b2813
comment_subject: which connection facts are frozen at connect time (provenance, endpoint) versus read live from deployment configuration (trust, auth token)
source_authors: [Dan Carter, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, capability-security]
status: current
---

The MCP account Durable Object distinguishes facts settled once at connect time and true forever after (who chose the endpoint, and the endpoint itself) from facts that must be read afresh from current deployment configuration (whether the endpoint's annotations are trusted, and any preissued bearer token). Provenance is frozen because it records a past decision; trust configuration must never be frozen onto an account because withdrawing it has to take effect without a reconnect. This split is why `ConnectedServer.provenance` is stored while `ServerTrust` is deliberately not.

## What connect settles once

A `ConnectedServer` record carries: the `endpoint` (immutable after first connect); a `serverId` slug used only for naming the suggested binding and the generated session type (not unique, so action-kind tags are built from the whole endpoint via `endpointTag`); the server's reported `serverName` (or the endpoint host); the `provenance` (`user` or `deployment`) naming who chose the endpoint, settled at connect time and true forever after; and the `auth` kind (`none`, `oauth`, or `token`).

The connect handshake, for context: `setCallback` records how to reach the Workshop and arms a self-deleting alarm; `beginConnect` probes the endpoint unauthenticated (success means a public server, a 401 both signals OAuth is needed and names the authorization server); `#beginOAuth` discovers and registers once per endpoint; `acceptAuthCode` exchanges the code. Every nonce is single-use, time-bounded, and compared in constant time.

## What must be read live

`provenance` is explicitly contrasted with `ServerTrust`, "which is current deployment configuration and must not be frozen onto an account." A preissued bearer token likewise comes from current deployment configuration (`staticToken`), read only for a `token`-auth endpoint and reported as a misconfiguration when absent. A server-supplied display name is capped at 60 characters, forced single-line, and stripped of markdown that could forge structure in an approval prompt, because it appears in every approval prompt.

The account is the only place an access token is stored, refreshed, or handed out. Per-connector subclasses supply where the Worker lives (`baseUrl`), how to hand the finished account back (`mintAccount`, per-connector because a Durable Object can only reach its own Worker's exports), and the optional static token.

Source: [packages/mcp-shared/src/account.ts](https://github.com/cloudflare/cloudflare-os/blob/50ac3efa2ddf98edf44393916b3f3688667b2813/packages/mcp-shared/src/account.ts) at commit `50ac3efa2d` (lines 1-13, 48-73, 128-178).
