---
title: "ADR 0008: Context and corrected diagnosis"
source: docs/decisions/0008-samples-gate-live-generation-resilience.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Repeated full-matrix runs failed on different samples and error classes, while isolated reruns passed; an initial missing-Rust-skill diagnosis was disproved because Flavor-contributed authoring inputs already supplied the exact Rust instructions, leaving transient model behavior as the credible failure class.

- Status: Accepted on 2026-08-20 after the 0.5.2 backport reproduced the same
  failure shape six times.
- Roadmap: `SAMPLES-RESILIENCE-001`, related to the corrected
  `SAMPLE-PORTFOLIO-002` claim.

The 0.5.1 release gate failed three consecutive full runs on different samples:
two timeout paths and one generation failure across `claude` and `cursor-agent`.
The Rust dependency planner later succeeded alone after identical-content failures.
Its build error said `source/main.rs` was absent even though its specification was
precise.

The investigation first blamed a missing Rust-specific skill, but that conclusion
only inspected Component `authoring_inputs`. Flavor definitions also contribute
authoring inputs. The selected Rust Flavor already supplied direct-`rustc`, no-Cargo,
`source/main.rs` guidance, which a duplicate-skill validation error confirmed. The
failure therefore occurred despite the exact instruction, consistent with transient
generation non-determinism rather than an uncovered skill.

Source: [docs/decisions/0008-samples-gate-live-generation-resilience.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0008-samples-gate-live-generation-resilience.md) at commit `fcc40bc6` (source lines 1-66).
