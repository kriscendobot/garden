---
source_kind: web
source_url: https://tailscale.com/docs/features/oauth-apps
source_date: 2026-06-30
source_authors: [Tailscale]
ingested: 2026-06-30
ingested_by: scholar
section_count: 2
status: current
notes: "The authorization-code (user-identity) half of Tailscale's OAuth surface; OAuth apps are in alpha as of 2026-06-30. Companion source: web--tailscale-oauth-clients (the client-credentials, service-identity half). Fetched direct; content sha256 5049…ea0f659."
---

Tailscale's canonical documentation for **OAuth apps**: internal tools that act on a tailnet **on behalf of an individual user** via the OAuth 2.0 authorization-code flow (RFC 6749 section 4.1). A user completes a Tailscale-hosted consent screen and the authorization carries that user's identity, so access-control rules, audit-log entries, and quotas apply to the consenting user rather than a shared service identity. The source draws the explicit contrast with OAuth clients (client-credentials, tag-owned, service-identity) that anchors the garden's identify-which-OAuth-pattern decision rule.

| Section | Topics | Status |
|---------|--------|--------|
| [user-delegated authorization-code model](../sections/web--tailscale-oauth-apps--user-delegated-authorization-code-model.md) | oauth-credentials, capability-security | current |
| [requirements and limitations](../sections/web--tailscale-oauth-apps--requirements-and-limitations.md) | oauth-credentials | current |
