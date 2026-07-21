---
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/2-virtual-module-source.md
source_content_sha256: ffd7fbc7ec72d75e4b377eb82b587bb0b05b88466b93e297fedb98c075fb858b
source_authors: [Mark S. Miller, Caridy Patiño, Kris Kowal, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
section_count: 3
status: current
notes: "TC39 Compartments layer 2 (2-virtual-module-source.md), Virtual Module Sources (Stage 1). Default branch `master`. Fetched direct via scripts/jobs/fetch-source.sh; idempotency anchor is source_content_sha256. source_date is an era approximation. Canonical human page: https://github.com/tc39/proposal-compartments/blob/master/2-virtual-module-source.md. Part of the tc39-module-harmony cluster (job scholar-research-module-harmony-compartments-layers)."
---

The **Virtual Module Sources** layer (layer 2) extends the `Module` constructor to accept virtual module sources — plain objects (no `[[Module Source]]` internal slot) implementing a `bindings`/`execute`/`needsImport`/`needsImportMeta` protocol sufficient to virtualize evaluating modules in languages ECMA-262 or a host did not anticipate. It lets *user code* (not only a host) integrate JSON, CommonJS, or WASM, with worked examples for each plus a pass-through re-exporter. The layer's open questions weigh a lower-level bindings-only API (Caridy Patiño's, to keep sources serializable), emulated JavaScript needing separate initialization/execution phases, and the shape of the internal namespace object; its hard limitation is that virtual sources — unlike compiled `ModuleSource`/`WebAssembly.Module` — are **not** transmissible by a general-purpose algorithm like structured clone, so cross-agent transport must be user-code. This is the loader-hook layer a minimal Compartments spec must decide whether to adopt.

| Section | Topics | Status |
|---------|--------|--------|
| [protocol-and-binding-linkage](../sections/tc39-module-harmony--compartments-virtual-module-source--protocol-and-binding-linkage.md) | module-harmony, compartments | current |
| [virtualization-examples-json-cjs-wasm-passthrough](../sections/tc39-module-harmony--compartments-virtual-module-source--virtualization-examples-json-cjs-wasm-passthrough.md) | module-harmony, compartments | current |
| [serializability-and-transmission-limits](../sections/tc39-module-harmony--compartments-virtual-module-source--serializability-and-transmission-limits.md) | module-harmony, compartments | current |
