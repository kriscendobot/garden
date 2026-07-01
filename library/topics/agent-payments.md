# agent-payments

Machine-to-machine and agent-initiated payment over open rails: the **x402** protocol (paying over HTTP by reviving the `402 Payment Required` status code), gateway-mediated **pay-per-request** monetization (charging for web pages, datasets, APIs, and **MCP tool calls**), stablecoin micropayment settlement, and the **payment-as-credential** property (an unverified buyer needs no prior account with the seller because the payment itself is the credential). This topic is the library's home for the economics and mechanics of an agent-first Internet where the request is the transaction. It is adjacent to `capability-security` (payment-as-credential and no-prior-relationship access echo capability discipline) and `networking` (the exchange lives entirely in ordinary HTTP round-trips, enforced at a proxy edge).

## Sections

| Section | Abstract |
|---------|----------|
| [monetization-gateway-x402/overview](../sections/web--cloudflare-monetization-gateway-x402--overview.md) | Cloudflare's Monetization Gateway: an edge engine to charge for any resource (page, dataset, API, MCP tool) with payment evidence moved into the request itself, settling in stablecoins over x402. |
| [monetization-gateway-x402/evolving-web-business-model](../sections/web--cloudflare-monetization-gateway-x402--evolving-web-business-model.md) | The attention-to-usage-based-pricing shift: agents pay per request/token/outcome; why sub-cent unverified-buyer payments were infeasible before stablecoin micropayments. |
| [monetization-gateway-x402/x402-protocol-and-flow](../sections/web--cloudflare-monetization-gateway-x402--x402-protocol-and-flow.md) | The x402 exchange: `402 Payment Required` carries price + asset + where-to-pay; client repeats with proof; facilitator verifies; peer-to-peer settlement; payment-as-credential; rail-agnostic. |
| [monetization-gateway-x402/gateway-rules-and-capabilities](../sections/web--cloudflare-monetization-gateway-x402--gateway-rules-and-capabilities.md) | The payment-rules API: expression-based rules, per-verb/per-route and variable pricing, 401→402 interception, Terraform-as-code, edge enforcement close to the buyer. |
| [monetization-gateway-x402/agent-identity-and-settlement-vision](../sections/web--cloudflare-monetization-gateway-x402--agent-identity-and-settlement-vision.md) | Agent wallets, verified agent identity, and identity-plus-payment settled inside a single request before the origin sees the call. |

## See also

- [capability-security](capability-security.md) — payment-as-credential and no-prior-relationship access are capability-flavored: authority travels with the request, not with an account.
- [networking](networking.md) — the x402 handshake is ordinary HTTP enforced at a proxy edge.
- [cloud-marketplace](cloud-marketplace.md) — the adjacent monetization axis (marketplace listings and metered billing for a known buyer) that x402 complements by serving the unverified sub-cent buyer.
