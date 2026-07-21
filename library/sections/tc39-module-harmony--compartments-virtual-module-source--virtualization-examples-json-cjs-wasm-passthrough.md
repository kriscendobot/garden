---
title: Compartments layer 2 — virtualization examples (JSON, WASM, CommonJS, pass-through)
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/2-virtual-module-source.md
source_content_sha256: ffd7fbc7ec72d75e4b377eb82b587bb0b05b88466b93e297fedb98c075fb858b
source_authors: [Mark S. Miller, Caridy Patiño, Kris Kowal, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
topics: [module-harmony, compartments]
status: current
---

Abstract: The worked examples from Compartments layer 2 showing what the virtual-module-source protocol buys — user-code virtualization of module kinds a host did not implement. **JSON**: a tiny class whose `bindings` is a single default export and whose `execute` clones the parsed object per instance. **WASM**: a class that derives `bindings` from `WebAssembly.Module.imports`/`.exports` and links them at execute time. **CommonJS**: a heuristic-static-analysis sketch (based on Endo's) that lexically infers named exports and `require` sites, then runs the module body through a `globalThis.Function` functor with a `module.exports` proxy to promote assigned properties to named exports. **Pass-through**: a bindings-only source (`{ exportAllFrom }`) that re-exports another module with no executor. Read `--protocol-and-binding-linkage` first for the interface these implement.

## JSON

For a host without JSON modules, a small virtual source suffices — a single default binding plus an `execute` that clones the parsed object so instances are referentially independent:

```js
class JsonModuleSource {
  bindings = { export: 'default' };
  constructor(text) {
    this.#object = JSON.parse(text); // throw SyntaxError here if invalid
  }
  execute(imports) {
    imports.default = clone(this.#object);
  }
}
const module = new Module(new JsonModuleSource({ meaning: 42 }));
const { default: { meaning } } = await import(module);
```

"Asset modules of various kinds would largely follow this pattern."

## WASM

On a host that does not wire WebAssembly into the module graph, a virtual source derives its `bindings` from the WASM module's imports/exports, then links them at execute time:

```js
class WasmModuleSource {
  constructor(buffer) {
    const module = new WebAssembly.Module(buffer);
    this.#imports = WebAssembly.Module.imports(module);
    this.#exports = WebAssembly.Module.exports(module);
    this.bindings = [
      ...this.#imports.map(({ module, name }) => ({ import: name, from: module })),
      ...this.#exports.map(({ name }) => ({ export: name })),
    ];
  }
  async execute(namespace) {
    const importObject = {};
    for (const { name } of this.#imports) importObject[name] = namespace[name];
    const instance = await WebAssembly.instantiate(module, importObject);
    for (const { name } of this.#exports) namespace[name] = instance[name];
  }
}
```

## CommonJS

There is **no single perfect solution** for binding CommonJS — an asynchronous loader cannot imitate Node.js's synchronous loader — but any Node.js library portable to the web must be transparent enough to static analysis that bundlers can subsume it, so large amounts of the CommonJS ecosystem are in fact portable. The explainer sketches one solution (based on Endo's): `lexicallyAnalyzeCjs` infers named-export `bindings` and the `require` sites, then `execute` compiles the body with a `globalThis.Function` functor of `(require, exports, module, __filename, __dirname)`, and installs a `Proxy` over `namespace.default` whose `set`/`defineProperty` traps **promote** assigned properties to top-level named exports (so `import *` sees them). A `module` object with an `exports` getter/setter distinguishes a wholesale `module.exports = …` reassignment, after which the keys of the new exports object are re-promoted. (`__esModule` must survive for TypeScript-compiled modules.)

## Pass-through

A virtual source can re-export another module with no executor at all — pure bindings:

```js
import * as direct from 'real.js';
const source = { bindings: { exportAllFrom: 'real.js', as: 'real' } };
const module = new Module(source);
const { real: indirect } = await import(module);
direct === indirect; // true
```

Source: [proposal-compartments/2-virtual-module-source.md](https://github.com/tc39/proposal-compartments/blob/master/2-virtual-module-source.md) at content sha256 `ffd7fbc7`. Stage 1; retrieved 2026-07-21.
