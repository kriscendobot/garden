---
title: §Move operations not atomic — acknowledged
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

§The-Security-Considerations-section explicitly names: *Move operations (copy + remove) are not atomic; a failure after copy but before remove could leave a duplicate. This matches the existing CLI `endo mv` behavior.*

§Acknowledged-non-atomic-move-with-named-existing-behavior. §When-a-new-UI-feature-inherits-a-known-non-atomic-behavior-from-the-existing-substrate, §name-the-non-atomic-behavior-explicitly-in-Security-Considerations + §match-the-existing-behavior-not-fix-it-as-part-of-this-feature.

§Sibling-pattern-to-cycle-245's-TODO-names-a-known-confusing-case — §two-cycles-with-explicit-acknowledgment-of-a-known-imperfection-not-fixed-in-this-design (cycle 245 TODO + cycle 248 non-atomic-move).
