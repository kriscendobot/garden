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
title: §Naming-convention-Option-B-`@endo/<subsystem>-test` (alphabetical adjacency)
parent: endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option
---

```
Adopted per kriskowal review (PR #206 [...]):
"I prefer this option on the grounds that the package and its
test package will be adjacent in the list."

The suffix `-test` says "test harness" and matches the existing
`@endo/stream-types-test` precedent exactly, so no rename of
that package is needed.
```

§Two-design-axes-considered:

- **Option A**: `@endo/test-<subsystem>` — groups synthetic
  packages alphabetically under `packages/test-*/`. §Rejected-
  because-it-loses-§alphabetical-adjacency between subject and
  test.
- **Option B**: `@endo/<subsystem>-test` — sorts test
  immediately after subject. §Chosen.

§The-rationale-named: "Each synthetic package sorts immediately
after the package it tests (both in `packages/` directory
listings and in alphabetical `package.json` lookups), which
makes it easy to find the test package next to its subject."

§Compare-to-cycle-180-hex-package's §sibling-package-cloned-
file-for-file naming. §Both-are-§adjacent-naming-as-
discoverability disciplines. §Hex-package: clone the source's
filename pattern. §This-design: sort the test next to its
subject.
