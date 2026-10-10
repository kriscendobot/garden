---
title: HTML observability: derived single-file views and their contracts
source: docs/architecture/html-observability.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, tooling]
status: current
---

> Abstract: HTML observability renders single-file, regenerable views over existing canonical JSON with no planner, daemon, server, or new authority; six project-scoped surfaces (authority graph, version check, lock health, verification health, performance history, workflow routing) are registered at 1.0.0, rendered by a typed emitter and render service, and governed by eleven html-observability contracts.

The accepted HTML observability contract (`schemas/v2/html-observability.schema.json`) describes single-file, regenerable views over existing JSON. It introduces no planner, dashboard daemon, server, or new source of project authority. A Phase 0/1 roadmap plan owns implementation and acceptance; `litai render html` and its staleness gate share source loading and exact output reconstruction; implemented views are not automatically release-qualified. Typed core records live in `literate_ai.contracts.html_observability`, and `adapters/html_surfaces.py` registers these project-scoped views at version `1.0.0`:

| Surface | View | Canonical producer |
| --- | --- | --- |
| `authority-graph` | `dag` | Effective project authority graph |
| `version-check` | `health` | Existing version-check report |
| `lock-health` | `health` | Shared current Component/repository lock observations |
| `verification-health` | `health` | Selected canonical project-verification gates |
| `performance-history` | `history` | Bounded diagnostic spans from the project build root |
| `workflow-routing` | `catalog` | Exact declared workflow and routing catalog bytes |

`adapters/html_emitter.py` emits inspected single-file bytes. Its DAG view uses one SRI-pinned Cytoscape.js library, fixed inline controls, and native catalog/relationship/source disclosures as a readable fallback. The emitter neither publishes nor applies cache policy; `adapters/html_render.py` owns that service and `cli/render.py` wraps it. `adapters/html_source_excerpts.py` supplies bounded, hash-checked Markdown/JSON previews from the graph's path/identity pairs: missing pairs are explicitly unavailable, while unsafe, changed, oversized, or non-UTF-8 declared sources refuse the observation, and display truncation happens only after verifying the complete bytes.

Contracts share the prefix `urn:literate-ai:schema:v1:html-observability-` (the schema owns fields and validation): `view` (versioned view and scope), `source-binding` (one canonical input surface), `external-asset` (HTTPS reference pinned by Subresource Integrity), `renderer-binding` (renderer, framework, template provenance), `provenance` (embedded input and renderer evidence), `artifact` (completed file identity and embedding attestation), `staleness-report`, `surface` (registered JSON producer and views), `render-request` (selection, destination, cache/asset policy), `render-refusal` (closed-set reason), and `render-result` (exactly one artifact or typed refusal).

Source: [docs/architecture/html-observability.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/html-observability.md) at commit `fcc40bc`.
