Worker observability covers structured logging, ambient diagnostic context, bounded private error reporting, and capability-confined access to Cloudflare Workers telemetry without leaking foreign services or caller data.

## Sections

| Section | Topics | Abstract |
|---|---|---|
| [Worker observability utilities](../sections/cloudflare-os--packages-backend-utils-readme--worker-observability-utilities.md) | cloudflare-workers-agent-hosting, worker-observability, errors | Cloudflare OS's backend utility package separates ordinary structured logging from optional ambient context and bounded private error reporting. |
| [Service roles and resource boundaries](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--service-roles-and-resource-boundaries.md) | capability-mediated-integrations, authentication-gatekeepers, ai-usage-billing, worker-observability | The Cloudflare Gatekeeper composes sign-in, billing authority, and Workers telemetry over one provider connection. |
| [Collaborator observer verification](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--collaborator-observer-verification.md) | collaborative-workspace-sharing, capability-mediated-integrations, worker-observability, capability-security | Every collaborator must prove through their own account that they can read the bound telemetry resource. |
| [Defensive Worker query confinement](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--defensive-worker-query-confinement.md) | worker-observability, capability-mediated-integrations, capability-security | Worker-scoped telemetry queries enforce confinement before and after the provider call. |
| [Safe telemetry discovery](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--safe-telemetry-discovery.md) | worker-observability, capability-mediated-integrations, capability-security | Filtered event samples replace provider discovery endpoints that ignore resource filters. |
| [Telemetry field-name normalization](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--telemetry-field-name-normalization.md) | worker-observability | Query keys are normalized across result paths and provider index names. |
| [Provider error data minimization](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--provider-error-data-minimization.md) | worker-observability, errors, capability-security | Provider error text stays out of logs because it can reflect caller-controlled filter values. |
| [Paginated account discovery](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--paginated-account-discovery.md) | capability-mediated-integrations, worker-observability | Account discovery walks every provider page before applying client-side substring matching. |

## See also

- [cloudflare-workers-agent-hosting](cloudflare-workers-agent-hosting.md)
- [capability-mediated-integrations](capability-mediated-integrations.md)
- [errors](errors.md)
