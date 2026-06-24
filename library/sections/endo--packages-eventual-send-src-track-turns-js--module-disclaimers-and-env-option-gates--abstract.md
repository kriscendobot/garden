---
title: Abstract
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

The opening section of `packages/eventual-send/src/track-turns.js` (lines 1-31) sets two structural constraints on the module's design. **Constraint 1: assert / X / Fail cannot be imported.** *We can't import these because they're not in scope before lockdown. We also cannot currently import them because it would create a cyclic dependency, though this is more easily fixed.* The commented-out `// import { assert, X, Fail } from '@endo/errors';` plus the linked Agoric SDK issue (`agoric-sdk#9515`) record both the *technical-constraint* (not in scope before lockdown) and the *unblock-path* (the cyclic dependency *is more easily fixed*, but hasn't been). Instead, the module accesses `globalThis.assert` lazily at call time, not as a static import. **Constraint 2: the module has *deliberate* global mutable state, which is the *one* exception to this module's no-observably-mutable-state norm.** The comment block is direct: *WARNING: Global Mutable State! This state is communicated to `assert` that makes it available to the causal console, which affects the console log output. Normally we regard the ability to see console log output as a meta-level privilege analogous to the ability to debug. Aside from that, this module should not have any observably mutable state.* The three globals are: `hiddenPriorError` (the prior sending-turn's error-object), `hiddenCurrentTurn` (turn counter), `hiddenCurrentEvent` (event-within-turn counter). The module is then gated by two environment options: `TRACK_TURNS=enabled` (the *feature gate* — track-turns is *disabled by default*) and `DEBUG=track-turns` (the *verbosity gate* — when set, an additional `console.log('REJECTED at top of event loop', reason)` or `console.log('THROWN to top of event loop', err)` fires on each event-loop-top rejection or throw).
