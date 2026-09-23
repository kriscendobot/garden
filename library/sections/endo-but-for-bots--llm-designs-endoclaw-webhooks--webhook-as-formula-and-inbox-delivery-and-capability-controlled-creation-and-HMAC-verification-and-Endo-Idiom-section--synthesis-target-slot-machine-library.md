---
title: §Synthesis target — slot machine library
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

For a slot machine library:

- §Game-event-as-formula — each external event subscription is a durable formula with stable URL/identifier.
- §Inbox-delivery for §game-event-payloads-arrive-as-normal-game-messages.
- §Capability-controlled-creation — host grants the game-event-creation authority; default is no authority.
- §HMAC-verification for §external-payment-events-signed-by-payment-processor.
- §Two-named-external-services-cited-by-header-name for §game-payment-integration-with-Stripe-or-similar-header-conventions.
- §WebhookEndpoint / WebhookControl pattern for §game-event-endpoint-vs-game-event-control.
- §Two-shapes-of-deactivation — §reversible-disable for game-pause + §permanent-revoke for game-deletion.
- §Short-design-doc-as-named-shape for §game-feature-spec-extending-existing-cluster.
- §Depends-On-bullet-list-as-distinct-from-Dependencies-table for §lightweight-game-feature-spec.
- §Five-section design as named shape for §game-feature-doc-template.
- §Endo-Idiom-section as recurring design-doc shape for §game-design-doc's-vocabulary-applied-to-this-feature.
