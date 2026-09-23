---
title: §Borrowable patterns
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

**Tier-1 (highest borrowing value):**

- §Group-table — four-column dispatch table (Group × Formula Types × Icon × Description).
- §Catch-all-bucket-explicitly-named — "Everything Else" with icon and description.
- §Options-Considered-with-preferred — distinct from Alternatives-Considered; both options viable, one preferred.
- §Additive-API-change-via-destructure-immune-consumers as named compatibility discipline.
- §Substrate-count-named-as-evidence-of-categorization-scope (26 types in substrate, 4 explicit groups).
- §The-design-IS-the-exposure-not-the-computation — when substrate already has the information.
- §Exposing-X-doesn't-grant-new-capabilities as named security argument shape.
- §Restrict-interface-metadata-to-host-level-authority — stretch-goal security thinking not deferred.
- §No-migration-needed — when API extension exposes existing substrate field.

**Tier-2 (design-doc shape patterns):**

- §Five-Considerations-sections recurring template (cycles 248 + 250 by same author).
- §Design-doc-template-recurs-across-related-designs as named author-discipline.
- §Affected-Packages-section-as-blast-radius-evidence with varying row counts.
- §`stretch goal`-vocabulary as named author's recurring deferral vocabulary.
- §Three-shapes-of-design-doc-alternatives-section in library now (Alternatives-with-three-rejected + Alternatives-with-rejected+deferred + Options-with-preferred).

**Tier-3 (named comparisons):**

- §Preserve-existing-toggle-as-named-non-change (system items with @-prefix).
- §Two-cycles-with-Affected-Packages-section with different blast radii (1 row vs 3 rows).
- §Two-cycles-with-explicit-named-backward-compatibility-discipline (242 forward-compatible-shim + 250 additive-API-change).
