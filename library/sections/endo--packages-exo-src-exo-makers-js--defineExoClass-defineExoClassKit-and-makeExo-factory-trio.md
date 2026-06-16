---
title: The §makeSelf private helper that creates + optionally `LABEL_INSTANCES`-labels + hardens a *self-object* from a frozen prototype (per-instance Symbol.toStringTag like `Tag#3` only when the `DEBUG=label-instances` env-option is set); the §`emptyRecord` + `initEmpty` zero-state convenience that returns the frozen empty record so callers don't need to construct it; the §`defineExoClass(tag, interfaceGuard, init, methods, options?)` factory that produces a *single-facet exo class* — `WeakMap<self, context>` instance-bookkeeping, `defendPrototype(...)` from `exo-tools.js` produces the guarded prototype, `makeInstance(...)` constructs an instance via `seal(init(...args))` + `makeSelf(proto, instanceCount)` + frozen `context = { state, self }` + `contextMap.set` + optional `finish(context)` callback — with the *be careful not to freeze the state record* discipline preserved across two seal/freeze lines; the §`options` callback hooks (`finish` / `receiveAmplifier` / `receiveInstanceTester`) that pass privileged capability-references back to the *host* — `receiveAmplifier` is rejected for non-kit classes via *Only facets of an exo class kit can be amplified*; the §`defineExoClassKit(tag, interfaceGuardKit, init, methodsKit, options?)` parallel factory that produces a *multi-facet exo class kit* — `contextMapKit = objectMap(methodsKit, () => new WeakMap())` (one WeakMap per facet) + `prototypeKit` via `defendPrototypeKit`; `makeInstanceKit` constructs all facets atomically, sets `context.facets = facets`, then freezes context; §`amplify(exoFacet)` allows going *from one facet to all sibling facets* (the *amplification* pattern); §`isInstance` accepts optional `facetName` to test against a specific facet's WeakMap; the §`makeExo(tag, interfaceGuard, methods, options?)` singleton convenience — *return a singleton instance of an internal ExoClass with no state fields* — delegates to `defineExoClass` with `initEmpty` and immediately invokes the returned maker
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio--abstract.md)
- [Body](endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio--body.md)
- [Connection to the wider library](endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio--see-also.md)
- [Common confusions](endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio--common-confusions.md)
