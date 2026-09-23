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
title: §Comparison with sibling utility packages
parent: endo-but-for-bots--llm-designs-endo-bytes--maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names
---

| Package | Lines | Cycle | Concern |
|---------|-------|-------|---------|
| @endo/where | 115 | 167 | Platform path resolution |
| @endo/stream | 247 | 171 | Async iterator streams |
| @endo/bytes | (small) | 172 | Uint8Array helpers |
| @endo/base64 | (small) | — | Base64 encoding |
| @endo/hex | (small) | — | Hex encoding |

§Family-of-small-focused-utility-packages. §Each-handles-
one-concern.

§Pattern: §minimal-leaf-utility-with-narrow-surface. §No-
peer-deps-when-avoidable.

§Synthesis-target: §when-you-see-duplication-across-the-
monorepo-extract-it-into-a-leaf-utility.
