---
title: Connection to the wider library
source: packages/exo/src/exo-tools.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2025-10-09
source_authors: [Kris Kowal]
source_lines: "1-346 (sentinels + defendSyncArgs + buildMatchConfig + defendSyncMethod + desync + defendAsyncMethod + defendMethod + bindMethod)"
topics: [hardened-javascript, exo]
status: current
notes: |
  Nineteenth comment-fragment ingest. Kris Kowal-authored
  *method-defense machinery* file — *the* implementation that
  cycle 108's exo-makers.js imports `defendPrototype` and
  `defendPrototypeKit` from. Section 1 of 2 covers the per-method
  defense layer (sync + async + raw-guard handling); section 2
  covers the prototype-building layer (`defendPrototype` +
  `defendPrototypeKit` with interface-guard validation).
  
  Three structurally interesting moves in section 1: (1) the
  *REDACTED_RAW_ARG-sentinel-for-raw-guard-pass-through* — raw-
  guarded positions are *replaced with a string sentinel for the
  matchConfig check*, then the original (un-redacted) arg passes
  through to the actual method; `mustMatch` validates the
  matchable form; the method receives the unmodified value; (2)
  the *desync transformer* that pulls awaitable args out of the
  method guard, returns awaitIndexes + rawMethodGuardPayload; the
  async wrapper does `Promise.all(awaitList)` before
  defendSyncArgs; (3) the *TOCTTOU-aware context lookup* — *Get
  the context after all waiting in case we ever do revocation by
  removing the context entry. Avoid TOCTTOU!* — the context is
  resolved *after* awaitable args complete, ensuring revocation
  between arg-await and method-execution is caught.
  
  Plus: the *concise method syntax* (`{ syncMethod(...syncArgs)
  { ... } }.syncMethod`) is used to make `this` work correctly
  via the destructure-pattern; the §`.catch` chained after the
  `mustMatch` is *deliberately positioned* — *Done is a chained
  `.catch` rather than an onRejected clause of the `E.when`
  above in case the `mustMatch` throws*. Cycle 118 papers-lane
  pivot to comments-lane (12+ consecutive papers-lane blocks).
parent: endo--packages-exo-src-exo-tools-js--method-defense-with-raw-guards-and-async-await-handling
---

This section is the **canonical *method-defense-with-raw-guard-pass-through* worked example**. Four threads:

1. **The REDACTED_RAW_ARG sentinel + paramsPattern with sentinel-positions** discipline — raw-guarded positions bypass validation by *string-equality at the sentinel*. The §pattern is reusable for any *opt-out-of-validation per-position* shape.

2. **The TOCTTOU-aware async method discipline** — resolve context *after* the await, not before. The §comment names the threat explicitly (*Avoid TOCTTOU!*). Reusable for any *context-revocation-during-async-operation* situation.

3. **The chained-`.catch`-not-onRejected discipline** — protects against onFulfilled exceptions (the return-guard mustMatch). Reusable for any *chained-promise-with-final-validation* shape.

4. **The buildMatchConfig one-time-slow + per-call-fast split** — *Convert a method guard to a match config for more efficient per-call execution. This is a one-time conversion, so it's OK to be slow*. The §discipline: *amortize compilation cost across all calls*.

The §library connections:

- **Cycle 108** `exo-makers.js` — imports `defendPrototype` + `defendPrototypeKit` from this file (covered in section 2). The §exo-makers's `defineExoClass` and `defineExoClassKit` consume the prototype-builder side.
- **Cycle 102** `checkKey.js` — provides `mustMatch` (via `@endo/patterns`) consumed here.
- **Cycle 104** `compareKeys.js` — patterns infrastructure that powers the guard system.
- **Earlier ingests** — pass-style's `toThrowable` and `Far` consumed here; eventual-send's `E.when` for async chaining.
