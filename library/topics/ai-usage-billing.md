Metering, quota, credit, and authority-routing designs for funding AI inference, including platform allowances and user-owned provider billing without custody of user funds or credentials.

## Sections

| Section | Topics | Abstract |
|---|---|---|
| [daily allowance and credit routing](../sections/cloudflare-os--docs-ai-gateway-billing--daily-allowance-and-credit-routing.md) | ai-usage-billing, agent-workspaces, capability-mediated-integrations | Per-turn routing chooses user credits or daily platform allowance. |
| [Cloudflare Gatekeeper billing connection](../sections/cloudflare-os--docs-ai-gateway-billing--cloudflare-gatekeeper-billing-connection.md) | ai-usage-billing, authentication-gatekeepers, capability-mediated-integrations | The Cloudflare Gatekeeper supplies OAuth authority for billing. |
| [AI Gateway transport configuration](../sections/cloudflare-os--docs-ai-gateway-billing--gateway-transport-configuration.md) | ai-usage-billing, cloudflare-workers-agent-hosting | Gateway requests choose a binding or token-authenticated HTTPS. |
| [billing state and code layout](../sections/cloudflare-os--docs-ai-gateway-billing--billing-state-and-code-layout.md) | ai-usage-billing, cloudflare-workers-agent-hosting | Quota and lightweight billing state live with each user. |
| [public multi-user deployment](../sections/cloudflare-os--docs-public-server--public-multi-user-deployment.md) | agent-workspaces, authentication-gatekeepers, ai-usage-billing, cloudflare-workers-agent-hosting | The public recipe composes daily allowance and user-funded credits. |
| [Service roles and resource boundaries](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--service-roles-and-resource-boundaries.md) | capability-mediated-integrations, authentication-gatekeepers, ai-usage-billing, worker-observability | The Cloudflare Gatekeeper composes sign-in, billing authority, and Workers telemetry over one provider connection. |

## See also

- [agent-payments](agent-payments.md)
- [coding-agent-economics](coding-agent-economics.md)
- [capability-mediated-integrations](capability-mediated-integrations.md)
