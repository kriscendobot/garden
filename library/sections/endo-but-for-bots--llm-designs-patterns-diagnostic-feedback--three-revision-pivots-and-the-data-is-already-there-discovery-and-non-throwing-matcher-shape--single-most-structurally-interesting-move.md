---
title: Single most structurally interesting move
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

§three-revision-pivots-visible-in-Prompt-section + §the-data-is-already-there-just-locked discovery + §non-throwing-matcher-mirroring-`matches`-shape + §opt-in-submodule-with-cost-asymmetry + §rich-not-configurable rendering convention with §Rust-compiler-error analogy as cited prior art.

The design's Prompt section preserves §three-round-review-trail in the source itself — the original three-axis "thread structured payloads through the matcher" framing got §CHANGES_REQUESTED'd and reshaped through three pivots, each named with the maintainer's review and the structural change it produced:

| Revision | Date | Pivot |
| --- | --- | --- |
| Original | (per the Prompt section) | Three-axis "carry-on-error" design threading structured payloads through the matcher. |
| Round 1 (CHANGES_REQUESTED) | 2026-05-19 | **§the-data-is-already-there-just-locked** discovery: `applyLabelingError` already records the chain via `annotateError` (SES `assert.note`); the chain is unreachable to programmatic readers but the data exists. Reshape: "build a sibling package that reads what is already there and renders it richly" instead of "thread structured payloads through the matcher". §Text-source-parse-path deferred as separable. |
| Round 2 (kriskowal round-2 review) | 2026-05-20 | `diagnose(err, options)` (error post-processor needing `try`/`catch`) reshaped into `diagnose({ specimen, pattern })` (non-throwing matcher mirroring `matches(specimen, pattern): boolean`). Renderer split into `compact` (default; one-line-per-mismatch sized for AI-agent token economy) + `expanded` (indented Rust-compiler-style for humans at a REPL). §Cause-chain-fallback-phase dropped (no error means no chain to walk). |
| Round 3 (kriskowal round-3 review) | 2026-05-20 | Sibling-package framing **retired** in favor of a submodule of `@endo/patterns` itself, exported as `@endo/patterns/explain-mismatch.js`. Direct access to `matchHelpers` registry and `confirmMatches` recursion; §the-drift-vs-stable-internal-surface tension a sibling would have introduced dissolves. Two-function `diagnose` + `render` API folded into single `explainMismatch({ specimen, pattern, context?, format?, width?, color? })`. |

§honest-design-evolution-record at higher fidelity than cycle 197's @endo/panic README — three pivots visible vs one. §honest-design-evolution-record family member (cycles 178/180/183/184/188/192/196/197/198).
