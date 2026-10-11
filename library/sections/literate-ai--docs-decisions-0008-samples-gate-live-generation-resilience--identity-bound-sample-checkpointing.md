---
title: "ADR 0008: Identity-bound sample checkpointing"
source: docs/decisions/0008-samples-gate-live-generation-resilience.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing, software-supply-chain]
status: current
---

> Abstract: A sample-level state file records genuine successes under the same recipe and generation-key identities the gate already computes, allowing a rerun to skip matching work while invalidating every entry whose current inputs differ.

Following the existing checkpointed-gates pattern, the sample runner writes a state
file beneath `OBJ_DIR`. Each success is keyed by the gate's existing per-sample content
identity, including recipe and generation-key inputs. A rerun after retry exhaustion or
operator interruption skips only an identity-matched success.

Changed inputs invalidate the entry. A checkpoint skip is not a new pass, and failed
or incomplete samples never enter the checkpoint. This keeps cache state an
optimization rather than acceptance authority.

Source: [docs/decisions/0008-samples-gate-live-generation-resilience.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0008-samples-gate-live-generation-resilience.md) at commit `fcc40bc6` (source lines 142-151).
