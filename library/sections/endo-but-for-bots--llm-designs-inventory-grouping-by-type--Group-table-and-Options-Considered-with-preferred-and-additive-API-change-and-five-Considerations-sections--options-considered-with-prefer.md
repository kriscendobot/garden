---
title: §Options Considered with preferred — distinct from Alternatives Considered
source-slug: endo-but-for-bots--llm-designs-inventory-grouping-by-type
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/inventory-grouping-by-type.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/inventory-grouping-by-type.md
total-lines: 125
ingest-cycle: 250
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections
---

§Two-Options-Considered: **Option A: Extend `followNameChanges()`** (preferred) + **Option B: New `identifyType(petName)` method**.

§Options-Considered-with-preferred is distinct from §Alternatives-Considered-with-fates (cycle 238 had rejected+rejected+deferred; cycle 240 had rejected+rejected+rejected). §The-difference: §Alternatives-Considered all-but-one-rejected + §Options-Considered the-preferred-one-named-and-both-described-as-viable.

§When-two-implementation-strategies-are-both-viable-but-one-is-preferred, §use-Options-Considered-not-Alternatives-Considered + §name-the-preferred-explicitly + §describe-both-with-their-trade-offs. §First-explicit-observation in library of §Options-Considered-with-preferred as distinct-from-Alternatives-Considered.

§The-trade-off-for-Option-A: §avoids-N+1-lookups + §lets-the-UI-group-at-subscription-time + §additive-change-shape. §The-trade-off-for-Option-B: §simpler-to-implement + §requires-a-round-trip-per-item.

§Three-shapes-of-design-doc-alternatives-section in library now: §Alternatives-Considered-with-three-rejected (240) + §Alternatives-Considered-with-rejected+deferred (238) + §Options-Considered-with-preferred (250). §The-vocabulary-of-the-section-IS-the-status-of-the-options.
