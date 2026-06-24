---
title: Abstract
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

The §`defendPrototype(tag, contextProvider, behaviorMethods, thisfulMethods?, interfaceGuard?)` (lines 348-468) is the file's primary export — the file that cycle 108's exo-makers.js imports as `defendPrototype` and consumes in `defineExoClass`. The §method discovery (lines 364-377) uses `getRemotableMethodNames(behaviorMethods)` filtered by *ignoring any method that seems to be a constructor* — *By ignoring any method that seems to be a constructor, we can use a `class.prototype` as a behaviorMethods*. The §filter logic: only ignore `key === 'constructor'` if `behaviorMethods.constructor` is *itself a class constructor* (i.e., `constructor.prototype.constructor === constructor`). This lets the user pass a JavaScript class's `.prototype` directly as the behavior-methods.

The §interface-guard validation (lines 378-407) extracts five fields from the interface guard via `getInterfaceGuardPayload`: `interfaceName`, `methodGuards`, `symbolMethodGuards`, `sloppy`, `defaultGuards`. The §`defaultGuards = sloppy ? 'passable' : undefined` clause handles the deprecated `sloppy: true` flag as an alias for `defaultGuards: 'passable'`. Symbol method guards are merged in via `fromEntries(getCopyMapEntries(symbolMethodGuards))`. The §two complementary `listDifference` checks: (1) *methods X not implemented by tag* (interface declares methods that the behavior doesn't have); (2) *methods X not guarded by interfaceName* (behavior has methods the interface doesn't declare; only enforced when `defaultGuards === undefined`, since otherwise the default-guard catches them).

The §per-method wrapping loop (lines 409-449) walks each method name and:

1. **Picks the right callable** — `thisfulMethods ? originalMethod : shiftedMethod`. The §`shiftedMethod(...args) { return originalMethod(this, ...args) }` adapter wraps the original to *put `this` as the first arg* — supporting the non-thisful style where users write `behaviorMethods = { method: (state, ...args) => ... }`.
2. **Picks the right method-guard** — explicit `methodGuards[prop]` if present; else fall back per `defaultGuards`: `undefined` → `PassableMethodGuard` for thisful or `RawMethodGuard` for non-thisful; `'passable'` → `PassableMethodGuard`; `'raw'` → `RawMethodGuard`; unknown → `Fail`.
3. **Wraps via `bindMethod`** — produces the defended method with `name = "In <prop> method of (<tag>)"`.
4. **Stores on prototype** — `prototype[prop] = defended-method`.

The §`GET_INTERFACE_GUARD` symbol auto-installation (lines 451-464) — if the prototype doesn't already have `GET_INTERFACE_GUARD`, the factory adds a method that returns the (possibly undefined) `interfaceGuard`. The method is wrapped via `bindMethod` with `PassableMethodGuard`. The §discipline: *every exo instance has a runtime-introspection point for its interface guard*.

The §final wrapping (line 466) — `Far(tag, prototype)` produces the user-visible prototype with the tag as `Symbol.toStringTag`.

The §`defendPrototypeKit(tag, contextProviderKit, behaviorMethodsKit, thisfulMethods?, interfaceGuardKit?)` (lines 478-513) is the multi-facet variant:

- **Sort facet names** — `ownKeys(behaviorMethodsKit).sort()` for stable iteration.
- **Reject single-facet kits** — *A multi-facet object must have multiple facets* (kits with one facet should use `defineExoClass` not `defineExoClassKit`).
- **Cross-check facet-names against interface-guard-names** — `listDifference` both ways; extras in either direction throw with *Interfaces X not implemented by tag* or *Facets X of tag not guarded by interfaces*.
- **Cross-check facet-names against context-provider-names** — same pattern; extras throw with *Contexts X not implemented by tag* or *Facets X of tag missing contexts*.
- **Per-facet delegation** — `objectMap(behaviorMethodsKit, (behaviorMethods, facetName) => defendPrototype('${tag} ${facetName}', contextProviderKit[facetName], behaviorMethods, thisfulMethods, interfaceGuardKit?.[facetName]))`.
