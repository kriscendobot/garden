# Topic: software-supply-chain

> Abstract: Dependency inventory and build-provenance systems that bind source declarations to resolved packages, toolchains, runtimes, native libraries, build inputs, artifacts, and receipts. The topic emphasizes graph completeness, standards-based SBOMs, non-executing observation, transition invariants, and the boundary between historical provenance and current authorization.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [literate-ai--docs-architecture-sbom-and-dependency-graph--source-and-resolved-sbom-lifecycle](../sections/literate-ai--docs-architecture-sbom-and-dependency-graph--source-and-resolved-sbom-lifecycle.md) | literate-ai SBOM and dependency graph | Pre-build managed dependency evidence and post-build observed closure are separate mandatory gates joined by identity preservation. |
| [literate-ai--docs-architecture-sbom-and-dependency-graph--component-and-package-inventory](../sections/literate-ai--docs-architecture-sbom-and-dependency-graph--component-and-package-inventory.md) | literate-ai SBOM and dependency graph | Both SBOM stages share an immutable managed Component, repository-source, and relationship subgraph. |
| [literate-ai--docs-architecture-sbom-and-dependency-graph--completeness-and-build-evidence](../sections/literate-ai--docs-architecture-sbom-and-dependency-graph--completeness-and-build-evidence.md) | literate-ai SBOM and dependency graph | Explicit graph completeness, source reconciliation, and retained Bazel evidence gate the build before tests. |
| [literate-ai--docs-architecture-sbom-and-dependency-graph--non-executing-host-observation](../sections/literate-ai--docs-architecture-sbom-and-dependency-graph--non-executing-host-observation.md) | literate-ai SBOM and dependency graph | Native, npm, and Python closures are observed without executing generated binaries or opaque wrappers. |
| [literate-ai--docs-architecture-sbom-and-dependency-graph--cache-receipt-and-trust-boundaries](../sections/literate-ai--docs-architecture-sbom-and-dependency-graph--cache-receipt-and-trust-boundaries.md) | literate-ai SBOM and dependency graph | Dependency evidence is revalidated through cache and receipt boundaries, and never substitutes for current authorization. |

## See also

- [agentic-sdlc](agentic-sdlc.md) — the larger specification-to-artifact lifecycle in which dependency evidence is produced and checked.
- [package-manifest](package-manifest.md) — package-manager declarations consumed as source-side dependency evidence.
- [testing](testing.md) — tests that run only after dependency evidence passes its lifecycle gates.
