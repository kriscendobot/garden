---
title: §Capability-controlled creation — host grants the authority
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

§The-Endo-Idiom-section's-third-discipline: §Capability-controlled-creation. *Not every agent can create webhooks. The host grants webhook creation authority. An agent without this authority cannot expose endpoints on the gateway.*

§The-host-is-the-gatekeeper-for-webhook-creation + §the-agent-cannot-self-grant-the-authority + §the-default-is-no-authority. §When-a-capability-could-be-self-granted-by-an-agent, §design-the-default-as-no-authority + §the-host-grants-the-capability-explicitly + §the-grant-IS-the-authorization.

§Four-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246). §Cycle-234's-the-agent-never-sees-the-token; §cycle-238's-the-controller-cap-the-host-retains; §cycle-244's-no-ambient-scheduling; §cycle-246's-capability-controlled-creation-for-webhooks.
