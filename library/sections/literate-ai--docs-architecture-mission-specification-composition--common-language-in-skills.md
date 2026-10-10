---
title: Common conversion language belongs in skills, not specs
source: docs/architecture/mission-specification-composition.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: A Component specification states observable product intent; a generation skill states reusable conversion practice; a Flavor states target requirements; a workflow states stage order. Feature specs therefore should not repeat conversion mechanics the canonical skills own, and agent-written glue stays generated reasoning, so any glue that creates observable behavior, a public interface, or a new constraint must come back as a proposed spec change.

The Component specification states observable product intent: objective, scope, interfaces, invariants, errors, examples, and measurable acceptance. A generation skill states reusable conversion practice: how to reconcile inherited context, preserve public interfaces, generate current tests, avoid private transitive coupling, and surface contradictions. A Flavor states target-specific requirements. A workflow states stage order.

Accordingly, a feature spec should not repeat statements such as "keep generated source outside the repository," "generate tests for every current requirement," "use only direct public dependency contracts," or "prefer Bazel unless overridden." The canonical planning and implementation skills own those instructions once. In the document's framing, moving that language out of a spec does not weaken the product contract; it prevents conversion mechanics from masquerading as product behavior.

An agent may write implementation glue or planning rationale needed to make selected Components work together. That language remains generated reasoning, not silent new specification authority. If the glue creates observable behavior, a public interface, or a new constraint, the agent must propose a spec change for review.

Source: [docs/architecture/mission-specification-composition.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/mission-specification-composition.md) at commit `fcc40bc`.
