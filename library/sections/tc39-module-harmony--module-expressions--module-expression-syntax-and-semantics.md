---
title: Module Expressions — syntax, the Module value, realm capture, and no closure
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-module-expressions/main/README.md
source_content_sha256: 4b29381601d31c9ddb3eab19f8298b5d52b77c1ef934df18196ef41d0ece3697
source_authors: [Surma, Daniel Ehrenberg, Nicolò Ribaudo]
source_date: 2025-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
topics: [module-harmony]
status: current
---

Abstract: The **module expressions** proposal (previously "module blocks"; Stage-3 reviewers listed) — `module { … }` is a `PrimaryExpression` that evaluates to a `Module` object, importable only through dynamic `import()` (there is no specifier string for a static import), cached in the module map so repeated `import()` of the same instance yields the same namespace. A module expression *captures the realm* it is declared in (so it evaluates once even when imported from another realm), but *cannot close over* any lexically-scoped variable outside the module — which is what makes it structured-cloneable and re-attachable to a different realm (ShadowRealm). Companion to `--relationship-to-module-class-and-bundling`. The `module {}`-evaluates-to-a-`Module`-instance surface is a direct intersection point with the Compartments `Module`/`ModuleSource` model.

## High-level

Module expressions are syntax for the contents of a module: they evaluate to a `Module` object.

```js
let mod = module { export let y = 1; };
let moduleExports = await import(mod);
assert(moduleExports.y === 1);
assert(await import(mod) === moduleExports);  // cached in the module map
```

Importing a `Module` object needs to be async, as module objects may import other modules from the network. Module objects may get imported multiple times, but get cached in the module map and return a reference to the same namespace. Module objects can only be imported through dynamic `import()`, not through `import` statements, as there is no way to address them using a specifier string. Relative import statements are resolved against the path of the *outer* module.

## Syntax

```
PrimaryExpression :  ModuleExpression
ModuleExpression : `module` [no LineTerminator here] `{` ModuleBody? `}`
```

As `module` is not a keyword in JavaScript, no newline is permitted after `module`.

## Realm interaction

Module expressions behave similarly to function expressions: they capture the Realm where they are declared. A `Module` object will always only be evaluated once, even if imported from multiple realms:

```js
let mod = module { export let x = true; };
let ns = await import(mod);
let ns2 = globalThisFromDifferentRealm.eval("m => import(m)")(mod);
assert(ns === ns2);
```

However, they cannot close over any lexically scoped variable outside of the module: this makes it possible to easily clone them, re-attaching them to a different realm. In conjunction with the [ShadowRealm proposal], module expressions could permit syntactically-local code to be executed in the context of another realm; a module imported into a ShadowRealm sees *that* realm's globals (`globalThis.flag` reads differently inside a `new ShadowRealm()`).

## HTML integration points

Four integration points: **Worklets** (`addModule` accepts a `Module` object), **structured clone** (module objects are structured-cloneable, so they can be `postMessage`'d to Workers/ServiceWorkers/windows), **`import.meta`** (inherited from the module the expression is *syntactically* located in, essential so relative paths behave as expected once shared across realms), and the **Worker constructor** (originally to accept a `Module` directly, currently on hold in favor of the Blank Worker proposal).

## CSP

Module expressions are parsed in syntax with the surrounding code, so they cannot be a vector for injection and are not blocked by a no-`eval` policy (unlike `data:` URLs); the source-list restriction treats them as always in the sources list, since they are part of an already-loaded script resource.

Source: [proposal-module-expressions/README.md](https://github.com/tc39/proposal-module-expressions/blob/main/README.md) at content sha256 `4b293816`. Stage-3 reviewers listed; retrieved 2026-07-21.
