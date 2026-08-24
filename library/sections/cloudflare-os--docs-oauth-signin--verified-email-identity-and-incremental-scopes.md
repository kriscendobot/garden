---
title: Verified-email identity and incremental OAuth scopes
source: docs/oauth-signin.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk, "Yo'av Moshe"]
ingested: 2026-08-24
ingested_by: scholar
topics: [authentication-gatekeepers, identity, capability-mediated-integrations, oauth-credentials]
status: current
---

Authentication Gatekeepers map every provider login to a provider-verified email and request only identity scopes until the user separately chooses to connect broader capabilities.

The verified email addresses the same User Durable Object regardless of which allowlisted provider supplied it. Each Gatekeeper must reject unverified addresses. Login grants are transient and carry only the scopes required to fetch identity; repository, mail, document, and billing scopes are requested later through an explicit full connection that persists a usable connected account.

Source: [docs/oauth-signin.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/docs/oauth-signin.md) at commit `657aa965`.
