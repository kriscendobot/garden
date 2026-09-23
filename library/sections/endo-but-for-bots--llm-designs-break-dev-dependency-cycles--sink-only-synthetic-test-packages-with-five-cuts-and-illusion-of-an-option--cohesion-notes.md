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
title: §Cohesion notes
parent: endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option
---

- §Sink-only-synthetic-test-packages is the §load-bearing-
  constraint. §A-package-downstream-of-the-SCC-cannot-extend-
  the-SCC.
- §Five-cuts collapse 18 cycle-forming devDep edges into four
  families. §Cuts-are-independent and §can-land-in-any-order.
- §Tarjan-SCC-survey identifies exactly one 13-package SCC;
  §dependencies-only-subgraph has zero non-trivial SCCs.
- §"An illusion of an option" — §a-fix-that-looks-like-a-
  cycle-break-but-only-renames-the-edge. §Reject-via-substance-
  test: does the candidate live outside the SCC?
- §Naming-convention-Option-B `@endo/<subsystem>-test` for
  §alphabetical-adjacency (sort test immediately after subject).
- §Test-condition-package-namespacing (`test-endo-foo` not
  bare `test`) to preserve §which-realm-owns-this-channel.
- §"I'm fine with duplication where necessary to avoid a utils
  package" — §duplication-preferred-over-indirection-that-
  creates-cycles. §The-utils-package-would-itself-need-cycle-
  forming-deps.
- §Five-Resolved-Decisions cited with PR review discussion
  links. §Review-iteration-archived-in-design.
- §Three-cited-costs-of-the-cycle: cosmetic noise +
  silent-by-default conflict + weaker cache hash.
- §Four-day-burst-for-Cuts-2-5 + §Cut-1-still-open. §Cuts-can-
  land-independently rhythm.
- §Audit-as-cycle-break-precondition: vestigial devDep
  detection via grep retires Cut 3 with zero new packages.
- §Parent-design-of-cycle-180-hex-package's-§"@endo/hex-test
  (Cut 2)" sentence. §Cycle-180-ratified-this-design's-Cut-2.
