---
title: import defer — motivation for deferring module evaluation
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

Abstract: Why the **Deferring Module Evaluation** proposal (`import defer`, previously "Lazy Module Initialization"; Stage 3; champion Nicolò Ribaudo) exists — even when loading is solved by preloading and dynamic `import()`, initialization still burns CPU executing modules whose exports are never touched on a given run. Dynamic `import()` does not solve deferral (it needs a preload step and forces async on every caller); a new primitive is wanted that defers *synchronous evaluation* without changing the module's consumer-facing API. Sets up the semantics section (`--import-defer-semantics-and-namespace-exotic`). Does not cover the phases-vs-attributes rationale (`--phases-model-modifiers-vs-attributes`).

## Background

JS applications can get very large, to the point that not only loading, but even executing their initialization scripts incurs a significant performance cost. Loading performance involves preloading techniques for avoiding waterfalls and dynamic `import()` for lazily loading modules. But even with loading performance solved, there is still overhead for execution performance — CPU bottlenecks during initialization due to the way the code itself is written.

## Motivation

Avoiding unnecessary execution is a well-known optimization in the Node.js CommonJS module system. The common pattern is to refactor code to dynamically require as needed:

```js
const operation = require('operation');
exports.doSomething = function (target) { return operation(target); }
```

rewritten into:

```js
exports.doSomething = function (target) {
  const operation = require('operation');
  return operation(target);
}
```

For ES modules, we have a solution for the lazy *loading* component via dynamic `import()`:

```js
export async function doSomething (target) {
  const { operation } = await import('operations');
  return operation(target);
}
```

This avoids bottlenecking the network and CPU during initialization, but there are still problems:

1. It doesn't actually solve the deferral of *execution*, since sending a network request would usually be a performance regression; a separate preloading step would still be desirable.
2. It forces all functions and their callers into an asynchronous programming model, without necessarily reflecting the real intention of the program — a breaking API change to existing consumers.

## Problem statement

Deferring the synchronous evaluation of a module may be a desirable new primitive to avoid unnecessary CPU work during application initialization, without requiring any changes from a module API consumer perspective. Dynamic import does not properly solve this, since it must often be coupled with a preload step, and enforces the unnecessary asyncification of all functions.

Source: [proposal-defer-import-eval/README.md](https://github.com/tc39/proposal-defer-import-eval/blob/main/README.md) at content sha256 `bd8d5bc5`. Stage 3; retrieved 2026-07-21.
