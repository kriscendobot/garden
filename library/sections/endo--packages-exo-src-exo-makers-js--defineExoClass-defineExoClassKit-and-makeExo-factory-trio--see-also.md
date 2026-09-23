---
title: See also
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

- [[hardened-javascript]] (topic) — the SES substrate.
- [[exo]] (topic) — the Exo class-API for capability-bearing objects.
- `endo--packages-exo-readme--virtual-durable-exos` — the package README discussing heap/virtual/durable axes.
- `endo--pkg-exo-docs-exo-taxonomy--*` (multiple sections) — the exo taxonomy that these factories implement.
- `endo--packages-patterns-src-keys-checkKey-js--*` (cycle 102) — @endo/patterns Keys + Collections validation; the interfaceGuard parameter uses the patterns language defined there.
- `endo--packages-patterns-src-keys-compareKeys-js--*` (cycle 104) — @endo/patterns partial-order Key comparison; sister to checkKey.
- `endo-but-for-bots--llm-designs-daemon-agent-tools--*` (cycle 107) — Dir/Shell/Git capabilities defined as exos via the factories in this file.
- `endo-but-for-bots--llm-designs-daemon-capability-bank--*` (cycle 105) — meta-framework whose six Design Principles include *LLM discoverability via M.interface() guards* — the guards consumed by these factories.
