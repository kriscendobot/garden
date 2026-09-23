Home-automation integrations expose selected homes, rooms, labels, devices, and entities as narrow capabilities while mediating credentials, network reachability, observations, and approval-gated physical side effects.

## Sections

| Section | Topics | Abstract |
|---|---|---|
| [instance-credentials-and-reachability](../sections/cloudflare-os--packages-gatekeeper-homeassistant-readme--instance-credentials-and-reachability.md) | home-automation-integrations, capability-mediated-integrations, cloudflare-workers-agent-hosting | A Home Assistant URL and long-lived token make network reachability part of the connection contract. |
| [resource-capability-granularities](../sections/cloudflare-os--packages-gatekeeper-homeassistant-readme--resource-capability-granularities.md) | home-automation-integrations, capability-mediated-integrations, capability-security | One account is attenuated to instance, area, label, device, or entity capabilities. |
| [approval-overlay-simulation](../sections/cloudflare-os--packages-gatekeeper-homeassistant-readme--approval-overlay-simulation.md) | home-automation-integrations, capability-mediated-integrations, agent-workspaces, capability-security | Pending physical actions overlay predicted final states on later agent reads. |
| [service-call-and-validation-boundaries](../sections/cloudflare-os--packages-gatekeeper-homeassistant-readme--service-call-and-validation-boundaries.md) | home-automation-integrations, capability-mediated-integrations, errors | WebSocket service calls and synchronous validation preserve target and argument boundaries. |

## See also

- [capability-mediated-integrations](capability-mediated-integrations.md)
- [cloudflare-workers-agent-hosting](cloudflare-workers-agent-hosting.md)
