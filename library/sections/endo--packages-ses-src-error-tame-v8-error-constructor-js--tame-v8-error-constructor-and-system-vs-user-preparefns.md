---
title: The tameV8ErrorConstructor function that wires censoring + shortening into V8's `Error.prepareStackTrace` hook; the system-vs-user prepareFn distinction; the WeakSet branding that ensures only system prepareFns ever receive an unattenuated SST; the captureStackTrace + prepareStackTrace pair with the `stackInfos` WeakMap; the getStackString shim of the proposed error-stack TC39 special-power
source: packages/ses/src/error/tame-v8-error-constructor.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson and prior contributors]
source_lines: "212-end (tameV8ErrorConstructor function and exports)"
topics: [hardened-javascript, errors, capability-security]
status: current
---

## Abstract

The §closing cluster of `tame-v8-error-constructor.js` is the `tameV8ErrorConstructor` function — the *taming* operation that installs SES's defensive stack-trace handling onto V8's Error constructor. The function takes four arguments: `OriginalError` (the realm's intrinsic Error), `InitialError` (SES's tamed Error), `errorTaming` (one of `'safe'`, `'unsafe'`, `'unsafe-debug'`), and `stackFiltering` (one of `'concise'`, `'omit-frames'`, `'shorten-paths'`). The function refuses `'unsafe-debug'` (the special case is handled elsewhere). The structural payload is the **system-vs-user prepareFn distinction**: V8 invokes `Error.prepareStackTrace(error, structuredStackTrace)` whenever an error's `.stack` is read, and the prepareStackTrace return value becomes the displayed `.stack`. A *user prepareFn* (assigned by application code) should only see an *attenuated SST* (an array of `safeV8CallSiteFacet`-wrapped frames per §1's permit list); a *system prepareFn* (defined by this module) sees the original unattenuated SST and is the only one allowed to do so. The distinction is enforced by a **`systemPrepareFnSet` WeakSet** that *brands* every system prepareFn the module creates. When application code assigns `Error.prepareStackTrace = userFn`, the setter wraps `userFn` in a new system prepareFn (`systemPrepareFnFor(userFn)`) that stores the original SST in `stackInfos`, then calls `userFn` with the *safe* SST. The `tamedMethods.captureStackTrace` shim either delegates to the original V8 `captureStackTrace` (cutting off the bottom frame by default) or, on non-V8 engines, sets `error.stack = ''`. The `tamedMethods.getStackString` function is *the shim of the proposed special power* for getting the stack-traceback-string associated with an error — pointing to `tc39.es/proposal-error-stacks/`. The function returns the cached `stackString` from `stackInfos` if present; otherwise reads `error.stack` to populate `stackInfos` (calling `prepareStackTrace` synchronously), then formats from the cached SST via `stackStringFromSST`. Under `errorTaming === 'unsafe'`, the default `prepareStackTrace` produces a stack string directly (matching V8's normal behavior); otherwise it stores the SST and returns the empty string (the error has no readable stack at the JavaScript layer).

## Body

### §The tameV8ErrorConstructor function — four-argument entry point

The function signature:

```js
export const tameV8ErrorConstructor = (
  OriginalError,
  InitialError,
  errorTaming,
  stackFiltering,
) => {
```

The structural reading of the four arguments:

1. **`OriginalError`** — the realm's *intrinsic* `Error` constructor. The function mutates *this* (installing `prepareStackTrace` on it) because V8 reads `Error.prepareStackTrace` from the constructor itself.
2. **`InitialError`** — the SES-tamed `Error` constructor exposed to user code. The function adds `captureStackTrace` and `prepareStackTrace` properties to this so user code sees a consistent API surface.
3. **`errorTaming`** — one of `'safe'` (default; suppress `.stack` for user code), `'unsafe'` (V8-native behavior; stacks visible), `'unsafe-debug'` (handled elsewhere). The function refuses `'unsafe-debug'` with an internal-error throw.
4. **`stackFiltering`** — one of `'concise'` (apply both `omit-frames` and `shorten-paths`), `'omit-frames'` (filename-censoring only), `'shorten-paths'` (path-pattern-shortening only). Two booleans derive: `omitFrames` and `shortenPaths`.

The two booleans:

```js
const omitFrames =
  stackFiltering === 'concise' || stackFiltering === 'omit-frames';

const shortenPaths =
  stackFiltering === 'concise' || stackFiltering === 'shorten-paths';
```

`'concise'` is the *union of both behaviors*; users can opt into one or the other via the `'omit-frames'` / `'shorten-paths'` values for finer control.

### §The callSiteFilter and callSiteStringifier internal functions

The function builds two internal-only functions for per-frame processing:

```js
const callSiteFilter = callSite => {
  if (omitFrames) {
    if (callSite.getFunctionName()?.startsWith('__HIDE_')) {
      return false;
    }
    return filterFileName(callSite.getFileName());
  }
  return true;
};

const callSiteStringifier = callSite => {
  let callSiteString = `${callSite}`;
  if (shortenPaths) {
    callSiteString = shortenCallSiteString(callSiteString);
  }
  return `\n  at ${callSiteString}`;
};
```

The structural reading:

- **`callSiteFilter`** combines two filters when `omitFrames` is true:
  - *Function-name censor*: functions whose name starts with `__HIDE_` are dropped. The `__HIDE_` prefix is the application-code convention for *hide this frame from concise stacks* — useful for instrumentation, decorators, and test scaffolding that shouldn't clutter the debugging view.
  - *Filename censor*: delegates to `filterFileName` from §1 (the five infrastructure-frame censors).
- **`callSiteStringifier`** stringifies a kept frame:
  - Coerces to string via `${callSite}` (uses V8's default `toString` on the frame).
  - Applies `shortenCallSiteString` from §2 when `shortenPaths` is true.
  - Prefixes with `'\n  at '` to match V8's default stack-string formatting.

The two functions compose via `stackStringFromSST`:

```js
const stackStringFromSST = (_error, sst) =>
  arrayJoin(
    arrayMap(arrayFilter(sst, callSiteFilter), callSiteStringifier),
    '',
  );
```

`arrayFilter` then `arrayMap` then `arrayJoin` — the standard filter-then-format pipeline.

### §The stackInfos WeakMap — error-to-cached-stack mapping

The function maintains a `WeakMap<Error, ParsedStackInfo | StructuredStackInfo>`:

```js
const stackInfos = new WeakMap();
```

Each value is one of two shapes:

- `StructuredStackInfo: { callSites: CallSite[]; stackString?: undefined }` — the structured SST captured at error-creation time but not yet stringified.
- `ParsedStackInfo: { callSites?: undefined; stackString: string }` — the stringified-and-cached form, ready for repeated reads.

The structural design: **lazy stringification with caching**. The structured SST is stored eagerly (when V8 calls `prepareStackTrace`); the string form is generated *only* if `getStackString` is called, and then cached for subsequent reads. This matches V8's lazy-stack-stringification model where reading `error.stack` triggers the formatter.

### §The tamedMethods object — captureStackTrace + getStackString + prepareStackTrace

The function defines three tamed methods:

#### `captureStackTrace(error, optFn)`

```js
captureStackTrace(error, optFn = tamedMethods.captureStackTrace) {
  if (typeof originalCaptureStackTrace === 'function') {
    apply(originalCaptureStackTrace, OriginalError, [error, optFn]);
    return;
  }
  reflectSet(error, 'stack', '');
},
```

The structural reading:

- **`optFn` default** — *cutting off the bottom of the stack — for capturing the stack only above the topmost call to that function*. Since this isn't the *real* `captureStackTrace` but instead calls the real one, if no other cutoff is provided, the function cuts *itself* off. The user calling `Error.captureStackTrace(err)` gets a stack that starts *above* their own call site.
- **V8 path** — delegate to V8's `originalCaptureStackTrace`. Same behavior as native.
- **Non-V8 path** — set `error.stack = ''`. Non-V8 engines don't have `captureStackTrace`; the shim provides a no-op so user code that calls `Error.captureStackTrace` doesn't crash.

#### `getStackString(error)`

The §code:

```js
getStackString(error) {
  let stackInfo = weakmapGet(stackInfos, error);

  if (stackInfo === undefined) {
    // The following will call `prepareStackTrace()` synchronously
    // which will populate stackInfos
    void error.stack;
    stackInfo = weakmapGet(stackInfos, error);
    if (!stackInfo) {
      stackInfo = { stackString: '' };
      weakmapSet(stackInfos, error, stackInfo);
    }
  }

  // prepareStackTrace() may generate the stackString
  // if errorTaming === 'unsafe'

  if (stackInfo.stackString !== undefined) {
    return stackInfo.stackString;
  }

  const stackString = stackStringFromSST(error, stackInfo.callSites);
  weakmapSet(stackInfos, error, { stackString });

  return stackString;
},
```

The §framing comment:

> Shim of proposed special power, to reside by default only in the start compartment, for getting the stack traceback string associated with an error.
> See https://tc39.es/proposal-error-stacks/

The structural reading:

1. **Check cache** — `weakmapGet(stackInfos, error)` returns `ParsedStackInfo`, `StructuredStackInfo`, or `undefined`.
2. **Force population on cache-miss** — `void error.stack` triggers V8's lazy stack stringification, which calls `prepareStackTrace`, which populates `stackInfos`. The `void` keyword discards the result; we only want the side effect.
3. **Fallback** — if even after `void error.stack` the cache is still empty, store `{ stackString: '' }`. This handles edge cases where the error somehow has no stack to read.
4. **Return cached string if present** — `ParsedStackInfo` case.
5. **Format from structured callSites** — `StructuredStackInfo` case. Call `stackStringFromSST` (which applies the censoring + shortening), cache the result, return it.

The §framing's *start-compartment-only* claim is structural: `getStackString` is the *capability* to read an error's stack. In safe lockdown, this capability lives only in the start compartment; guest compartments cannot exercise it. The shim implements the proposed TC39 *Error Stacks* spec.

#### `prepareStackTrace(error, sst)`

```js
prepareStackTrace(error, sst) {
  if (errorTaming === 'unsafe') {
    const stackString = stackStringFromSST(error, sst);
    weakmapSet(stackInfos, error, { stackString });
    return `${error}${stackString}`;
  } else {
    weakmapSet(stackInfos, error, { callSites: sst });
    return '';
  }
},
```

The structural reading:

- **`'unsafe'` mode** — produce a stack string directly. The user sees `error.stack` as `<ErrorMessage>\n  at <frame1>\n  at <frame2>...` (V8's default). Cache the string.
- **Default (safe) mode** — store the structured SST, return the empty string. The user sees `error.stack` as `''` (empty). Stack access goes through `getStackString` which is only available to the start compartment.

The two modes encode the *security-vs-debugging trade-off*: safe mode hides stacks from user code (preventing capability leakage via stack-frame inspection); unsafe mode exposes them (useful for debugging but trusts user code with stack data).

### §The system-vs-user prepareFn distinction

The §middle comment block names the central design distinction:

> A prepareFn is a prepareStackTrace function.
> An sst is a `structuredStackTrace`, which is an array of callsites.
> A user prepareFn is a prepareFn defined by a client of this API, and provided by assigning to `Error.prepareStackTrace`.
> A user prepareFn should only receive an attenuated sst, which is an array of attenuated callsites.
> A system prepareFn is the prepareFn created by this module to be installed on the real `Error` constructor, to receive an original sst, i.e., an array of unattenuated callsites.
> An input prepareFn is a function the user assigns to `Error.prepareStackTrace`, which might be a user prepareFn or a system prepareFn previously obtained by reading `Error.prepareStackTrace`.

The structural distinction:

| Class | Defined by | Receives | Allowed to see |
|---|---|---|---|
| **System prepareFn** | This module | Original SST (unattenuated) | Full V8 CallSite API |
| **User prepareFn** | Application code | Attenuated SST via `safeV8SST` | Only the 16 permit-list methods |
| **Input prepareFn** | Application code (via setter) | Either of the above; classified at setter time | Either of the above |

#### `systemPrepareFnSet` WeakSet — the branding mechanism

```js
const systemPrepareFnSet = new WeakSet([defaultPrepareFn]);
```

The WeakSet *brands* every system prepareFn the module creates. Initially it contains only `defaultPrepareFn` (the module's `prepareStackTrace` from `tamedMethods`).

#### `systemPrepareFnFor(inputPrepareFn)` — wrap if needed

```js
const systemPrepareFnFor = inputPrepareFn => {
  if (weaksetHas(systemPrepareFnSet, inputPrepareFn)) {
    return inputPrepareFn;
  }
  const systemMethods = {
    prepareStackTrace(error, sst) {
      weakmapSet(stackInfos, error, { callSites: sst });
      return inputPrepareFn(error, safeV8SST(sst));
    },
  };
  weaksetAdd(systemPrepareFnSet, systemMethods.prepareStackTrace);
  return systemMethods.prepareStackTrace;
};
```

The structural reading:

1. **If `inputPrepareFn` is already a system prepareFn**, return it unchanged (preserves identity for round-trip reads of `Error.prepareStackTrace`).
2. **Otherwise wrap** in a new system prepareFn that:
   - Stores the original SST in `stackInfos` (so `getStackString` later can produce a censored stack from the unattenuated SST).
   - Calls `inputPrepareFn` with the *safe* SST (`safeV8SST(sst)` — the attenuated version from §1's permit list).
3. **Brand the wrapper** with `weaksetAdd`. Now future reads of `Error.prepareStackTrace` followed by re-assignment will not double-wrap.

The branding-via-WeakSet ensures *only one layer of wrapping*. Without branding, code like:

```js
const old = Error.prepareStackTrace;
Error.prepareStackTrace = (e, sst) => old(e, sst);
```

would create an infinite stack of system-prepareFn wrappers. The WeakSet check short-circuits the wrapping.

### §The prepareStackTrace setter — branding-on-assignment

The §closing `defineProperties` call installs `captureStackTrace` and `prepareStackTrace` on `InitialError`:

```js
defineProperties(InitialError, {
  captureStackTrace: {
    value: tamedMethods.captureStackTrace,
    writable: true,
    enumerable: false,
    configurable: true,
  },
  prepareStackTrace: {
    get() {
      return OriginalError.prepareStackTrace;
    },
    set(inputPrepareStackTraceFn) {
      if (typeof inputPrepareStackTraceFn === 'function') {
        const systemPrepareFn = systemPrepareFnFor(inputPrepareStackTraceFn);
        OriginalError.prepareStackTrace = systemPrepareFn;
      } else {
        OriginalError.prepareStackTrace = defaultPrepareFn;
      }
    },
    enumerable: false,
    configurable: true,
  },
});
```

The structural design:

- **`captureStackTrace` is a writable data property** — user code can override it but not weaponize it.
- **`prepareStackTrace` is an accessor pair**:
  - **Getter** returns the *current* `OriginalError.prepareStackTrace`. This may be the default, or a previously-set wrapped user prepareFn (preserving the input identity for read-back).
  - **Setter** calls `systemPrepareFnFor(inputPrepareStackTraceFn)` to wrap (or pass-through if already a system prepareFn) and installs the result on `OriginalError`.
- **Non-function inputs reset to default** — `Error.prepareStackTrace = null` (or any non-function) restores `defaultPrepareFn`.

The accessor-pair pattern is *transparent-from-the-user-perspective*: user code reads `Error.prepareStackTrace`, gets back what looks like their function (it's actually the wrapped version, but the *brand-check* prevents double-wrapping if they re-assign).

### §The return value — `tamedMethods.getStackString`

The function ends with:

```js
return tamedMethods.getStackString;
```

The structural return: the *capability* to read an error's stack string. The caller of `tameV8ErrorConstructor` (the SES lockdown machinery) receives `getStackString` and installs it where appropriate — typically in the start compartment's `assert` machinery, so causal-console can read stacks from arbitrary errors *without* exposing the stack-string capability to guest compartments.

## Connection to the wider library

This section is the **canonical worked example of *system-vs-user-prepareFn distinction* via WeakSet branding** at the SES V8-taming layer. Three threads:

1. **The system-vs-user-prepareFn distinction** is reusable for any *capability-wrapping API* where user code can assign callbacks that should not see the full unattenuated input. The WeakSet branding prevents double-wrapping on read-back-and-re-assign cycles.

2. **The accessor-pair-as-transparent-wrapper pattern**. Getter returns the current installed function (preserving identity); setter wraps if needed. From the user's perspective, the API behaves like a plain property; the wrapping is invisible until something breaks the brand-check.

3. **The `__HIDE_` function-name convention**. Functions whose name starts with `__HIDE_` are dropped from concise stacks. The convention generalizes — any application can use this prefix to hide instrumentation, decorators, or test scaffolding from debugging output.

## Translation block (comment idiom → contemporary practice)

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `tameV8ErrorConstructor` four-argument entry point | The *taming function* idiom across SES: `tame*` functions install defensive replacements for engine intrinsics. |
| System-vs-user prepareFn distinction | The *who-can-see-what* discipline at the capability-attenuation layer. |
| WeakSet branding for system prepareFns | Prevents double-wrapping; preserves identity round-trip for read-then-assign cycles. |
| `__HIDE_` function-name censor | Application-code convention for *hide this frame*; the function-name-prefix is the marker. |
| Lazy stringification via `void error.stack` | Trigger V8's internal `prepareStackTrace` synchronously without consuming the result. |
| `getStackString` as proposed TC39 special-power | The *Error Stacks* proposal capability; SES makes this start-compartment-only. |
| `errorTaming === 'unsafe'` mode | The debug-friendly mode that exposes stacks; default-off because stack-frame inspection is a capability leak. |
| Accessor-pair setter that wraps via brand-check | Transparent-wrapper-with-identity-preservation pattern. |

## See also

- [[hardened-javascript]] (topic) — the SES substrate this taming inhabits.
- [[errors]] (topic) — the SES error-handling surface; `getStackString` is the start-compartment-only stack-read capability.
- [[capability-security]] (topic) — the system-vs-user prepareFn distinction is the canonical capability-attenuation pattern for a V8-defined hook.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--call-site-permit-list-and-filename-censors` — the first section: the 16-name permit list + five filename-censors that this section's `callSiteFilter` + `safeV8SST` consume.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--callsite-path-shortening-patterns` — the second section: the four regex patterns that this section's `callSiteStringifier` applies when `shortenPaths` is true.
- `endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair` (cycle 87) — the complementary pass-style-side V8-stack-accessor repair. The pass-style side fixes the *accessor channel*; this file attenuates the *prepareStackTrace API surface*.
- `endo--packages-eventual-send-src-track-turns-js--*` (cycle 90) — the causal-console + eventual-send module whose frames are dropped by this file's `FILENAME_EVENTUAL_SEND_CENSOR`. Track-turns *adds* causal annotations; tame-v8 *removes* the underlying frames from concise stacks. The two compose to produce a useful causal-but-not-noisy stack view.

## Common confusions

- **"User prepareFns are restricted — what if they need the full SST?"** Then they need to be a system prepareFn, which only this module can create. Application code is *intentionally* prevented from seeing the unattenuated SST because it can leak capabilities (function-objects via `getFunction`, receivers via `getThis`). The restriction is the *point* of the design.
- **"`__HIDE_` is a magic string."** It is — and it's *documented* magic. The convention is part of the contract: name your hidden functions with the prefix, and they're censored from concise stacks. The prefix is unusual enough that accidental matches are vanishingly unlikely.
- **"WeakSet branding is overkill."** Without it, re-assigning `Error.prepareStackTrace` via `Error.prepareStackTrace = Error.prepareStackTrace` would double-wrap. With it, the second assignment is a no-op. The WeakSet check is cheap; the alternative (re-wrap every time) would create unbounded layers.
- **"`void error.stack` is a code smell."** It is *intentional* — the side effect (triggering V8's `prepareStackTrace`) is exactly what we want; the result (the stack string in safe mode is `''`) is uninteresting. The `void` operator is the standard JavaScript way to *evaluate-for-side-effect-only*.
- **"`errorTaming: 'unsafe'` defeats the whole point."** It exposes stacks to user code, but it does *not* expose `getThis` / `getFunction` (the suppressed methods stay suppressed). The unsafe mode is a debugging convenience that retains the most-load-bearing capability-attenuation.
- **"The accessor-pair setter could be simpler."** The brand-check is *required* to prevent double-wrapping; the wrapping is *required* to attenuate the SST seen by user prepareFns. The pair's complexity is the *minimum* to achieve both.
- **"The shim of TC39 error-stacks proposal is speculative."** The proposal is mature (at stage 3-ish as of paper-writing). The shim ensures SES is forward-compatible: when the proposal lands as standard, SES's `getStackString` will already match the spec. Until then, the shim provides the same capability with a clear migration path.
