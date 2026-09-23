---
title: PendingLogin storage and authentication code layout
source: docs/oauth-signin.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk, "Yo'av Moshe"]
ingested: 2026-08-24
ingested_by: scholar
topics: [authentication-gatekeepers, cloudflare-workers-agent-hosting]
status: current
---

PendingLogin is an ephemeral Durable Object reached through `ctx.exports`; the live waiting RPC keeps it resident and no durable login-attempt record is stored.

Backend authentication code separates allowlist and password-toggle configuration, Gatekeeper binding lookup, and the PendingLogin callback flow. Client configuration exposes the provider list and password availability to an OAuth-button component that owns the popup and attempt wait.

Source: [docs/oauth-signin.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/docs/oauth-signin.md) at commit `657aa965`.
