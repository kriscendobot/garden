---
title: "Sample portfolio review: correctness conclusion"
source: docs/architecture/sample-portfolio-review.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [testing, agentic-sdlc]
status: current
---

> Abstract: The catalog's executable correctness boundary combines complete runnable recipes, pinned and entropy-derived verifier cases (or a stateful cross-process verifier), withheld expected results, exact acceptance-interface binding, deterministic arithmetic and ordering, and repository checks against checked-in generated source, while explicitly declining to claim universal implementation correctness or unstated production properties.

> Curator note: the source's portfolio table lists 25 samples, while the paragraph below says “twenty-one applications.” Both are preserved as source evidence; readers should treat the total as internally inconsistent.

All twenty-one applications define complete recipes for runnable artifacts. Twenty use
two pinned verifier cases plus a third post-build entropy-derived case during E2E
execution. The durable portfolio instead owns a stateful verifier across its four
independently built process boundaries, including restart and failure transitions that
cannot be represented by one entrypoint invocation. Public generation recipes do not
contain expected results. The verifier binds the exact acceptance interfaces and runs
the same built artifacts used by generated
current-state tests. The behavior contracts use integer arithmetic where financial or
scheduling precision matters and specify ordering or tie-breaking wherever map, graph,
or set order could leak into output. The repository conformance suite independently
checks that every sample remains a strict spec-driven application with no checked-in
generated source.

That is a strong executable correctness boundary. It is not a proof that every possible
generated implementation is defect-free, and the intentionally small Components do not
claim production concerns absent from their specs. In particular, the record vault is
not distributed storage, the endpoint router is not a service mesh, and the security
gate is not a scanner.

Source: [docs/architecture/sample-portfolio-review.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/sample-portfolio-review.md) at commit `fcc40bc` (source lines 65–84).
