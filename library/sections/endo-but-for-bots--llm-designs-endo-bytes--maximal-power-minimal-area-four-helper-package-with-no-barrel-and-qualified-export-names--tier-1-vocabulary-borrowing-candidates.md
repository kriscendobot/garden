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
title: §Tier-1 vocabulary borrowing candidates
parent: endo-but-for-bots--llm-designs-endo-bytes--maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names
---

§Maximal-power-minimal-area discipline (audit first,
include only what retires existing duplicates).

§No-barrel-module-per-helper-surface (tree-shaking +
audit-friendly).

§Qualified-export-names (concat.js → concatBytes; file
name doesn't stutter, export carries qualifier).

§Module-scoped-TextEncoder/TextDecoder (capture-at-module-
load; no per-call allocation).

§First-release-at-1.0.0 (no 0.x purgatory for new utility
packages).

§Open-Questions-resolved-during-implementation (design
doc evolves with implementation review).

§Sourced-from-PR-inline-review-comment as a §design-
lifecycle.

§Tier-2: §helper-rationale-table-with-existing-duplicates-
counts (audit-driven inclusion).
