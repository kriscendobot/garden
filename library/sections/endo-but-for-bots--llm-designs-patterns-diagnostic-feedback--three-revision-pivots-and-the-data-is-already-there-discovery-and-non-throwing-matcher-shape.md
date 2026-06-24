---
title: Three-revision-pivots visible in source (carry-on-error → sibling-package → submodule) + §the-data-is-already-there-just-locked discovery + §non-throwing-matcher-mirroring-`matches`-shape + §opt-in-submodule-with-cost-asymmetry — endo-but-for-bots designs/patterns-diagnostic-feedback.md
source: endo-but-for-bots designs/patterns-diagnostic-feedback.md
source-slug: endo-but-for-bots--llm-designs-patterns-diagnostic-feedback
ingest-cycle: 198
ingest-date: 2026-06-06
lane: designs
status: Proposed (2026-05-19 created; 2026-05-20 round-3 reshape)
author: Kris Kowal (prompted by maintainer kriskowal)
related:
  - endo--packages-pass-style (cycle 71+: passable substrate matched against)
  - endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js (cycle 189: passableAsJustin diagnostic rendering)
  - endo-but-for-bots--llm-designs-endoclaw (cycle 196: §honest-architectural-difference + §multi-author-quote-blocks; sibling §genre but different shape)
  - endo--packages-panic (cycle 197: §honest-design-evolution-in-the-README; this design's §three-revision-rounds is a more extreme instance)
  - endo--packages-eventual-send-src-message-breakpoints-js (cycle 147: also @endo addresses-diagnostic-surface-shape problem)
  - endo--packages-ses-src-error-tame-console-js (cycle 106: SES error-observation surface — `applyLabelingError` rides on top of this)
keywords:
  - three-revision-pivots visible in Prompt section
  - the-data-is-already-there-just-locked discovery
  - sibling-package to submodule pivot
  - opt-in submodule with cost-asymmetry
  - non-throwing matcher mirroring matches() shape
  - compact-default + expanded-opt-in
  - AI-agent-token-economy rationale
  - Rust-compiler-error analogy
  - all-alternatives-reported no-heuristic
  - rich-not-configurable convention
  - column separator | not JSON-Lines
  - ASCII not unicode for terminal/log/CI
  - tracing recursion reuses helpers in place (no parallel implementation)
  - two-consumer-postures (library users + AI agents)
kind: index
section_count: 18
---

Sections:

- [Source](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--source.md)
- [Single most structurally interesting move](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--single-most-structurally-interesting-move.md)
- [§The-data-is-already-there-just-locked — the central discovery](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--the-data-is-already-there-just-locked-the-central-discovery.md)
- [§Non-throwing-matcher mirroring `matches()` shape](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--non-throwing-matcher-mirroring-matches-shape.md)
- [§Opt-in-submodule-with-cost-asymmetry](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--opt-in-submodule-with-cost-asymmetry.md)
- [§Rich-not-configurable convention with §Rust-compiler-error analogy](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--rich-not-configurable-convention-with-rust-compiler-error-analogy.md)
- [§Two-consumer-postures (library users + AI agents)](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--two-consumer-postures-library-users-ai-agents.md)
- [§Tracing recursion reuses helpers in place — no parallel implementation](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--tracing-recursion-reuses-helpers-in-place-no-parallel-implementation.md)
- [§Composition with `@endo/exo` argument guards — no exo change required](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--composition-with-endo-exo-argument-guards-no-exo-change-required.md)
- [§Compact format: column separator `|` not JSON-Lines](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--compact-format-column-separator-not-json-lines.md)
- [§ASCII not unicode for terminal/log/CI compatibility](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--ascii-not-unicode-for-terminal-log-ci-compatibility.md)
- [§Nine Design Decisions canonical format](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--nine-design-decisions-canonical-format.md)
- [§Single-PR-scope despite three revision rounds](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--single-pr-scope-despite-three-revision-rounds.md)
- [§No-design-predecessors named explicitly](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--no-design-predecessors-named-explicitly.md)
- [§One open question](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--one-open-question.md)
- [§Borrowable patterns (tier-1)](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--borrowable-patterns-tier-1.md)
- [§Synthesis-target](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--synthesis-target.md)
- [§Cycle 198 meta-observations](endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape--cycle-198-meta-observations.md)
