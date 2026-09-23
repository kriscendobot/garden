---
title: §Group table — four-column dispatch table
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

```
| Group | Formula Types | Icon | Description |
|-------|--------------|------|-------------|
| Handles | handle | Person silhouette | Agent identities |
| Hubs | directory, host, guest, pet-store | Folder | Naming containers |
| Workers | worker | Gear | Execution sandboxes |
| Everything Else | All remaining types | Circle | Blobs, eval results, promises, lookups |
```

§Four-named-groups + §four-column-table with §Group × Formula Types × Icon × Description. §Group-table-IS-the-categorization-and-the-presentation-vocabulary-in-one-place.

§The-fourth-row-is-`Everything Else` — §the-catch-all-bucket-explicitly-named-with-an-icon-and-description; §when-categorization-might-miss-types, §explicitly-name-the-catch-all-bucket + §the-catch-all-IS-the-completeness-guarantee. §Sibling-pattern-to-cycle-236's-four-buckets (which classified caplet sources with explicit catch-all "Eval-inside-individual-worker" as the escape hatch) — §two-cycles-with-explicit-catch-all-bucket-as-completeness-guarantee.

§First-explicit-observation in library of §four-column-Group-table-with-Icon-and-Description as categorization-and-presentation-vocabulary.
