---
source: docs/oauth-signin.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk, "Yo'av Moshe"]
ingested: 2026-08-24
ingested_by: scholar
section_count: 4
status: current
---

The sign-in design makes auth-capable Gatekeepers an additive federated-login surface keyed by verified email, with transient minimal-scope grants and capability-shaped login attempts.

| Section | Topics | Status |
|---------|--------|--------|
| [verified-email identity and incremental OAuth scopes](../sections/cloudflare-os--docs-oauth-signin--verified-email-identity-and-incremental-scopes.md) | authentication-gatekeepers, identity, capability-mediated-integrations, oauth-credentials | current |
| [capability-shaped sign-in flow](../sections/cloudflare-os--docs-oauth-signin--capability-shaped-sign-in-flow.md) | authentication-gatekeepers, identity, capability-mediated-integrations | current |
| [deployment configuration and lockout guard](../sections/cloudflare-os--docs-oauth-signin--deployment-configuration-and-lockout-guard.md) | authentication-gatekeepers, cloudflare-workers-agent-hosting | current |
| [PendingLogin storage and authentication code layout](../sections/cloudflare-os--docs-oauth-signin--pending-login-storage-and-code-layout.md) | authentication-gatekeepers, cloudflare-workers-agent-hosting | current |
