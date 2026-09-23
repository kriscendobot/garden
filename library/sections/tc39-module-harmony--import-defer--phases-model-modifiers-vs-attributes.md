---
title: import defer — the phases model, import modifiers vs attributes, and deferred re-exports
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-defer-import-eval/main/README.md
source_content_sha256: bd8d5bc5fe2b8a90aa273153ecfe465f10005d484b82754928247f981c233fc7
source_authors: [Yulia Startsev, Nicolò Ribaudo, Guy Bedford]
source_date: 2025-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
topics: [module-harmony]
status: current
---

Abstract: The proposal's own account of how it composes with the rest of module harmony — it explicitly follows the *phases model* established by [source phase imports], it uses an **import modifier** (`import defer`) rather than an import **attribute** (`with { defer: true }`) and states precisely why, it lists the module-loading phases the two proposals jointly expose, and it leaves **deferred re-exports** and a synchronous-eval API on the compartments `ModuleInstance` as explicit open extensions. Primary evidence for the "phases are a shared axis" claim in [[module-harmony-intersection-surface]] and for the open-questions list there.

## The phases model

The API follows the phases model established by the [source phase imports] proposal. Together, source-phase and defer expose multiple "phases" of module loading. The phases identified are: resolving a module given a specifier, fetching the module (these two happen in hosts, not in ECMA-262), attaching modules to their execution and resolution context, linking modules together, and finally executing them. Import *modifiers* represent modules processed up to one of those phases, without going all the way to finishing execution.

These modifiers give more guarantees than import attributes: while `import "x" with { attr1: "val" }` and `import "x" with { attr2: "val2" }` might be two completely different modules, `import source s from "x"`, `import defer * as ns from "x"`, and `import "x"` **all are guaranteed to load the same module**, and that module will be executed at most once regardless of which "phase" it gets temporarily paused at (and then continued from).

## Why an import modifier, not an import attribute

Two reasons the proposal chose an "import modifier" over `import * as ns from "mod" with { defer: true }`:

1. Import attributes affect what a module *is*, but cannot change basic semantics of how ECMAScript modules behave — they are similar to adding query parameters to the imported URL, handled by the running environment. For example, `with { type: "json" }` behaves as if the imported module were a JS file wrapped in ``export default JSON.parse(`…`)``. `import defer` changes how namespace objects *behave* (by making them side-effectful, whereas before this proposal property access on namespace objects couldn't trigger any side effect): it cannot be expressed as a wrapped/modified "classic" module.
2. Together with source phase imports, it is one of the "phases" of module loading (see above).

## Deferred re-exports (open extension)

There are possible extensions under consideration, such as **deferred re-exports**, but they are not included in the current version of the proposal.

## Direct lazy bindings (discarded first form)

The initial version included direct binding access for deferred evaluation via named exports (`import { feature } from './lib' with { lazyInit: true }`), where deferred evaluation would happen on *access* of the `feature` binding. This introduces a novel type of execution point in the language; focusing on the module-namespace-exotic-object approach first keeps the semantics simple. It may still be investigated within this proposal or an extension.

## Why not a synchronous-eval API on the compartments `ModuleInstance`?

A synchronous evaluation API on the module-expression / compartments [ModuleInstance] object could offer synchronous evaluation compatible with this approach, but only a clear *syntactical* solution can be supported across dependency boundaries and in bundlers to bring the full benefits of avoiding unnecessary initialization work to the wider JS ecosystem.

Source: [proposal-defer-import-eval/README.md](https://github.com/tc39/proposal-defer-import-eval/blob/main/README.md) at content sha256 `bd8d5bc5`. Stage 3; retrieved 2026-07-21.
