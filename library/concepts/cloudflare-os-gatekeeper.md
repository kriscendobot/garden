---
id: cloudflare-os-gatekeeper
aliases: [Gatekeeper, Cloudflare OS Gatekeeper, deferred approval]
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

## See also

- [[cloudflare-os-gadget]]
- [[principle-of-least-authority]]
