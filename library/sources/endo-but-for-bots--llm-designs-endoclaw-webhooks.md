---
title: "endoclaw-webhooks — Webhook gateway routing HTTP requests to agent inboxes as messages"
source-slug: endo-but-for-bots--llm-designs-endoclaw-webhooks
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-webhooks.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-webhooks.md
total-lines: 79
status: Not Started (2026-03-03)
ingest-cycle: 246
ingest-date: 2026-06-08
lane: designs
---

# endoclaw-webhooks.md

A 79-line **Not Started** design for a webhook gateway that routes incoming HTTP requests to agent inboxes as messages. Parent: endoclaw. Among the shortest design docs ingested.

## Key design moves

- **§Webhook-as-formula** — formula IS the webhook + formula-id IS the URL path.
- **§Inbox-delivery** — webhook payloads arrive as normal inbox messages, processed by the agent's existing `follow()` mechanism.
- **§Capability-controlled-creation** — host grants webhook-creation authority; default is no authority.
- **§HMAC-verification** — secret stored in the formula; gateway verifies at the boundary.
- **§Two named external services cited by header name** (GitHub `X-Hub-Signature-256` + Stripe `Stripe-Signature`).
- **§WebhookEndpoint / WebhookControl** two-facet caretaker pattern (fourth instance).
- **§Two shapes of deactivation** — reversible disable on the use facet + permanent revoke on the control facet.
- **§Short design-doc as named shape** with five sections only (Summary + Capability Shape + How It Works + Endo Idiom + Depends On).
- **§Depends-On bullet-list as distinct from Dependencies-table** — lighter weight for two-or-three deps.
- **§Endo Idiom section** as recurring design-doc shape with N named disciplines.

## Section files

- [§webhook-as-formula + §inbox-delivery + §capability-controlled-creation + §HMAC-verification + §Endo-Idiom-section](../sections/endo-but-for-bots--llm-designs-endoclaw-webhooks--webhook-as-formula-and-inbox-delivery-and-capability-controlled-creation-and-HMAC-verification-and-Endo-Idiom-section.md) — full 79-line design ingest.

## Ingest scope

Cycle 246 (designs-lane): full 79-line ingest. §First-explicit-observation of three patterns: §two-shapes-of-deactivation (reversible-disable + permanent-revoke) + §short-design-doc-as-named-shape with five-sections-only + §Depends-On-bullet-list-as-distinct-from-Dependencies-table.
