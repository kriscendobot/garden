---
title: §Two-consumer-postures (library users + AI agents)
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

§Library-users writing `M.splitRecord(...)` shapes against incoming CapTP traffic see a failure in their AVA log and have to manually walk the specimen against the pattern in a REPL to find the offending field.

§AI-agents that construct patterns from natural-language or JSON-Schema inputs (the `endo-but-for-bots` audience) see the same message but §cannot-walk-the-specimen-interactively. They retry with random perturbations until the message changes, which is §expensive-and-frequently-masks-the-underlying-mismatch.

§AI-agents-cannot-walk-the-specimen-interactively is the §unique-cost-AI-agents-pay that humans don't. §library-users have escape hatches AI agents don't. §the-design-addresses-both. §Sibling-pattern to cycle 196 endoclaw's §two-consumer-postures (assistant + coding-agent) — the design names §who-suffers-most-without-this-feature explicitly.

§Compact-default-is-AI-tuned: §an-agent-has-less-budget-per-token-than-a-human and §a-one-line-per-mismatch-shape-is-both-smaller-and-easier-to-line-grep.
§Expanded-opt-in-is-human-tuned: §a-human-who-wants-the-indented-Rust-compiler-style-view-passes-`{ format: 'expanded' }`.

§Default-favors-the-tighter-budget-consumer (AI agents) rather than the looser (humans) — §the-design-defends-the-token-budget-by-default.
