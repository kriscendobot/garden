---
title: Compartments layer 1 — ModuleSource.bindings reflection and the Binding shapes
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/1-static-analysis.md
source_content_sha256: f775af192fde66eaae4004a1d990ddc5f0dae2b5514ae02e51cc8768a44f58dd
source_authors: [Mark S. Miller, Caridy Patiño, Kris Kowal, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
topics: [module-harmony, compartments]
status: current
---

Abstract: Compartments **layer 1** (`1-static-analysis.md`) extends `ModuleSource` instances to reflect the results of static analysis so tools can inspect a module graph without executing it. It adds two properties to `ModuleSource`: **`bindings`** — an `Array` of `Binding` objects, one per name (or wildcard `*`) bound by `import`/`export` in source order — and **`needsImportMeta`**, a boolean flagging whether the module contains `import.meta` syntax. This section catalogs the eight canonical `Binding` shapes (the same shapes layer 2's virtual module sources must produce), and records why the reflected view is a *copy* over an immutable underlying record. The motivation, worked graph-analysis and hot-module-replacement examples, and the `isAsync`/`needsImport` design questions live in the companion `--motivation-and-graph-analysis-examples`.

## Design — the two added properties

Layer 1 depends on layer 0 (`Module and ModuleSource`) to introduce `ModuleSource`, then extends instances with:

- **`bindings`** — an `Array` of `Binding`s.
- **`needsImportMeta`** — a `boolean` indicating that the module contains `import.meta` syntax.

A `Binding` is an ordinary `Object` with one of the valid binding shapes below, one for each name or wildcard (`*`) bound by `import` or `export` in the module text, **in their order of appearance**.

## The eight Binding shapes

| Shape | Example source | Produces |
|---|---|---|
| `{ import: string, from: string }` | `import { a } from 'a.js'` | `{ import: 'a', from: 'a.js' }` (one binding per name: `import { a, b } from 'ab.js'` yields two) |
| `{ import: string, as: string, from: string }` | `import { a as x } from 'a.js'` | `{ import: 'a', as: 'x', from: 'a.js' }` |
| `{ export: string }` | `export { x }` | `{ export: 'x' }` |
| `{ export: string, from: string }` | `export { x } from 'x.js'` | `{ export: 'x', from: 'x.js' }` |
| `{ export: string, as: string, from: string }` | `export { x as a } from 'x.js'` | `{ export: 'x', as: 'a', from: 'x.js' }` |
| `{ importAllFrom: string, as: string }` | `import * as x from 'x.js'` | `{ importAllFrom: 'x.js', as: 'x' }` |
| `{ exportAllFrom: string }` | `export * from 'x.js'` | `{ exportAllFrom: 'x.js' }` |
| `{ exportAllFrom: string, as: string }` | `export * as x from 'x.js'` | `{ exportAllFrom: 'x.js', as: 'x' }` |

The dependency edge for any binding is whichever of `from` / `importAllFrom` / `exportAllFrom` is present.

## Reflection is a copy over an immutable record

When dynamic import instantiates a `Module`, the host **continues to depend on the `[[Module Source]]` internal slot and the bindings slots of the underlying Module Source Record** for its own analysis. User code therefore **cannot confuse the host by mutating a `ModuleSource` instance's reflected `bindings`**: the instance's reflected view is distinct from the immutable Module Source Record, which in turn may be safely shared among agents in an agent cluster. This is the layer-0 "powerless, immutable, serializable" `ModuleSource` guarantee viewed from the reflection side — the reflected array is a convenience over a record the holder cannot alter.

Source: [proposal-compartments/1-static-analysis.md](https://github.com/tc39/proposal-compartments/blob/master/1-static-analysis.md) at content sha256 `f775af19`. Stage 1; retrieved 2026-07-21.
