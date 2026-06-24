---
source: packages/eventual-send/src/track-turns.js
source_repo: endojs/endo
source_branch: master
source_commit: 86d983a0fbd1c16089953eecabaec28e85defed5
source_date: 2025-05-12
source_authors: [Mark S. Miller]
ingested: 2026-05-29
ingested_by: scholar
section_count: 3
status: current
notes: |
  Eighth comment-fragment ingest. A small but conceptually rich
  117-line module that instruments the eventual-send pipeline's
  causal-console diagnostic surface. Three coherent argument
  clusters: module-level disclaimers (cyclic-dependency / not-in-
  scope-before-lockdown for assert/X/Fail; meta-level-privilege
  framing for the *deliberate* global mutable state — the one
  exception to this module's no-observably-mutable-state norm; two
  env-option gates `TRACK_TURNS=enabled` for the feature and
  `DEBUG=track-turns` for verbose console output); closure-hoisting +
  bidirectional error annotation (hoisted wrapFunction +
  addRejectionNote to discourage HandledPromise argument retention;
  sync-throw via try/catch + async-rejection via Promise.catch; the
  must-capture-this-now timing rule for the detailsNote string; the
  `THROWN to top of event loop` vs `REJECTED at top of event loop`
  log strings; the finally-clear of hiddenPriorError for inter-turn
  hygiene); the sending-event-causes-receiving-events causal model
  from the trackTurns JSDoc (each trackTurns call is a sending event
  in some turn at some event-within-turn; each call to a returned
  TurnStarterFn is a receiving event that begins a new turn; the
  sending caused the receiving; inert-fallback guard returns input
  unchanged when ENABLED is false or globalThis or globalThis.assert
  is missing; Caused-by chain via annotateError links the new
  sendingError to the prior turn's prior-error; TurnStarterFn
  this-free constraint).
---

> Abstract: `packages/eventual-send/src/track-turns.js` is the
> eventual-send pipeline's *causal-console* instrument. When an
> asynchronous-sent message is sent in turn `T.E` and a later
> receiving turn throws or rejects, the diagnostic on the thrown/
> rejected error is annotated with the sending turn's address. The
> module is *normally inert* (gated by `TRACK_TURNS=enabled`) but
> when enabled it instruments every wrapped TurnStarterFn with a
> turn-bumping wrapper that captures the sending event's address
> *eagerly* (the *must-capture-this-now* timing rule) and annotates
> both synchronous throws and asynchronous rejections with that
> address. The opening comment block declares the module's
> *deliberate* global mutable state (`hiddenPriorError`,
> `hiddenCurrentTurn`, `hiddenCurrentEvent`) with the *meta-level-
> privilege* framing — *normally we regard the ability to see
> console log output as a meta-level privilege analogous to the
> ability to debug; aside from that, this module should not have
> any observably mutable state*. The closure-hoisting discipline
> records a practice-driven observation: HandledPromise arguments
> were being retained for a surprisingly long time when wrapFunction
> closures were defined inside trackTurns; hoisting them to module
> scope mitigates the retention. The trackTurns JSDoc encodes the
> module's *causal model*: *the call to `trackTurns` is itself a
> sending event, that occurs in some call stack in some turn number
> at some event number within that turn; each call to any of the
> returned `TurnStartFn`s is a receiving event that begins a new
> turn; this sending event caused each of those receiving events*.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [module-disclaimers-and-env-option-gates](../sections/endo--packages-eventual-send-src-track-turns-js--module-disclaimers-and-env-option-gates.md) | eventual-send, errors, hardened-javascript | current |
| [closure-hoisting-and-bidirectional-error-annotation](../sections/endo--packages-eventual-send-src-track-turns-js--closure-hoisting-and-bidirectional-error-annotation.md) | eventual-send, errors | current |
| [sending-event-causes-receiving-events-causal-model](../sections/endo--packages-eventual-send-src-track-turns-js--sending-event-causes-receiving-events-causal-model.md) | eventual-send, errors, capability-theory | current |

The 117-line file's argument-cluster distribution maps cleanly to three sections. Lines 1-31 are module-level disclaimers + env-option gates → section 1. Lines 33-76 are closure-hoisting rationale + wrapFunction + addRejectionNote → section 2. Lines 78-117 are trackTurns + JSDoc causal model + TurnStarterFn typedef → section 3.

## Provenance

- Fetched 2026-05-29 from `endojs/endo@86d983a0fbd1c16089953eecabaec28e85defed5` via the local bare-clone.
- Last touched 2026-05-12 by Mark S. Miller. The file's authorship is appropriate for the comments-lane: Mark is the user's mentor (per the cycle-65 mentor-context preserved in subsequent direct-draft cycles) and is the canonical author of the eventual-send + causal-console design.
- Verified file existence and comment density via bare-clone listing (cycle 73 / 74 verify-bare-clone discipline): 117 lines / 42 comment lines (~36% density), the highest of the three cycle-89 comments-lane candidates.
- **Eighth comment-fragment ingest**. Small file (smallest of the eight comment-fragment ingests so far) but cohesion-over-density justified the pick: three coherent argument clusters with no padding.
