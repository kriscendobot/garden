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
title: §Helper rationale table
parent: endo-but-for-bots--llm-designs-endo-bytes--maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names
---

| Helper | Existing duplicates | Why include |
|--------|---------------------|-------------|
| concatBytes | 5+ (PR 122 ×3 + cli/store.js + ocapn buffer-utils + Buffer.concat ports) | Highest-value extraction; the immediate trigger |
| bytesEqual | Several inline loops (not yet a named helper) | Pre-empts the next reviewer flag |
| bytesFromText | 8 module-scoped TextEncoders in daemon/src + connection.js + worker.js | Avoids per-module encoder allocation |
| bytesToText | 4+ fresh-TextDecoder-per-call sites | Symmetric with bytesFromText |

§Each-helper-is-justified-by-a-count. §Counts-are-
auditable. §The-design-doesn't-include-a-helper-with-zero-
duplicates.
