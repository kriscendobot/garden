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
title: §Five-existing-duplicates audit (the trigger)
parent: endo-but-for-bots--llm-designs-endo-bytes--maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names
---

§PR-122-triplication: three near-identical `concatChunks`
helpers in `packages/platform/src/fs-node/{file,directory,
tree-writer}.js`, each a §verbatim-copy-of-the-same-nine-
line-function.

§Broader-audit shows §at-least-five-separate-concat-a-list-
of-chunks-functions with §subtly-different-signatures
(`concat`, `concatChunks`, `concatUint8Arrays`,
`asyncConcat`, plus inline `Buffer.concat(...)` ports).

§Three-concrete-costs:

1. §Each-new-caller-invents-another-copy.
2. §Subtle-drift-between-copies (`length` vs `byteLength`;
   `for`-loop vs `reduce`; etc.).
3. §Buffer-ports-still-landing (Node-only dependencies
   keep being introduced where they don't need to be).

§The-immediate-trigger is PR 122's triplication; §the-
broader-state was identified during the audit.
