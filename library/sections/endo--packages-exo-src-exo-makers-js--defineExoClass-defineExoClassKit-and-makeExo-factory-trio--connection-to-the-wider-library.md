---
title: Connection to the wider library
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

This section is the **canonical *exo-construction-factory-trio* worked example**. Four threads:

1. **The callback-options-hooks pattern** (`finish` / `receiveAmplifier` / `receiveInstanceTester`) — *factory-grants-public-and-private-references*. The maker function is the public surface; the privileged capabilities are received via callback so they never leak. Reusable for any *factory-with-privileged-out-band-capabilities* shape.

2. **The state-sealed-not-frozen discipline** — methods need value-mutability; the state's shape is sealed for consistency. The §double-comment is the visible reminder against the easy-to-violate invariant.

3. **The class-vs-kit symmetry** — `defineExoClass` and `defineExoClassKit` follow the same shape but with single-context vs per-facet-context-map. The kit form uniquely supports *amplification* (going from one facet to all sibling facets).

4. **The `makeExo` singleton convenience** — `defineExoClass + initEmpty + immediate-invoke`. Reusable for any *factory-that-produces-stateless-singletons* shape.

The §exo-construction surface is *foundational* across the library:

- **Cycle 102 / 104** `checkKey.js` / `compareKeys.js` (@endo/patterns) — the patterns language (`M.interface()`, `M.call()`, etc.) used as the `interfaceGuard` parameter.
- **Cycle 101 / 103 / 105 / 107** daemon designs — every daemon capability is exo-shaped via these factories.
- **Earlier-cycle ingests** — pass-style, marshal, eventual-send all use exo-shaped capabilities.

This file is *the* construction surface for exo-shaped values across the entire codebase.
