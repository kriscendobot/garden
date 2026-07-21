---
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-source-phase-imports/main/README.md
source_content_sha256: e8151c8e6f399eab87a1c23a8be316349b0dd275856473d5dbe007b9c6f97b68
source_authors: [Luca Casonato, Guy Bedford, Nicolò Ribaudo]
source_date: 2025-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
section_count: 3
status: current
notes: "TC39 source phase imports (Stage 3). Fetched direct from raw.githubusercontent.com via scripts/jobs/fetch-source.sh (source_fetched_via=direct); idempotency anchor is source_content_sha256, not a git SHA. source_date is an era approximation (Stage 3 ~2024-2025; README carries no explicit date). Canonical human-readable page: https://github.com/tc39/proposal-source-phase-imports. Part of the tc39-module-harmony cluster ingested 2026-07-21 for the proposal-compartments intersection research (job scholar-research-module-harmony-intersection)."
---

The **source phase imports** proposal introduces `import source x from "<specifier>"` and `await import.source("<specifier>")` — a new module *loading phase* that reifies a compiled-but-not-evaluated module source when the host supplies one. It defines `%AbstractModuleSource%.prototype` as the minimal shared base for any compiled modular resource, `ModuleSource` as the EcmaScript subclass, and re-parents `WebAssembly.Module` under the same base. It is a foundational member of module harmony: its `ModuleSource` surface is the opaque, powerless value the fresh Compartments design uses as a key, and its "phases" framing is shared with import defer. Motivation is userland loaders (JS) and custom Wasm inspection/wrapping without manual `fetch` + `compileStreaming`.

| Section | Topics | Status |
|---------|--------|--------|
| [overview-motivation-and-source-phase](../sections/tc39-module-harmony--source-phase-imports--overview-motivation-and-source-phase.md) | module-harmony | current |
| [abstract-module-source-and-module-source-objects](../sections/tc39-module-harmony--source-phase-imports--abstract-module-source-and-module-source-objects.md) | module-harmony | current |
| [cache-key-and-relationship-to-other-proposals](../sections/tc39-module-harmony--source-phase-imports--cache-key-and-relationship-to-other-proposals.md) | module-harmony | current |
