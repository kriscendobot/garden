---
title: Compartments layer 1 — why static analysis, the graph-analysis and HMR examples, and the isAsync/needsImport questions
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

Abstract: The motivation and design-question half of Compartments layer 1 (`1-static-analysis.md`). Surfacing `import`/`export` bindings at the language level lets tools build a module graph **from module text without executing it and without a ~1MB JavaScript meta-parser** — the first step for bundlers, import-map generators, hot-module-replacement systems, and persistent test runners, and a way to make production systems operate on real sources rather than generated artifacts. Includes the worked "analyze a module graph over the web without executing anything" example, the hot-module-replacement watcher sketch, and the two open design questions: whether `isAsync` must also be reflected, and why `needsImportMeta` is worth a per-source flag (a per-module-instance closure-allocation optimization) while `needsImport` is not. The `Binding` shapes and the reflection-is-a-copy guarantee live in the companion `--binding-shapes-and-modulesource-reflection`.

## Motivation

A mechanism to statically analyze a module's *shallow* dependencies lets tools create a module graph from module texts **without executing them and without a heavy dependency on a full JavaScript parser**. This is the first step in many module-system tools: build systems, bundlers, import-map generators, hot-module-replacement systems, and test dependency watchers.

The weight and performance of a JavaScript meta-parser (about 1MB) often precludes production use-cases that operate directly on JavaScript module source. Surfacing this feature at the language level would likely let production systems operate directly on JavaScript sources instead of generated artifacts — making production more closely resemble what was tested in development, and making production debugging map onto its development analogue. Tools named as beneficiaries:

- **Bundlers** (Browserify, WebPack, Parcel) virtualize *loading* but not *evaluation* of module graphs and emulate other host environments.
- **Import mappers** (import-map) need to collect transitive dependencies per ECMAScript and specific host behaviors; a native module-loader interface would expedite their evolution.
- **Hot module replacement** (WebPack, SnowPack) needs to instantiate new module graphs when dependencies change and to bequeath subgraphs to new graphs. (Node.js defers to ECMAScript to provide the loader interface HMR needs.)
- **Persistent test apparatuses** (Jest) reinstantiate whole module graphs to reconstruct tests and subjects. Jest currently exploits the Node.js `vm` module to instantiate separate realms and *fails* to fully paper over the single-realm illusion by patching client realms with host intrinsics.

## Example — analyze a module graph without executing it

Static bindings let a loader crawl the graph over the network, keyed on URL, executing nothing:

```js
const graph = new Map();
const load = async url => {
  if (graph.has(url)) return;
  const response = await fetch(url);
  if (response.url !== url) {           // account for redirects
    graph.set(url, new Set([response.url]));
    return load(response.url);
  }
  const edges = new Set();
  graph.set(url, edges);
  const source = new ModuleSource(await response.text());
  const dependencies = [];
  for (const binding of source.bindings) {
    const from = binding.from ?? binding.importAllFrom ?? binding.exportAllFrom;
    if (from) {
      const importUrl = new URL(binding.from, url).href;
      edges.add(importUrl);
      dependencies.push(load(importUrl));
    }
  }
  await Promise.all(dependencies);
};
await load('https://example.com/example.js');
```

## Example — hot module replacement

The explainer sketches an HMR watcher that reuses `Module`/`ModuleSource` objects between reloads: `getImports` derives dependency specifiers from `source.bindings`; a change invalidates a module and its transitive **dependees** (via the co-graph), hands off module-scoped state through an `import.meta.registerGetState` protocol, and rebuilds only the changed subgraph. The `importHook` memoizes one `Module` per URL and one `ModuleSource` per source text, and the state-handoff protocol is `import.meta.state` in / `import.meta.registerGetState(() => state)` out. (The sketch assumes fictitious `watch`/`Promise.defer`/`Promise.delay` helpers; it is illustrative, not runnable.)

## Design questions

- **Reflect `isAsync`?** Whether the source must expose that execution will be asynchronous *before* execution begins. XS implemented virtual module sources **without** an explicit indicator; ECMA-262 currently carries `[[IsAsync]]` on the *Cyclic Module Record*, which suggests that if engines can be implemented without foreknowledge, the spec would need refactoring to reflect that.

## Design rationales

- **`needsImportMeta` earns its flag.** It lets virtual import hooks omit properties from the `importMeta` of any `Module` derived from the source, on proof the module never reads `import.meta`. Concretely `import.meta.resolve` is a closure over the module's referrer; in graphs with thousands of instances that mostly do not touch it, avoiding per-module closure allocation is a significant memory saving.
- **`needsImport` was omitted.** The analogous flag would be `false` only for modules that use no static `import`/`export … from` and never use dynamic `import`. Since virtual module graphs can share relatively few `importHook` instances, the savings would be negligible, so the flag was dropped.

Source: [proposal-compartments/1-static-analysis.md](https://github.com/tc39/proposal-compartments/blob/master/1-static-analysis.md) at content sha256 `f775af19`. Stage 1; retrieved 2026-07-21.
