---
title: "ADR 0005: Phase-specific dependency-edge semantics"
source: docs/decisions/0005-executable-component-semantics.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: `executable-component-edge-semantics@1` assigns each generation, build, runtime, validation, toolchain, packaging, or deployment edge exactly one consumer phase, provider barrier, and consumed input; relationships with multiple effects use multiple edge records instead of phase-dependent overloaded meaning.

The semantics are versioned as `executable-component-edge-semantics@1`.

| Edge kind | Consumer phase | Provider barrier | Consumed input | Visible during generation |
| --- | --- | --- | --- | --- |
| generation | generate | none; interface is already locked | public interface | yes |
| build | build | provider build | artifact export | no |
| runtime | run | provider build | runtime artifact export | no |
| validation | validate | provider validation | validation evidence | no |
| toolchain | build | provider build | toolchain export | no |
| packaging | package | provider package | package export | no |
| deployment | deploy | provider deploy | deployment evidence | no |

An edge has exactly one kind. When a relationship has more than one effect—for example,
a public API used during generation and a library linked during build—the lock contains
two edge records. This avoids an overloaded edge whose meaning changes by phase.

Source: [docs/decisions/0005-executable-component-semantics.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0005-executable-component-semantics.md) at commit `fcc40bc` (source lines 65–81).
