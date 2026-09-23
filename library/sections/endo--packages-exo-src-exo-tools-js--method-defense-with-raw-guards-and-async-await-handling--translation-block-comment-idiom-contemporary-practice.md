---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `RawMethodGuard = M.call().rest(M.raw()).returns(M.raw())` | The *no-validation-method-guard* sentinel; for inclusion in interface guards. |
| `REDACTED_RAW_ARG = '<redacted raw arg>'` | The *string-sentinel-for-raw-guard-pass-through* pattern; sentinel-position in paramsPattern matches sentinel-replacement in matchableArgs. |
| `PassableMethodGuard = M.call().rest(M.any()).returns(M.any())` | The *minimum-non-raw-method-guard* — implied by all other non-raw guards. |
| `Use syncArgs if possible, but copy it when necessary to implement redactions` | The *copy-only-when-modification-needed* discipline. |
| `This is a one-time conversion, so it's OK to be slow` | The *one-time-slow + per-call-fast* compile-vs-runtime split. |
| `Note purposeful use of `this` and concise method syntax` | The *concise-method-syntax-via-destructure-pattern* idiom for `this`-preserving wrappers. |
| `Get the context after all waiting in case we ever do revocation by removing the context entry. Avoid TOCTTOU!` | The *resolve-after-await-not-before* discipline; avoid time-of-check-to-time-of-use races during revocation. |
| `Done is a chained `.catch` rather than an onRejected clause ... in case the `mustMatch` throws` | The *chained-catch-after-onFulfilled-validation* pattern; protects against post-await validation throws. |
| `Rest args may not be awaited` | The *no-await-on-rest-args* invariant. |
| `Method X called without 'this' object` / `X may only be applied to a valid instance` | The *two-layer-error-handling-for-context-lookup* discipline. |
| `defineProperties(method, { name, length })` | The *defended-method-looks-like-original-method-to-introspection* discipline. |
