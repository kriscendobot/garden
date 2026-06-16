---
title: §Synthesis-target
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
parent: endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape
---

Slot machine library §pattern-matcher-diagnostic-surface (when the slot machine's predicate over an outcome fails) can §borrow-the-non-throwing-matcher-shape directly: a `explainOutcome({ outcome, predicate }): string | undefined` mirror of a boolean `matches()` API. §opt-in-submodule discipline gates the diagnostic feature behind an explicit import so the production payout-path pays zero.

§The-data-is-already-there-just-locked discovery pattern is borrowable in any §library-with-a-throwing-API that consumers wish were §programmatically-introspectable: check whether the data already exists in a hidden place (in this case, SES `annotateError` chain via `assert.note`) before threading new storage through.

§All-alternatives-reported-no-heuristic borrowable for any §multi-candidate-failure surface (slot machine combinator failures, predicate disjunctions). §Rust-compiler-error-analogy is the citable prior art.

§Two-consumer-postures-named-explicitly with §default-favors-the-tighter-budget-consumer borrowable for any §dual-audience API where humans and AI agents both consume output.
