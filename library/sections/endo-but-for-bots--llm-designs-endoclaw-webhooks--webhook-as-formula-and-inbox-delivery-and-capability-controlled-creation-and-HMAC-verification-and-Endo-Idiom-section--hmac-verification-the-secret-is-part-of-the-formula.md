---
title: §HMAC verification — the secret is part of the formula
source-slug: endo-but-for-bots--llm-designs-endoclaw-webhooks
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-webhooks.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-webhooks.md
total-lines: 79
ingest-cycle: 246
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-webhooks--webhook-as-formula-and-inbox-delivery-and-capability-controlled-creation-and-HMAC-verification-and-Endo-Idiom-section
---

§The-Endo-Idiom-section's-fourth-discipline: §HMAC-verification. *The webhook stores a secret that external services use for payload signing (GitHub `X-Hub-Signature-256`, Stripe `Stripe-Signature`). The gateway verifies signatures before delivery, preventing spoofed events.*

§The-secret-IS-part-of-the-formula-state + §the-gateway-verifies-before-delivery + §the-agent-never-sees-an-unsigned-payload-from-an-external-source (when HMAC is configured). §When-an-external-service-can-sign-payloads, §store-the-shared-secret-in-the-formula + §verify-at-the-gateway-boundary-not-at-the-agent. §The-verification-IS-the-gateway's-responsibility-not-the-agent's.

§Two-named-external-services-cited-by-header-name (GitHub `X-Hub-Signature-256` + Stripe `Stripe-Signature`). §When-a-design-implements-a-protocol-shape-used-by-known-services, §cite-the-services-by-name-and-their-header-by-string + §the-implementer-knows-which-headers-to-honor-without-guessing.

§Sibling-to-cycle-234's-OAuth's-the-agent-never-sees-the-token — §two-cycles-with-the-secret-stays-at-the-gateway-or-control-facet-and-the-agent-uses-the-authenticated-channel-without-handling-the-credential.
