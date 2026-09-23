---
title: §`identify()` already returns formula identifiers but not type
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

§Implementation-Notes section: *The `identify()` method on the agent already returns formula identifiers. The formula type is embedded in the stored formula but not currently returned to the client.*

§The-existing-API-already-has-the-information-internally + §the-design-extends-the-API-to-expose-what-the-substrate-already-knows. §When-a-substrate-has-the-information-but-doesn't-expose-it, §the-design-IS-the-exposure-not-the-computation.

§Sibling-pattern-to-cycle-242's-`@endo/platform`-extracts-existing-daemon-types (which extracted existing types into a shared package); §two-different-shapes-of-expose-existing-substrate-information: §cycle-242 extracts-types-into-shared-package + §cycle-250 extends-API-to-return-existing-internal-field.
