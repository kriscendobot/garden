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
---

## Abstract

The §file opens (lines 1-27) with imports of `harden`, `E` from `@endo/eventual-send`, `getRemotableMethodNames`/`toThrowable`/`Far` from `@endo/pass-style`, plus eight names from `@endo/patterns` (`mustMatch`, `M`, `isAwaitArgGuard`, `isRawGuard`, `getAwaitArgGuardPayload`, `getMethodGuardPayload`, `getInterfaceGuardPayload`, `getCopyMapEntries`), plus `listDifference` + `objectMap` from `@endo/common`, plus `q`+`Fail` from `@endo/errors`, plus the local `GET_INTERFACE_GUARD` symbol. The §three sentinels (lines 29-44): `RawMethodGuard = M.call().rest(M.raw()).returns(M.raw())` is *a method guard, for inclusion in an interface guard, that does not enforce any constraints of incoming arguments or return results*; `REDACTED_RAW_ARG = '<redacted raw arg>'` is the *string sentinel* used in matchable args where the original arg has a raw guard; `PassableMethodGuard = M.call().rest(M.any()).returns(M.any())` is *the least possible non-raw enforcement for a method guard, and is implied by all other non-raw method guards*.

The §`defendSyncArgs(syncArgs, matchConfig, label?)` function (lines 46-94) is the per-call argument-defense surface. It *uses syncArgs if possible, but copies it when necessary to implement redactions*: when raw-guarded positions exist, it replaces them with `REDACTED_RAW_ARG` in a *copy* of the args array; runs `mustMatch(harden(matchableArgs), paramsPattern, label)` against the matchable form; then returns the *original syncArgs* (un-redacted) so the actual method receives the unmodified values. The §`hasRestArgGuard` branch returns syncArgs directly; otherwise it asserts `syncArgs.length <= declaredLen` (rejecting excess args with *accepts at most ${declaredLen} arguments, not ${syncArgs.length}*).

The §`buildMatchConfig(methodGuardPayload)` function (lines 96-148) is the *one-time conversion* (per the comment: *This is a one-time conversion, so it's OK to be slow*). It walks the arg guards detecting `isRawGuard(...)`, replacing matched positions with `REDACTED_RAW_ARG` and recording their indices in `redactedIndices`. It treats `isRawGuard(restArgGuard)` specially — replacing with `M.arrayOf(REDACTED_RAW_ARG)` and setting `restArgGuardIsRaw: true`. It builds the `paramsPattern` via `M.splitArray(argGuards, optionalArgGuards, restArgGuard)`. The returned config has `{declaredLen, hasRestArgGuard, restArgGuardIsRaw, paramsPattern, redactedIndices, matchableMethodGuardPayload}` — all hardened.

The §`defendSyncMethod(getContext, behaviorMethod, methodGuardPayload, label)` (lines 150-184) is the sync-method wrapper. It uses *concise method syntax* via the destructure pattern (`const { syncMethod } = { syncMethod(...syncArgs) { ... } }`) so `this` works correctly. The try-block calls `getContext(this)` for the context; `defendSyncArgs(syncArgs, matchConfig, label)` for arg validation; `apply(behaviorMethod, context, realArgs)` for the actual invocation; and `mustMatch(harden(result), returnGuard, '${label}: result')` for return-guard validation (skipped when `isRawReturn`). The catch-block re-throws via `toThrowable(thrownThing)`.

The §`desync(methodGuardPayload)` (lines 186-215) is the async-transformer. It walks arg guards looking for `isAwaitArgGuard(...)`; for each match, extracts the inner `argGuard` via `getAwaitArgGuardPayload(argGuard).argGuard` and records the position in `awaitIndexes`. The §discipline: *Rest args may not be awaited* — `restArgGuard` is rejected if `isAwaitArgGuard`. Returns `{awaitIndexes, rawMethodGuardPayload}` where the latter has the await-stripped guards.

The §`defendAsyncMethod(getContext, behaviorMethod, methodGuardPayload, label)` (lines 217-273) is the async-method wrapper. It builds an `awaitList` by collecting args at `awaitIndexes`; resolves them via `Promise.all(awaitList)`; then within `E.when(...)`: writes the resolved values back into a syncArgs copy at the awaitIndexes positions, *gets the context after all waiting in case we ever do revocation by removing the context entry. Avoid TOCTTOU!*, runs `defendSyncArgs` on the resolved arg array, and invokes the method. The result is then `E.when`-chained with the return-guard `mustMatch` (skipped when raw) and a `.catch` that re-throws via `toThrowable`. The §discipline: *Done is a chained `.catch` rather than an onRejected clause of the `E.when` above in case the `mustMatch` throws*.

The §`defendMethod(getContext, behaviorMethod, methodGuard, label)` (lines 275-301) is the callKind-dispatch: if `methodGuardPayload.callKind === 'sync'` → `defendSyncMethod`; if `'async'` → `defendAsyncMethod`. The §`bindMethod(methodTag, contextProvider, behaviorMethod, methodGuard)` (lines 303-346) is the final wrapper: it builds `getContext(representative)` (with `Fail` on missing `this` or undefined context) + calls `defendMethod` + sets `.name = methodTag` and `.length = behaviorMethod.length` via `defineProperties`.

## Body

### §The three sentinel constants

The §lines 29-44:

```js
const RawMethodGuard = M.call().rest(M.raw()).returns(M.raw());

const REDACTED_RAW_ARG = '<redacted raw arg>';

const PassableMethodGuard = M.call().rest(M.any()).returns(M.any());
```

The §three structural commitments:

- **`RawMethodGuard`** — *a method guard, for inclusion in an interface guard, that does not enforce any constraints of incoming arguments or return results*. Used when the maintainer wants *zero validation* for a specific method. The `M.raw()` markers tell the buildMatchConfig that the args/return don't need pattern checking.

- **`REDACTED_RAW_ARG`** — string sentinel `'<redacted raw arg>'` used in the matchable-args array where the original arg has a raw guard. The §discipline: *raw-guarded positions are replaced with a sentinel during pattern matching, but the original value passes through to the method*. The matching pattern at those positions also contains the sentinel, so the match is a trivial string-equality.

- **`PassableMethodGuard`** — *the least possible non-raw enforcement for a method guard, and is implied by all other non-raw method guards*. Args must be passable; return must be passable. This is the default for unguarded methods in `sloppy: true` interface guards (per section 2).

The §three sentinel structure: *one for-no-validation* + *one for-pass-through-sentinel* + *one for-minimal-validation*. Reusable for any *guard-system-with-bypass-and-minimal-fallback* shape.

### §The defendSyncArgs redaction-and-validation

The §`defendSyncArgs` (lines 52-94):

```js
const defendSyncArgs = (syncArgs, matchConfig, label = undefined) => {
  const {
    declaredLen,
    hasRestArgGuard,
    restArgGuardIsRaw,
    paramsPattern,
    redactedIndices,
  } = matchConfig;

  // Use syncArgs if possible, but copy it when necessary to implement
  // redactions.
  let matchableArgs = syncArgs;
  if (restArgGuardIsRaw && syncArgs.length > declaredLen) {
    const restLen = syncArgs.length - declaredLen;
    const redactedRest = Array(restLen).fill(REDACTED_RAW_ARG);
    matchableArgs = [...syncArgs.slice(0, declaredLen), ...redactedRest];
  } else if (
    redactedIndices.length > 0 &&
    redactedIndices[0] < syncArgs.length
  ) {
    // Copy the arguments array, avoiding hardening the redacted ones (which are
    // trivially matched using REDACTED_RAW_ARG as a sentinel value).
    matchableArgs = [...syncArgs];
  }

  for (const i of redactedIndices) {
    if (i >= matchableArgs.length) {
      break;
    }
    matchableArgs[i] = REDACTED_RAW_ARG;
  }

  mustMatch(harden(matchableArgs), paramsPattern, label);

  if (hasRestArgGuard) {
    return syncArgs;
  }
  syncArgs.length <= declaredLen ||
    Fail`${q(label)} accepts at most ${q(declaredLen)} arguments, not ${q(
      syncArgs.length,
    )}: ${syncArgs}`;
  return syncArgs;
};
```

The §two-mode operation:

1. **Common case (no redactions, no raw rest)** — `matchableArgs = syncArgs`; the matchConfig's paramsPattern matches against the original args directly.
2. **Raw-args present** — copy the args array, replace raw-guarded positions with `REDACTED_RAW_ARG`, then `mustMatch` against the matchable form. The §rationale: *avoid hardening the redacted ones (which are trivially matched using `REDACTED_RAW_ARG` as a sentinel value)*. Hardening can be expensive; raw values bypass.

The §return value is *always the original `syncArgs`*, not the matchable copy. The method receives the un-redacted values; the redaction is only for the validation check.

The §rest-arg-len enforcement: when there's no `restArgGuard`, *extra* args are rejected (*accepts at most N arguments, not M*). The §discipline: arity-strictness when no rest-args allowed.

### §The buildMatchConfig one-time conversion

The §`buildMatchConfig` (lines 105-148):

```js
const buildMatchConfig = methodGuardPayload => {
  const {
    argGuards,
    optionalArgGuards = [],
    restArgGuard,
  } = methodGuardPayload;

  const matchableArgGuards = [...argGuards, ...optionalArgGuards];

  const redactedIndices = [];
  for (let i = 0; i < matchableArgGuards.length; i += 1) {
    if (isRawGuard(matchableArgGuards[i])) {
      matchableArgGuards[i] = REDACTED_RAW_ARG;
      redactedIndices.push(i);
    }
  }

  // Pass through raw rest arguments without matching.
  let matchableRestArgGuard = restArgGuard;
  if (isRawGuard(matchableRestArgGuard)) {
    matchableRestArgGuard = M.arrayOf(REDACTED_RAW_ARG);
  }
  // ... build matchableMethodGuardPayload + paramsPattern via M.splitArray ...

  return harden({
    declaredLen: matchableArgGuards.length,
    hasRestArgGuard: restArgGuard !== undefined,
    restArgGuardIsRaw: restArgGuard !== matchableRestArgGuard,
    paramsPattern,
    redactedIndices,
    matchableMethodGuardPayload,
  });
};
```

The §opening comment names the design:

> Convert a method guard to a match config for more efficient per-call execution. This is a one-time conversion, so it's OK to be slow. Most of the work is done to detect `M.raw()` so that we build a match pattern and metadata instead of doing this in the hot path.

The §two-phase design:

- **Once-per-method-definition (slow)** — buildMatchConfig walks the arg guards, detects raw guards, builds the paramsPattern. This happens once when the prototype is built.
- **Per-call (fast)** — defendSyncArgs uses the precomputed matchConfig; no guard-walking; just `mustMatch` on the matchable form.

The §raw-rest handling: `M.arrayOf(REDACTED_RAW_ARG)` as the rest-pattern matches *any-length array of REDACTED_RAW_ARG strings*; combined with defendSyncArgs replacing actual rest values with REDACTED_RAW_ARG, the match always succeeds. This *bypasses validation for raw rest args*.

The §`restArgGuardIsRaw` flag is the *originally-raw vs replaced-with-arrayOf-sentinel* discriminator. Per-call defendSyncArgs uses this to decide whether to redact the rest.

### §The defendSyncMethod concise-method-syntax-for-this

The §`defendSyncMethod` (lines 157-184):

```js
const defendSyncMethod = (
  getContext,
  behaviorMethod,
  methodGuardPayload,
  label,
) => {
  const { returnGuard } = methodGuardPayload;
  const isRawReturn = isRawGuard(returnGuard);
  const matchConfig = buildMatchConfig(methodGuardPayload);
  const { syncMethod } = {
    // Note purposeful use of `this` and concise method syntax
    syncMethod(...syncArgs) {
      try {
        const context = getContext(this);
        const realArgs = defendSyncArgs(syncArgs, matchConfig, label);
        const result = apply(behaviorMethod, context, realArgs);
        if (!isRawReturn) {
          mustMatch(harden(result), returnGuard, `${label}: result`);
        }
        return result;
      } catch (thrownThing) {
        throw toThrowable(thrownThing);
      }
    },
  };
  return syncMethod;
};
```

The §key idiom: *concise method syntax via destructure pattern*. The `{ syncMethod(...syncArgs) {...} }` object literal contains a *method* (concise method syntax) named `syncMethod`. The §`const { syncMethod } = {...}` destructures to extract it.

The §rationale (from the comment): *Note purposeful use of `this` and concise method syntax*. The concise method syntax (`name(...args) { ... }` inside an object literal) preserves the `this` binding at call time. An equivalent arrow function `syncMethod = (...args) => {...}` would not preserve `this`; a regular function declaration would, but wouldn't carry a function-name property in the same way.

The §three-step defense:

1. **Get context** — `getContext(this)` resolves the per-instance context (the `{state, self}` record from cycle 108's exo-makers). Throws if `this` is missing.
2. **Defend args + invoke** — `defendSyncArgs` validates; `apply(behaviorMethod, context, realArgs)` invokes the user-provided method with the context as `this`.
3. **Defend return** — `mustMatch(harden(result), returnGuard, ...)` unless raw.

The §catch-block uses `toThrowable(thrownThing)` (from `@endo/pass-style`) to coerce any thrown value into a passable Error. The §discipline: *any thrown value crossing the method boundary is a passable Error*.

### §The desync transformer for await-arg-guards

The §`desync` (lines 189-215):

```js
const desync = methodGuardPayload => {
  const {
    argGuards,
    optionalArgGuards = [],
    restArgGuard,
  } = methodGuardPayload;
  !isAwaitArgGuard(restArgGuard) ||
    Fail`Rest args may not be awaited: ${restArgGuard}`;
  const rawArgGuards = [...argGuards, ...optionalArgGuards];

  const awaitIndexes = [];
  for (let i = 0; i < rawArgGuards.length; i += 1) {
    const argGuard = rawArgGuards[i];
    if (isAwaitArgGuard(argGuard)) {
      rawArgGuards[i] = getAwaitArgGuardPayload(argGuard).argGuard;
      awaitIndexes.push(i);
    }
  }
  return {
    awaitIndexes,
    rawMethodGuardPayload: {
      ...methodGuardPayload,
      argGuards: rawArgGuards.slice(0, argGuards.length),
      optionalArgGuards: rawArgGuards.slice(argGuards.length),
    },
  };
};
```

The §three-step transform:

1. **Reject await-on-rest-args** — *Rest args may not be awaited*. The §rationale: a rest arg is a variable-length array; awaiting it as a whole doesn't make sense (await individual elements? await the array reference?). The discipline forbids it.
2. **Extract await-guards from declared args** — for each `argGuard` that is `isAwaitArgGuard`, replace it with the inner `argGuard` (the post-await constraint) and record the position in `awaitIndexes`.
3. **Return the stripped guard + indexes** — the rawMethodGuardPayload has the same shape as the input but with await-stripped guards; awaitIndexes tells the async wrapper which positions to await.

The §pattern: *separate the await-discipline from the post-await-guard-discipline*. The arg-guard knows both *whether to await* and *what to check after*; desync pulls them apart.

### §The TOCTTOU-aware defendAsyncMethod

The §`defendAsyncMethod` (lines 223-273):

```js
const defendAsyncMethod = (
  getContext,
  behaviorMethod,
  methodGuardPayload,
  label,
) => {
  const { returnGuard } = methodGuardPayload;
  const isRawReturn = isRawGuard(returnGuard);

  const { awaitIndexes, rawMethodGuardPayload } = desync(methodGuardPayload);
  const matchConfig = buildMatchConfig(rawMethodGuardPayload);

  const { asyncMethod } = {
    asyncMethod(...args) {
      const awaitList = [];
      for (const i of awaitIndexes) {
        if (i >= args.length) {
          break;
        }
        awaitList.push(args[i]);
      }
      const p = Promise.all(awaitList);
      const syncArgs = [...args];
      const resultP = E.when(
        p,
        awaitedArgs => {
          for (let j = 0; j < awaitedArgs.length; j += 1) {
            syncArgs[awaitIndexes[j]] = awaitedArgs[j];
          }
          // Get the context after all waiting in case we ever do revocation
          // by removing the context entry. Avoid TOCTTOU!
          const context = getContext(this);
          const realArgs = defendSyncArgs(syncArgs, matchConfig, label);
          return apply(behaviorMethod, context, realArgs);
        },
      );
      return E.when(resultP, fulfillment => {
        if (!isRawReturn) {
          mustMatch(harden(result), returnGuard, `${label}: result`);
        }
        return fulfillment;
      }).catch(reason =>
        // Done is a chained `.catch` rather than an onRejected clause of the
        // `E.when` above in case the `mustMatch` throws.
        Promise.reject(toThrowable(reason)),
      );
    },
  };
  return asyncMethod;
};
```

The §five-step async defense:

1. **Build awaitList** — collect args at `awaitIndexes`. If an awaitIndex is past `args.length`, break (the arg is undefined/missing).
2. **`Promise.all(awaitList)`** — resolve all awaitable args concurrently.
3. **In `E.when(p, ...)` body**: write resolved values back into `syncArgs` copy; **get context AFTER waiting**; defend args via `defendSyncArgs`; invoke `behaviorMethod`.
4. **Chained `E.when(resultP, ...)`** — validate return via `mustMatch` (if not raw).
5. **Chained `.catch(reason => ...)`** — re-throw via `toThrowable`.

The §**TOCTTOU comment** (lines 253-254):

> Get the context after all waiting in case we ever do revocation by removing the context entry. Avoid TOCTTOU!

The §discipline: *Time-Of-Check-To-Time-Of-Use*. If the context is resolved *before* awaiting, then the awaitable args take a long time, then revocation removes the context entry — the context lookup would have *already succeeded* but the actual invocation would happen with a stale context. The §fix: *resolve context after the await completes*. If revocation happens during the await, the context-lookup at use-time will fail.

The §`.catch`-chained-not-onRejected comment (lines 266-268):

> Done is a chained `.catch` rather than an onRejected clause of the `E.when` above in case the `mustMatch` throws.

The §rationale: if `mustMatch` (the return-guard check) throws, the onRejected handler of the same `E.when` *can't catch its own onFulfilled's error* — that requires a *subsequent* `.catch`. The §discipline: *chained `.catch` catches both the original `resultP` rejection AND the mustMatch's potential throw*.

### §The defendMethod callKind dispatch

The §`defendMethod` (lines 282-301):

```js
const defendMethod = (getContext, behaviorMethod, methodGuard, label) => {
  const methodGuardPayload = getMethodGuardPayload(methodGuard);
  const { callKind } = methodGuardPayload;
  if (callKind === 'sync') {
    return defendSyncMethod(getContext, behaviorMethod, methodGuardPayload, label);
  } else {
    assert(callKind === 'async');
    return defendAsyncMethod(getContext, behaviorMethod, methodGuardPayload, label);
  }
};
```

The §two-mode dispatch by `callKind`. The §discipline: *sync vs async at the method-guard level*. The user-side method-guard authoring (`M.call(...).returns(M.promise())` vs `M.call(...).returns(M.any())`) encodes which mode applies.

### §The bindMethod wrapper

The §`bindMethod` (lines 309-346):

```js
const bindMethod = (
  methodTag,
  contextProvider,
  behaviorMethod,
  methodGuard,
) => {
  assert.typeof(behaviorMethod, 'function');

  const getContext = representative => {
    representative ||
      Fail`Method ${methodTag} called without 'this' object`;
    const context = contextProvider(representative);
    if (context === undefined) {
      throw Fail`${q(methodTag)} may only be applied to a valid instance: ${representative}`;
    }
    return context;
  };

  const method = defendMethod(getContext, behaviorMethod, methodGuard, methodTag);

  defineProperties(method, {
    name: { value: methodTag },
    length: { value: behaviorMethod.length },
  });
  return method;
};
```

The §three-step wrapping:

1. **Build a `getContext` closure** that wraps the user-provided `contextProvider` with two-layer error handling: missing `this` throws *Method X called without 'this' object*; missing context throws *X may only be applied to a valid instance*.
2. **Call defendMethod** to produce the defended method.
3. **Set `name` and `length`** — `name = methodTag` (the user-visible label like `In "transfer" method of (Token)`) + `length = behaviorMethod.length` (mirrors the original method's arity for `Function.prototype.length` introspection).

The §`defineProperties` is used (not direct assignment) so the properties get the standard descriptor shape. The §discipline: *the defended method looks like the original method to introspection*; `.name` is informative; `.length` is correct.

## Connection to the wider library

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

## Translation block (comment idiom → contemporary practice)

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

## See also

- [[hardened-javascript]] (topic) — the SES substrate.
- [[exo]] (topic) — the Exo class-API for capability-bearing objects.
- `endo--packages-exo-src-exo-tools-js--defendPrototype-and-defendPrototypeKit-with-interface-guard-validation` — the next section: the prototype-building layer (`defendPrototype` + `defendPrototypeKit` + interface-guard validation + `GET_INTERFACE_GUARD` auto-installation).
- `endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio` (cycle 108) — the upstream consumer; imports `defendPrototype` + `defendPrototypeKit` from this file.
- `endo--packages-patterns-src-keys-checkKey-js--*` (cycle 102) — provides `mustMatch` (via `@endo/patterns`) consumed here.
- `endo--packages-patterns-src-keys-compareKeys-js--*` (cycle 104) — patterns infrastructure that powers the guard system.

## Common confusions

- **"`REDACTED_RAW_ARG` looks like a real value — could it collide with a real arg?"** It's *deliberately distinctive*: `<redacted raw arg>` is an unlikely real value, and the matching pattern at raw positions explicitly *expects* this string. The §discipline: *raw guards never actually validate*; the sentinel is just for paramsPattern bookkeeping.
- **"`defendSyncArgs` could just `mustMatch` syncArgs directly."** It could *if no raw guards*. When raw guards exist, the matchable form *must* have the sentinel at those positions (because the matching paramsPattern has sentinel there). The §copy-when-redaction-needed avoids modifying the caller's args.
- **"`buildMatchConfig` being slow is a problem."** It's called *once* per method definition (when the prototype is built). The hot path is `defendSyncArgs` which uses the precomputed config. The §amortization-discipline is *compile-once-execute-many-times*.
- **"The concise-method-syntax destructure-pattern is over-clever."** It's *the correct idiom for `this`-preserving wrappers* with a named function. An equivalent named-function-expression approach (`function syncMethod(...args) {...}`) works but the destructure-pattern is the @endo idiom.
- **"`toThrowable(thrownThing)` is just `new Error(thrownThing)`."** It's *pass-style coercion*. Some thrown values are already pass-style Errors (or wrapped exotics); `toThrowable` ensures the thrown thing is a passable Error before re-throwing. Non-Error throws (strings, numbers, plain objects) get wrapped.
- **"TOCTTOU in single-threaded JavaScript? That's not a thing."** It is — *asynchronously*. JavaScript is single-threaded *per turn*, but multiple turns interleave. A revocation that runs in a turn *between* the await-completion-turn and the method-execution-turn would create the TOCTTOU window. The §discipline closes the window by deferring the context lookup.
- **"The `.catch` after `E.when(resultP, fulfillment => mustMatch(...))` is just standard promise chaining."** It's *deliberately positioned to catch the mustMatch throw*. If `mustMatch` is inside the onFulfilled clause of the *same* `E.when`, its thrown value *doesn't* propagate to the onRejected of *that* `E.when` — it propagates to the *next* link. The §discipline puts the catch at the next link explicitly.
- **"Why a `desync` transformer? Can't the async method just check await-arg-guards inline?"** It could — but the §discipline *separates the await-extraction (one-time) from the per-call validation (every-call)*. desync runs once at method-definition; the per-call wrapper consumes the precomputed awaitIndexes.
- **"`bindMethod` setting `.length = behaviorMethod.length` is cosmetic."** It's *for introspection-correctness*. `Function.prototype.length` is the *declared parameter count*. Code that uses `method.length` for arity-aware dispatch (rare but real) sees the original method's arity, not the wrapper's. The §discipline preserves the user-visible behavior.
- **"`Rest args may not be awaited` (line 196) is an arbitrary restriction."** It's a *coherence restriction*. Rest args are *a variable-length array*; awaiting the rest would mean *await each element of the unbounded array*. The §discipline: *if you need awaitable rest, use an array argument with `M.awaited(M.arrayOf(...))` semantics instead* (or similar — the design forbids the syntactic shortcut).
