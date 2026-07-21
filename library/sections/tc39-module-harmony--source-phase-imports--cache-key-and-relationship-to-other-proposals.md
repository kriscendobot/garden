---
title: Source Phase Imports — cache-key semantics and relationship to attributes, module expressions, compartments
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-source-phase-imports/main/README.md
source_content_sha256: e8151c8e6f399eab87a1c23a8be316349b0dd275856473d5dbe007b9c6f97b68
source_authors: [Luca Casonato, Guy Bedford, Nicolò Ribaudo]
source_date: 2025-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
topics: [module-harmony]
status: current
---

Abstract: How the source phase interacts with the rest of module harmony — the source object is keyed on the base module record (so it is unique per imported module and does not perturb load idempotency), import *attributes* are orthogonal properties of the module request while *phases* are stages of that same request/key, and the module object is explicitly specified to be compatible with the linking model of module expressions and compartments. This is the proposal's own statement of its intersection points, the primary evidence for the concept page [[module-harmony-intersection-surface]].

## Cache Key Semantics

Because `[[ModuleSourceObject]]` is keyed on the base module record, it will always be unique to the module being imported from.

## Q&A — relationship to other proposals

**Q**: How does this relate to import attributes?

**A**: Import attributes are properties of the module request, while source imports represent phases of that specific request / key in the module map, without affecting the idempotency of the module load. Both can be used together for a resource to indicate alternative phasing for the given module resource and attributes.

**Q**: How does this relate to module expressions and compartments?

**A**: The module object that is provided has been carefully specified here to be compatible with the linking model of module expressions and compartments.

**Q**: Why not just use `const module = await WebAssembly.compileStreaming(fetch(new URL("./module.wasm", import.meta.url)));`?

**A**: There are multiple benefits: firstly if the module is statically referenced in the module graph, it is easier to statically analyze (by bundlers for example). Secondly when using CSP, `script-src: unsafe-eval` would not be needed. See the security-benefits section for more details.

## Intersection notes (scholar)

- The source phase's `ModuleSource` is the shared spine the deferred-execution examples in the Compartments layer-0 explainer reuse (`import module example from 'example.js'; example.source instanceof ModuleSource`). A minimal Compartments spec that indexes module *instances* by an opaque `ModuleSource` is adopting exactly the "keyed on the base module record → unique" guarantee stated here.
- Phases (`source`, `defer`, and full evaluation) are guaranteed to load *the same module*, executed at most once regardless of which phase it pauses at — the invariant the [import defer] proposal restates as its reason for using import *modifiers* rather than attributes.

Source: [proposal-source-phase-imports/README.md](https://github.com/tc39/proposal-source-phase-imports/blob/main/README.md) at content sha256 `e8151c8e`. Stage 3; retrieved 2026-07-21.
