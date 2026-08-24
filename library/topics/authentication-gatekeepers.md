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

## See also

- [capability-mediated-integrations](capability-mediated-integrations.md)
- [identity](identity.md)
- [oauth-credentials](oauth-credentials.md)
