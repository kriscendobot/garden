---
title: §UI-only — no daemon API changes
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

§Implementation-Notes: *All necessary daemon API methods already exist*. The design enumerates four-existing-daemon-API-methods (copy + move + send + remove) and §names-the-file-each-lives-in. §No-daemon-API-changes-needed — §all-operations-use-existing-methods.

§Eleven-cycles-on-no-new-abstractions discipline now (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244 + 246 + 248). §When-a-UI-feature-could-be-implemented-by-adding-new-daemon-methods-or-by-reusing-existing-ones, §reuse-the-existing-ones + §the-UI-IS-the-presentation-layer-not-the-new-substrate.

§Sibling-pattern-to-cycle-246's-inbox-delivery (webhook payloads through existing mail system) — §two-cycles-with-explicit-no-new-daemon-API-changes-as-named-discipline. §The-UI-or-the-event-delivery-layer-IS-the-only-new-code-needed.
