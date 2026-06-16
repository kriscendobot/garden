---
title: §Tracing recursion reuses helpers in place — no parallel implementation
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

The submodule's recursion mirrors `confirmMatches` from `patternMatchers.js` but accumulates a structured trace instead of throwing:

```ts
type TraceStep = { kind: 'property', name: string }
              | { kind: 'index', index: number }
              | { kind: 'mapKey', key: Passable }
              | { kind: 'setElement', element: Passable }
              | { kind: 'orBranch', branchIndex: number, branchPattern: Pattern }
              | { kind: 'arrayOfElement', index: number }
              | { kind: 'recordOfEntry', key: string };

type Trace = {
  path: TraceStep[],
  outcome: 'match' | { failure: string, specimenFragment: Passable, expectedFragment: Pattern },
  children: Trace[]
};
```

§Seven-trace-step-kinds (the discriminated-union shape gives §step-kind-discrimination that the today-shape lacks: a label of `2` is now `{ kind: 'index', index: 2 }` or `{ kind: 'orBranch', branchIndex: 2, ... }`).

The recursion §calls-into-the-existing-matchHelpers-registry-directly — there is exactly one source of matcher truth. §No-parallel-implementation-to-drift. §A-change-to-a-helper-updates-both-lanes-simultaneously. §A-shared-test-corpus-exercising-both-`matches`-and-`explainMismatch`-pins-the-verdict-equivalence.

§The-earlier-sibling-package-draft-worried-about-drift; §the-submodule-reshape-dissolves-that-concern-entirely. §Drift-elimination-by-co-location is the §architectural-pay-off of round 3.
