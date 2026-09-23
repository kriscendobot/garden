---
title: The §`defendPrototype(tag, contextProvider, behaviorMethods, thisfulMethods?, interfaceGuard?)` public factory — the file's *primary export* that cycle 108's exo-makers.js imports; the §method-name discovery via `getRemotableMethodNames(behaviorMethods)` with the §`constructor` filter (ignore method-named *constructor* unless `constructor.prototype.constructor !== constructor` — *By ignoring any method that seems to be a constructor, we can use a class.prototype as a behaviorMethods*); the §interface-guard validation — extracts `interfaceName`/`methodGuards`/`symbolMethodGuards`/`sloppy`/`defaultGuards` via `getInterfaceGuardPayload`; merges `symbolMethodGuards` via `fromEntries(getCopyMapEntries(...))`; the §`defaultGuards: dg = sloppy ? 'passable' : undefined` deprecated `sloppy` flag handled as alias for `defaultGuards: 'passable'`; the §two complementary listDifference checks — *methods X not implemented by tag* (interface declares methods the behavior doesn't have) and *methods X not guarded by interfaceName* (behavior has methods the interface doesn't declare; only enforced when `defaultGuards` is undefined); the §per-method wrapping in the iteration — `thisfulMethods ? originalMethod : shiftedMethod` where `shiftedMethod(...args) { return originalMethod(this, ...args) }` adapts behavior-methods-as-first-arg to behavior-methods-as-this for the non-thisful case (allowing `behaviorMethods = { method: (state, ...args) => ... }` style); the §defaultGuards-resolution per-method — `undefined` falls back to `PassableMethodGuard` for thisful or `RawMethodGuard` for non-thisful; `'passable'` → `PassableMethodGuard`; `'raw'` → `RawMethodGuard`; the §`GET_INTERFACE_GUARD` symbol auto-installation if not already present — the runtime-introspection method that returns the interfaceGuard (possibly undefined); wrapped via `bindMethod` with `PassableMethodGuard`; the §`Far(tag, prototype)` final wrapping produces the user-visible prototype; the §`defendPrototypeKit(tag, contextProviderKit, behaviorMethodsKit, thisfulMethods?, interfaceGuardKit?)` multi-facet factory — sorts facet names; rejects single-facet kits (`A multi-facet object must have multiple facets`); cross-checks facet-names against interface-guard-names and context-provider-names (extras in either direction throw); delegates to `defendPrototype` per facet with `${tag} ${facetName}` as the per-facet tag
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-exo-src-exo-tools-js--defendPrototype-and-defendPrototypeKit-with-interface-guard-validation--abstract.md)
- [Body](endo--packages-exo-src-exo-tools-js--defendPrototype-and-defendPrototypeKit-with-interface-guard-validation--body.md)
- [Connection to the wider library](endo--packages-exo-src-exo-tools-js--defendPrototype-and-defendPrototypeKit-with-interface-guard-validation--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-exo-src-exo-tools-js--defendPrototype-and-defendPrototypeKit-with-interface-guard-validation--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-exo-src-exo-tools-js--defendPrototype-and-defendPrototypeKit-with-interface-guard-validation--see-also.md)
- [Common confusions](endo--packages-exo-src-exo-tools-js--defendPrototype-and-defendPrototypeKit-with-interface-guard-validation--common-confusions.md)
