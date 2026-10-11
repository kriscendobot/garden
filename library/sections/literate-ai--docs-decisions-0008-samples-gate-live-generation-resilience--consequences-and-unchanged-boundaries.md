---
title: "ADR 0008: Consequences and unchanged boundaries"
source: docs/decisions/0008-samples-gate-live-generation-resilience.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Retry and checkpointing reduce repeated live-generation cost without relaxing sample acceptance, changing top-level release checkpoints, or conflating transient failures with provider denial; their main risk is stale checkpoint identity or an overbroad retry allowlist masking real defects.

Hard-denial provider fallback remains unchanged. Deterministic failures still fail after
their applicable retry policy, and the checkpoint stores only genuine successes. The
change is internal to the sample matrix rather than the existing Python and release
checkpoint layers.

The benefit is avoiding regeneration of already-passing samples and suppressing
transient failures before they abort the gate. The cost is new state and policy: loose
identity invalidation could mistake stale evidence for a current pass, while blanket
retry could delay a useful deterministic failure. Both identities and retryable error
codes must therefore stay explicit and narrow.

Source: [docs/decisions/0008-samples-gate-live-generation-resilience.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0008-samples-gate-live-generation-resilience.md) at commit `fcc40bc6` (source lines 153-178).
