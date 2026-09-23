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
title: §Four-phase migration
parent: endo-but-for-bots--llm-designs-endo-bytes--maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names
---

| Phase | Content | PR |
|-------|---------|-----|
| 1 | Create `@endo/bytes` package | #142 |
| 2 | Migrate PR 122's three `concatChunks` | Follow-up |
| 3 | Migrate sibling duplicates (cli/ocapn/envelope) | #142 |
| 4 | Migrate TextEncoder/TextDecoder instantiations | #142 |

§PR-#142-shipped-Phases-1-3-4-in-three-commits (scaffold,
implementation, yarn.lock).

§Phase-2-deferred because PR 122 was still in review;
§coordinate-with-still-in-flight-work via §layer-the-
migration or §wait-for-merge.

§The-package-is-shipped-first-and-adopted-incrementally;
§no-call-site-rewrites-are-load-bearing-for-the-package-
itself. §Decoupled-rollout.
