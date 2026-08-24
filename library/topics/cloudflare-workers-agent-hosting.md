Hosting agent workspaces and generated applications on Cloudflare Workers primitives, especially Durable Objects, Dynamic Workers, Facets, Workers KV, R2, bindings, and the open-source `workerd` runtime.

## Sections

| Section | Topics | Abstract |
|---|---|---|
| [Workers runtime architecture](../sections/cloudflare-os--readme--workers-runtime-architecture.md) | cloudflare-workers-agent-hosting, agent-workspaces, sandbox-platforms | Durable Objects, Dynamic Workers, Facets, and bindings host the workspace and its applications. |
| [Blueprint storage and publication](../sections/cloudflare-os--docs-blueprints--storage-and-publication.md) | reusable-app-blueprints, cloudflare-workers-agent-hosting, persistence | Blueprint metadata propagates through Durable Objects and KV while code snapshots live in R2. |
| [authorization and live-session termination](../sections/cloudflare-os--docs-sharing--authorization-and-session-termination.md) | collaborative-workspace-sharing, capability-security, cloudflare-workers-agent-hosting | Durable Object restart forces open clients to reauthorize after access changes. |
| [real Worker integration-test harness](../sections/cloudflare-os--docs-integration-testing--real-worker-harness.md) | testing, cloudflare-workers-agent-hosting | The harness exercises the production Worker and WebSocket boundaries. |
| [cross-process time and fixture control](../sections/cloudflare-os--docs-integration-testing--cross-process-time-and-fixture-control.md) | testing, cloudflare-workers-agent-hosting | A protocol-real fixture Worker supplies deterministic observer outcomes. |
| [persistent harness storage isolation](../sections/cloudflare-os--docs-integration-testing--persistent-harness-storage-isolation.md) | testing, cloudflare-workers-agent-hosting | Server reset is teardown rather than a cheap storage wipe. |
| [Wrangler and workerd version coupling](../sections/cloudflare-os--docs-integration-testing--wrangler-workerd-version-coupling.md) | testing, cloudflare-workers-agent-hosting, node-packaging | Runtime compatibility dates expose mismatched tooling versions. |
| [Worker entry-module export discipline](../sections/cloudflare-os--docs-integration-testing--worker-entry-module-export-discipline.md) | testing, cloudflare-workers-agent-hosting | Workerd treats every named runtime export as an entrypoint. |
| [deployment configuration and lockout guard](../sections/cloudflare-os--docs-oauth-signin--deployment-configuration-and-lockout-guard.md) | authentication-gatekeepers, cloudflare-workers-agent-hosting | OAuth credentials stay on their Gatekeeper Workers. |
| [PendingLogin storage and authentication code layout](../sections/cloudflare-os--docs-oauth-signin--pending-login-storage-and-code-layout.md) | authentication-gatekeepers, cloudflare-workers-agent-hosting | PendingLogin needs no durable storage or explicit binding. |
| [AI Gateway transport configuration](../sections/cloudflare-os--docs-ai-gateway-billing--gateway-transport-configuration.md) | ai-usage-billing, cloudflare-workers-agent-hosting | Cross-account Gateways require explicit binding opt-out. |
| [billing state and code layout](../sections/cloudflare-os--docs-ai-gateway-billing--billing-state-and-code-layout.md) | ai-usage-billing, cloudflare-workers-agent-hosting | Tokens remain in Gatekeeper storage while backend services route usage. |
| [public multi-user deployment](../sections/cloudflare-os--docs-public-server--public-multi-user-deployment.md) | agent-workspaces, authentication-gatekeepers, ai-usage-billing, cloudflare-workers-agent-hosting | Local and deployed Gateway transports use Workers bindings deliberately. |

## See also

- [agent-workspaces](agent-workspaces.md)
- [sandbox-platforms](sandbox-platforms.md)
- [persistence](persistence.md)
