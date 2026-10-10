---
title: "CycloneDX SBOM and dependency graph: Component and package inventory"
source: docs/architecture/sbom-and-dependency-graph.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [software-supply-chain, agentic-sdlc]
status: current
---

> Abstract: Both SBOM stages share an immutable managed subgraph containing the root, exact Component closure, repository-only source dependencies, and relationship identities; package, toolchain, runtime, and binary nodes may extend this graph but cannot rewrite it.

The graph begins with dependencies managed by Literate AI itself. Both the source and
resolved SBOM bind the same exact resolved graph identity and always include:

- the root Component revision;
- every Component revision in its exact selected dependency closure;
- every declared repository-source dependency, even though that source has no Literate
  AI specification of its own; and
- every exact managed relationship, including its source, target, dependency kind,
  optionality, and relationship identity.

Stable `bom-ref` values derive from exact framework identities. Namespaced CycloneDX
metadata binds that authority as `literate-ai:resolved-graph-identity`; lock-native
generation uses the exact `ComponentLock` identity, while legacy composition-native
generation uses the exact `ComponentComposition` identity. Component properties preserve
the Component revision or repository-source declaration identity, node kind and scope,
and one canonical record for every managed relationship. Standard CycloneDX `dependsOn`
represents reachability and may deduplicate the same source/target pair; the namespaced
record still preserves each relationship's kind, optionality, and exact identity.
Package-manager, toolchain, runtime, system-library, and other binary nodes may extend
this managed subgraph; they cannot change its resolved graph identity or replace, rename,
add, or omit a managed Component relationship.

A Component is distinguished by its accepted specification and ability to regenerate
source. Repository-only OSS remains a normal managed dependency node without pretending
that it has a Literate AI specification. A mutable selector may become an exact commit
only through typed source-lock evidence binding the snapshot, tree, resolver, index,
admission, and cache record. The ordinary `litai generate` CLI fails closed until an
integration supplies that exact admitted evidence.

Source: [docs/architecture/sbom-and-dependency-graph.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/sbom-and-dependency-graph.md) at commit `fcc40bc` (source lines 48–98).
