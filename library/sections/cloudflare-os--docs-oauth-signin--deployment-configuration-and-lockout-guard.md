---
title: Deployment configuration and lockout guard
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

Deployments explicitly allowlist authentication Gatekeepers and may hide password login only when that list is nonempty, preventing a configuration from locking out every user.

OAuth client credentials live on each Gatekeeper Worker, not on the Workshop backend, and each app registers its own Gatekeeper redirect URI under `PUBLIC_BASE_URL`. The allowlist controls both which buttons appear and their order; an empty list preserves the username/password or Cloudflare Access behavior.

Source: [docs/oauth-signin.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/docs/oauth-signin.md) at commit `657aa965`.
