---
id: cloudflare-os-gatekeeper
aliases: [Gatekeeper, Cloudflare OS Gatekeeper, deferred approval, Email Gatekeeper, Home Assistant Gatekeeper, Spotify Gatekeeper, Supabase Gatekeeper, ZoomInfo Gatekeeper, LLAT]
topics: [capability-mediated-integrations, capability-security]
---

# Cloudflare OS Gatekeeper

A Gatekeeper is a service-specific Worker that gives an agent or gadget a narrow Cap'n Web capability to an external resource, handles credentials, records actions, and can simulate side effects until a person approves or rejects them.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Gatekeepers and deferred human approval](../sections/cloudflare-os--readme--gatekeepers-and-deferred-approval.md) | Defines service mediation, logging, simulation, and deferred approval. |
| [capability-based introductions](../sections/cloudflare-os--readme--capability-based-introductions.md) | Places Gatekeepers behind explicit resource introductions. |
| [binding requirements and annotations](../sections/cloudflare-os--docs-blueprints--binding-requirements.md) | Captures the shape of a Gatekeeper connection without credentials. |
| [collaborator resource isolation](../sections/cloudflare-os--docs-sharing--collaborator-resource-isolation.md) | Connects Gatekeeper bindings through the collaborator who creates them. |
| [Service roles and resource boundaries](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--service-roles-and-resource-boundaries.md) | Composes sign-in, billing, and telemetry capabilities over one provider. |
| [Defensive Worker query confinement](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--defensive-worker-query-confinement.md) | Enforces a Worker telemetry resource boundary around unreliable provider filtering. |
| [Confluence resource capability hierarchy](../sections/cloudflare-os--packages-gatekeeper-confluence-readme--resource-capability-hierarchy.md) | Attenuates an Atlassian account grant to site, space, or content resources. |
| [Deferred actions and simulation](../sections/cloudflare-os--packages-gatekeeper-confluence-readme--deferred-actions-and-simulation.md) | Defers Confluence side effects while simulating their results for the agent. |
| [mailbox capability and delivery path](../sections/cloudflare-os--packages-gatekeeper-email-readme--mailbox-capability-and-delivery-path.md) | Implements inbound email as a per-mailbox Durable Object and gadget hook. |
| [identity grant versus resource grant](../sections/cloudflare-os--packages-gatekeeper-github-readme--identity-grant-versus-resource-grant.md) | Separates GitHub authentication authority from explicitly connected repository authority. |
| [verified-email login and resource scopes](../sections/cloudflare-os--packages-gatekeeper-google-readme--verified-email-login-and-resource-scopes.md) | Separates Google identity authority from resource-specific API grants. |
| [resource capability granularities](../sections/cloudflare-os--packages-gatekeeper-homeassistant-readme--resource-capability-granularities.md) | Attenuates a Home Assistant account to instance, area, label, device, or entity access. |
| [Bring-your-own MCP server connector](../sections/cloudflare-os--packages-gatekeeper-mcp-readme--bring-your-own-server-connector.md) | Connects any user-supplied MCP server as a capability with generated typed tool methods. |
| [MCP portal connector and per-server grants](../sections/cloudflare-os--packages-gatekeeper-mcp-portal-readme--portal-server-connector.md) | Connects an administrator-configured MCP portal, granting one upstream server at a time. |
| [Notion workspace, page, and database resources](../sections/cloudflare-os--packages-gatekeeper-notion-readme--workspace-page-and-database-resources.md) | Mediates OAuth access to a user's Notion pages and databases at workspace or per-page grain. |
| [Slack read-only mediation and user-token scopes](../sections/cloudflare-os--packages-gatekeeper-slack-readme--read-only-user-token-auth.md) | Read-only Slack access through a user token so the agent sees only what the user can. |
| [Scheduled task registration API](../sections/cloudflare-os--packages-gatekeeper-scheduler-readme--scheduled-task-registration-api.md) | An ambient Gatekeeper registering persistent scheduled callbacks as disabled hooks. |
| [Spotify account and playlist resource granularities](../sections/cloudflare-os--packages-gatekeeper-spotify-readme--resource-granularities.md) | Attenuates Spotify authority to one account or one playlist. |
| [Spotify approval simulation and provider limits](../sections/cloudflare-os--packages-gatekeeper-spotify-readme--approval-simulation-and-provider-limits.md) | Simulates pending library edits while preserving real playback state. |
| [Supabase project and organization resource grants](../sections/cloudflare-os--packages-gatekeeper-supabase-readme--project-and-organization-resource-grants.md) | Prefers one Supabase project capability over organization-wide access. |
| [Supabase OAuth and approval boundary](../sections/cloudflare-os--packages-gatekeeper-supabase-readme--oauth-and-approval-boundary.md) | Approval-gates arbitrary SQL without pretending pending mutations are readable. |
| [ZoomInfo account search and enrichment capability](../sections/cloudflare-os--packages-gatekeeper-zoominfo-readme--account-search-and-enrichment-capability.md) | Exposes one entitlement-scoped account for search, enrichment, Copilot, and usage. |
| [ZoomInfo credit approval and query guards](../sections/cloudflare-os--packages-gatekeeper-zoominfo-readme--credit-approval-and-query-guards.md) | Defers credit-bearing enrichment and rejects silently broadened queries. |
| [Observer tracking strategy per binding granularity](../sections/cloudflare-os--packages-gatekeeper-supabase-src-supabase--observer-tracking-strategy.md) | A concrete gatekeeper's observer methods pick ACL-check versus data-set-tracking from binding granularity. |
| [Verifier answers access against the observer's own token](../sections/cloudflare-os--packages-gatekeeper-supabase-src-supabase--own-token-verifier.md) | A gatekeeper mints a verifier the overseer hands back to it, trusting its booleans against the observer's token. |
| [Account authentication and resource authority](../sections/cloudflare-os--packages-workshop-shared-src-gatekeeper--account-authentication-and-resource-authority.md) | Separates vendor discovery, privileged account authority, transient identity, and narrowed resource grants. |
| [Observer verification across past and future reads](../sections/cloudflare-os--packages-workshop-shared-src-gatekeeper--observer-verification-contract.md) | Defines the opaque verifier handoff, historical admission check, re-verification, and forward exclusion duty. |
| [Approval, simulation, rejection, and revert](../sections/cloudflare-os--packages-workshop-shared-src-gatekeeper--approval-and-revert-contract.md) | Defines mandatory asynchronous submission, optional provisional simulation, rejection cleanup, and best-effort undo. |
| [Persistent hook binding and fresh-session delivery](../sections/cloudflare-os--packages-workshop-shared-src-gatekeeper--persistent-hook-lifecycle.md) | Stores persistent callbacks under the Overseer and refreshes session authority for each event. |
| [Sensitive observation confinement](../sections/cloudflare-os--packages-workshop-shared-src-gatekeeper--sensitive-observation-confinement.md) | Blocks disclosure until authorized and supports owner-only lockdown or per-observer exclusion. |

## See also

- [[cloudflare-os-gadget]]
- [[principle-of-least-authority]]
