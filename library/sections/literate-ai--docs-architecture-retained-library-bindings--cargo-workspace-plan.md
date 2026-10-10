---
title: "Retained library bindings: the Cargo workspace plan"
source: docs/architecture/retained-library-bindings.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [tooling, agentic-sdlc]
status: current
---

> Abstract: `literate-ai/retained-cargo-workspace-plan@1` pins the workspace root, full expected native graph, Cargo/rustc identities, target triple, features, and gate commands; manifest changes pin before/after blobs (absence explicit), inputs cannot alias or overlap Cargo output, metadata commands run `--locked` with an explicit target and separate `CARGO_TARGET_DIR`, and reopening is pure byte/graph matching with no I/O.

The Rust workspace reference can now contain a canonical
`literate-ai/retained-cargo-workspace-plan@1` document. It records the project-relative
workspace root, full expected native graph, Cargo/rustc identities, named target
triple, explicit feature switches and existing gate commands. Manifest changes pin
before/after blob references; absence is explicit, and unchanged references remain
read preconditions. Prospective inputs must include the workspace manifest, lockfile
and every expected local package manifest. Paths cannot alias, and Cargo output
cannot overlap these inputs or target sources. Source inventory and ownership
remain with the separate boundary-transfer plan.

The graph uses the same typed expectation as the native Cargo verifier, preserving
dependency aliases/kinds, inactive edges, target sources and test flags through
serialization. Plan-derived metadata commands use `--locked`, an explicit target
and feature configuration, optional `--offline`, and a separate `CARGO_TARGET_DIR`.
Reopening checks bounded exact canonical bytes against the binding, then matches
each Rust library's package name and destination to the planned graph and refuses
output overlap with any bound export. It performs no I/O or execution. Later
admission must resolve current tool identities, compare the recorded gates with
current retained authority, verify actual manifest bytes and Cargo resolution, and
keep package custody throughout full consumer qualification.

Source: [docs/architecture/retained-library-bindings.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/retained-library-bindings.md) at commit `fcc40bc` (source lines 48–67).
