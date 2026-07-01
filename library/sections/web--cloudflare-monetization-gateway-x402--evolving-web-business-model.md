---
title: "The evolving business model of the web: usage-based pricing for agents"
source_kind: web
source_url: https://blog.cloudflare.com/monetization-gateway/
source_date: 2026-07-01
source_content_sha256: 58f99a22430fb8b65931f95dfe1c8f960684d059e7462a7a15f92883fa5f10a4
source_fetched_via: direct
source_authors: [Rohin Lohe, Justin Ridgely, Will Papper]
ingested: 2026-07-01
ingested_by: scholar
topics: [agent-payments]
status: current
notes: "The motivating economic argument. The x402-protocol-and-flow section covers the mechanism this argument calls for."
---

The web's 30-year economic bargain traded content for human attention, monetized through advertising, subscriptions, and e-commerce. That bargain breaks as agents become the dominant Internet users: an agent does not look at ads or hold a monthly subscription. It reads a page or consumes a feed once, takes what it needs, and moves on. AI crawlers already request content a hundred to tens of thousands of times for every visitor they send back. The post's thesis is that this demands **usage-based pricing for everything**, where the natural unit of payment for software is the **request, the token, or the outcome**, not the seat or the month. Illustrative price points from the post:

- a few cents per web search, billed per call;
- `$0.001` base fee plus `$0.01` per MB for an upload endpoint;
- `$0.99` per resolved support escalation, paid only when the work succeeds (outcome-priced).

Why this has not happened before: cloud and APIs have been sold by the call for years, but only to a **known buyer** who signs up, is issued an API key, and incurs metered billing. Content skipped payment and ran on advertising because existing payment rails could not serve **unverified buyers for sub-cent transactions**: below a certain price, collecting the payment cost more than the payment was worth. Usage-based billing was also operationally hard: a business effectively had to become a payments company, running auditable internal-usage accounting, so many chose per-seat pricing because it is simpler and often more profitable.

Agents flip the dynamic. A single agent does the work of a team around the clock, making a flat one-time fee disconnected from actual consumption; and an agent can make thousands of micropayments without friction, where asking a person to approve each would be impossibly burdensome. Usage-based price points are where agents live, and where **stablecoin micropayments** shine: stablecoins (the post names Open USD and USDC) let buyers transfer tiny sums with negligible fees, settling in under a second, which is not feasible with other rails today. There is, the post argues, enormous value moving across the Internet that goes unmonetized only because the tools to charge for it have never existed.

Source: [Announcing the Monetization Gateway](https://blog.cloudflare.com/monetization-gateway/) retrieved 2026-07-01 (content sha256 `58f99a22`).
