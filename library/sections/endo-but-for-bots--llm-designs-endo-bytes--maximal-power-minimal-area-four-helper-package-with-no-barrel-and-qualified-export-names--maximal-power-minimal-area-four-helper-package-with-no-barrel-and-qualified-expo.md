---
source: designs/endo-bytes.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endo-bytes.md
source_path: designs/endo-bytes.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Designer (dispatched per kriskowal review)
topics:
  - tooling
  - patterns
  - pass-style
genre: §endo-but-for-bots-design
cycle: 172
lane: designs
status: current
title: Maximal-power-minimal-area four-helper package with no barrel and qualified export names
parent: endo-but-for-bots--llm-designs-endo-bytes--maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names
---

> §Endo-but-for-bots-design genre (designs-lane). Status:
> **Implemented** (PR #142). §Sourced-from-PR-inline-
> review-comment ([PR 122 comment 3205507716]).

`designs/endo-bytes.md` (617 lines) is the design for
extracting duplicated `Uint8Array` helpers into a new
`@endo/bytes` utility package. The single most structurally
interesting move is the **§maximal-power-minimal-area
discipline** (per user's review guidance): §ship-the-
smallest-API-that-retires-the-existing-duplicates; §add-
helpers-when-a-real-consumer-asks.

Cycle 167's @endo/where/index.js and cycle 171's
@endo/stream/index.js are §sibling-utility-packages with
similar shape (small, focused, foundational). This design
shows what the §process-of-extracting-a-new-utility-package
looks like.
