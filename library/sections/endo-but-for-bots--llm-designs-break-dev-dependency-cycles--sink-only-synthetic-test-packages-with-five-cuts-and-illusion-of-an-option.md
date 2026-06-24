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
kind: index
section_count: 16
---

Sections:

- [Sink-only synthetic test packages with five cuts, alphabetical-adjacency naming, package-namespaced `test` conditions, and illusion-of-an-option rejected](endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option--sink-only-synthetic-test-packages-with-five-cuts-alphabetical-adjacency-naming-p.md)
- [§The-survey (Tarjan SCC produces exactly one 13-package SCC)](endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option--the-survey-tarjan-scc-produces-exactly-one-13-package-scc.md)
- [§The-`sink-only` constraint (the load-bearing property)](endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option--the-sink-only-constraint-the-load-bearing-property.md)
- [§Cut-1-eats-11-edges (the largest cut)](endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option--cut-1-eats-11-edges-the-largest-cut.md)
- [§Cut-3-is-pure-deletion (the simplest cut)](endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option--cut-3-is-pure-deletion-the-simplest-cut.md)
- [§The-"illusion of an option" (Cut 4 rejected sub-option)](endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option--the-illusion-of-an-option-cut-4-rejected-sub-option.md)
- [§Naming-convention-Option-B-`@endo/<subsystem>-test` (alphabetical adjacency)](endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option--naming-convention-option-b-endo-subsystem-test-alphabetical-adjacency.md)
- [§The-`test`-condition mechanism (resolved with package-namespacing)](endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option--the-test-condition-mechanism-resolved-with-package-namespacing.md)
- [§Five-Resolved-Decisions (all settled in PR #206 review)](endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option--five-resolved-decisions-all-settled-in-pr-206-review.md)
- [§The-§"I'm fine with duplication where necessary to avoid a utils package"](endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option--the-i-m-fine-with-duplication-where-necessary-to-avoid-a-utils-package.md)
- [§The-§cycle-is-cosmetic-noise-not-fatal (the motivation)](endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option--the-cycle-is-cosmetic-noise-not-fatal-the-motivation.md)
- [§Roadmap-calibration (per `git blame`)](endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option--roadmap-calibration-per-git-blame.md)
- [§Future-Work (the §next-cycle-of-cleanups)](endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option--future-work-the-next-cycle-of-cleanups.md)
- [§Cohesion notes](endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option--cohesion-notes.md)
- [§Tier-1 borrowing](endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option--tier-1-borrowing.md)
- [§Synthesis-target](endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option--synthesis-target.md)
