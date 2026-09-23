---
title: §The-data-is-already-there-just-locked — the central discovery
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

The original prompt assumed the matcher needed augmenting to carry diagnostics. A close read of `applyLabelingError(func, args, label)` in `@endo/common` revealed the data is mostly already there:

1. On rejection it constructs an outer Error with `` message = `${label}: ${innerErr.message}` `` and annotates via `annotateError(outerErr, X\`Caused by ${innerErr}\`)` (SES `assert.note`).
2. `annotateError` attaches a hidden details record, surfaced by the SES console at log time but **not** present on `err.message` or any enumerable property.
3. The cause chain is reachable only via SES's privileged `takeNoteLogArgs(err)` (internal weakmap accessor) or by capturing console output.

In `packages/patterns/src/patterns/patternMatchers.js`, the matcher uses `applyLabelingError` at every nesting level. A six-level-deep failure produces a six-link annotated cause chain plus a flattened message `"l1: l2: l3: l4: l5: l6: detail"`.

The gap is **not** "the matcher fails to record the path". The gap is "the recorded path is held in a private place, in a string-only format, with no combinator-aware renderer, and the disjunction combinator discards its branch attempts".

§the-gap-is-render-not-record is the load-bearing reframing. §discovery-driven-redesign: "build a sibling package that reads what is already there and renders it richly" instead of "thread structured payloads through the matcher". This is §worth-naming-as-a-pattern: §before-adding-storage-check-if-the-data-is-already-stored. The bonus over cycle 197 panic's design: panic's evolution was security argument; this is information-architecture.

§What-was-already-true:
- Per-level labels preserved as distinct Error objects (chain-walker can recover each label independently).
- SES console already renders the full causal chain (just not in actionable format and not at err.message).
- `InterfaceGuard` argument labeling composes through the same chain — explain-mismatch gets exo composition for free.

§What-was-the-gap:
- No programmatic walker over the cause chain (data lives in SES-internal weakmaps).
- No discrimination of step kinds (a label of `2` could be array index, bag-count index, or alternative branch).
- No combinator awareness at render time (`M.or` over three alternatives currently fails with `"Must match one of [...]"` and abandons all per-alternative chain information).
- No rendering convention (the flat colon-joined message is the only string format).
