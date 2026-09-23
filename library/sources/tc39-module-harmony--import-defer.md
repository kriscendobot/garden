---
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-defer-import-eval/main/README.md
source_content_sha256: bd8d5bc5fe2b8a90aa273153ecfe465f10005d484b82754928247f981c233fc7
source_authors: [Yulia Startsev, Nicolò Ribaudo, Guy Bedford]
source_date: 2025-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
section_count: 3
status: current
notes: "TC39 Deferring Module Evaluation / `import defer` (Stage 3; previously 'Lazy Module Initialization'). Repo is proposal-defer-import-eval. Fetched direct via scripts/jobs/fetch-source.sh; idempotency anchor is source_content_sha256. source_date is an era approximation (`import defer` reached Stage 3 ~2025-01). Canonical human page: https://github.com/tc39/proposal-defer-import-eval. Part of the tc39-module-harmony cluster (job scholar-research-module-harmony-intersection)."
---

The **Deferring Module Evaluation** proposal adds `import defer * as ns from "y"`: the module and its dependencies are fully loaded but not evaluated until a property of the returned namespace exotic object is accessed, at which point a *synchronous* top-level execution runs. It targets initialization CPU cost that dynamic `import()` cannot address without forcing asyncification. It follows the *phases model* of source phase imports and uses an import *modifier* (not an attribute) precisely because it changes namespace behavior. Deferred re-exports and a synchronous-eval API on the compartments `ModuleInstance` are named open extensions. Top-level-await subgraphs are eagerly evaluated (only synchronous parts defer), and a deferred namespace differs from a plain `import *` namespace because it must re-throw evaluation errors on access.

| Section | Topics | Status |
|---------|--------|--------|
| [motivation-deferring-module-evaluation](../sections/tc39-module-harmony--import-defer--motivation-deferring-module-evaluation.md) | module-harmony | current |
| [import-defer-semantics-and-namespace-exotic](../sections/tc39-module-harmony--import-defer--import-defer-semantics-and-namespace-exotic.md) | module-harmony | current |
| [phases-model-modifiers-vs-attributes](../sections/tc39-module-harmony--import-defer--phases-model-modifiers-vs-attributes.md) | module-harmony | current |
