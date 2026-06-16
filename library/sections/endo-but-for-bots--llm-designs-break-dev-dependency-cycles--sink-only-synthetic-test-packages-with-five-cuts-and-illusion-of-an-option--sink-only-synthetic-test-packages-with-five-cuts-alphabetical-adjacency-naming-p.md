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
title: Sink-only synthetic test packages with five cuts, alphabetical-adjacency naming, package-namespaced `test` conditions, and illusion-of-an-option rejected
parent: endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option
---

> §Designs-lane after cycle 185's chat-lane. §The-twentieth-
> consecutive designs/chat alternation cycle (166-186). §Status:
> **In Progress** — design merged 2026-05-10 via PR #206; Cuts
> 2-5 shipped 2026-05-11 → 2026-05-14; Cut 1 open as PR #261.
> §The-parent-design that cycle 180 hex-package's §"@endo/hex-
> test (Cut 2)" sentence ratified.

`break-dev-dependency-cycles.md` (736 lines, Created 2026-05-11,
Updated 2026-05-18) audits the workspace dependency graph and
proposes a §sink-only-synthetic-test-package factoring that
breaks the 13-package SCC currently formed by 18 dev-
dependency back-edges.

§The-single-most-structurally-interesting-move is §sink-only-
synthetic-test-packages-where-`sink-only-is-the-load-bearing-
constraint`. §A-package-downstream-of-the-SCC-cannot-extend-
the-SCC: that is what makes it a cycle break. §Each-cut moves
test scaffolding into a `@endo/<subsystem>-test` package whose
dependencies declare the upstream subsystems, and on which no
other workspace package depends (neither as dependencies nor
devDependencies).
