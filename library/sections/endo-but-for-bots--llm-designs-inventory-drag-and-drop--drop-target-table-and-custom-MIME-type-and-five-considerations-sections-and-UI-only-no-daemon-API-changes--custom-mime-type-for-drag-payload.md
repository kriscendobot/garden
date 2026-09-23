---
title: §Custom MIME type for drag payload
source-slug: endo-but-for-bots--llm-designs-inventory-drag-and-drop
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/inventory-drag-and-drop.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/inventory-drag-and-drop.md
total-lines: 99
ingest-cycle: 248
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-inventory-drag-and-drop--drop-target-table-and-custom-MIME-type-and-five-considerations-sections-and-UI-only-no-daemon-API-changes
---

§The-drag-data-payload-includes-the-pet-name-path-as-both-`text/plain`-AND-`application/x-endo-petname`. §Two-MIME-types-on-drag-data: §`text/plain` for legacy compatibility + §`application/x-endo-petname` for type-safe Endo-aware drop targets.

§The-custom-MIME-type-IS-the-discriminator — §a-drop-target-that-only-accepts-Endo-pet-names-can-check-the-custom-MIME-type + §plain-text-drops-from-other-applications-don't-trigger-Endo-handlers. §First-explicit-observation in library of §custom-MIME-type-as-discriminator-on-HTML5-drag-payload.

§The-`x-endo-`-prefix follows the §custom-MIME-type-convention for non-IANA-registered types. §When-a-design-extends-an-HTML5-API-with-application-specific-type-information, §define-a-custom-MIME-type-with-the-`x-`-prefix-or-the-`application/vnd.`-prefix.

§Sibling-pattern-to-cycle-246's-`X-Hub-Signature-256`-and-`Stripe-Signature` (named external headers) — §two-cycles-with-explicit-protocol-string-conventions: §cycle-246 cites external service headers + §cycle-248 defines an application-specific MIME type.
