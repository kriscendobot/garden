---
title: Abstract
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

The §file opens (lines 1-27) with imports of `harden`, `E` from `@endo/eventual-send`, `getRemotableMethodNames`/`toThrowable`/`Far` from `@endo/pass-style`, plus eight names from `@endo/patterns` (`mustMatch`, `M`, `isAwaitArgGuard`, `isRawGuard`, `getAwaitArgGuardPayload`, `getMethodGuardPayload`, `getInterfaceGuardPayload`, `getCopyMapEntries`), plus `listDifference` + `objectMap` from `@endo/common`, plus `q`+`Fail` from `@endo/errors`, plus the local `GET_INTERFACE_GUARD` symbol. The §three sentinels (lines 29-44): `RawMethodGuard = M.call().rest(M.raw()).returns(M.raw())` is *a method guard, for inclusion in an interface guard, that does not enforce any constraints of incoming arguments or return results*; `REDACTED_RAW_ARG = '<redacted raw arg>'` is the *string sentinel* used in matchable args where the original arg has a raw guard; `PassableMethodGuard = M.call().rest(M.any()).returns(M.any())` is *the least possible non-raw enforcement for a method guard, and is implied by all other non-raw method guards*.

The §`defendSyncArgs(syncArgs, matchConfig, label?)` function (lines 46-94) is the per-call argument-defense surface. It *uses syncArgs if possible, but copies it when necessary to implement redactions*: when raw-guarded positions exist, it replaces them with `REDACTED_RAW_ARG` in a *copy* of the args array; runs `mustMatch(harden(matchableArgs), paramsPattern, label)` against the matchable form; then returns the *original syncArgs* (un-redacted) so the actual method receives the unmodified values. The §`hasRestArgGuard` branch returns syncArgs directly; otherwise it asserts `syncArgs.length <= declaredLen` (rejecting excess args with *accepts at most ${declaredLen} arguments, not ${syncArgs.length}*).

The §`buildMatchConfig(methodGuardPayload)` function (lines 96-148) is the *one-time conversion* (per the comment: *This is a one-time conversion, so it's OK to be slow*). It walks the arg guards detecting `isRawGuard(...)`, replacing matched positions with `REDACTED_RAW_ARG` and recording their indices in `redactedIndices`. It treats `isRawGuard(restArgGuard)` specially — replacing with `M.arrayOf(REDACTED_RAW_ARG)` and setting `restArgGuardIsRaw: true`. It builds the `paramsPattern` via `M.splitArray(argGuards, optionalArgGuards, restArgGuard)`. The returned config has `{declaredLen, hasRestArgGuard, restArgGuardIsRaw, paramsPattern, redactedIndices, matchableMethodGuardPayload}` — all hardened.

The §`defendSyncMethod(getContext, behaviorMethod, methodGuardPayload, label)` (lines 150-184) is the sync-method wrapper. It uses *concise method syntax* via the destructure pattern (`const { syncMethod } = { syncMethod(...syncArgs) { ... } }`) so `this` works correctly. The try-block calls `getContext(this)` for the context; `defendSyncArgs(syncArgs, matchConfig, label)` for arg validation; `apply(behaviorMethod, context, realArgs)` for the actual invocation; and `mustMatch(harden(result), returnGuard, '${label}: result')` for return-guard validation (skipped when `isRawReturn`). The catch-block re-throws via `toThrowable(thrownThing)`.

The §`desync(methodGuardPayload)` (lines 186-215) is the async-transformer. It walks arg guards looking for `isAwaitArgGuard(...)`; for each match, extracts the inner `argGuard` via `getAwaitArgGuardPayload(argGuard).argGuard` and records the position in `awaitIndexes`. The §discipline: *Rest args may not be awaited* — `restArgGuard` is rejected if `isAwaitArgGuard`. Returns `{awaitIndexes, rawMethodGuardPayload}` where the latter has the await-stripped guards.

The §`defendAsyncMethod(getContext, behaviorMethod, methodGuardPayload, label)` (lines 217-273) is the async-method wrapper. It builds an `awaitList` by collecting args at `awaitIndexes`; resolves them via `Promise.all(awaitList)`; then within `E.when(...)`: writes the resolved values back into a syncArgs copy at the awaitIndexes positions, *gets the context after all waiting in case we ever do revocation by removing the context entry. Avoid TOCTTOU!*, runs `defendSyncArgs` on the resolved arg array, and invokes the method. The result is then `E.when`-chained with the return-guard `mustMatch` (skipped when raw) and a `.catch` that re-throws via `toThrowable`. The §discipline: *Done is a chained `.catch` rather than an onRejected clause of the `E.when` above in case the `mustMatch` throws*.

The §`defendMethod(getContext, behaviorMethod, methodGuard, label)` (lines 275-301) is the callKind-dispatch: if `methodGuardPayload.callKind === 'sync'` → `defendSyncMethod`; if `'async'` → `defendAsyncMethod`. The §`bindMethod(methodTag, contextProvider, behaviorMethod, methodGuard)` (lines 303-346) is the final wrapper: it builds `getContext(representative)` (with `Fail` on missing `this` or undefined context) + calls `defendMethod` + sets `.name = methodTag` and `.length = behaviorMethod.length` via `defineProperties`.
