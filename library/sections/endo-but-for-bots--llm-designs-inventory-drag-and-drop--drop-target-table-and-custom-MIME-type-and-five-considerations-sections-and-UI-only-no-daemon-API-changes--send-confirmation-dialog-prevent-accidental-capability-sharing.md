---
title: §Send-confirmation dialog — prevent accidental capability sharing
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

§The-design-names-`Send confirmation`: *Dropping onto an agent handle shows a confirmation dialog before sending, to prevent accidental capability sharing.* §The-confirmation-IS-the-defense-against-accidental-share.

§When-a-UI-action-shares-a-capability-irreversibly, §require-a-confirmation-dialog + §the-confirmation-IS-the-defense-against-misclick. §Sibling-pattern-to-cycle-238's-revoke()-and-cycle-246's-permanent-revoke — §three-cycles-with-explicit-defense-against-irreversible-action (238 + 246 + 248). §Cycle-238-and-cycle-246-name-revocation-as-permanent; §cycle-248-names-a-confirmation-before-a-share-action.
