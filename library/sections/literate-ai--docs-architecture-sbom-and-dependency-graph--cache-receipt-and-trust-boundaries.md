---
title: "CycloneDX SBOM and dependency graph: cache, receipt, and trust boundaries"
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

> Abstract: SBOM graph authority originates in the generation request and is revalidated through resolver, cache, workspace, and receipt boundaries; cached evidence is provenance rather than current authorization, and an SBOM remains inventory rather than a vulnerability, license, signature, or safety verdict.

`GenerationRequest` carries the exact managed SBOM graph as application authority. The
orchestrator independently compares Component nodes and relationship evidence with the
current composition and includes the graph in immutable run and model-stage inputs.
Before build, the resolver must return a typed source-BOM binding whose bytes and graph,
composition, and root identities match that authority. The post-build result must
reproduce the pre-build binding and validation identity; internally consistent bindings
for a different composition are rejected.

The concrete resolver remains in the trusted computing base for semantic validation and
observation of resolved bytes. The application validates returned content identities and
current authority bindings without duplicating CycloneDX logic or opening an
adapter-owned path. On publication and reload, the cache adapter reads both BOMs from its
content-addressed store and repeats strict validation against the serialized managed
graph. A custom resolver therefore needs the same operator trust as another pinned
lifecycle adapter; a typed result alone is not remote attestation.

Source and resolved BOM byte identities, normalized graph identities, managed graph
identity, and the resolved-to-source identity travel with generation, cache, workspace,
and receipt evidence. Cache entries retain both SBOMs, exact source, generated tests,
acceptance records, and ordered repository-source resolutions. Reload replays those
projections, so serialization cannot erase dependencies whose source was fetched rather
than generated.

Historical evidence is provenance, not current authorization. A cache hit is an
acceptance-untrusted candidate: the current lifecycle must re-index, validate, classify,
authorize, build, verify its resolved SBOM, run generated tests, and independently accept
the materialized tree. An SBOM is inventory evidence, not a vulnerability verdict,
license approval, signature, or safety claim. A compact Git receipt may record both SBOM
binding identities, but does not embed the documents or authenticate a remote store.

Source: [docs/architecture/sbom-and-dependency-graph.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/sbom-and-dependency-graph.md) at commit `fcc40bc` (source lines 320–361).
