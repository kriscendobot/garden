---
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/GRAPH.md
source_content_sha256: 759c00d9848573c2dcc1277c60a78ec64d68dc48676c489218ec8b0a900a02a5
source_authors: [Mark S. Miller, Caridy Patiño, Kris Kowal, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
section_count: 2
status: current
notes: "TC39 Compartments GRAPH.md — motivating use cases mapping each proposed module feature to the layers and sibling proposals (module blocks, import reflection, deferred import evaluation). Default branch `master`. Fetched direct via scripts/jobs/fetch-source.sh; idempotency anchor is source_content_sha256. source_date is an era approximation. Opens with a Mermaid feature-dependency graph (not reproduced; see source). Canonical human page: https://github.com/tc39/proposal-compartments/blob/master/GRAPH.md. Raw material for the module-harmony-intersection-surface concept's adopt/defer argument. Part of the tc39-module-harmony cluster (job scholar-research-module-harmony-compartments-layers)."
---

`GRAPH.md` is the Compartments proposal's own **feature-to-use-case map**: a feature catalog (which low-level feature each layer contributes, and how those map onto module blocks, import reflection, and deferred import evaluation) paired with a motivating-use-case list (each use case named with the exact features it requires). It reads bottom-up from layer 0's module source concept / `Module` / `ModuleSource` up through bindings reflection, virtual sources (minimal vs maximal), Evaluators, and Compartments (the high-level API out of which all lower layers fell, constructible in user code). The use-case side — non-JavaScript and asset modules, WASM, deferred execution, multiple instantiation, hot module replacement, module-block bundles, WASM-under-CSP, inter-agent transfer, module instrumentation, DSLs, supply-chain isolation — is the demand-side argument for why each layer exists, and the raw material for strengthening the module-harmony-intersection-surface concept.

| Section | Topics | Status |
|---------|--------|--------|
| [feature-to-layer-map-and-module-proposals](../sections/tc39-module-harmony--compartments-graph--feature-to-layer-map-and-module-proposals.md) | module-harmony, compartments | current |
| [motivating-use-cases](../sections/tc39-module-harmony--compartments-graph--motivating-use-cases.md) | module-harmony, compartments | current |
