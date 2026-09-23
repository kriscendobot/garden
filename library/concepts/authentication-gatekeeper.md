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
| [Service roles and resource boundaries](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--service-roles-and-resource-boundaries.md) | Uses verified Cloudflare identity while keeping broader grants resource-specific. |
| [identity grant versus resource grant](../sections/cloudflare-os--packages-gatekeeper-github-readme--identity-grant-versus-resource-grant.md) | GitHub login consumes and discards a minimal verified-email grant. |
| [OAuth App permission model](../sections/cloudflare-os--packages-gatekeeper-github-readme--oauth-app-permission-model.md) | GitHub OAuth Apps preserve request-time scope attenuation for sign-in. |
| [verified-email login and resource scopes](../sections/cloudflare-os--packages-gatekeeper-google-readme--verified-email-login-and-resource-scopes.md) | Google login verifies email through transient identity-only scopes. |

## See also

- [[cloudflare-os-gatekeeper]]
- [[oauth-client-credentials-vs-authorization-code]]
- [[tripartite-identity]]
