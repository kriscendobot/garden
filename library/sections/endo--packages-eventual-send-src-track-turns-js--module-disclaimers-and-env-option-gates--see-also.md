---
title: See also
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

- [[eventual-send]] (topic) — the broader eventual-send pipeline track-turns instruments.
- [[errors]] (topic) — the causal console and `assert.note` annotation system this module feeds.
- [[hardened-javascript]] (topic) — the lockdown-discipline under which this module's *not-in-scope-before-lockdown* constraint operates.
- `endo--packages-eventual-send-src-track-turns-js--closure-hoisting-and-bidirectional-error-annotation` — the next section in this source: the closure-hoisting discipline and the wrapFunction / addRejectionNote bidirectional-error-annotation construction.
- `endo--packages-eventual-send-src-track-turns-js--sending-event-causes-receiving-events-causal-model` — the third section: the trackTurns JSDoc's *each call is a sending event; each call to returned TurnStarterFn is a receiving event; sending caused receiving* causal model.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--promise-pipelining` — the eventual-send + promise-pipelining mechanism this module instruments.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch` — the `_whenBroken` / `_whenMoreResolved` machinery this module's causal annotations support.
