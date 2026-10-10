---
id: sbom-transition-invariant
aliases: [source-to-resolved SBOM invariant, pre-build post-build SBOM preservation, dependency evidence transition]
topics: [software-supply-chain, agentic-sdlc]
---

# sbom-transition-invariant

A two-stage dependency-evidence rule: the post-build SBOM must preserve the exact managed identities, references, edges, and relationship records of the admitted pre-build SBOM while narrowing authorized external ranges to exact versions and adding independently observed transitive closure. It may extend knowledge but cannot silently remove, rename, reparent, or reinterpret the source graph.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Source and resolved SBOM lifecycle](../sections/literate-ai--docs-architecture-sbom-and-dependency-graph--source-and-resolved-sbom-lifecycle.md) | Establishes the two mandatory lifecycle documents and their ordered gates. |
| [Component and package inventory](../sections/literate-ai--docs-architecture-sbom-and-dependency-graph--component-and-package-inventory.md) | Defines the managed subgraph that neither stage may rewrite. |
| [Completeness and build evidence](../sections/literate-ai--docs-architecture-sbom-and-dependency-graph--completeness-and-build-evidence.md) | Requires explicit reachability and retained resolver evidence before closure can be called complete. |
| [Non-executing host observation](../sections/literate-ai--docs-architecture-sbom-and-dependency-graph--non-executing-host-observation.md) | Permits exact-version and transitive additions while rejecting managed-edge removal or substitution. |
| [Cache, receipt, and trust boundaries](../sections/literate-ai--docs-architecture-sbom-and-dependency-graph--cache-receipt-and-trust-boundaries.md) | Carries and revalidates the transition identities across caches, workspaces, and receipts. |

## See also

- [[specification-authority-chain]] — the larger authority/evidence sequence containing the two SBOM stages.
