---
title: §Single-PR-scope despite three revision rounds
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

> The submodule is small enough to land as a single PR. The new code is approximately 600 lines including tests.

§Phase-A-is-the-whole-thing — only one phase. §The-three-revision-rounds-shrank-the-scope-not-expanded-it.

Phase A breakdown:
- `packages/patterns/src/explain-mismatch.js` (public entry)
- `packages/patterns/src/explain-mismatch/trace.js` (tracing recursion mirroring `confirmMatches`)
- `packages/patterns/src/explain-mismatch/render.js` (formatter with compact + expanded, width + color)
- `packages/patterns/package.json` `exports` entry
- `packages/patterns/test/explain-mismatch.test.js` (three exemplar cases × 2 formats + InterfaceGuard composition)
- §No-changes-to-`mustMatch`,-`assertMatches`,-`matches`,-or-`applyLabelingError`.

§Three-revision-rounds-shrunk-the-scope is unusual and worth naming as a §borrowable-pattern: §each-review-round-was-a-simplification, not §each-review-round-added-features. §Round-1 dissolved the "thread payloads through matcher" framing. §Round-2 dissolved the try/catch boilerplate. §Round-3 dissolved the sibling-package boundary and folded two functions into one.
