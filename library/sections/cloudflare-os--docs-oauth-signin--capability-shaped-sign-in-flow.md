---
title: Capability-shaped sign-in flow
source: docs/oauth-signin.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk, "Yo'av Moshe"]
ingested: 2026-08-24
ingested_by: scholar
topics: [authentication-gatekeepers, identity, capability-mediated-integrations]
status: current
---

The sign-in attempt is represented by an RPC capability to a short-lived PendingLogin Durable Object rather than by a client-visible login identifier.

The public API asks an allowlisted Gatekeeper to begin login and returns an OAuth URL plus an attempt stub. The browser opens the Gatekeeper's self-closing popup and waits on that capability. On completion, the Gatekeeper callback reads a verified email, resolves or creates the email-keyed user, mints a normal session token, and resolves the waiter. The minimal login grant is discarded and does not become a connected account.

Source: [docs/oauth-signin.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/docs/oauth-signin.md) at commit `657aa965`.
