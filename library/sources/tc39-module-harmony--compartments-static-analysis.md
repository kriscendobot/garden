---
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/1-static-analysis.md
source_content_sha256: f775af192fde66eaae4004a1d990ddc5f0dae2b5514ae02e51cc8768a44f58dd
source_authors: [Mark S. Miller, Caridy Patiño, Kris Kowal, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
section_count: 2
status: current
notes: "TC39 Compartments layer 1 (1-static-analysis.md), Surface Module Source Static Analysis (Stage 1). Default branch `master`. Fetched direct via scripts/jobs/fetch-source.sh; idempotency anchor is source_content_sha256. source_date is an era approximation. Canonical human page: https://github.com/tc39/proposal-compartments/blob/master/1-static-analysis.md. Part of the tc39-module-harmony cluster (job scholar-research-module-harmony-compartments-layers, follow-on to scholar-research-module-harmony-intersection)."
---

The **Surface Module Source Static Analysis** layer (layer 1) of the Compartments proposal extends `ModuleSource` instances to reflect their static-analysis results — a `bindings` array (one `Binding` object per name or wildcard bound by `import`/`export`, in source order) and a `needsImportMeta` boolean — so tools can build a module graph from module text without executing it and without a ~1MB JavaScript meta-parser. The reflected view is a copy over an immutable, cluster-shareable Module Source Record, so user mutation cannot confuse the host. Motivating tools: bundlers, import-map generators, hot-module-replacement, persistent test runners. Open questions: whether `isAsync` must be reflected; why `needsImportMeta` earns a per-source flag (per-module closure-allocation savings) while `needsImport` does not.

| Section | Topics | Status |
|---------|--------|--------|
| [binding-shapes-and-modulesource-reflection](../sections/tc39-module-harmony--compartments-static-analysis--binding-shapes-and-modulesource-reflection.md) | module-harmony, compartments | current |
| [motivation-and-graph-analysis-examples](../sections/tc39-module-harmony--compartments-static-analysis--motivation-and-graph-analysis-examples.md) | module-harmony, compartments | current |
