---
title: Module Declarations — named inline modules, static import, and bundling
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-module-declarations/main/README.md
source_content_sha256: 78c1d1724d4270f12a1d7ba9f80d6b2dd87067de6dfe84368c4ad3cb0dcd0410
source_authors: [Daniel Ehrenberg, Nicolò Ribaudo]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
topics: [module-harmony]
status: current
---

Abstract: The **module declarations** proposal (previously "module fragments"; Stage 2; champions Daniel Ehrenberg, Nicolò Ribaudo) — `module Identifier { … }` is a top-level declaration for a named, inline JS module that *can be imported statically* (`import { count } from countModule`), unlike an anonymous module expression which is only dynamically importable. Declarations are singletons (imported multiple times → same instance), have their own top-level lexical scope with no shared scope, and are only visible outside their containing file if `export`ed. The intended use is a low-overhead JS-only bundling format that engines and tools can see through, ideally *nested inside* general-purpose resource bundles. Its relationship to module expressions (static-import lift, shared no-closure design) is the intersection edge; the deeper resource-bundle comparison is summarized here rather than transcribed.

## What it is

A syntax for named, inline JS modules, usable for bundling multiple modules into a single JavaScript file. `ModuleDeclaration` is a new nonterminal that can exist at the top level of a module or a script:

```
ModuleDeclaration : module [no LineTerminator here] Identifier { ModuleBody? }
```

Example:

```js
// filename: app.js
module countModule {
  let i = 0;
  export function count() { i++; return i; }
}
export module uppercaseModule {
  export function uppercase(string) { return string.toUpperCase(); }
}
import { count } from countModule;
import { uppercase } from uppercaseModule;
```

Module declarations may be nested inside other module declarations. As with module expressions, there is no shared lexical scope between a declaration and its container — they sit side by side, like modules fetched from different URLs.

## Semantics

- Module declarations can be imported **statically**.
- They are only available outside the containing module if **exported explicitly** (`countModule` above is private; `uppercaseModule` is exported).
- Each declaration has its own top-level lexical scope; there is no shared scope.
- If imported multiple times, the same module "instance" is returned — declarations are **singletons**, just like modules in separate files.

## HTML integration

`import.meta.url` inside a declaration is the module specifier of the *surrounding* module; relative specifiers resolve as if defined in the outer module (`new URL(spec, import.meta.url)`). This follows from the module-expressions semantics.

## Motivation and bundling

Bundlers today must *entirely virtualize* ES module semantics, which adds complexity (growing with features like top-level await) and hides module structure from engines. Module declarations give a native JS-only bundling format with low execution overhead that tools can emit and engines can see through. The author's hypothesis is that for best performance, module declarations should be *nested inside* resource bundles: resource-bundle expressiveness combined with the low per-asset overhead of a JS-specialized format (most of the "blow-up" in asset count is JS modules). See the README's point-by-point resource-bundles-vs-module-declarations comparison (level, types, metadata, caching, versioning, parsing performance, per-asset overhead, complexity) for the full trade table.

## Relationship to module expressions

Module expressions are *expressions* and inherently dynamic (importable with `import()`/`new Worker()` but not static `import`). Module declarations lift that restriction: at the top level of a module they can be imported statically, which makes them more useful for bundling. They are developed as separate proposals because declarations add complexity around static import statements; declarations *inherit* design decisions from module expressions, so their advancement depends on the evolution of module expressions.

Source: [proposal-module-declarations/README.md](https://github.com/tc39/proposal-module-declarations/blob/main/README.md) at content sha256 `78c1d172`. Stage 2; retrieved 2026-07-21.
