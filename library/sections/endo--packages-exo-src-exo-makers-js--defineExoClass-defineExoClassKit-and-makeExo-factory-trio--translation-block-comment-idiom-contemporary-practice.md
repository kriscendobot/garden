---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `LABEL_INSTANCES = environmentOptionsListHas('DEBUG', 'label-instances')` | The *opt-in-debug-feature-via-env-option* discipline; DEBUG=label-instances enables per-instance toStringTag. |
| `makeSelf(proto, instanceCount)` | The *one-self-per-instance* construction; create + optional-label + harden in one step. |
| `Symbol.toStringTag` per-instance with `Tag#3` shape | The *debug-affordance-per-instance* discipline; production uses the prototype's tag. |
| `emptyRecord = harden({})` + `initEmpty = () => emptyRecord` | The *zero-state-zero-arg-convenience* pattern; one shared frozen empty record. |
| `Only facets of an exo class kit can be amplified` | The *reject-amplification-on-non-kit-class* invariant; amplification is facet-to-siblings. |
| `Be careful not to freeze the state record` (twice) | The *state-sealed-not-frozen* invariant; values mutable, shape fixed. |
| `Don't freeze context until we add facets` | The *two-phase-context-construction* discipline for kits. |
| `defendPrototype(tag, getContext, methods, true, interfaceGuard)` | The *thisful-prototype-with-context-lookup-and-guard* construction. |
| `finish` / `receiveAmplifier` / `receiveInstanceTester` callback options | The *factory-grants-privileged-references-via-callback* pattern; never-leaking-out-band-capabilities. |
| `amplify(exoFacet)` walking per-facet contextMaps | The *facet-to-siblings-via-context-lookup* mechanism for caretaker patterns. |
| `makeExo` = `defineExoClass + initEmpty + immediate-invoke` | The *stateless-singleton-convenience* shorthand. |
| `CAVEAT: static typing does not yet support callWhen transformation` | The *honest-typescript-limitation* admission; runtime works; static types incomplete. |
