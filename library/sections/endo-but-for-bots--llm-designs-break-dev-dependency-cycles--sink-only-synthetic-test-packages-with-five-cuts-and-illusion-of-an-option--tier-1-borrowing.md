---
source: designs/break-dev-dependency-cycles.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/break-dev-dependency-cycles.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - repository-governance
  - tooling
status_at_ingest: In Progress
genre: §endo-but-for-bots-design §sink-only-package-pattern
cycle: 186
lane: designs
status: current
title: §Tier-1 borrowing
parent: endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option
---

- §sink-only-synthetic-test-packages (no incoming workspace
  edges = can't extend an SCC)
- §the-cycle-is-all-in-devDependencies discipline (audit by
  removing dev edges first; see if cycles persist)
- §"an illusion of an option" rejection-language for §a-fix-
  that-looks-like-a-cycle-break-but-only-renames-the-edge
- §package-namespaced-conditions (`test-endo-foo` not bare
  `test`) to preserve realm ownership
- §duplication-preferred-over-indirection-that-creates-cycles
  ("I'm fine with duplication")
- §alphabetical-adjacency-naming (test sorts immediately after
  subject)
- §cuts-can-land-independently rhythm (each PR small + self-
  contained; ordered by diff size)
- §audit-as-cycle-break-precondition (grep for unused devDeps
  before adding new packages)
- §review-iteration-archived-in-design (PR discussion links
  per Resolved Decision)
- §exhaustive-Tarjan-SCC-survey as §motivation-evidence
- §three-cited-costs-of-the-cycle (cosmetic-noise + silent-by-
  default-conflict + weaker-cache-hash)
