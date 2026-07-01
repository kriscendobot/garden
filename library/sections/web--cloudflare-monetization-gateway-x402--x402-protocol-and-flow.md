---
title: "A refresher on x402: paying over HTTP via the 402 status code"
source_kind: web
source_url: https://blog.cloudflare.com/monetization-gateway/
source_date: 2026-07-01
source_content_sha256: 58f99a22430fb8b65931f95dfe1c8f960684d059e7462a7a15f92883fa5f10a4
source_fetched_via: direct
source_authors: [Rohin Lohe, Justin Ridgely, Will Papper]
ingested: 2026-07-01
ingested_by: scholar
topics: [agent-payments, networking, capability-security]
status: current
notes: "The protocol mechanism. Concept pages x402-protocol and payment-as-credential draw from this section."
---

**x402** is an open protocol for paying over HTTP, named for the `402 Payment Required` status code it finally puts to use. Its lineage in the post: Content Independence Day gave site owners one-click control over which AI crawlers could reach their content, and Pay Per Crawl let them charge crawlers; the Monetization Gateway generalizes that from charging-crawlers-for-content to charging **any caller for any resource** (an API, data, or an MCP tool call) without the seller building the payment machinery.

The x402 exchange, verbatim in substance from the post:

1. A client requests a payment-gated resource.
2. Instead of serving it, the server responds with **`402 Payment Required`** and a small payload stating **the price, the accepted asset, and where to pay**.
3. The client pays and **repeats the request with proof of payment attached**.
4. A **facilitator** verifies the payment, and the server returns the resource.

It all happens inside ordinary HTTP requests and responses: **no redirect to a checkout page and no separate payment API to call**. Settlement is **peer-to-peer**: funds a buyer sends go directly to the seller's wallet. Cloudflare is designing the Gateway for low payment overhead, aiming for **sub-second settlement**. (The post references an "x402 Payment Flow: AI Agent ↔ API Server ↔ Blockchain" diagram sourced from the x402 README on GitHub.)

Two properties make x402 a good fit for machine payments:

- **Amounts can be tiny** (down to fractions of a cent) because the protocol adds almost no overhead.
- **The buyer needs no account with the seller, because the payment itself is the credential** (the "no prior relationship required" property).

x402 is **rail-agnostic** but a natural fit for stablecoins, which settle in under a second for a fraction of a cent with **zero chargebacks**.

Source: [Announcing the Monetization Gateway](https://blog.cloudflare.com/monetization-gateway/) retrieved 2026-07-01 (content sha256 `58f99a22`).
