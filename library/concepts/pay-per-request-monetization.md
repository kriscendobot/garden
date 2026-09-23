---
id: pay-per-request-monetization
aliases: ["pay-per-request", "usage-based pricing", "per-call billing", "micropayments", "stablecoin micropayment", "per-token pricing", "outcome pricing", "pay per crawl"]
topics: [agent-payments]
---

# pay-per-request-monetization

The economic model behind x402 and the [[monetization-gateway]]: **usage-based
pricing** where the natural unit of payment for software is the **request, the
token, or the outcome**, not the seat or the month. Cloudflare's argument: as
agents become the dominant Internet users they read a resource once and move on,
so per-seat and per-month pricing disconnect from actual consumption, while an
agent can make thousands of frictionless micropayments. Sub-cent, unverified-
buyer transactions were historically infeasible because payment rails cost more
than the payment was worth and because usage-based billing forced a business to
become a payments company; **stablecoin micropayments** (Open USD, USDC) plus a
proxy that moves metering off the origin remove both obstacles. Example price
points from the source: a few cents per web search billed per call; `$0.001`
base plus `$0.01`/MB for an upload endpoint; `$0.99` per resolved support
escalation paid only on success (outcome pricing). Lineage: Cloudflare's earlier
**Pay Per Crawl** charged AI crawlers for content; pay-per-request generalizes
that to any caller and any resource, including MCP tool calls.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [monetization-gateway-x402/evolving-web-business-model](../sections/web--cloudflare-monetization-gateway-x402--evolving-web-business-model.md) | The attention-to-usage-based shift; why sub-cent unverified-buyer payments were infeasible; the three example price points. |
| [monetization-gateway-x402/overview](../sections/web--cloudflare-monetization-gateway-x402--overview.md) | "You will write a rule and agentic buyers will pay for what they use." |

## See also

- [[x402-protocol]] — the rail that makes sub-cent per-request charging feasible.
- [[monetization-gateway]] — the product that operationalizes the model.
- [[payment-as-credential]] — why the unverified buyer can transact at all.
