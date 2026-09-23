---
title: Common confusions
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

- **"State should be hardened — sealing isn't safe enough."** Sealing is *intentional*. Methods need to update state values; hardening would prevent that. The §invariant is *shape-fixed-values-mutable*; sealing achieves it; hardening would break it.
- **"Why two `Be careful not to freeze the state record` comments?"** The §discipline is *easy to violate* — a careless maintainer might add `harden(state)` thinking it's safer. The repeated comment is a *visible reminder* at both the class and kit constructions.
- **"`receiveAmplifier === undefined || Fail\`...\`` is an obscure way to assert."** It is the §canonical SES short-circuit-assert idiom: if the condition is truthy, the expression short-circuits to the truthy value (discarded); if falsy, the `Fail\`...\`` template-tag throws. Used throughout @endo for inline invariant checks.
- **"`makeSelf` should be exported — other code might want to build similar objects."** It is *intentionally private*. The discipline: *only the exo factories construct self-objects*. Exposing `makeSelf` would let external code construct objects with the prototype but bypass the contextMap registration, breaking the invariant that *every self has a context*.
- **"`initEmpty` is just `() => harden({})` — why not inline it?"** Inlining would allocate a new empty record per call. The shared `emptyRecord` is allocated once and reused. The §discipline matters for hot-path call-sites that construct many stateless exos.
- **"The amplifier should be exposed as a method on the kit."** It would *leak the amplifier to anyone holding the kit*. The §discipline: *amplification is privileged*; the host receives the amplifier via callback so it can be held privately. Exposing it as a kit method would defeat the purpose.
- **"`contextMap.has(exo)` is O(n) — slow for many instances."** It is *O(1) average*. WeakMaps are hash-based; the lookup is constant-time. The §WeakMap key is the self-object reference (which has a stable hash).
- **"`facets` initially null then mutated — that's a mutation hazard."** It is — and the §discipline scopes the mutation tightly: `context = { state, facets: null }` is mutable; `context.facets = facets`; `freeze(context)`. After freeze, the mutation is locked in. The window of mutability is the same-function-call-scope.
- **"The `LABEL_INSTANCES` per-instance label leaks instance identity in production logs."** The flag is *opt-in via DEBUG env-option*; production runs don't enable it. The discipline keeps debug-affordances out of production by default.
- **"`makeExo` is just sugar — why not have users write the two lines themselves?"** Convention. *Stateless singletons* are a common pattern; having one canonical helper makes the call-site read consistently. The §pattern documents itself by name.
