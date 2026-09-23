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
title: §Synthesis-target
parent: endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option
---

The §slot-machine-library's workspace (when it has one) can
§borrow-the-sink-only-test-package-pattern from day one rather
than retrofitting after cycles form. §The-§Option-B-naming-
convention (`@endo/<subsystem>-test`) is the canonical
adjacency-preserving form.

§The-§"illusion of an option" diagnostic is borrowable for any
§cycle-break-candidate: ask "does this candidate live outside
the SCC?" If the answer is "no, it just renames the edge,"
the candidate is an illusion.

§The-§package-namespaced-condition pattern (`test-endo-foo`)
is borrowable for any §internal-surface-exposed-only-to-a-
specific-consumer scenario; it preserves the §minimal-
visibility-radius that a bare `test` condition erodes.
