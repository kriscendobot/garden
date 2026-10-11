---
title: "ADR 0003: Flow classification"
source: docs/decisions/0003-constraint-classification.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: The lifecycle is an invariant partial order—accepted specification before generation, validation and classification before authorization, authorization before build or execution, and explicit publication—while stages, providers, Flavors, toolchains, and fallback choices remain pinned policy and several sandbox, provenance, evidence, and CLI properties remain deferred.

The high-level lifecycle is a partial order, not a fixed implementation pipeline:

- accepted specification and selected Flavor requirements precede generation;
- validation and classification of the exact generated tree precede build
  authorization;
- authorization precedes compilation or host execution; and
- publication is explicit and never follows from a local build alone.

Those dependency relationships are invariants. Stage names, the number of model stages,
eligible providers, Flavor selections, toolchains, sandbox profiles, and whether an
approved model fallback is allowed come from pinned policy. `litai rebuild` exposes the
complete project lifecycle through a content-pinned project driver; phase-specific
project validation, planning, generation, receipts, and source-to-specification remain
direct CLI surfaces. Native lifecycle services remain injected adapters rather than
hard-coded neutral-CLI policy.

The bootstrap restriction that every Flavor slot use a different axis is retired. It
was a data-model shortcut, not an invariant, and prevented ordinary multi-role systems.
Slot IDs are the selection authority: an axis-wide target remains convenient when the
axis occurs once, while repeated axes require unambiguous slot-scoped constraints.

The following remain delivery claims, not guarantees:

- a hardened operating-system sandbox suitable for arbitrary hostile source;
- exhaustive provenance coverage for every lifecycle transition and projection;
- authenticated resolution of external evidence named by project test receipts; and
- every lifecycle service being available as an independent first-class public CLI
  command, rather than as a pinned `litai rebuild` driver phase.

Source: [docs/decisions/0003-constraint-classification.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0003-constraint-classification.md) at commit `fcc40bc` (source lines 45–74).
