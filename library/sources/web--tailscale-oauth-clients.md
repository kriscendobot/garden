---
source_kind: web
source_url: https://tailscale.com/docs/features/oauth-clients
source_date: 2026-06-30
source_authors: [Tailscale]
ingested: 2026-06-30
ingested_by: scholar
section_count: 3
status: current
notes: "The client-credentials (service-identity) half of Tailscale's OAuth surface. Companion source: web--tailscale-oauth-apps (the authorization-code, user-identity half). Fetched direct; content sha256 5228…c62f3."
---

Tailscale's canonical documentation for **OAuth clients**: durable `(client ID, client secret)` credentials that mint short-lived (one-hour) API access tokens through the OAuth 2.0 client-credentials grant. Captures the two capability dimensions (scopes, which name reachable API endpoints; tags, which name grantable device identities), the scope-to-endpoint least-privilege mapping, the token endpoint and renewal lifecycle, tag-owned auth-key minting (`auth_keys` scope, `get-authkey`, `tailscale up --auth-key`), and the tailnet-owned credential lifecycle that lets a client outlive its creator. This is the model the garden's future programmatic-access OAuth work most resembles; see `skills/oauth-use-case-patterns/SKILL.md` on `main2`.

| Section | Topics | Status |
|---------|--------|--------|
| [client-credentials, scopes, and token lifecycle](../sections/web--tailscale-oauth-clients--client-credentials-scopes-and-token-lifecycle.md) | oauth-credentials, capability-security | current |
| [tags as capabilities and auth-key minting](../sections/web--tailscale-oauth-clients--tags-as-capabilities-and-auth-key-minting.md) | oauth-credentials, capability-security, networking | current |
| [client setup and secret lifecycle](../sections/web--tailscale-oauth-clients--client-setup-and-secret-lifecycle.md) | oauth-credentials, capability-security | current |
