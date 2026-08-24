---
id: authentication-gatekeeper
aliases: [authentication Gatekeeper, auth Gatekeeper, Gatekeeper sign-in, AUTH_GATEKEEPERS]
topics: [authentication-gatekeepers, identity, capability-mediated-integrations]
---

# Authentication Gatekeeper

A Cloudflare OS Gatekeeper that can produce a provider-verified email for a transient minimal-scope login grant, while reserving broader service capabilities for a later explicit account connection.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [verified-email identity and incremental OAuth scopes](../sections/cloudflare-os--docs-oauth-signin--verified-email-identity-and-incremental-scopes.md) | Uses a transient verified-email grant distinct from a full connected account. |
| [capability-shaped sign-in flow](../sections/cloudflare-os--docs-oauth-signin--capability-shaped-sign-in-flow.md) | Completes OAuth through a short-lived PendingLogin capability. |
| [deployment configuration and lockout guard](../sections/cloudflare-os--docs-oauth-signin--deployment-configuration-and-lockout-guard.md) | Allowlists providers while guarding against passwordless lockout. |
| [Cloudflare Gatekeeper billing connection](../sections/cloudflare-os--docs-ai-gateway-billing--cloudflare-gatekeeper-billing-connection.md) | Distinguishes Cloudflare login from a persisted full-scope billing connection. |

## See also

- [[cloudflare-os-gatekeeper]]
- [[oauth-client-credentials-vs-authorization-code]]
- [[tripartite-identity]]
