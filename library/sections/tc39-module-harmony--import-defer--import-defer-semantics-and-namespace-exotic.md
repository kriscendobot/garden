---
title: import defer — semantics, the deferred namespace exotic object, and top-level await
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

Abstract: The operational core of `import defer` — the syntax `import defer * as ns from "y"`, the rule that the module and its dependencies are *fully loaded* but *not evaluated* until a property of the namespace is accessed, the fact that property access triggers a *synchronous* top-level execution (so the namespace acts as a proxy with side-effectful `[[Get]]`), the eager evaluation of any top-level-await subgraph (deferral only covers the synchronous parts), and why a deferred namespace is a *different* object from a plain `import *` namespace (it must re-throw the module's evaluation error on every access). This is the surface a Compartments spec must decide whether to virtualize. Companion to `--motivation-deferring-module-evaluation` and `--phases-model-modifiers-vs-attributes`.

## Proposal

A new syntactical import form which will only ever return a namespace exotic object. When used, the module and its dependencies would not be executed, but would be fully loaded to the point of being execution-ready before the module graph is considered loaded. *Only when accessing a property of this module would the execution operations be performed (if needed).* The namespace exotic object acts like a proxy to the evaluation of the module, effectively with `[[Get]]` behavior that triggers synchronous evaluation before returning the defined bindings.

```js
import defer * as yNamespace from "y";
```

## Semantics

The imports still participate in deep graph loading so that they are fully populated into the module cache prior to execution, but the imported module is not evaluated yet. When a property of the resulting module namespace object is accessed, if the execution has not already been performed, a new top-level execution is initiated for that module. A deferred module evaluation import acts as a new top-level execution node in the execution graph, just like a dynamic import does, except executing synchronously.

## Top-level await

Property access on the namespace object of a deferred module must be synchronous, so it is impossible to defer evaluation of modules that use top-level await. When a module is imported using `import defer`, its asynchronous dependencies together with their transitive dependencies are eagerly evaluated, and only the synchronous parts of the graph are deferred.

In the proposal's worked example (`a` imports `b` and `import defer * as c from "c"`; `c` imports `d` and `f`; `d` uses `await 0`): since `d` uses top-level await, `d` and its dependencies cannot be deferred — the initial evaluation executes `b`, `e`, `d`, and `a`; later, the `c.value` access triggers the execution of `f` and `c`.

## Why the deferred namespace differs from a plain namespace

Module namespace objects of modules that are *already evaluated* and threw during evaluation do **not** re-throw on property access. Deferred namespaces are different: if the module throws while being evaluated, `deferredNamespace.foo` will **always** throw the evaluation error.

```js
// module-that-throws2: export let a = 1; throw new Error("oops");
import defer * as ns2 from 'module-that-throws2';
try { ns2.a } catch (e) { console.log(e.message) } // logs "oops"
```

`ns2.a` must throw even if `module-that-throws2` is already evaluated, so it cannot be the same namespace object as `import *`. (An alternative that always suppressed evaluation errors on access was considered and discarded.)

Source: [proposal-defer-import-eval/README.md](https://github.com/tc39/proposal-defer-import-eval/blob/main/README.md) at content sha256 `bd8d5bc5`. Stage 3; retrieved 2026-07-21.
