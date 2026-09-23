---
title: §Drop-target table — three columns
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

```
| Target | Action | Daemon API Call |
|--------|--------|-----------------|
| Directory item (expandable) | Copy capability into directory | `E(agent).copy(sourcePath, [targetDir, itemName])` |
| Agent/guest handle | Send capability to agent | `E(agent).send(targetAgent, strings, edgeNames, petNames)` |
| PINS section (work item 003) | Pin the capability | `E(agent).pin(petName)` |
| Trash/dismiss zone | Remove from inventory | `E(agent).remove(petName)` |
```

§Four-named-drop-targets + §each-row-has-the-action-and-the-existing-daemon-API-call. §The-table-IS-the-mapping-from-UI-target-to-daemon-API-call. §When-a-UI-feature-dispatches-to-existing-API-methods, §the-table-IS-the-dispatch-table + §the-design-IS-the-mapping-not-the-implementation.

§Sibling-pattern-to-cycle-238's-method-placement-table (which methods sit on which facet) — §two-different-shapes-of-dispatch-table: §cycle-238 maps methods to facets + §cycle-248 maps UI-targets to daemon-API-calls. §Two-cycles-with-explicit-dispatch-table-as-the-design.

§Three-cycles-with-explicit-dispatch-or-method-placement-table (238 + 240 method-placement + 248 drop-target). §The-table-IS-the-mechanism-of-decoupling-between-the-presentation-and-the-substrate.
