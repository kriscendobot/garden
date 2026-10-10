---
title: "Retained library bindings: the provider-neutral export set"
source: docs/architecture/retained-library-bindings.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, tooling]
status: current
---

> Abstract: `literate-ai/retained-library-export-set@1` binds an existing `ArtifactBuildGraph`, one exact link plan, and the typed library product for every `library`-role export (ordered, unique; missing/extra/substituted products refuse); the graph stays authoritative for closure checks, parsing is pure structural validation with no accepted flag, and admission must separately reopen current independent qualification (ADR 0040 owns the bridge design).

[ADR 0040](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0040-retained-cargo-library-bridge.md) owns the retained
Cargo bridge design. Its implementation begins with a provider-neutral export
set and bounded explicit delivery. This document separates those integrity checks
from the remaining qualification admission, Cargo integration and source retirement.

`literate-ai/retained-library-export-set@1` binds an existing `ArtifactBuildGraph`,
one exact link-plan identity from that graph, and the existing typed library
product for every graph export whose role is `library`. Every selected link root
must be a library. Products are unique and ordered by their full export identity;
a missing, extra or substituted product refuses. The full export binds Component,
ABI, target, producer, source tree, toolchain, authorization, transitive artifact
dependencies and exact package bytes. The product additionally binds its import
surface and public interface identities.

The graph remains authoritative for missing-dependency, cycle and exact-closure
checks. Explicit non-library dependencies remain in the graph; the export set
does not pretend every native dependency is an importable library. Multi-output
manifests retain their declared outputs. Selecting one link plan does not silently
rewrite those manifests or remove their other outputs.

Parsing is pure structural validation. A caller can describe an incorrect import
surface and obtain a different content identity; that cannot qualify the new
surface. No accepted/authenticated flag is allowed. Admission must separately
reopen current independent qualification and match it to the exact export set,
reviewed importer trust, target/toolchain/features, materialization destinations
and Cargo integration plan. Those admission bindings, transactional materialization and acknowledged boundary
transfer remain open. The bounded delivery adapter below is not consumer admission.
The frozen v1 catalog is unchanged; the export-set record belongs to current v2.

Source: [docs/architecture/retained-library-bindings.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/retained-library-bindings.md) at commit `fcc40bc` (source lines 1–30).
