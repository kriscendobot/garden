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
title: §Synthesis-target
parent: endo-but-for-bots--llm-designs-endo-bytes--maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names
---

When the garden grows a utility package to retire
duplication, follow this design's pattern:

1. Audit existing duplicates with counts.
2. Apply §maximal-power-minimal-area.
3. Per-helper-surface, no barrel.
4. Qualified export names.
5. Module-scoped captured globals.
6. No peer deps unless absolutely required.
7. Start at 1.0.0.
8. Resolve Open Questions during implementation.

§Slot machine library will likely need similar leaf-
utility packages. §Reuse-this-pattern.
