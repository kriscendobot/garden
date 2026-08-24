---
id: ai-gateway-credit-routing
aliases: [AI Gateway billing, AI Gateway credits, daily LLM allowance, BYOK routing, CF_AI_GATEWAY]
topics: [ai-usage-billing, agent-workspaces, capability-mediated-integrations]
---

# AI Gateway credit routing

Cloudflare OS's per-turn choice between a daily platform-funded allowance and the user's own Cloudflare AI Gateway credits, with OAuth authority confined to the Cloudflare Gatekeeper and no platform custody of funds.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [daily allowance and credit routing](../sections/cloudflare-os--docs-ai-gateway-billing--daily-allowance-and-credit-routing.md) | Selects user credits or the platform-funded daily allowance per turn. |
| [Cloudflare Gatekeeper billing connection](../sections/cloudflare-os--docs-ai-gateway-billing--cloudflare-gatekeeper-billing-connection.md) | Sources user billing authority from the Cloudflare Gatekeeper. |
| [AI Gateway transport configuration](../sections/cloudflare-os--docs-ai-gateway-billing--gateway-transport-configuration.md) | Routes in-account through a binding and cross-account through HTTPS. |
| [public multi-user deployment](../sections/cloudflare-os--docs-public-server--public-multi-user-deployment.md) | Shows the complete public-deployment composition. |

## See also

- [[cloudflare-os-gatekeeper]]
- [[monetization-gateway]]
