---
title: Common confusions
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

- **"`getRemotableMethodNames(behaviorMethods)` returns just string keys."** It returns *both string keys and symbol keys* (Remotable methods can have symbol names). The §`symbolMethodGuards` handling later in the function merges symbol-keyed guards into the same `methodGuards` record.
- **"`shiftedMethod` always wraps even when not needed."** It does — *but only when `thisfulMethods === false`*. The §`thisfulMethods ? originalMethod : shiftedMethod` selects per call site. For `defineExoClass` (which passes `thisfulMethods = true`), the wrapping never happens.
- **"The deprecated `sloppy: true` should just be removed."** It's *kept for backward compatibility*. The §`sloppy ? 'passable' : undefined` aliasing lets old code continue to work; new code uses `defaultGuards: 'passable'` directly. Removing the alias would break existing interface guards.
- **"`unguarded` check only runs when `defaultGuards === undefined` — what about `'passable'`?"** When `defaultGuards: 'passable'`, *every unguarded method gets `PassableMethodGuard` automatically*. The §discipline: no need to flag unguarded methods because the default covers them. The `'raw'` case similarly.
- **"`hasOwn(prototype, GET_INTERFACE_GUARD)` check is dead code — `prototype = {}` was just created."** It's *not always*. The §user-provided `behaviorMethods` might define `[GET_INTERFACE_GUARD]` explicitly; in that case, the loop adds it from behaviorMethods, and the `hasOwn` check skips the auto-install. The §discipline: *don't override user intent*.
- **"`Far(tag, prototype)` is just adding a toStringTag — why not `Object.defineProperty`?"** `Far` is *the canonical passable-marker*. It does more than just set toStringTag — it ensures the object satisfies pass-style's *remotable* requirements (frozen + no own data properties + correct prototype structure). Using `Object.defineProperty` would be insufficient.
- **"Why `ownKeys(behaviorMethodsKit).sort()` instead of `Object.keys(...).sort()`?"** `ownKeys` includes *symbol keys*; `Object.keys` doesn't. The §discipline: kit facets can be symbol-keyed; the iteration must include them.
- **"`A multi-facet object must have multiple facets` is tautological."** It's *intentional rejection of the single-facet-kit category error*. A user with one facet should use `defineExoClass`; using `defineExoClassKit` for one facet would create a kit-shape (record-of-facets) where a class-shape (single object) is more appropriate. The §discipline: *fail-fast on category errors*.
- **"`objectMap(behaviorMethodsKit, (behaviorMethods, facetName) => defendPrototype(...))` produces a record of facets — but each facet has its own context."** Each facet's `contextProviderKit[facetName]` resolves to *the same shared context object* (the kit's single context with multiple facets). The §discipline: *facets share the context; each gets its own self-reference via the facet name*.
- **"Section 1's `defendMethod` could just inline the dispatch — why a separate function?"** Symmetry. `defendMethod` is the *callKind dispatcher*; `defendSyncMethod` and `defendAsyncMethod` are the *per-kind implementations*. Separating the dispatcher makes each piece testable and replaceable. The §discipline: *one-concern-per-function*.
