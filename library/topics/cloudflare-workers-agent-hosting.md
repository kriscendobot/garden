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
| [Git object store and commit model](../sections/cloudflare-os--plans-git-storage--git-object-store-and-commit-model.md) | Cloudflare OS plans/git-storage.md | Gadget code moves from workspace-wide Yjs mainline into real Git commits stored as loose objects in each Overseer Durable Object. |
| [Revision epochs, stragglers, and materialization](../sections/cloudflare-os--plans-git-storage--revision-epochs-stragglers-and-materialization.md) | Cloudflare OS plans/git-storage.md | Revision windows materialize compactly while eligible in-flight changes bridge merge boundaries against recorded commits. |
| [Migration decisions and provider routing](../sections/cloudflare-os--plans-pi-impl--migration-decisions-and-provider-routing.md) | Cloudflare OS plans/pi-impl.md | The pi migration fixes low-level loop selection, provider endpoints, credentials, and compatibility bounds. |
| [Structured observability and error reporting](../sections/cloudflare-os--agents--structured-observability-and-error-reporting.md) | Cloudflare OS AGENTS.md | Typed structured logs and bounded reports share a no-secrets contract across server and browser paths. |
| [Pull-request CI and preview boundary](../sections/cloudflare-os--contributing--pull-request-ci-and-preview-boundary.md) | Cloudflare OS CONTRIBUTING.md | Fork pull requests receive normal CI but not token-authorized Cloudflare previews. |
| [Secret-safe logging and reporting review](../sections/cloudflare-os--review--secret-safe-logging-and-reporting-review.md) | Cloudflare OS REVIEW.md | Logs, exceptions, reports, and locations must not disclose secrets or bearer capabilities. |
| [Worker observability utilities](../sections/cloudflare-os--packages-backend-utils-readme--worker-observability-utilities.md) | cloudflare-workers-agent-hosting, worker-observability, errors | Cloudflare OS's backend utility package separates ordinary structured logging from optional ambient context and bounded private error reporting. |
| [OAuth configuration and verification](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--oauth-configuration-and-verification.md) | authentication-gatekeepers, oauth-credentials, cloudflare-workers-agent-hosting | Cloudflare OAuth setup separates exact callback, credential, sign-in, billing, and observability configuration. |
| [Confluence credential and deployment configuration](../sections/cloudflare-os--packages-gatekeeper-confluence-readme--credential-and-deployment-configuration.md) | oauth-credentials, cloudflare-workers-agent-hosting | Data-connector credentials remain separate from Cloudflare OS sign-in configuration. |
| [OAuth connect and refresh flow](../sections/cloudflare-os--packages-gatekeeper-confluence-readme--oauth-connect-and-refresh-flow.md) | capability-mediated-integrations, oauth-credentials, cloudflare-workers-agent-hosting | A Durable Object preserves rotating credentials and accessible-site identity through the connect flow. |

## See also

- [agent-workspaces](agent-workspaces.md)
- [sandbox-platforms](sandbox-platforms.md)
- [persistence](persistence.md)
