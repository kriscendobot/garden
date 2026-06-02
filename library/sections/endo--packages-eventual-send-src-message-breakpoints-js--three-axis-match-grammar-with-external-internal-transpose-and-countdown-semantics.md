---
section: three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
source: endo--packages-eventual-send-src-message-breakpoints-js
topics: [eventual-send, errors]
status: current
---

# Three-axis match grammar with external↔internal transpose and countdown semantics

> *A star `'*'` will always breakpoint. Otherwise, the string must
> be a non-negative integer. Once that is zero, always breakpoint.
> Otherwise decrement by one each time it matches until it reaches
> zero.*
>
> — `packages/eventual-send/src/message-breakpoints.js` §MatchCountdown JSDoc

`message-breakpoints.js` (179 lines, Mark Miller-last-touched
2024-01-13 in commit `b191aaf3`) is the *runtime-configurable
breakpoint tester* for E()-mediated eventual-send dispatch. The
file exports a single factory, `makeMessageBreakpointTester`, that
reads an env-option-named JSON record and produces a tester with
`getBreakpoints` / `setBreakpoints` / `shouldBreakpoint` methods.

## The §three-axis match grammar

The file's load-bearing taxonomy is three JSDoc typedefs:

- **`MatchStringTag = string | '*'`** — matches against the
  recipient's `@@toStringTag` after `simplifyTag()` strips a
  leading `'Alleged: '` or `'DebugName: '` prefix. *For objects
  defined with `Far` this is the first argument, known as the
  `farName`. For exos, this is the tag.* The `'*'` wildcard
  matches any recipient.

- **`MatchMethodName = string | '*'`** — matches against the
  method name. *Currently, this is only an exact match.* The `'*'`
  wildcard matches any method name. The §comment names a future
  hazard: *we may introduce a string syntax for symbol method
  names* — currently symbols can't be matched by string.

- **`MatchCountdown = number | '*'`** — `'*'` always breakpoint;
  `0` always breakpoint; positive integer decrements by one each
  match. The *skip-N-then-breakpoint* mechanism.

The three axes compose: `{tag: {method: countdown}}` at the
external surface; *every recipient × every method × every match
count* gets a decision.

## The §external↔internal transpose

The §`MessageBreakpoints` external JSON shape and the §
`BreakpointTable` internal shape differ in *index order*:

| Shape | Outer key | Inner key | Value |
|-------|-----------|-----------|-------|
| External (user-facing) | `tag` or `'*'` | `method` or `'*'` | countdown |
| Internal (lookup-fast) | `method` or `'*'` | `tag` or `'*'` | countdown |

The §setBreakpoints procedure transposes the external shape into
the internal one. The §rationale is in the §shouldBreakpoint flow:
on every method call, the tester knows `methodName` first and
`recipient` second; *method-keyed lookup* lets the common case (no
breakpoint matches this method) early-exit at the first table
indexing. The external shape is *human-organized* (group by
recipient class); the internal shape is *lookup-organized* (group
by method).

The transpose builds the internal table fresh on each
setBreakpoints call:

```js
const newBreakpointsTable = { __proto__: null };

for (const [tag, methodBPs] of entries(newBreakpoints)) {
  // ... validation ...
  for (const [methodName, count] of entries(methodBPs)) {
    // ... validation ...
    const classBPs = hasOwn(newBreakpointsTable, methodName)
      ? newBreakpointsTable[methodName]
      : (newBreakpointsTable[methodName] = {
          __proto__: null,
        });
    classBPs[tag] = count;
  }
}
```

The §`__proto__: null` discipline (twice — outer table and inner
class-BPs) ensures the lookup `breakpointsTable[methodName]`
returns *only own-key matches*, never accidental matches against
`Object.prototype` keys (e.g., `'constructor'`, `'toString'`).

## The §simplifyTag idiom and the *only-the-outer-one-removed*
rule

The §`simplifyTag(tag)` function strips a leading `'Alleged: '` or
`'DebugName: '` prefix:

```js
const simplifyTag = tag => {
  for (const prefix of ['Alleged: ', 'DebugName: ']) {
    if (tag.startsWith(prefix)) {
      return tag.slice(prefix.length);
    }
  }
  return tag;
};
```

The §JSDoc names the §explicit-non-recursion behavior: *If there
are multiple such prefixes, only the outer one is removed.* The
*one-level-strip* discipline — a tag like `'Alleged: Alleged: moola
issuer'` becomes `'Alleged: moola issuer'`, not `'moola issuer'`.

The §setBreakpoints validation *enforces canonical simple tags*:

```js
tag === simplifyTag(tag) ||
  Fail`Just use simple tag ${q(simplifyTag(tag))} rather than ${q(tag)}`;
```

The §don't-pass-in-already-prefixed-tag discipline pushes the
prefix-stripping responsibility to *the configuration time*, not
*the per-call match time*. The user must provide *simple tags*; if
they pass `'Alleged: foo'`, the error message tells them exactly
what to use instead (`'foo'`).

## The §shouldBreakpoint match flow

The §shouldBreakpoint procedure is the structurally interesting
center of the file. The flow:

1. **No methodName → no breakpoint.** *TODO enable function
   breakpointing.* The current implementation only matches on
   method calls.

2. **Method lookup**: `classBPs = breakpointsTable[methodName] ||
   breakpointsTable['*']`. The §method-or-wildcard fallback —
   exact-name first, then wildcard.

3. **Class-BPs not configured for this method → no breakpoint.**

4. **Tag lookup with wildcard fallback**:
   ```js
   let tag = simplifyTag(recipient[Symbol.toStringTag]);
   let count = classBPs[tag];
   if (count === undefined) {
     tag = '*';
     count = classBPs[tag];
     if (count === undefined) {
       return false;
     }
   }
   ```

   *Exact tag first, then wildcard tag, then no breakpoint.*

5. **Always-breakpoint shortcuts**:
   - `count === '*'` → always breakpoint
   - `count === 0` → always breakpoint (the *countdown-exhausted*
     state)

6. **Decrement-and-skip**: positive integer → `classBPs[tag] =
   count - 1; return false`. The §in-place-decrement mutates the
   internal table; *next call to shouldBreakpoint sees the
   decremented count*.

## The §getBreakpoints-returns-original-not-mutated invariant

The §getBreakpoints / §setBreakpoints / §shouldBreakpoint trio
maintains a subtle invariant:

- `getBreakpoints()` returns the *user-configured* JSON
  (decrements are *not* visible).
- `setBreakpoints(newBreakpoints)` re-installs from a new (or
  same) JSON.
- `shouldBreakpoint(recipient, methodName)` mutates the *internal*
  table's countdowns *without* mutating the external `breakpoints`
  variable.

The separation lets the user inspect the original configuration
even after many shouldBreakpoint calls have decremented the
internal countdowns. *Re-installing the same JSON resets the
countdowns* — `setBreakpoints()` with no arguments uses the stored
breakpoints, effectively rebuilding the table:

```js
const setBreakpoints = (newBreakpoints = breakpoints) => {
  ...
};
```

The §default-argument-to-stored-breakpoints idiom makes
`setBreakpoints()` *both* a configure-from-new and a
reset-countdowns call.

## The §env-option-driven instantiation

The factory takes an `optionName`:

```js
export const makeMessageBreakpointTester = optionName => {
  let breakpoints = JSON.parse(getEnvironmentOption(optionName, 'null'));

  if (breakpoints === null) {
    return undefined;
  }
  ...
};
```

The §env-option-yields-undefined-when-unset discipline — *if the
env var isn't set, the tester is `undefined` rather than a no-op
tester*. The §caller can check `if (tester)` and skip the
shouldBreakpoint call entirely. The *zero-cost-when-unset*
property.

The `getEnvironmentOption(optionName, 'null')` call uses
`@endo/env-options`'s configurable env-option lookup. The
factory's *single-argument-is-an-env-var-name* discipline: the
factory doesn't read a fixed env var; *callers name what to
read*. This lets multiple breakpoint testers exist in parallel for
different concerns (e.g., E-eventual-sends vs HandledPromise
applies).

## The §`__proto__: null` + freeze + harden chain

The file uses *both* `__proto__: null` and `freeze`:

- **`__proto__: null`** on the internal BreakpointTable records
  prevents accidental prototype-key matches (e.g.,
  `breakpointsTable['hasOwnProperty']` would otherwise return a
  method, not `undefined`).

- **`freeze`** on the three exported functions
  (`getBreakpoints`, `setBreakpoints`, `shouldBreakpoint`) and on
  the returned `breakpointTester` object — *callers cannot
  replace the methods* on the tester.

The two disciplines together: *no prototype-pollution lookup
hazards in the internal table*; *no method-replacement on the
external API*. Both are SES-compatible (this file doesn't use
`harden` — it predates the `@endo/harden` migration that cycles
108 + 110 + 115 + 118 + 123 + 125 all used).

The §`@ts-expect-error confused by __proto__` comments (twice)
acknowledge a TypeScript limitation: TS doesn't understand the
prototype-null pattern as creating a typed Record, so the
declarations need explicit narrowing.

## The §single TODO — *enable function breakpointing*

The §shouldBreakpoint procedure carries one TODO:

```js
if (methodName === undefined || methodName === null) {
  // TODO enable function breakpointing
  return false;
}
```

The §current-state: only method invocations are breakpoint-able;
function-as-target calls (where there's no method name to match)
are silently skipped. The future-work direction is to *match on
function identity or function name* — but the JSDoc's match
grammar above doesn't yet have a typedef for that case.

## Why this file matters for eventual-send

The file integrates with E() and HandledPromise (cycle 66 §handler-
protocol) to provide *debugger-friendly* eventual-send dispatch.
The caller pattern (visible in `E.js` and `handled-promise.js`):

```js
if (tester && tester.shouldBreakpoint(recipient, methodName)) {
  // eslint-disable-next-line no-debugger
  debugger;
}
```

The §`if (tester)` short-circuit makes the breakpoint check
*zero-cost when the env var isn't set* — `makeMessageBreakpointTester`
returns `undefined` in that case. *Pay-only-for-what-you-use*
debugger integration.

The *async-call-debugging-pain-point* this file solves: in
eventual-send, the actual delivery happens *later than the call
site*, often after an async hop. Breakpointing at the call site is
useless; you need to break at the *receiver's method dispatch
point*. This file lets the user say *break on the third call to
`.send` on any object tagged `'wallet'`* via a JSON env var, with
no code modification.

## Related sections

- cycle 66 (§handler-protocol)
  [[endo--packages-eventual-send-src-handled-promise-js--handler-protocol]]
  — the HandledPromise handler that calls into this file's tester
  before dispatching the method to the receiver.
- cycle 90
  [[endo--packages-ses-src-error-assert-js--redaction-discipline]]
  (et al.) — the SES side of the *causal-console substrate*; this
  file's debugger integration complements that diagnostic surface.
- cycle 96
  [[endo--packages-ses-src-error-tame-v8-error-constructor-js--unfilteredCaptureStackTrace]]
  — the V8-specific stack-capture machinery that surfaces alongside
  this file's breakpoints when the debugger pauses.
