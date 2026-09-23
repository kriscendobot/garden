---
id: provisional-action-simulation
aliases: [provisional action simulation, deferred side-effect simulation, pending action overlay]
topics: [capability-mediated-integrations, agent-workspaces, capability-security]
---

# Provisional action simulation

Provisional action simulation records a side effect for later human approval while immediately overlaying its predicted result on subsequent reads, allowing an agent to continue coherent multi-step work without prematurely mutating the external service.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Deferred actions and simulation](../sections/cloudflare-os--packages-gatekeeper-confluence-readme--deferred-actions-and-simulation.md) | Overlays pending Confluence writes until approval, rejection, or reversion. |
| [approval overlay simulation](../sections/cloudflare-os--packages-gatekeeper-homeassistant-readme--approval-overlay-simulation.md) | Predicts final Home Assistant states while physical changes await approval. |

## See also

- [[cloudflare-os-gatekeeper]]
