Authentication Gatekeepers reuse capability-mediating service Workers as federated sign-in providers, separating transient identity-only OAuth grants from explicitly connected full-capability accounts.

## Sections

| Section | Topics | Abstract |
|---|---|---|
| [verified-email identity and incremental OAuth scopes](../sections/cloudflare-os--docs-oauth-signin--verified-email-identity-and-incremental-scopes.md) | authentication-gatekeepers, identity, capability-mediated-integrations, oauth-credentials | Login uses verified email and transient identity-only scopes. |
| [capability-shaped sign-in flow](../sections/cloudflare-os--docs-oauth-signin--capability-shaped-sign-in-flow.md) | authentication-gatekeepers, identity, capability-mediated-integrations | A PendingLogin capability represents the in-flight OAuth attempt. |
| [deployment configuration and lockout guard](../sections/cloudflare-os--docs-oauth-signin--deployment-configuration-and-lockout-guard.md) | authentication-gatekeepers, cloudflare-workers-agent-hosting | A nonempty provider allowlist gates password-only disablement. |
| [PendingLogin storage and authentication code layout](../sections/cloudflare-os--docs-oauth-signin--pending-login-storage-and-code-layout.md) | authentication-gatekeepers, cloudflare-workers-agent-hosting | A waiting RPC keeps the ephemeral PendingLogin object alive. |
| [Cloudflare Gatekeeper billing connection](../sections/cloudflare-os--docs-ai-gateway-billing--cloudflare-gatekeeper-billing-connection.md) | ai-usage-billing, authentication-gatekeepers, capability-mediated-integrations | Login and full billing connection remain distinct grants. |
| [public multi-user deployment](../sections/cloudflare-os--docs-public-server--public-multi-user-deployment.md) | agent-workspaces, authentication-gatekeepers, ai-usage-billing, cloudflare-workers-agent-hosting | Google, GitHub, and Cloudflare Gatekeepers can provide login. |
| [Service roles and resource boundaries](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--service-roles-and-resource-boundaries.md) | capability-mediated-integrations, authentication-gatekeepers, ai-usage-billing, worker-observability | The Cloudflare Gatekeeper composes sign-in, billing authority, and Workers telemetry over one provider connection. |
| [OAuth configuration and verification](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--oauth-configuration-and-verification.md) | authentication-gatekeepers, oauth-credentials, cloudflare-workers-agent-hosting | Cloudflare OAuth setup separates exact callback, credential, sign-in, billing, and observability configuration. |
| [identity grant versus resource grant](../sections/cloudflare-os--packages-gatekeeper-github-readme--identity-grant-versus-resource-grant.md) | authentication-gatekeepers, identity, capability-mediated-integrations, oauth-credentials | GitHub login discards a minimal verified-email grant before any repository connection. |
| [OAuth App permission model](../sections/cloudflare-os--packages-gatekeeper-github-readme--oauth-app-permission-model.md) | authentication-gatekeepers, oauth-credentials, capability-security | OAuth Apps honor request scopes while GitHub Apps fix permissions globally. |
| [verified-email login and resource scopes](../sections/cloudflare-os--packages-gatekeeper-google-readme--verified-email-login-and-resource-scopes.md) | authentication-gatekeepers, identity, capability-mediated-integrations, oauth-credentials | Google login discards identity scopes while connections add only selected API scopes. |
| [Workshop build-time authentication modes](../sections/cloudflare-os--packages-workshop-frontend-readme--build-time-authentication-modes.md) | authentication-gatekeepers, cloudflare-workers-agent-hosting | A build flag selects password login or Cloudflare Access identity. |

## See also

- [capability-mediated-integrations](capability-mediated-integrations.md)
- [identity](identity.md)
- [oauth-credentials](oauth-credentials.md)
