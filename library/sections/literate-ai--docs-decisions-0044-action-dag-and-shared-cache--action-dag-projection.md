---
title: "ADR 0044: Action DAG projection and late assembly edges"
source: docs/decisions/0044-action-dag-and-shared-cache.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: Schedule exact (Component revision, lifecycle action) nodes that become ready on their own predecessor evidence, with runtime and packaging edges bound late and exactly.

The scheduler projects the exact `(Component revision, lifecycle action)` graph from resolved execution plans, keeping generation, indexing, source admission, build, test, execution, independent acceptance, link/import, package, and finalization as distinct nodes where contracts permit. An action is ready once its own required predecessor evidence is accepted; it never waits for a former layer. Build intent follows source indexing and precedes authorization; build/toolchain dependencies gate intent, runtime dependencies gate execution, and packaging/deployment dependencies gate linking, and none may become a transitive barrier to consumer compilation. Projection checks inspect transitive predecessors, since direct edges alone miss serialization.

Runtime and packaging assembly edges are bound to exact consumer/provider artifacts, locked edge identity, kind, and accepted provider evidence, and enter the verified transitive link closure without rewriting build manifests or promoting provider artifacts to entrypoints. Missing endpoints, duplicates, cycles, and substituted closures are rejected; an empty late-edge set preserves legacy identities. Deployment-evidence dependencies keep their own semantics and never authorize adding provider artifacts to a runtime package.

Source: [docs/decisions/0044-action-dag-and-shared-cache.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0044-action-dag-and-shared-cache.md) at commit 2820f853.
