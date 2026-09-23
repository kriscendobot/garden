---
title: §Nine Design Decisions canonical format
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

The design enumerates §nine-Design-Decisions, each named with its alternative and the reason for choosing one over the other. §Canonical-Design-Decisions-format (per the §canonical-Design-Decisions-format family cycles 184/188/192/194/196):

1. Submodule of `@endo/patterns`, not a sibling package.
2. `explainMismatch` is a non-throwing matcher, not an error post-processor.
3. Public surface is a single function returning a string, not a split diagnose-plus-render pair.
4. `compact` is the default format, `expanded` is opt-in.
5. Column separator is `|`, not JSON.
6. All alternatives reported, no closest-alternative heuristic.
7. Tracing recursion reuses the matcher's helpers in place.
8. No text-source pattern parser in this design.
9. Renderer uses ASCII, not unicode box-drawing.

§Each-decision-names-the-alternative-it-rejected. §The-pattern-is-not-"here's-what-we-did"-but-"here's-what-we-considered-and-why-we-chose-one".

§Sibling-to cycle 184 daemon-xs-worker-metering's §seven-Design-Decisions and cycle 196 endoclaw's §status-matrix — both name §what-was-considered-but-not-chosen.
