---
title: Compartments layer 0 — intersection semantics with other proposals and the ECMA-262 refactoring
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/0-module-and-module-source.md
source_content_sha256: e51cb06e5a048eb9ab6fcbadda8784c7975673bde1138de67a42fc43df8badbe
source_authors: [Mark S. Miller, Caridy Patiño, Kris Kowal, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
topics: [module-harmony, compartments]
status: current
---

Abstract: The layer-0 explainer's own "Intersection Semantics" worked examples — how first-class `Module`/`ModuleSource` line up with **module blocks/expressions** (`(module {}) instanceof Module`, `.source instanceof ModuleSource`), with **deferred execution** (`import module example from 'example.js'` / `await import.module('example.js')` yielding an unexecuted `Module` you can kick later, or rebuild with your own `importHook`), and with **`import.meta.resolve()`**. Plus the proposed **ECMA-262 factoring**: decoupling a new Module Source Record hierarchy that the authors expect could ultimately collapse Cyclic/Virtual/abstract Module Records into one concrete record. This section is the densest single primary source for [[module-harmony-intersection-surface]]; it is the upstream text the fresh design both draws on and diverges from (it retains `import module` / `import.module` phase syntax the fresh minimal spec must decide whether to adopt).

## Intersection Semantics with Module Blocks

Extending to accommodate both a module block *instance* and module block *source*:

```js
const instance = module {};
instance instanceof Module;             // true
instance.source instanceof ModuleSource; // true
const namespace = await import(instance);
```

## Intersection Semantics with deferred execution

Loading the source and creating the instance with the default `importHook` and the importer's `import.meta`, importable at any later time, suffices:

```js
import module example from 'example.js';          // static
const example = await import.module('example.js'); // or dynamic
example instanceof Module;                 // true
example.source instanceof ModuleSource;    // true
const namespace = await import(example);
```

To also control the `importHook` and `importMeta`, use the `source` of the unexecuted module and construct a new `Module`:

```js
import module example from 'example.js';
const instance = new Module(example.source, { importHook });
const namespace = await import(instance);
```

In these cases the `ModuleSource` may benefit from the origin being captured in host data, so it can be evaluated under a no-unsafe-eval CSP.

## Intersection Semantics with import.meta.resolve()

A handler can resolve specifiers using the host `import.meta.resolve` in its two-argument form, then `fetch` + `new ModuleSource` + `new Module`, and lazily provide a per-module `importMeta.resolve` closure via `importMetaHook`. (Full example in source.)

## Factoring ECMA-262

This proposal decouples a new **Module Source Record** and **EcmaScript Module Source Record** from the existing Module Record class hierarchy and introduces a concrete **Virtual Module Record**. The hope is that this makes evident that Virtual Module Record, Cyclic Module Record, and the abstract base Module Record could be refactored into a single concrete record (all meaningful variation expressed by implementations of the abstract Module Source Record) — though the proposal does not make that refactoring normative, and does not impose on host-defined import behavior.

## Naming open question

`Module` vs `ModuleInstance` are both contenders for the instance name; the authors tentatively entertain `Module` because they expect a world where `(module {}) instanceof Module`. This is unsettled and interacts with whether module blocks are reified as module *source* instead of module *instance* — `WebAssembly.Module` more closely resembles a module *source* than an instance, which would push the naming the other way. A live contradiction the fresh design must resolve; see [[module-harmony-intersection-surface]].

Source: [proposal-compartments/0-module-and-module-source.md](https://github.com/tc39/proposal-compartments/blob/master/0-module-and-module-source.md) at content sha256 `e51cb06e`. Stage 1; retrieved 2026-07-21.
