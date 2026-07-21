---
title: Source Phase Imports — motivation and the source loading phase
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

Abstract: The TC39 **source phase imports** proposal (Stage 3; champions Luca Casonato, Guy Bedford) adds `import source x from "<specifier>"` and its dynamic form `await import.source("<specifier>")` — a new *loading phase* that imports a reified, compiled-but-not-instantiated representation of a module's source when the host provides one. This section carries the motivation (userland loaders for JS need a shared host-parsed module-source type; WebAssembly needs custom inspection/wrapping without manual `fetch` + `compileStreaming`) and the framing of source-import as one of several *evaluation phases* of the import pipeline. It grounds the `ModuleSource`-as-first-class-value surface the fresh Compartments design keys a module-instance index on. Does not cover the `AbstractModuleSource` prototype details (see sibling `--abstract-module-source-and-module-source-objects`) or cache-key semantics (`--cache-key-and-relationship-to-other-proposals`).

## Motivation

For both JavaScript and WebAssembly, there is a need to more closely customize the loading, linking, and execution of modules beyond the standard host execution model.

For JavaScript, creating userland loaders would require a module source type in order to share the host parsing, execution, security, and caching semantics.

For WebAssembly, imports and exports for WebAssembly modules often require custom inspection and wrapping in order to be set up correctly, which typically requires manual fetch and instantiation work that is not provided for in the current host [ESM integration] proposal.

Supporting syntactical module source imports as a new import phase creates a primitive that can extend the static, security and tooling benefits of modules from the ESM integration to these dynamic instantiation use cases.

## Proposal — the `source` phase

This proposal allows ES modules to import a reified representation of the compiled source of a module when the host provides such a representation:

```js
import source x from "<specifier>";
```

The `source` module source loading phase name is added to the beginning of the ImportStatement. Only the above form is supported — named exports and unbound declarations are not supported.

### Dynamic form

Just as with static and dynamic imports, there is a need for static and dynamic access to sources — for sources required to be instantiated from source text during initialization, and those optionally or lazily created at runtime. The dynamic form uses an `import.<phase>` import call:

```js
const x = await import.source("<specifier>");
```

By making the phase part of the explicit syntax, it is possible to statically distinguish between a full dynamic import and one that is only for a source (where dependencies don't need to be processed). Optional [import attributes] may still be specified with the second argument in a `with` key, just like for dynamic import, and without conflict due to the design of phased evaluation.

### Loading phase

Module source imports can be seen to be one type of evaluation phase. If the [asset references proposal] advances in future this could be seen as another type of phase representing an earlier phase of the loading process:

```js
import asset x from "<specifier>";
await import.asset("<specifier>");
```

Only the `source` import source phase is specified by this proposal.

Source: [proposal-source-phase-imports/README.md](https://github.com/tc39/proposal-source-phase-imports/blob/main/README.md) at content sha256 `e8151c8e`. Stage 3; retrieved 2026-07-21.
