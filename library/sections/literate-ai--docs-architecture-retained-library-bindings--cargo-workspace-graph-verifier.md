---
title: "Retained library bindings: the Cargo workspace graph verifier"
source: docs/architecture/retained-library-bindings.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [tooling, testing]
status: current
---

> Abstract: `verify_cargo_workspace_graph` compares an observed `cargo metadata` format-1 document with an independently supplied `CargoWorkspaceExpectation`: every local package, dependency declaration and resolved edge, membership, resolved features, and every target, refusing external substitutes and external-to-local back edges; package IDs stay opaque, it performs no I/O, and a native fixture exercises offline metadata with aliases, conditional and inactive edges.

The internal `verify_cargo_workspace_graph` adapter compares an observed Cargo
format-version-1 document with an independently supplied `CargoWorkspaceExpectation`.
It requires every local package at its exact workspace-relative manifest root,
name and version; the complete local dependency declarations and resolved edges;
workspace and default membership; resolved feature sets; and every Cargo target,
including test/doctest flags, source path, edition and required features. Explicit
output-directory agreement keeps the observed Cargo output separate from nested
package roots; an unreviewed separate build-directory override refuses. Inactive
optional declarations remain part of the check. External packages cannot substitute
for expected local packages, and a dependency from an external package back to a
local package refuses because this expectation does not describe external consumers.
Ordinary external dependency qualification remains with the reviewed Cargo.lock
and provisioned dependency policy.

Package IDs are opaque, and additive metadata fields remain compatible with
[Cargo's metadata contract](https://doc.rust-lang.org/cargo/commands/cargo-metadata.html).
A filtered report can retain a conditional dependency kind when another declaration
resolves the same package. The expectation therefore states whether each edge is
present in the observed resolution; that field is not a claim that its target
predicate executed. Invocation, toolchain, target and feature custody still belong
to the importing integration plan.

The graph verifier performs no I/O and has no public apply/CLI operation. Its
immutable expectation is shared with the workspace-plan contract; parsing it does
not qualify the graph or prove that the caller reviewed it. The trusted importer must still reopen current
provider evidence, bind the manifests and lockfile, run the exact locked Cargo
command, maintain materialized-package custody through build/test, and preserve
full workspace acceptance before source retirement. The native fixture exercises
metadata only: a fresh Cargo home, offline resolution, normal/dev/build aliases,
a conditional edge, an inactive optional edge, a transitive local library and
workspace globs. Exact file inventories before and after metadata are unchanged.

Source: [docs/architecture/retained-library-bindings.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/retained-library-bindings.md) at commit `fcc40bc` (source lines 397–427).
