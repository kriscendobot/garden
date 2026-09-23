---
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/0-module-and-module-source.md
source_content_sha256: e51cb06e5a048eb9ab6fcbadda8784c7975673bde1138de67a42fc43df8badbe
source_authors: [Mark S. Miller, Caridy Patiño, Kris Kowal, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
section_count: 3
status: current
notes: "TC39 Compartments layer 0 (0-module-and-module-source.md), the first-class Module + ModuleSource layer (Stage 1). Default branch `master`. Fetched direct via scripts/jobs/fetch-source.sh; idempotency anchor is source_content_sha256. source_date is an era approximation. Canonical human page: https://github.com/tc39/proposal-compartments/blob/master/0-module-and-module-source.md; spec-change form at https://tc39.es/proposal-compartments/0-module-and-module-source.html. This is the single densest primary source for the module-harmony-intersection-surface concept. Part of the tc39-module-harmony cluster (job scholar-research-module-harmony-intersection)."
---

The **Module and ModuleSource** layer of the Compartments proposal provides first-class `Module` and `ModuleSource` constructors and extends dynamic `import()` to operate on `Module` instances. A `ModuleSource` is powerless, immutable, and serializable (the compiled result of source text, shareable across realms/agents); a `Module` instance wraps a source plus a `ModuleHandler` (with eagerly-captured `importHook`/`importMetaHook`) and carries a lifecycle producing one namespace exotic object, in a 1-1-1-1 relationship among environment record, source record, and namespace. Multiple `Module` instances can share one `ModuleSource` to yield separate namespaces — the opaque-key-indexes-an-instance surface the fresh design keys on. Documents intersection semantics with module blocks, deferred execution (`import module` / `import.module`), and `import.meta.resolve`, plus the proposed ECMA-262 Module-Record refactoring and the unresolved `Module` vs `ModuleInstance` naming.

| Section | Topics | Status |
|---------|--------|--------|
| [modulesource-and-module-instance-model](../sections/tc39-module-harmony--compartments-module-and-source--modulesource-and-module-instance-model.md) | module-harmony, compartments | current |
| [virtual-import-hooks-and-referrer](../sections/tc39-module-harmony--compartments-module-and-source--virtual-import-hooks-and-referrer.md) | module-harmony, compartments | current |
| [intersection-semantics-and-262-factoring](../sections/tc39-module-harmony--compartments-module-and-source--intersection-semantics-and-262-factoring.md) | module-harmony, compartments | current |
