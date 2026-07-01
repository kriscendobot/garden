---
title: "Announcing the Monetization Gateway: charge for any resource behind Cloudflare via x402"
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
notes: "Announcement / waitlist post. Companion sections cover the business-model argument, the x402 protocol flow, the gateway rules API, and the agent-identity settlement vision."
---

Cloudflare's Monetization Gateway is an announced (waitlist-stage, 2026-07-01) edge engine that lets a Cloudflare customer charge for any asset behind Cloudflare: a web page, a dataset, an API, or an **MCP tool call**. It gives one control plane for payment policies and access control across a customer's applications, and it protects the origin from high payment volumes by doing payment verification and enforcement **at the edge** rather than on the origin. At launch, payments settle in **stablecoins over x402**, the open payment-over-HTTP protocol Cloudflare is building with a coalition of 25+ industry leaders via the x402 Foundation. The seller writes a rule; agentic buyers pay for what they use; the metering, the payment exchange, and the settlement move off the seller's origin, leaving the seller only its rules, its prices, and its revenue. No buyer onboarding, no API key issuance, and no separate billing system are required.

The core reframing: with a proxy layer sitting between buyer and seller, **the evidence of payment moves into the request itself**, so the payment-validation path and the request path merge into one HTTP round-trip. This is the same "charge the software that uses your content" shift behind paying creators when an answer engine uses their work, but generalized from crawlers-and-content to any-caller-and-any-resource.

Source: [Announcing the Monetization Gateway](https://blog.cloudflare.com/monetization-gateway/) retrieved 2026-07-01 (content sha256 `58f99a22`).
