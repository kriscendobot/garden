---
id: oauth-client-credentials-vs-authorization-code
aliases: ["OAuth client credentials", "client credentials grant", "client-credentials flow", "authorization code flow", "authorization code grant", "OAuth app", "OAuth apps", "OAuth client", "OAuth clients", "service identity OAuth", "user-delegated OAuth", "on behalf of a user", "tag-owned credentials", "scope to capability", "scope to endpoint mapping", "short-lived access token", "Tailscale OAuth", "auth_keys scope", "get-authkey", "non-interactive API access"]
topics: [oauth-credentials, capability-security]
---

# oauth-client-credentials-vs-authorization-code

The central decision in adopting an OAuth-app pattern is which OAuth 2.0 grant fits the need. **Client-credentials** gives an unattended program a durable credential (a client ID and secret) that mints short-lived, scope-bounded access tokens tied to a **service identity** — there is no person in the loop, the credential is owned by the organization and outlives any individual, and least privilege is expressed as the scopes (and, in Tailscale's model, tags) fixed at client-creation time. **Authorization-code** instead lets a tool act **on behalf of a consenting user**: the user passes through a consent screen, the authorization carries that user's identity, and access-control, audit, and quotas all attribute to the user. Pick client-credentials for durable, person-independent automation; pick authorization-code when the action must be attributed to and bounded by a specific human. Tailscale realizes both — OAuth clients (client-credentials, tag-owned) and OAuth apps (authorization-code, user-identity) — and is the library's worked exemplar.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [web--tailscale-oauth-clients--client-credentials-scopes-and-token-lifecycle](../sections/web--tailscale-oauth-clients--client-credentials-scopes-and-token-lifecycle.md) | The client-credentials grant: durable client mints short-lived tokens; scopes map to least-privilege endpoint sets. |
| [web--tailscale-oauth-clients--tags-as-capabilities-and-auth-key-minting](../sections/web--tailscale-oauth-clients--tags-as-capabilities-and-auth-key-minting.md) | Tags name grantable device identities; the `auth_keys` scope mints tag-owned auth keys and registers nodes. |
| [web--tailscale-oauth-clients--client-setup-and-secret-lifecycle](../sections/web--tailscale-oauth-clients--client-setup-and-secret-lifecycle.md) | Secret exposed once; client is tailnet-owned and outlives its creator; revocation, not offboarding, retires it. |
| [web--tailscale-oauth-apps--user-delegated-authorization-code-model](../sections/web--tailscale-oauth-apps--user-delegated-authorization-code-model.md) | The authorization-code flow on behalf of a user; the explicit OAuth-apps-versus-OAuth-clients decision contrast. |
| [web--tailscale-oauth-apps--requirements-and-limitations](../sections/web--tailscale-oauth-apps--requirements-and-limitations.md) | Preconditions and single-tailnet boundary of the OAuth-apps flow. |

## See also

- [[capability-security]] — a scope is a capability; its reachable endpoint set is the capability's surface; over-broad scopes widen the bearer's authority beyond the task.
