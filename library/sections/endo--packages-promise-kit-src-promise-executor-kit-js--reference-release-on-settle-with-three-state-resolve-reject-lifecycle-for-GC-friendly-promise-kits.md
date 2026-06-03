---
source: packages/promise-kit/src/promise-executor-kit.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/promise-executor-kit.js
source_path: packages/promise-kit/src/promise-executor-kit.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - patterns
  - async-flow
genre: §endo-source-comment-fragment
cycle: 173
lane: chat
status: current
---

# Reference-release on settle with three-state resolve/reject lifecycle for GC-friendly promise kits

> §Chat-lane after cycle 172's designs-lane. §Endo-source-
> comment-fragment genre. **§Sibling-to-cycle-152's-memo-
> race.js** (both in @endo/promise-kit) and §used-by-cycle-
> 171's-stream-substrate (makeStream uses makePromiseKit
> per-cell).

`packages/promise-kit/src/promise-executor-kit.js` (55
lines) exports a single function: `makeReleasingExecutorKit`.
The single most structurally interesting move is the
**§three-state-internal-reference-lifecycle**: each of
`internalResolve` and `internalReject` traverses `undefined`
(initial) → `function` (executor captured) → `null`
(settled, references released). The §reference-release-on-
settle discipline lets the underlying promise become GC-
eligible immediately after settlement.

## §Why-this-file-exists

§The-problem: a plain `new Promise(executor)` captures the
resolve/reject functions in the executor closure. If the
holder of those captured functions never releases them, the
promise itself is kept alive — even after settlement.
§Reference-retention-prevents-GC.

§The-fix: separate the §resolve/reject-functions-the-holder-
needs from the §internal-resolve/reject-captured-during-
executor-invocation. After settlement, §null-out-the-
internal-references. §The-holder's-exported-handles-are-
no-ops-after-settle.

§Result: §the-promise-can-be-GC'd-after-settlement even if
the kit object is retained.

## §Three-state-internal-reference-lifecycle

```js
let internalResolve;   // state 0: undefined (initial)
let internalReject;    // state 0: undefined (initial)

const executor = (res, rej) => {
  assert(internalResolve === undefined && internalReject === undefined);
  internalResolve = res;     // state 0 → 1
  internalReject = rej;      // state 0 → 1
};

const resolve = value => {
  if (internalResolve) {
    internalResolve(value);
    internalResolve = null;  // state 1 → 2
    internalReject = null;   // state 1 → 2
  } else {
    assert(internalResolve === null);
  }
};
```

§Three-states-encoded-as-three-JS-values:

| State | `internalResolve` | Meaning |
|-------|-------------------|---------|
| 0 (initial) | `undefined` | Executor not yet called |
| 1 (armed) | function | Executor called; references captured |
| 2 (settled) | `null` | Resolved or rejected; references released |

§undefined-vs-null-meaningful-distinction. §undefined ≠
null in this design: §undefined-is-pre-arming, §null-is-
post-settlement. §The-falsy-check (`if (internalResolve)`)
distinguishes state 1 from states 0+2 (both falsy but
different).

§The-assert-discriminates: in state 2, `internalResolve ===
null`. In state 0, `internalResolve === undefined`. §State-
0-shouldn't-be-reachable-via-resolve (executor hasn't run
yet); the §assert would fire if a user did something
illegal.

## §The-executor-is-single-use

```js
const executor = (res, rej) => {
  assert(internalResolve === undefined && internalReject === undefined);
  internalResolve = res;
  internalReject = rej;
};
```

§assert-on-double-invocation. The executor expects to be
called §exactly-once by the promise constructor.

§Why-this-matters: Promise constructors invoke the executor
synchronously, once. §The-assertion-catches-misuse if
someone tries to reuse the executor.

§State-0-precondition: §undefined-undefined-both-must-hold.

## §Resolve/reject-are-fire-once

```js
const resolve = value => {
  if (internalResolve) {           // state 1?
    internalResolve(value);         // fire
    internalResolve = null;         // → state 2
    internalReject = null;          // → state 2
  } else {
    assert(internalResolve === null); // must be state 2
  }
};
```

§First-call: state 1 → state 2 (fires, releases).
§Subsequent-calls: silent no-op (with assert).

§Why-silent-no-op-on-double-resolve: §Promise-semantics-
already-make-second-resolve-a-no-op; the kit honors this
without forwarding to the (now-released) resolve function.

§Symmetric-release: resolve releases *both* internalResolve
*and* internalReject. §Once-settled-neither-can-fire.
§Same-on-reject-side: rejection releases both.

## §reject-symmetric

```js
const reject = reason => {
  if (internalReject) {
    internalReject(reason);
    internalResolve = null;
    internalReject = null;
  } else {
    assert(internalReject === null);
  }
};
```

§Identical-structure-to-resolve. §Two-functions-symmetric-
in-shape; §the-only-difference-is-the-trigger-condition.

§Could-this-be-DRYed: yes, with a higher-order factory.
§Why-it-isn't: §two-functions-named-resolve-and-reject is
§clearer-than-one-function-with-a-mode-arg; the duplication
is §intentional-readability.

## §The-pattern-named: §reference-release-on-settle

This is a §micro-pattern with three components:

1. **§Captured-state-as-mutable-let** (not const) — the
   variables must be re-assignable.
2. **§Three-distinct-states** distinguishable by JS value
   shape (undefined / function / null).
3. **§Symmetric-release-on-first-firing** — both halves of
   the pair are released, regardless of which side fired.

§Applicable-to-other-kit-shapes: any factory that captures
references it wants to release after a §single-firing event
can borrow this pattern. §Watchdog-timers, §one-shot-event-
emitters, §single-use-cleanup-handlers.

## §Why-not-just-WeakRef

A reader might ask: why not use `WeakRef` to hold
internalResolve/internalReject and let GC handle the
release?

§Answer: §timing-guarantees. WeakRef doesn't give §immediate-
release; it gives §release-when-GC-runs (which could be
arbitrarily later). For §promise-settlement-pipeline-
hygiene, §immediate-release-by-explicit-assignment is the
right shape.

§Cycle-156's-finalize.js (WeakValueMap pattern) is the
sibling: that file uses WeakRef-equivalent for §observe-
when-no-strong-ref-remains. This file uses §explicit-
release-on-known-event.

§Two-different-promises-about-GC: §weak-when-no-strong-
reference (finalize.js) vs §release-on-known-event (this
file).

## §Comparison-with-cycle-152-memo-race.js

§Cycle-152 memo-race.js implements `memoRace`: race a list
of promises, returning the first to settle. Both files are
in @endo/promise-kit; both deal with §promise-lifecycle.

| File | Primary concern | Lifecycle pattern |
|------|----------------|-------------------|
| memo-race.js (cycle 152) | §Racing-with-cleanup | First-settler wins; losers signal abandonment |
| promise-executor-kit.js (this) | §Reference-release-on-settle | Captured executor refs cleared after settlement |

§Both-named-cleanup-disciplines for §async-resource-
hygiene. Cycle 152 cleans up §racing-promises; this cleans
up §kit-internal-references.

§Common-author: both are Kris Kowal authored — same author
discipline across @endo/promise-kit.

## §Used-by-cycle-171-stream-substrate

`packages/stream/index.js` (cycle 171) calls
`makePromiseKit()` to create the §functional-async-queue's
cons-cells. Each cons-cell's `{value, promise}` involves a
promise that needs to be GC-eligible after consumption.

§If-promise-kits-didn't-release-internal-refs: the stream's
cons-cell chain would §retain-each-resolve-function until
the cons-cell itself was collected. With §reference-release-
on-settle, each settled cons-cell's promise can be GC'd
§independently-of-cons-cell-lifetime.

§Cycle-171's-promise-as-pointer pattern §depends-on-this-
hygiene. The §queue-can-be-long because §settled-cells-
don't-pin-resolution-functions.

## §The-makePromiseKit-factory-vs-this-kit

`@endo/promise-kit` exports `makePromiseKit()` (the
canonical name). This file exports `makeReleasingExecutorKit
()` — note the §releasing-qualifier in the name.

§The-distinction:

- `makePromiseKit()` (in another file, not this one): the
  §full-kit including the promise itself.
- `makeReleasingExecutorKit()` (this file): the §executor-
  half only — resolve/reject + executor function, no
  promise. §Caller-passes-executor-to-Promise-constructor.

§This-file-is-the-§executor-half; the promise itself is
constructed by the caller. §Decomposed-for-composition.

§Why-decompose: §the-promise-constructor-can-be-any (not
just `Promise` — could be `HandledPromise`, a future
variant, etc.). §The-executor-kit-is-promise-agnostic.

§Cycle-66's-HandledPromise + cycle-146's-E.js use this
flexibility — they construct §HandledPromises with executors
from kits like this one.

## §The-naming-discipline-§releasing-as-qualifier

§makeReleasingExecutorKit names the §release-discipline in
the function name. §The-name-tells-you-the-pattern.

§Alternative-names that would lose this:
- `makeExecutorKit` — silent about release behavior
- `makeKitExecutor` — doesn't say *kit* clearly

§Releasing-as-adjective-in-function-name is the §borrow-
this-naming pattern. §If-your-function-does-cleanup-name-
the-cleanup-in-the-function-name.

§Cycle-118's-defendPrototype follows similar discipline
(*defend* names the protection mechanism). §Cycle-90's-
trackTurns (track = causal annotation). §Cycle-138's-
safe-promise (safe = reentrancy-safe). §Action-verb-or-
adjective-in-function-name is the @endo discipline.

## §The-assert-without-condition-is-just-Fail

```js
} else {
  assert(internalResolve === null);
}
```

§assert(condition)-without-message: §relies-on-the-assert-
substrate-to-throw-a-default-message. §SES's-assert
(cycle 98) provides this.

§Why-not-`Fail`-template-tag: §the-assertion-is-a-genuine-
invariant-check, not a §user-facing-error. The default
message ("Check failed") is fine for §a-bug-not-a-user-
mistake.

§Comparison-with-Fail-X-template-discipline (cycles 87/96/
98): §those-are-for-user-facing-errors-with-context. §This-
is-for-impossible-states-that-indicate-a-bug.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 152 (memo-race.js) | §Sibling-file-in-same-package; §promise-lifecycle discipline |
| 171 (stream/index.js) | §Consumer-of-makePromiseKit; this file's release is §what-makes-the-stream-queue-GC-friendly |
| 156 (finalize.js) | §WeakValueMap-GC-pattern sibling; §weak-vs-explicit-release distinction |
| 66 (handled-promise.js) | §Promise-constructor that this kit's executor could feed |
| 146 (E.js) | §Consumer-of-HandledPromise; uses kit-style executors indirectly |
| 90 (track-turns.js) | §Promise-pipeline-hygiene sibling |

## §Tier-1 vocabulary borrowing candidates

§Three-state-internal-reference-lifecycle (undefined →
function → null).

§Reference-release-on-settle (explicit-release-on-known-
event, distinct from §weak-when-no-strong-ref).

§Releasing-as-qualifier-in-function-name (cleanup
mechanism named in the function name).

§Symmetric-release-of-paired-references (resolve releases
both internalResolve AND internalReject).

§undefined-vs-null-meaningful-distinction (state encoding
via JS value).

§Tier-2: §two-functions-named-vs-one-with-mode-arg
(intentional readability over DRY), §assert-without-
condition-as-bug-not-user-error.

## §Synthesis-target

§Slot machine library's promise-based callbacks need this
hygiene: if a game session captures resolve/reject for an
event-loop-style handler, the §reference-release-on-settle
discipline keeps the session GC-friendly.

§More-broadly: any factory that captures one-shot callbacks
benefits from this pattern. §Watchdog-timers, §single-use-
listeners, §promised-input-completion.

## §Small-file-but-load-bearing-knowledge

55 lines. The §reference-release-on-settle pattern lives in
this one function. §Reading-this-file-tells-you-how-to-
make-promise-kits-not-retain-references-after-settlement.

§Sibling-to-cycle-167-where-and-cycle-169-atomics-and-
cycle-171-stream as §small-files-with-large-knowledge-
density. §The-pattern-is-the-point, not the line count.
