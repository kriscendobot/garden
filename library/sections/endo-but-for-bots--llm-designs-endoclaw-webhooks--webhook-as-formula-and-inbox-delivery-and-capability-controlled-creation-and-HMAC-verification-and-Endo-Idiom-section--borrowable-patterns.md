---
title: §Borrowable patterns
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

**Tier-1 (highest borrowing value):**

- §Webhook-as-formula — the formula IS the webhook + the formula-id IS the URL path.
- §Inbox-delivery — webhook payloads arrive as normal inbox messages; reuses `follow()` mechanism.
- §Capability-controlled-creation — host grants the authority; default is no authority.
- §HMAC-verification — secret stored in the formula; gateway verifies at the boundary.
- §Two-named-external-services-cited-by-header-name (GitHub + Stripe) — implementer knows which headers to honor.
- §WebhookEndpoint / WebhookControl two-facet caretaker pattern (fourth instance).
- §Two-shapes-of-deactivation — reversible disable on the use facet + permanent revoke on the control facet.

**Tier-2 (design-doc shape patterns):**

- §Short-design-doc-as-named-shape with five-sections-only.
- §Depends-On-bullet-list-as-distinct-from-Dependencies-table — lighter weight for two-or-three deps.
- §Five-section design as named shape (Summary + Capability Shape + How It Works + Endo Idiom + Depends On).
- §Endo-Idiom-section as recurring design-doc shape with N-named-disciplines.

**Tier-3 (named comparisons):**

- §The-cluster-grows-with-different-design-sizes (244 long + 246 short).
- §Two-different-shapes-of-dependency-record (Dependencies-table + Depends-On-bullet-list).
- §Three-cycles-with-mail-system-as-the-event-substrate (232 + 244 + 246).
- §Ten-cycles-on-no-new-abstractions discipline (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244 + 246).
