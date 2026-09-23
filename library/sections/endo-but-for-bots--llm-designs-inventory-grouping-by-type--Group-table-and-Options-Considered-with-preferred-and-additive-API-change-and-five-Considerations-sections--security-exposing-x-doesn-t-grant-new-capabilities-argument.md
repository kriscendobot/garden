---
title: §Security exposing-X-doesn't-grant-new-capabilities argument
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

§Security-Considerations: *Formula type is already determinable by inspecting behavior; exposing it explicitly doesn't grant new capabilities.*

§The-named-security-argument: §an-information-leak-that-already-exists-via-behavior-inspection-isn't-a-new-information-leak. §When-a-design-exposes-information-explicitly, §argue-that-the-information-was-already-implicitly-available + §the-explicit-exposure-doesn't-grant-new-capabilities.

§First-explicit-observation in library of §exposing-X-doesn't-grant-new-capabilities as named security argument shape.

§Sibling-pattern-to-cycle-244's-no-ambient-scheduling-security-invariant — §two-cycles-with-explicit-named-security-argument: §cycle-244 by-construction-no-ambient-X + §cycle-250 X-already-implicitly-available.

§Restrict-interface-metadata-to-host-level-authority as named-recommendation for the stretch goal — §when-exposing-implementation-details-could-leak-to-guests, §restrict-the-exposure-to-host-level-authority-not-guest-level. §When-a-stretch-goal-has-named-security-implications, §name-the-recommended-restriction-in-the-Security-Considerations-section + §don't-defer-the-security-thinking.
