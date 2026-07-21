---
title: Compartments layer 0 — the ModuleHandler, import hooks, and the referrer design
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

Abstract: How the layer-0 `Module` constructor virtualizes host module loading — an optional second argument, a **`ModuleHandler`** (Proxy-handler-shaped), supplies an async `importHook(specifier) → Promise<Module>` and an `importMetaHook(importMeta)`; the constructor *eagerly captures* those methods (deliberately unlike `Proxy`, which reads them afresh), so mutating the handler afterward does not change an already-constructed instance; and the **referrer** (the basis for resolving relative specifiers) is carried on the handler object rather than a fixed parameter, kept deliberately independent from `import.meta.url` and from the non-virtualizable *origin* used for CSP. This is the virtualization surface a minimal Compartments spec must decide how much of to adopt; companion to `--modulesource-and-module-instance-model` and `--intersection-semantics-and-262-factoring`.

## Virtual host import behavior

The `Module` constructor takes an optional handler that overrides the host-defined behavior for importing shallow dependencies. It eagerly captures `importHook` and `importMetaHook` (all optional):

```js
class ModuleHandler {
  importHook(specifier) {
    return import.module(specifier);         // defer to the host, or…
    // return new Module((await import.module(specifier)).source); // separate instance
    // return module {};                     // …a module expression, or…
    // const source = new ModuleSource(await (await fetch(specifier)).text());
    // return new Module(source);             // …a fresh Module from whole cloth
  }
}
const source = new ModuleSource(`import foo from 'foo'`);
const module = new Module(source, new ModuleHandler());
await import(module);
```

The `importHook` is called once per unsatisfied dependency; `Module` instances memoize its result keyed on the import specifier. For `importHook` to receive `this` it must be a class method, function declaration, or concise method. Unlike a `Proxy`, changing the `importHook` property does not alter the behavior of any `Module` instance that already captured it at construction.

`importMetaHook(importMeta)` receives an empty null-prototype object the first time (if ever) a module evaluates `import.meta`, so a handler can lazily embellish it (e.g. set `importMeta.url = this.url`) and avoid the per-module allocation except where needed.

## The referrer design

A module typically has three distinct but often coincident data:

- The **`referrer`** — the basis for resolving import specifiers.
- The **`import.meta.url`** — the basis for locating resources adjacent to a module via URL math. `import.meta` should not have a `url` unless useful for that purpose (so it should not exist for modules in bundles/archives), but is often identical to the referrer.
- The **origin of the source** — the basis for a host deciding whether to allow evaluation under CSP. It lives in host data of the *module source* and **must not be virtualizable**, lest a virtual host escape a same-origin policy.

Although related, these must be independent. Virtual hosts cannot rely on `import.meta.url` existing and must be able to virtualize the referrer. The authors relegated the `referrer` to the handler object (analogous to a `Proxy` handler) rather than a fixed parameter, so a virtual host can carry it however it likes — `this.referrer` (a string), `this.slot` (an index into precomputed bundle resolutions), or any protocol. This works because host-defined and virtual-host-defined resolution never need to communicate. A consequence: each `Module` retains its handler, and if the handler carries a per-module referrer, every `Module` instance needs a unique handler even though many can share the same hooks.

Source: [proposal-compartments/0-module-and-module-source.md](https://github.com/tc39/proposal-compartments/blob/master/0-module-and-module-source.md) at content sha256 `e51cb06e`. Stage 1; retrieved 2026-07-21.
