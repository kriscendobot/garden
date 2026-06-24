---
title: The §`RawMethodGuard` sentinel constant (`M.call().rest(M.raw()).returns(M.raw())`) — *a method guard, for inclusion in an interface guard, that does not enforce any constraints of incoming arguments or return results*; the §`REDACTED_RAW_ARG` string sentinel for raw-guard pass-through redaction during matching; the §`PassableMethodGuard` (`M.call().rest(M.any()).returns(M.any())`) — *the least possible non-raw enforcement for a method guard, and is implied by all other non-raw method guards*; the §`defendSyncArgs(syncArgs, matchConfig, label?)` per-call argument-defense that *uses syncArgs if possible, but copies it when necessary to implement redactions* — replaces raw-guarded positions with `REDACTED_RAW_ARG` for the `mustMatch` call, then returns the *original syncArgs* (un-redacted) to the actual method; the §`buildMatchConfig(methodGuardPayload)` one-time conversion (*This is a one-time conversion, so it's OK to be slow*) that detects `M.raw()` guards, builds `redactedIndices`, constructs the `M.splitArray(argGuards, optionalArgGuards, restArgGuard)` `paramsPattern`, and computes `restArgGuardIsRaw`; the §`defendSyncMethod(getContext, behaviorMethod, methodGuardPayload, label)` wrapper using *concise method syntax* (`syncMethod(...syncArgs)`) so `this` works correctly: try-block performs `getContext(this)` + `defendSyncArgs` + `apply(behaviorMethod, context, realArgs)` + return-guard `mustMatch` (skipping when `isRawReturn`); catch-block re-throws via `toThrowable(thrownThing)`; the §`desync(methodGuardPayload)` transformer — pulls `awaitArgGuards` out of arg guards, returns `{awaitIndexes, rawMethodGuardPayload}` with the await-stripped guards; *rejects rest args being awaited* (`Rest args may not be awaited`); the §`defendAsyncMethod` async wrapper — `Promise.all(awaitList)` resolves the awaitable args first; *Get the context after all waiting in case we ever do revocation by removing the context entry. Avoid TOCTTOU!*; then `defendSyncArgs` on the resolved arg array; then `apply(behaviorMethod, context, realArgs)`; chained `.catch` rather than onRejected clause *in case the mustMatch throws*; the §`defendMethod(getContext, behaviorMethod, methodGuard, label)` callKind-dispatch (`sync` → `defendSyncMethod`; `async` → `defendAsyncMethod`); the §`bindMethod(methodTag, contextProvider, behaviorMethod, methodGuard)` wrapper that adds `getContext(this)` with `Fail`-throw on missing `this` + delegates to `defendMethod` + sets `.name = methodTag` and `.length = behaviorMethod.length` on the resulting method
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-exo-src-exo-tools-js--method-defense-with-raw-guards-and-async-await-handling--abstract.md)
- [Body](endo--packages-exo-src-exo-tools-js--method-defense-with-raw-guards-and-async-await-handling--body.md)
- [Connection to the wider library](endo--packages-exo-src-exo-tools-js--method-defense-with-raw-guards-and-async-await-handling--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-exo-src-exo-tools-js--method-defense-with-raw-guards-and-async-await-handling--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-exo-src-exo-tools-js--method-defense-with-raw-guards-and-async-await-handling--see-also.md)
- [Common confusions](endo--packages-exo-src-exo-tools-js--method-defense-with-raw-guards-and-async-await-handling--common-confusions.md)
