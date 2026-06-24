---
title: Abstract
source: packages/exo/src/exo-makers.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2025-10-09
source_authors: [Kris Kowal]
source_lines: "1-242 (full file)"
topics: [hardened-javascript, exo]
status: current
notes: |
  Sixteenth comment-fragment ingest. Kris Kowal-authored *Exo
  construction surface* — *the* file that defines `defineExoClass`,
  `defineExoClassKit`, and `makeExo`, the three factories that
  every exo-shaped capability in @endo and downstream code (Agoric,
  endo-but-for-bots daemon designs, etc.) uses. Three structurally
  interesting moves: (1) the *callback-options hooks* pattern
  (`finish` / `receiveAmplifier` / `receiveInstanceTester`) that
  pass *privileged capability-references back to the host* — the
  host calls `defineExoClass` and gets back the *public* maker
  function, but additionally receives the *host-only* facets
  (amplifier, instance-tester) via callback options; (2) the
  *state-sealed-not-frozen* discipline — *Be careful not to freeze
  the state record* (twice repeated) — state must remain mutable
  for the exo class's methods to update it, but sealing prevents
  shape changes; context wrapping is frozen *after* the state and
  facets are attached; (3) the *class-vs-kit symmetry* —
  defineExoClass and defineExoClassKit follow the same shape but
  with single-context vs per-facet-context-map; the kit form
  uniquely supports *amplification* (going from one facet to all
  sibling facets via receiveAmplifier). Single-section cohesion-
  honest ingest. Complements:
  - the @endo/patterns cycles (102 checkKey + 104 compareKeys),
    since exo's method guards use the patterns language defined
    there;
  - the daemon design cycles (101 commands + 103 value + 105
    capability-bank + 107 agent-tools), since all daemon
    capabilities are exo-shaped — the Dir/Shell/Git capabilities
    from cycle 107 are concrete consumers of this file's
    `defineExoClass` / `makeExo` factories.
  
  Cycle 108 papers-lane pivot to comments-lane (sixth consecutive
  papers-lane block, cycles 97/100/102/104/106/108).
parent: endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio
---

The §file opens (lines 1-15) with imports of `harden` from `@endo/harden`, `objectMap` from `@endo/common`, `environmentOptionsListHas` from `@endo/env-options`, `Fail`+`q` from `@endo/errors`, and the sibling `defendPrototype`/`defendPrototypeKit` from `./exo-tools.js`. The §destructured `Object` builtins (`create`/`seal`/`freeze`/`defineProperty`/`values`) are captured-and-tamed at module-load. The §`LABEL_INSTANCES` flag (line 15): *Turn on to give each exo instance its own toStringTag value* — controlled by `environmentOptionsListHas('DEBUG', 'label-instances')`. The §`makeSelf(proto, instanceCount)` helper (lines 17-34) creates a `create(proto)`-derived self-object; if `LABEL_INSTANCES` is set, defines a per-instance `Symbol.toStringTag` like `Tag#3`; hardens and returns. The §`emptyRecord` + `initEmpty` (lines 36-46): a hardened empty record + an exported `initEmpty` function that returns it. The §JSDoc names the use case: *When calling `defineDurableKind` and its siblings, used as the `init` function argument to indicate that the state record of the (virtual/durable) instances of the kind/exoClass should be empty, and that the returned maker function should have zero parameters*. The §`defineExoClass(tag, interfaceGuard, init, methods, options?)` factory (lines 48-118) produces a *single-facet exo class maker*: hardens methods; destructures `options` into `finish`/`receiveAmplifier`/`receiveInstanceTester`; rejects `receiveAmplifier` with *Only facets of an exo class kit can be amplified*; creates a `WeakMap<self, context>` for instance-bookkeeping; builds the guarded prototype via `defendPrototype(tag, contextMap.get, methods, true, interfaceGuard)`; defines `makeInstance(...args)` that calls `seal(init(...args))` for state, `makeSelf(proto, instanceCount)` for self, freezes `context = { state, self }`, sets `contextMap.set(self, context)`, optionally calls `finish(context)`, and returns `self`; if `receiveInstanceTester` was provided, builds and hardens an `isInstance` that rejects `facetName` arguments and tests `contextMap.has(exo)`; returns the hardened `makeInstance`. The §`defineExoClassKit(tag, interfaceGuardKit, init, methodsKit, options?)` factory (lines 120-218) parallels `defineExoClass` for the multi-facet case: hardens `methodsKit`; destructures same options; builds `contextMapKit = objectMap(methodsKit, () => new WeakMap())` (one WeakMap per facet); builds `prototypeKit` via `defendPrototypeKit`; defines `makeInstanceKit(...args)` that creates a mutable `context = { state, facets: null }`, builds all facets via `objectMap(prototypeKit, (proto, facetName) => makeSelf(proto, instanceCount))`, sets `context.facets = facets`, freezes context, optionally calls `finish(context)`, returns `context.facets`. The §`amplify(exoFacet)` (lines 184-193) is the *amplification* operation: given a facet, walks all `contextMapKit` WeakMaps; the first one that has the facet yields `context.facets` (all sibling facets); otherwise throws *Must be a facet of `tag`*. The §`isInstance(exoFacet, facetName?)` for kits (lines 200-211) accepts optional `facetName` — without it, checks if any facet's WeakMap has the exoFacet; with it, checks specifically the named facet's WeakMap. The §`makeExo(tag, interfaceGuard, methods, options?)` singleton convenience (lines 220-242): *Return a singleton instance of an internal ExoClass with no state fields*. Delegates to `defineExoClass` with `initEmpty` as the init function (so the maker takes zero parameters) and immediately invokes `makeInstance()` to produce the singleton.
