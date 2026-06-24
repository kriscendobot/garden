---
title: Body
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
