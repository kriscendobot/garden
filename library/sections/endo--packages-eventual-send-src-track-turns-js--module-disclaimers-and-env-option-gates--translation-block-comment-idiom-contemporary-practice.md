---
title: Translation block (comment idiom → contemporary practice)
source: packages/eventual-send/src/track-turns.js
source_repo: endojs/endo
source_branch: master
source_commit: 86d983a0fbd1c16089953eecabaec28e85defed5
source_date: 2025-05-12
source_authors: [Mark S. Miller]
source_lines: "1-31 (imports + cyclic-dependency disclaimer + global mutable state warning + env-option gates)"
topics: [eventual-send, errors, hardened-javascript]
status: current
notes: |
  The track-turns module is the *causal-console* instrument for the
  eventual-send pipeline: when an asynchronous-sent message is sent in
  turn `T:E` and then a later receiving turn throws or rejects, the
  diagnostic on the thrown/rejected error is annotated with the
  sending turn's address. The module is *normally inert* — it only
  activates when explicitly enabled via the `TRACK_TURNS=enabled`
  environment option. The opening comment block is unusual in
  declaring this module's *deliberate* global mutable state (`let
  hiddenPriorError`, `let hiddenCurrentTurn`, `let
  hiddenCurrentEvent`) with the *meta-level-privilege* framing:
  *normally we regard the ability to see console log output as a
  meta-level privilege analogous to the ability to debug; aside from
  that, this module should not have any observably mutable state*.
parent: endo--packages-eventual-send-src-track-turns-js--module-disclaimers-and-env-option-gates
---

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| Cyclic-dependency-not-in-scope-before-lockdown | The `globalThis.assert` lazy-access pattern; commented-out imports as documentation of intent. |
| `WARNING: Global Mutable State!` | Deliberate-controlled-mutable-state-as-meta-level-privilege disclaimer; the *hidden* prefix on the mutable bindings is the marker. |
| Meta-level-privilege framing | The hardened-JavaScript justification for diagnostic-only mutable state: never affects observable program semantics. |
| `TRACK_TURNS=enabled` feature gate | Opt-in feature default-off; the whole feature is inert when not enabled. |
| `DEBUG=track-turns` verbosity gate | Verbose console output orthogonal to feature enable. |
| External-issue pointer to Agoric SDK #9515 | The *future-work-tracked-externally* discipline; doesn't promise when, just where. |
