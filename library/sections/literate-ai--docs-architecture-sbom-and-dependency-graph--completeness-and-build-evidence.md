---
title: "CycloneDX SBOM and dependency graph: completeness and build evidence"
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

> Abstract: SBOM completeness means explicit dependency entries for every node, root reachability, exact managed-graph reconciliation, semantic range checking, and inert source-manifest/import inspection; Bazel adds retained, bounded, content-addressed resolution and input-consumption evidence without mutating the admitted source tree.

The validated profile follows the CycloneDX dependency-graph and composition rules:

- the root and every Component or service inventory object has exactly one explicit
  `dependencies` entry;
- every direct and transitive edge uses `dependsOn` and references an existing `bom-ref`;
- leaves have an explicit empty `dependsOn` array rather than an omitted entry;
- every inventory node is reachable from the root; and
- root composition is `complete`, except that a pre-build document may use
  `incomplete_third_party_only` for an authorized resolver's explicitly unknown closure.

For the managed portion, inventory inclusion is not enough. Unknown or omitted owners,
alternate references claiming the same identity, changed scopes, and missing or changed
relationship records all fail validation. An omitted dependency entry means unknown
information, not a compact leaf. The source document may carry an external range; the
resolved document requires exact versions and returns to `complete`. Range resolution is
semantic and rejects unsupported ecosystems, malformed ranges, and versions outside the
declared range.

Before a generated build begins, source admission reconciles supported manifests, locks,
and external imports with the source SBOM. The reference covers Python requirements and
lock formats, JavaScript `package.json` and `package-lock.json`, Rust Cargo manifests and
locks, C++ `vcpkg.json`, and corresponding imports or includes. JavaScript observation is
lexical and inert: comments, regular expressions, template text, and ordinary strings do
not masquerade as executable imports.

For Bzlmod, literal `bazel_dep` versions are intent rather than final lock evidence because
Minimal Version Selection can choose a newer compatible transitive request. Inert
pre-build inspection accepts a narrow literal `module()`/`bazel_dep()` subset and fails
closed on overrides, extensions, includes, legacy `WORKSPACE` authority, and dynamic
Starlark. After build authorization, an external projection resolves and replays the
graph in lockfile-error mode. The adapter retains `MODULE.bazel.lock`, raw module and
repository observations, exact Bazel identity, build-file and source-input queries, and
a content-addressed `BuildInputConsumption` record bound to the admitted source tree.

The lifecycle independently parses raw evidence rather than trusting normalized claims.
Evidence and artifact manifests bind authorization, Component revision, build plan,
source tree, resolver and toolchain, graph, consumed inputs, executable, and resolved BOM.
Missing, extra, replaced, linked, oversized, noncanonical, or authority-mismatched
evidence fails before tests. The current profile is deliberately bounded: extension-made
repositories and target-used actions remain unknown until a future profile models them;
it must not be marketed as universal dependency knowledge.

Source: [docs/architecture/sbom-and-dependency-graph.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/sbom-and-dependency-graph.md) at commit `fcc40bc` (source lines 99–240).
