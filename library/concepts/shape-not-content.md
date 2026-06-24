---
id: shape-not-content
aliases: ["shape not content", "library captures shape", "upstream meta-tables", "shape-not-content principle", "do not transcribe upstream rows", "taxonomy capture without rows"]
topics: [agent-conventions, repository-governance]
---

# shape-not-content

A library ingestion principle: when an upstream document's value is a
*meta-index* of other items (every-design-status table, every-package-
state table, every-tenant list) whose rows change at upstream's cadence
rather than the library's, capture the table's *shape* — column
structure, taxonomy, current row count, query-upstream pointer — but
**do not transcribe the rows**. The library would otherwise become a
stale mirror that diverges silently. Originated in cycle 41 of the
endo-but-for-bots design ingest, when `designs/README.md`'s 100+-row
summary table threatened to overwhelm the section budget; established
formally in `conventions.md`.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [endo-but-for-bots--llm-designs-readme--summary-shape-and-counts](../sections/endo-but-for-bots--llm-designs-readme--summary-shape-and-counts.md) | The worked example: captures column structure + current count + query-upstream pointer, not the rows. |

The principle is codified in [`conventions.md`](../conventions.md) §
*Structural principles from cycles 41-43*.

## See also

- [[producer-typed-shape-consumer-rendering]] — the related "what should be carried explicitly vs derived" principle.
- [[sentinel-with-rationale]] — the third structural principle from the same cluster.
