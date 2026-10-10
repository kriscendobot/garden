---
title: Lock graph invariants
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

> Abstract: A LockedComponentRevision carries only local forward-generation authority and excludes generated source, provenance, and other evidence; lock nodes bind it to per-node target/Flavor selections and interfaces through a typed decode seam that requires the exact authoring values, and executable edges must match exactly one authored requirement with a constraint-satisfaction record, forming a reachable acyclic graph within declared size limits.

A `LockedComponentRevision` identifies only local forward-generation authority: the complete authoring identity; exact specification, selected-Flavor revision, skill, workflow, routing, acceptance, public-interface, and repository-source selections; exact requirements introduced by selected Flavors, each bound to the declaring Flavor revision; and the coordinate and semantic version needed to review the graph. It deliberately excludes generated source, source snapshots, parent runs, prompts, tests, build artifacts, SBOMs, caches, publication records, qualification, promotion journals, and other provenance.

A `ComponentLockNode` binds that revision to one per-node target/Flavor selection and to every public interface the revision supplies. A lock cannot be constructed or decoded without a typed tuple containing every and only the exact `ComponentAuthoring` values named by its nodes. The decoder binds each to `LockedComponentRevision.definition`, so typed consumers keep the same definition across a v2 serialization round trip; this private validation context is absent from `to_dict`, equality, and lock identity. A missing or substituted definition fails at the typed decode seam, which proves the repeated coordinate/version, ordered specification set, selector kinds/URIs/pins, Flavor slots, public capability interfaces, and repository locks against the authoring values.

An `ExecutableComponentEdge` references locked revision identities and must correspond to one exact consumer requirement authored by the Component or one of its selected Flavors. One requirement selects at most one provider; every non-optional requirement selects exactly one; IDs are unique across both authorities. Capability, dependency kind, optionality, and provider capability/version must satisfy the authored contract, and a generation edge must consume the exact public-interface binding its provider exports.

Every selected requirement has one `RequirementConstraintSatisfaction` in its consumer node that repeats every authored constraint, binds the selected provider, target name, target profile, selection policy, and per-node Flavor selection, and names the resolver's satisfaction evidence. An unconstrained requirement still has an empty record, so omitted evaluation cannot be confused with an evaluated empty constraint set.

All endpoints must exist, every node must be reachable from the root, and the graph must be acyclic. Reachability and cycle checks are iterative and bounded by declared 4,096-node / 16,384-edge limits rather than Python's recursion limit.

Source: [docs/architecture/component-authoring-lock-boundary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/component-authoring-lock-boundary.md) at commit `fcc40bc`.
