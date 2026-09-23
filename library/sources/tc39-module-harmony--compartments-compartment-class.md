---
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/4-compartment.md
source_content_sha256: da5681d6259013c31ff429d36e5256e2079761f994ca1a3a01187d3ba43e2e2
source_authors: [Mark S. Miller, Caridy Patiño, Patrick Soquet, Kris Kowal, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
section_count: 5
status: current
notes: "TC39 Compartments layer 4 (4-compartment.md), the high-level Compartment class built on Evaluators + Module + ModuleSource (~32KB; 850 lines). Default branch master. Fetched direct via scripts/jobs/fetch-source.sh; idempotency anchor is source_content_sha256. source_date is an era approximation. Canonical human page: https://github.com/tc39/proposal-compartments/blob/master/4-compartment.md. This layer introduces the user-code-constructible Compartment class with resolveHook/loadHook virtualization — the module-descriptor/module-map-hook surface where upstream Stage-1 Compartments still uses module descriptors (which the fresh design abandoned in favor of opaque ModuleSource keys). Part of the tc39-module-harmony cluster."
---

The **Compartments** layer 4 (layer 4) introduces the high-level **`Compartment`** class — a user-code-constructible object that orchestrates evaluators (`eval`, `Function`, `Module`) and module loading within a single global scope. It accepts an options object with `globals`, `endorsedBuiltins`, `resolveHook`, and `loadHook` callbacks for full virtualization of the host module loader. The `ModuleDescriptor` type captures compiled source records plus per-compartment metadata; this is the **module descriptor surface** that upstream Stage-1 Compartments carries, which the fresh design has abandoned in favor of an opaque `ModuleSource` key (see [[module-harmony-intersection-surface]] §5 for the reconciliation).

| Section | Topics | Status |
|---------|--------|--------|
| [compartment-class-and-interfaces](../sections/tc39-module-harmony--compartments-compartment-class-and-interfaces.md) | module-harmony, compartments | current |
| [compartment-constructor-and-options](../sections/tc39-module-harmony--compartments-compartment-constructor-and-options.md) | module-harmony, compartments | current |
| [compartment-virtual-modules](../sections/tc39-module-harmony--compartments-compartment-virtual-modules.md) | module-harmony, compartments | current |
| [compartment-motivating-examples](../sections/tc39-module-harmony--compartments-compartment-motivating-examples.md) | module-harmony, compartments | current |
| [compartment-thenable-and-design](../sections/tc39-module-harmony--compartments-compartment-thenable-and-design.md) | module-harmony, compartments | current |
