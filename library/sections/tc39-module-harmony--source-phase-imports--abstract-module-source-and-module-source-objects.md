---
title: Source Phase Imports — AbstractModuleSource, ModuleSource, and host module sources
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

Abstract: The object surface the source phase returns — `%AbstractModuleSource%.prototype` as the minimal shared base prototype for every "compiled modular resource," `ModuleSource` as the concrete EcmaScript subclass, `WebAssembly.Module` re-parented under the same base, and the `@@toStringTag` brand-check with a strong internal-slot guard. This is the exact prototype/brand contract a minimal Compartments spec must stay compatible with when it treats a `ModuleSource` as an opaque, powerless key. Companion to the motivation section (`--overview-motivation-and-source-phase`); the fuller first-class-`ModuleSource`-plus-`Module`-constructor model lives in the Compartments layer-0 sections (`tc39-module-harmony--compartments-module-and-source--*`).

## Defining Module Source

The object provided by the module source phase must be an object with `AbstractModuleSource.prototype` in its prototype chain, defined by this specification to be a minimal shared base prototype for a compiled modular resource. In addition it defines the `@@toStringTag` getter returning the constructor name string corresponding to the name of the specific module source subclass, with a strong internal slot check.

## JS Module Source

For JavaScript modules, the module source phase is specified to return a `ModuleSource` object, representing an ECMAScript Module Source, where `ModuleSource.prototype.[[Proto]]` is `%AbstractModuleSource%.prototype`.

Future proposals may then add support for [bindings lookup methods] (see the Compartments *static analysis* layer), the [ModuleSource constructor] and [instantiation] support. New properties may be added to the base `%AbstractModuleSource%.prototype`, or shared with ECMAScript module sources via `ModuleSource.prototype` additions.

## Wasm Module Source

For WebAssembly modules, the existing `WebAssembly.Module.prototype` object is to be updated to have a `[[Proto]]` of `%AbstractModuleSource%.prototype` in the [WebAssembly JS integration API]. This allows workflows like:

```js
import source FooModule from "./foo.wasm";
FooModule instanceof WebAssembly.Module; // true

// For example, to run a WASI execution with an API like Node.js WASI:
import { WASI } from 'wasi';
const wasi = new WASI({ args, env, preopens });

const fooInstance = await WebAssembly.instantiate(FooModule, {
  wasi_snapshot_preview1: wasi.wasiImport
});

wasi.start(fooInstance);
```

The static analysis benefits of not needing a custom `fetch` and `WebAssembly.compileStreaming` apply not only to code analysis and security but also for bundlers. In turn this enables [Wasm components to be able to import] `WebAssembly.Module` objects themselves in future.

## Other Module Types

Any other host-defined module types may define their own host module sources. If a given module does not define a source representation for its source, importing it with a `"source"` phase target fails with a `ReferenceError` at link time.

Host-defined module sources must include `%AbstractModuleSource%.prototype` in their prototype chain and support the `[[ModuleSourceRecord]]` internal slot containing the `@@toStringTag` brand check and underlying source host data.

## Security Benefits

The native ES module loader is able to implement security policies, including support for [Content Security Policies][CSP] in browsers, and permission systems on platforms such as Deno. These policies are based on protecting which URLs are supported for the compilation and execution of scripts or modules. Extending the static security benefits of the host module system to custom loaders is a security benefit of this proposal; for Wasm it would enable source-specific CSP policies for dynamic Wasm instantiation.

Source: [proposal-source-phase-imports/README.md](https://github.com/tc39/proposal-source-phase-imports/blob/main/README.md) at content sha256 `e8151c8e`. Stage 3; retrieved 2026-07-21.
