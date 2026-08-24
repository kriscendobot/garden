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

## See also

- [[cloudflare-os-gadget]]
- [[principle-of-least-authority]]
