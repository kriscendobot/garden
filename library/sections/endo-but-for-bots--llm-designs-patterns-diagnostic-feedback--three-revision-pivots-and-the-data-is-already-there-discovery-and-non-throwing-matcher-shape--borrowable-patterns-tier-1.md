---
title: §Borrowable patterns (tier-1)
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

1. **§three-revision-pivots-visible-in-Prompt-section** — preserve the review trail in the source itself; future readers see the design's evolution, not just its endpoint.
2. **§the-data-is-already-there-just-locked discovery** — before adding storage, check if the data is already stored somewhere unreachable. §Discovery-driven-redesign: build a renderer that reads what already exists instead of threading new storage through the production path.
3. **§non-throwing-matcher mirroring an existing non-throwing API shape** — when a feature could be an "error post-processor", check if a sibling API is already non-throwing; if so, mirror its shape.
4. **§opt-in-submodule with cost-asymmetry** — production path pays zero; only callers that import the submodule pay. Bundler / ESM-loader / `package.json exports` mechanics make this enforceable without convention.
5. **§submodule-not-sibling-package** — when the diagnostic facility needs internal access, a submodule with direct registry access dissolves the drift-vs-stable-internal-surface tension a sibling package would have introduced.
6. **§rich-not-configurable rendering convention** with §Rust-compiler-error-analogy as cited prior art.
7. **§all-alternatives-reported, ranked-by-depth-of-match, no-heuristic-suppresses-the-others** — show all candidates and let the reader pick.
8. **§two-consumer-postures named explicitly** (library users + AI agents) with §AI-agents-cannot-walk-the-specimen-interactively as the unique cost AI agents pay.
9. **§compact-default + expanded-opt-in** with §default-favors-the-tighter-budget-consumer (AI agents) rather than the looser (humans).
10. **§pipe-separated-columns for line-greppable machine-readable format** — `path | found | expected | reason` beats JSON-Lines for line-grep without sacrificing parseability (`split(' | ')`).
11. **§ASCII-not-unicode** for terminal/log/CI compatibility, with §future-unicode-trivial-to-add if a caller asks.
12. **§tracing-recursion-reuses-helpers-in-place** — one source of matcher truth; a change to a helper updates both lanes simultaneously; no parallel implementation to drift.
13. **§seven-trace-step-kinds discriminated-union** for step-kind-discrimination that string/number labels lacked.
14. **§each-Design-Decision-names-the-alternative-it-rejected** — not "here's what we did" but "here's what we considered and why we chose one".
15. **§nine-Design-Decisions canonical format** — sibling to cycle 184/188/192/194/196 same-shape format.
16. **§single-PR-scope-despite-three-revision-rounds** — review rounds shrank the scope, not expanded it. §Each-review-round-was-a-simplification.
17. **§explicit-no-predecessors-row** in the Dependencies table — negative space as record.
18. **§future-helpers-named-not-shipped** (`explainExoCall`, structured-trace export, JSON export, `style: 'unicode'`) — minimal public surface with named extension points; future-pattern reflects what cycle 197 panic also documents as §three-named-future-extensions.
19. **§single-Open-Question-discipline** as §design-maturity-signal.
20. **§composition-without-modification** of `@endo/exo` — the `context` field on `ExplainMismatchInput` carries the method-name + argument-index prefix without any exo change required.
