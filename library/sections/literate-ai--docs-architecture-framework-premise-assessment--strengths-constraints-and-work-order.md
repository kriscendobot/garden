---
title: Framework premise assessment: strengths to keep, constraint classification, and work order
source: docs/architecture/framework-premise-assessment.md
source_repo: jordanhubbard/literate-ai
source_commit: 08ff70273a5462cf4d205b730f445a296cb3f067
source_date: 2026-10-03
source_authors: [jkh]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: The assessment lists the design strengths to preserve, sorts claims into hard invariants (exact identities, independent verification, cache never authority, authorization before execution, immutable CAS, signatures prove integrity not safety), removable policies (Bazel, CycloneDX 1.7, yolo vocabulary), and claims to relax (universal disposability, exhaustive provenance, complete dynamic closures), then gives a ten-step work order and its verification run.

**Preserve:** the separation of invariants, policy, and deferred claims (ADR 0003); exact identities at authority crossings rather than indiscriminate hashing; generated tests versus independent verifier oracles; cache materialization staying current-acceptance-untrusted; typed Flavor contributions instead of unordered overlays; exact skill pins instead of ambient agent instructions; the Component versus repository-only dependency distinction; pre- and post-build CycloneDX evidence preserving the managed graph; source-derived specs staying drafts until explicit review; and the boundary between Literate AI as derivation engine and MAC as agent/task ledger.

**Hard invariants:** exact identities at semantic authority and execution boundaries; generated tests distinct from independent verification; cache contents never becoming authority; explicit authorization before compilation or host execution; immutable content-addressed objects with separate mutable projections; a valid signature proves integrity or origin, never behavioral safety.

**Valuable policies, not invariants:** Bazel as the removable preferred build Flavor; no source-graph indexer as a product dependency; CycloneDX 1.7 as the SBOM wire standard; the yolo profile name and privilege vocabulary; the repository's full cross-platform sample matrix.

**Relax or defer:** universal source disposability; exhaustive provenance for every internal operation; absolute completeness of every dynamic runtime closure; enterprise-safe execution before an OS containment boundary exists. Dependency evidence should be honest, explicitly bounded knowledge: the managed graph can be complete; the declared package graph complete to a named resolver boundary; the observed binary closure complete under a named environment and observer; a dynamic runtime closure may be bounded, incomplete, or unknown.

**Recommended order of work** (executed as the repository's framework score-improvement program):

1. Make fungibility an earned Component qualification state.
2. Fix source-free promotion and qualification defects before another release.
3. Extract and ship one reusable lifecycle application service and standard driver.
4. Generate, cache, and build per Component rather than flattening the graph.
5. Add a bounded, identity-bearing compiler and test repair loop.
6. Keep human `component.md` intent separate from generated `component.lock.json`.
7. Replace keyword parity with normalized requirement graphs, property tests, mutation testing, and invalid-input cases.
8. Add one stateful, networked, dependency-bearing application using a package and a pinned Git dependency.
9. Add authenticated nightly and release workflows producing the compact current receipt.
10. Add a production sandbox before enterprise-security claims.

**Verification performed.** The full non-live suite ran 770 tests (764 passed, 1 failed, 5 skipped, 455.5 s); the failure was a conflict between an active indexer daemon and a validator treating live SQLite sidecars as frozen, later resolved by validating against a disposable race-checked mirror and consistent backup. A focused inverse suite passed 55 tests in 9.57 s; credentialed live coding-agent tests were not run. No repository files were modified during the assessment.

Source: [docs/architecture/framework-premise-assessment.md](https://github.com/jordanhubbard/literate-ai/blob/08ff70273a5462cf4d205b730f445a296cb3f067/docs/architecture/framework-premise-assessment.md) at commit `08ff702`.
