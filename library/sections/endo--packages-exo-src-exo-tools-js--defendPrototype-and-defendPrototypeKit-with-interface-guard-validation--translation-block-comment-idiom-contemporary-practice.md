---
title: Translation block (comment idiom → contemporary practice)
source: packages/exo/src/exo-tools.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2025-10-09
source_authors: [Kris Kowal]
source_lines: "348-513 (defendPrototype + defendPrototypeKit)"
topics: [hardened-javascript, exo]
status: current
notes: |
  Section 2 of cycle 118's exo-tools.js ingest (sister to section 1
  which covers the method-defense layer). This section captures
  the *prototype-building* layer — the two public exports
  `defendPrototype` and `defendPrototypeKit` that cycle 108's
  exo-makers.js imports and consumes.
  
  Three structurally interesting moves in section 2: (1) the
  *behavior-methods-as-first-arg-vs-as-this* dual mode via the
  `thisfulMethods` flag — non-thisful mode wraps each behavior
  method in a `shiftedMethod(...args) { return originalMethod(this,
  ...args) }` adapter so the user can write methods that take
  state as the first arg explicitly; (2) the *symmetric
  listDifference validation* for interface guards — *methods X
  not implemented by tag* (interface declares methods behavior
  doesn't have) + *methods X not guarded by interfaceName*
  (behavior has methods interface doesn't declare; only enforced
  when defaultGuards is undefined); (3) the *GET_INTERFACE_GUARD
  auto-installation* — the runtime-introspection method gets
  added to every prototype that doesn't already have it; this is
  how downstream code (the introspection API for exo classes)
  queries the interface guard at runtime.
  
  Plus the *constructor-filter discipline* — *By ignoring any
  method that seems to be a constructor, we can use a
  class.prototype as a behaviorMethods* — lets the user pass a
  JavaScript class.prototype directly as the behavior-methods
  object. And the *deprecated-sloppy-flag handling* — `sloppy:
  true` is aliased to `defaultGuards: 'passable'` for backward
  compatibility.
parent: endo--packages-exo-src-exo-tools-js--defendPrototype-and-defendPrototypeKit-with-interface-guard-validation
---

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `By ignoring any method that seems to be a constructor, we can use a class.prototype as a behaviorMethods` | The *gracefully-accept-class-prototypes-by-filtering-constructor* discipline. |
| `defaultGuards: dg = sloppy ? 'passable' : undefined` | The *deprecated-flag-aliased-to-new-mechanism* discipline; preserve backward-compat. |
| `methods X not implemented by tag` + `methods X not guarded by interfaceName` | The *symmetric-listDifference-validation* discipline; check both directions. |
| `shiftedMethod(...args) { return originalMethod(this, ...args) }` | The *non-thisful-to-thisful adapter* idiom; supports two authoring styles. |
| `thisful → PassableMethodGuard; non-thisful → RawMethodGuard` default | The *style-appropriate-default-guard* discipline. |
| `hasOwn(prototype, GET_INTERFACE_GUARD) ? skip : install` | The *auto-installation-if-not-already-present* discipline. |
| `[GET_INTERFACE_GUARD]() { ... }` computed-property concise method | The *concise-method-syntax-for-symbol-keys* idiom. |
| `// Note: May be `undefined`` (GET_INTERFACE_GUARD method body) | The *honest-acknowledgment-of-undefined-return* comment. |
| `Far(tag, prototype)` | The *passable-prototype-with-Symbol.toStringTag* wrapping. |
| `A multi-facet object must have multiple facets` | The *category-error-rejection* discipline; kit-vs-class distinction. |
| 4-way listDifference validation in defendPrototypeKit | The *all-four-corners* validation; facet/interface + facet/context, both directions. |
| `objectMap(behaviorMethodsKit, ...)` per-facet delegation | The *per-facet-delegate-to-single-facet-factory* pattern. |
