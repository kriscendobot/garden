---
title: Compartments GRAPH — the feature-to-layer dependency map and how each layer maps to the module proposals
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/GRAPH.md
source_content_sha256: 759c00d9848573c2dcc1277c60a78ec64d68dc48676c489218ec8b0a900a02a5
source_authors: [Mark S. Miller, Caridy Patiño, Kris Kowal, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
topics: [module-harmony, compartments]
status: current
---

Abstract: The feature catalog from `GRAPH.md` — the Compartments proposal's own map of which low-level feature each layer contributes and how those features map onto the sibling module-harmony proposals (module blocks, import reflection, deferred import evaluation). It reads bottom-up: **layer 0** contributes the *module source concept*, the `ModuleSource` instance/prototype/constructor (and a trusted-types constructor variant for CSP), the `Module` instance/prototype/constructor, and `import.meta` injection; **module blocks** contribute a `module` block (with an optional `source`); **import reflection** contributes static `import module` / dynamic `import.module` (which may carry a `source`, including a `WebAssembly.Module`); **layer 1** contributes `ModuleSource` bindings reflection; **layer 2** contributes minimal and maximal virtual module sources; **layer 3** contributes Evaluators; **layer 4** is Compartments, the high-level API out of which all lower layers fell (constructible in user code from Evaluators + `Module`/`ModuleSource` constructors + dynamic `import.module`). The companion `--motivating-use-cases` walks the use cases each feature unlocks. `GRAPH.md` also opens with a Mermaid dependency graph (feature → feature edges); it is not reproduced here — see the source for the diagram.

## Layer 0 — first-class `Module` and `ModuleSource`

- **module source concept** — any object with a `[[ModuleSource]]` internal slot of type *Module Source Record*. The record captures bindings, initialization, and execution behavior but is abstract enough that JavaScript modules, host-defined sources, and virtual sources all participate. A `WebAssembly.Module` becomes a module source by gaining a `[[ModuleSource]]` slot. A `Module` instance *may* lack a `source`, or have it redacted (host-defined modules like Node.js `internal*` may have none; a module block would have one; whether a lexically named module fragment has one is unresolved).
- **`ModuleSource` instance and prototype** — a handle for a JavaScript module source, sufficient to represent a parsed module for both static `import module` and dynamic `import.module`.
- **`ModuleSource` constructor** — parses text into an instance. Because the text is arbitrary, it cannot imbue the record's `[[HostData]]` with an origin, so the module cannot execute under a `no-unsafe-eval` Content-Security-Policy.
- **`ModuleSource` constructor with trusted types** — could supply an origin for `[[HostData]]` if it received W3C Trusted Types text instead of a plain string, overcoming the CSP limitation.
- **`Module` instance and prototype** — represents the lifecycle of one instance; a single source can produce multiple instances across realms and agents, but an instance is the singleton linking/execution in a context. Useful for anchoring module blocks and the `import module` syntaxes even without a `Module` constructor.
- **`Module` constructor** — unlocks deferred execution and multiple instantiation, plus linking instances through virtualized host import hooks.
- **`import.meta` injection** — the `Module` constructor must virtualize `import.meta` when the module evaluates.

## Module blocks

- **`module` block** — produces a `Module` instance executable later, possibly multiple times, possibly on another agent.
- **`module` block with `source`** — lets user code extract the source and transport it independent of its instance metadata or linkage.

## Import reflection

- **static `import module` / dynamic `import.module`** — produce `Module` instances that *may* have a `source` (a module source concept) at the host or virtual host's discretion.
- **import `WebAssembly.Module`** — the module source concept is flexible enough that an existing `WebAssembly.Module` can implement it via a `[[ModuleSource]]` slot referring to a *WebAssembly Module Source Record*; a host can go further and expose `WebAssembly.Module.prototype.bindings` so bundlers accommodate WASM sources.

## Layers 1–4

- **Layer 1 — `ModuleSource` bindings reflection** — lets programs (bundlers) analyze a source's imports/exports; the `import` behavior for `Module` instances uses the same information to drive the `importHook`.
- **Layer 2 — virtual module sources** — a *minimal* virtual source (emulating bindings reflection plus an execution hook) models languages without dependency cycles, hoisted-declaration initialization, or lazy bindings, and can hoist a static-analyzable subset of CommonJS into the module graph (coexisting with a synchronous legacy loader). A *maximal* virtual source (like SystemJS's protocol) is required to fully emulate JavaScript, needed for mock modules in module instrumentation.
- **Layer 3 — Evaluators** — creates a new `eval`/`Function`/`Module` intrinsic set. 262 gives `eval`/`Function` a `[[Context]]` reaching the `[[Realm]]`; this extends the design to `Module` and adds a `[[Context]] → [[Evaluators]] → [[Realm]]` indirection so multiple evaluator sets (each with its own global and module behavior) can share one realm. Unlocks better DSLs and supply-chain isolation.
- **Layer 4 — Compartments** — the high-level API out of which all prior layers fell. For supply-chain isolation in Node.js a compartment corresponds to a package; Moddable's XS implements `Compartments` to delegate powers to guest compartments (for example, preventing guest code from drawing too much power). Compartments can be implemented in user code from **Evaluators**, the **`Module`** and **`ModuleSource` constructors**, and **dynamic `import.module`**.

Source: [proposal-compartments/GRAPH.md](https://github.com/tc39/proposal-compartments/blob/master/GRAPH.md) at content sha256 `759c00d9`. Stage 1; retrieved 2026-07-21.
