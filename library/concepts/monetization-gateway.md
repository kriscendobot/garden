---
id: monetization-gateway
aliases: ["Monetization Gateway", "Cloudflare Monetization Gateway", "pay-per-request gateway", "payment gateway edge", "MCP tool monetization", "monetize MCP server"]
topics: [agent-payments, networking]
---

# monetization-gateway

Cloudflare's **Monetization Gateway** (announced 2026-07-01, waitlist stage) is
a proxy-edge engine that charges callers for any asset behind Cloudflare: a web
page, a dataset, an API, or an **MCP tool call**. Because Cloudflare already
proxies the traffic, it merges the payment-validation path into the request path
so the **evidence of payment moves into the request itself** (an x402 exchange,
see [[x402-protocol]]) and the metering, payment exchange, and settlement move
**off the seller's origin**. Sellers express **payment rules** as expressions
(like other Cloudflare rules) in a dedicated product API, manageable via
dashboard, API, or Terraform-as-code; planned rule kinds include per-route /
per-verb pricing (`$0.01` per GET to `/api/premium/*`), variable pricing (up to
`$2` per image generation), and intercepting an origin `401 Unauthorized` to
return `402 Payment Required` with pricing. Enforcement runs across 330+ edge
cities so the x402 handshake occurs near the buyer, cutting latency and shielding
the origin. Payments settle in stablecoins the seller can spend or redeem for
fiat. The pattern that makes it notable for the garden: a **gateway mediating
pay-per-call to weblets / MCP tools** with no buyer onboarding
([[payment-as-credential]]).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [monetization-gateway-x402/overview](../sections/web--cloudflare-monetization-gateway-x402--overview.md) | What the Gateway is: one control plane, edge-enforced, MCP-tool monetization, settlement off the origin. |
| [monetization-gateway-x402/gateway-rules-and-capabilities](../sections/web--cloudflare-monetization-gateway-x402--gateway-rules-and-capabilities.md) | The payment-rules API, expression syntax, the three planned rule kinds, Terraform-as-code, and edge enforcement. |
| [monetization-gateway-x402/agent-identity-and-settlement-vision](../sections/web--cloudflare-monetization-gateway-x402--agent-identity-and-settlement-vision.md) | Verifying agent, applying rule, and checking payment inside one request before the origin sees the call. |

## See also

- [[x402-protocol]] — the settlement rail the Gateway enforces.
- [[payment-as-credential]] — why a caller needs no account to pay.
- [[pay-per-request-monetization]] — the economic model the Gateway operationalizes.
