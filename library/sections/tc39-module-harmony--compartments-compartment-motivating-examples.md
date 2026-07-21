---
title: Compartments layer 4 — motivating examples (multiple instantiation, virtualized web/node compartments, bundling)
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/4-compartment.md
source_content_sha256: da5681d6259013c31ff429d36e5256e2079761f994ca1a3a01187d3ba43e2e2
source_authors: [Mark S. Miller, Caridy Patiño, Patrick Soquet, Kris Kowal, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
topics: [module-harmony, compartments]
status: current
---

Abstract: Five motivating use cases for the Compartments layer — multiple-instantiation (reusing the host's module source as a memo cache across separate compartment instances), virtualized web compartments (full URL-URL redirection via `resolveHook`/`loadHook`), virtualized Node.js compartments (`file:` specifiers with custom `import.meta.url` and conditional evaluation hooks), bundling/archiving (serializing a compiled module's bytecode for redeployment in another realm or engine), and inter-compartment linkage (transitive imports across compartment boundaries using shared `ModuleSource` records). Each example shows how `resolveHook`, `loadHook`, and the descriptor/namespace return options from `loadHook` compose into concrete isolation patterns.

## Multiple-instantiation

This example illustrates the use of a new compartment to support multiple instantiation of modules, reusing the host's compartment and module source memo as a cache.

```js
const evaluator = await (async () => {
  const { Module } = await import('node:module');
  // ... evaluate the module in a new context
})();

// The evaluator can now import from the same compiled source
// multiple times, each time producing a separate instance.
await evaluator.import('https://example.com/example.js');
```

Multiple `Compartment` instances sharing the same `ModuleSource` produce distinct module namespaces — one namespace per compartment instance. This is the "many-instances-per-source" pattern that enables isolated sandboxing without recompilation overhead.

## Virtualized Web Compartment

A virtualized web compartment uses a `resolveHook` to redirect URL resolution and a `loadHook` that fetches remote content, allowing the compartment to operate entirely in user code without browser integration:

```js
const compartment = new Compartment({
  resolveHook(importSpecifier, referrerSpecifier) {
    return new URL(importSpecifier, referrerSpecifier).href;
  },
  async loadHook(fullSpecifier) {
    const response = await fetch(fullSpecifier);
    if (response.status !== 200) throw new Error(response.statusText);
    const text = await response.text();
    // Return a ModuleSource constructed from the fetched text.
    return { source: new ModuleSource(text) };
  }
});
```

The `resolveHook` produces URL-based specifiers consistent with web semantics; the `loadHook` fetches and compiles them, returning a `{source}` descriptor that the compartment will compile on first load and memoize.

## Virtualized Node.js Compartment

A virtualized Node.js compartment supports `file:` specifiers, custom `import.meta.url`, and per-load evaluation hooks:

```js
const compartment = new Compartment({
  resolveHook(importSpecifier, referrerSpecifier) {
    return new URL(importSpecifier, referrerSpecifier).href;
  },
  loadHook(fullSpecifier) {
    const url = new URL(fullSpecifier);
    if (url.protocol !== 'file:') throw new Error('Only file: supported');
    
    // Use node's FS to read the module
    const fs = require('fs');
    const source = fs.readFileSync(url.pathname, 'utf8');
    
    return {
      source: new ModuleSource(source),
      importMeta: { url: fullSpecifier }
    };
  },
  endorseBuiltinsHook(builtins) {
    return new Proxy(builtins, {
      get(target, prop) {
        if (prop === 'fs') return null; // deny fs
        return Reflect.get(target, prop);
      }
    });
  }
});
```

The `endorseBuiltinsHook` demonstrates per-compartment control over which built-in modules are accessible. Returning `null` for a builtin name denies access to that module. The `importMeta.url` is set from the file specifier, providing a meaningful referrer value.

## Bundling or Archiving

A bundler can capture bytecode from a compiled module and rehydrate it in another context:

```js
class BundledModuleSource {
  #bytecode;
  #bindings;
  
  constructor(bytecode, bindings) {
    this.#bytecode = bytecode;
    this.#bindings = bindings;
  }
  
  static async compile(moduleSource, evaluator) {
    // Compile the source and capture bytecode
    return new BundledModuleSource(
      evaluator.compile(moduleSource),
      moduleSource.staticAnalysis.bindings
    );
  }
}
```

Bundling compiles modules once (in a "build" context) and produces serializable artifacts. The `staticAnalysis.bindings` capture the import/export surface without execution, allowing bundlers to inspect module graphs without running code. This is critical for tree-shaking and dependency analysis at build time.

[ses]: https://github.com/endojs/endo/tree/master/packages/ses
