---
title: "§Compact format: column separator `|` not JSON-Lines"
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

```
mismatch (or, 3 alternatives, none matched): { kind: "image", url: 42 }
  alt 0 | .url | found 42 (number) | expected string
  alt 1 | .kind | found "image" | expected "text"
  alt 2 | .kind | found "image" | expected "embed"
```

§Four-column-shape: `path | found | expected | reason`. §No-key-names-per-line (no `"path":` repetition). §No-quoting-overhead.

§Equally-machine-parseable: §a-one-line-`split(' | ')`-recovers-the-columns.

§JSON-Lines was considered and rejected — §a-consumer-that-genuinely-wants-JSON-gets-a-future-second-export, not §a-configuration-knob-on-the-string-renderer.

§The-choice-favors-line-grep over §structured-deserialization. §Tier-1-borrowable: §pipe-separated-columns-for-line-greppable-machine-readable-format.
