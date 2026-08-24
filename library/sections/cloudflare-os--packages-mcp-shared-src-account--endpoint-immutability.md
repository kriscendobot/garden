---
title: Endpoint immutability and the credential-confusion hazard
source: packages/mcp-shared/src/account.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/mcp-shared/src/account.ts
source_line_range: "75-106, 291-338"
source_commit: 50ac3efa2ddf98edf44393916b3f3688667b2813
comment_subject: why a connected MCP endpoint is immutable after first connect, and why the one allowed repoint deletes credentials
source_authors: [Dan Carter, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, capability-security]
status: current
---

The Durable Object that owns one connection to one MCP endpoint pins that endpoint immutably after the first connect, because a gatekeeper facet freezes the endpoint into its props while `getAuthorization()` answers for whatever the account currently points at. Letting the account move would send a token minted for the new server to the old one, a credential-confusion hazard. The one endpoint change allowed is a deployment repointing its own gateway (a target from this Worker's own configuration, not from anything a user typed), and that repoint deletes all credentials and persists the new endpoint before its probe so no stale facet can receive the new portal's token.

## Only the endpoint is pinned

`resolveConnectTarget` decides which server record a `beginConnect` proceeds with. A reconnect re-authorizes the server this account already holds credentials for and cannot name a different endpoint. Everything else on the record is the caller's to restate: a deployment's portal supplies its name and auth kind from current configuration. Preferring the stored copy meant a reconnect could not adopt a renamed portal, a rotated preissued token, or a switch between `token` and `oauth` (the reconnect would appear to succeed while keeping the configuration it was meant to replace). A user-supplied reconnect passes no target and falls back to what is stored.

The refusal condition is precise: refuse only when there is an existing record, a target with a *different* endpoint, and the target's provenance is not `deployment`.

## The allowed repoint deletes credentials and persists first

A deployment repointing its own gateway is the exception. That target comes from this Worker's configuration rather than anything a user typed, and bindings minted against the old endpoint already fail closed (each connector checks its props against current configuration before handing out a capability). Refusing it outright left the repoint unrecoverable: every existing binding told the user to reconnect, and reconnecting was the one thing the account would not do. Credentials do not survive the move.

`beginConnect` enacts this in a specific order. Every claimed attempt advances a connection generation before its first `await`, invalidating stale probe, OAuth-callback, refresh, and session writes. A repoint additionally persists the new endpoint *now*, not after its probe: static tokens come from current deployment configuration, so leaving the old server record in place during that await would let a stale old-endpoint facet pass `getConnection()` and receive the new portal's token. On an endpoint change the connector writes the new `server` record and deletes `tokens`, `oauthClient`, `oauthDiscovery`, `oauthVerifier`, and `pendingAuth`.

Source: [packages/mcp-shared/src/account.ts](https://github.com/cloudflare/cloudflare-os/blob/50ac3efa2ddf98edf44393916b3f3688667b2813/packages/mcp-shared/src/account.ts) at commit `50ac3efa2d` (lines 75-106, 291-338).
