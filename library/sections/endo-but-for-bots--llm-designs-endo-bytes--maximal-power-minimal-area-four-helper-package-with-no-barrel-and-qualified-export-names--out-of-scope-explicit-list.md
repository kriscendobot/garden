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
title: §Out-of-scope explicit list
parent: endo-but-for-bots--llm-designs-endo-bytes--maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names
---

§Out-of-scope-explicit:

- Full `Buffer` replacement library (use `buffer/`-shim).
- Hex encoding (use @endo/hex).
- Base64 (use @endo/base64).
- Streaming API (use @endo/stream).
- Async helpers (one-liners over sync helpers).

§Defer-to-sibling-packages discipline. §Each-package-has-
one-concern. §Don't-build-a-mega-package.

§Cycle-167's-where/index.js follows the same shape:
location-resolution is its concern; everything else is
elsewhere.
