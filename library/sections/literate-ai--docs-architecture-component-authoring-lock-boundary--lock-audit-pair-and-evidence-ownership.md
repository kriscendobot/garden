---
title: One-way lock/audit identity, evidence ownership, and read-only lock observation
source: docs/architecture/component-authoring-lock-boundary.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: The Component lock identity is the selected derivation identity and the catalog audit points to the lock, never the reverse, so rejected-candidate explanations cannot enter cache identity, yet admission re-derives and checks the exact lock/audit pair; shared lock operations own revalidation and rollback-safe publication, read-only health observation never creates storage or treats a retained lock as current, and provenance records may name a lock without entering it.

The Component lock identity is the selected derivation identity. Catalog audit is a separate content-addressed record that points to the lock; the lock never points back. That one-way relationship keeps rejected-candidate explanations out of the selected derivation and cache identity. Lifecycle admission still requires the current exact pair: it reproduces the resolution plan from one captured catalog, checks the audit's graph-bound catalog and resolver identities, reproduces the exact lock, and rechecks that plan through model egress. A graph or catalog change thus requires deterministic re-locking but regenerates source only when selected authority actually changes.

`adapters/component_lock_operations.py` owns lock preparation, exact input revalidation, paired artifact checks, and rollback-safe publication; the CLI delegates to it. Read-only observability must reuse these currentness checks, because reading a retained lock or audit alone does not prove current inputs still match. `adapters/project_lock_health.py::observe_project_locks` keeps each check report, project-relative Component path, and structured refusal beside the gate result; a repository-lock failure leaves Component observations empty rather than claiming they were checked. Its v2 `project-lock-health` serialization is a derived report, not an admitted attestation.

Matrix-scoped lock and resolution-audit stores do not create directories during construction, checks, snapshots, or required reads; an absent artifact reports missing state. Real updates create storage through the safe-directory/write-lock path, and reads revalidate component and storage ancestors so an absent suffix never permits parent traversal, links, reparse points, or non-directory ancestors. The check path is thus suitable for `verify`, and never turns a missing lock or audit into a current result or grants execution authority.

Source-to-specification prompts, source snapshots, promotion journals, qualification proofs, and generation-input audits stay beneath provenance authority: they may name the Component lock involved in a transition but never enter `ComponentAuthoring`, `LockedComponentRevision`, or `ComponentLock`. To avoid an identity cycle, `ComponentInterfaceBinding` (which names a locked revision) lives in `ComponentLockNode` beside the revision; the lock serializes authoring values' identities, never their bytes.

The Python decoder and public JSON Schema enforce the same wire bounds, selector kinds, portable catalog-relative paths, and collection limits; semantic invariants spanning external authoring values and the lock graph are enforced at the mandatory typed decode seam because JSON Schema cannot dereference content identities.

Source: [docs/architecture/component-authoring-lock-boundary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/component-authoring-lock-boundary.md) at commit `fcc40bc`.
