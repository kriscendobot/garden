---
title: §Inbox delivery — no new abstractions for webhook handling
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

§The-Endo-Idiom-section's-second-discipline: §Inbox-delivery. *Webhook payloads arrive as normal inbox messages. The agent processes them with the same `follow()` mechanism it uses for human messages. No special webhook handler API — just messaging.*

§Reuse-the-mail-system-not-build-a-parallel-delivery-mechanism. §The-payload-IS-a-`package`-message + §the-body-IS-the-message-text + §the-headers-ARE-the-metadata. §The-agent-doesn't-distinguish-webhook-from-human-message — §both-flow-through-the-same-follow()-mechanism.

§Ten-cycles-on-no-new-abstractions discipline now (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244 + 246). §Sibling-to-cycle-244's-tick-events-as-messages-not-iterator-values (same mail-system reuse pattern); §three-cycles-with-mail-system-as-the-event-substrate (cycle 232 channel-bridges-as-inbox-messages + cycle 244 tick-events-as-messages + cycle 246 webhook-payloads-as-inbox-messages).

§When-an-event-stream-could-arrive-via-a-new-API-or-via-the-existing-mail-system, §reuse-the-mail-system + §the-agent's-existing-message-loop-handles-the-new-event-type + §no-new-handler-API. §Three-cycles-with-this-mail-system-reuse-discipline.
