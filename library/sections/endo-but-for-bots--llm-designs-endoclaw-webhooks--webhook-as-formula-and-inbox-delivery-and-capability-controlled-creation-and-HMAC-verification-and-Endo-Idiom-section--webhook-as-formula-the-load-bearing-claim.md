---
title: §Webhook as formula — the load-bearing claim
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

§The-Endo-Idiom-section opens with §Webhooks-are-formulas. *Each webhook endpoint is a durable formula in the daemon store. It survives restarts and has a stable URL. The agent holds it via pet name in its directory.*

§The-formula-IS-the-webhook + §the-formula-id-IS-the-URL-path (`POST /webhooks/<formula-id>`). §When-a-webhook-needs-a-stable-URL-that-survives-restarts, §the-formula-IS-the-stable-handle + §the-formula-id-IS-the-URL-component. §The-URL-stability-is-derived-from-the-formula-id-not-arranged-separately.

§Sibling-pattern-to-cycle-238's-the-controller-IS-the-pet-name-handle — §two-cycles-with-the-formula-or-pet-name-IS-the-stable-identifier. §Cycle-238's-controller-pet-name-survives-CLI-invocations; §cycle-246's-formula-id-survives-daemon-restarts + §IS-the-URL-path. §Two-different-substrates-for-stable-naming.

§Sibling-to-cycle-244's-IntervalScheduler-pet-name (named SCHEDULER in agent's pet store) — §three-cycles-with-stable-cap-handles-via-pet-name (238 + 244 + 246).
