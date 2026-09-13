---
created: 2026-09-13
updated: 2026-09-13
author: designer
---

# Ironhorse js-26 Map/Set cross-cutting gap sequence

| Field | Decision |
| --- | --- |
| Scope | Four engine-wide gaps recovered from `ironhorse-js-26-map-methods` |
| Order | Function prototype/constructor -> function own metadata -> `Reflect.construct` constructor validation -> `Array.from` iteration |
| Delivery | Serial, halt on a failed exit gate, never stacked |
| Current disposition | Do not queue any of the four. Every fix is already an ancestor of `endojs/endo-but-for-bots` `origin/llm` at `a894459f25bf`. |

## Decision

If these gaps must be replayed from a pre-fix base, use one serial orchestration
with these build-job bases:

1. `build-ironhorse-function-prototype-constructor`
2. `build-ironhorse-function-own-metadata`
3. `build-ironhorse-reflect-construct-isconstructor`
4. `build-ironhorse-array-from-iterator`

Do not stack the changes. Increment 1 makes the test262 `assert.throws` oracle
reliable for the error paths exercised by later increments. Increment 2 has the
best residuals-to-change ratio and gives the property model a quiet checkpoint
after increment 1. Increment 3 consumes the constructor classification established
by increment 1. Increment 4 is independent at the proposal level, but it crosses
iteration, callbacks, construction, property definition, abrupt completion, and
metering. It therefore runs last, after the other changes are merged and the
iterator/property surface is quiet. This separates the two largest regression
surfaces, increments 1 and 4, with two independently verifiable changes.

The source report recorded the shared nature of the residuals and the four gaps at
[`jobs/tada/ironhorse-js-26-map-methods.md:28`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/ironhorse-js-26-map-methods.md#L28),
then said each warranted a separate feature increment at
[`jobs/tada/ironhorse-js-26-map-methods.md:35`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/ironhorse-js-26-map-methods.md#L35).
The implementation citations below are pinned to `endojs/endo-but-for-bots` commit
`a894459f25bf`, so later refactors do not move the cited lines.

## The four recovered gaps

### 1. User-function `prototype.constructor` wiring

The missing observable link was the pair created for a constructable user function:
the function's own `.prototype` must expose the same object used by `new`, and that
prototype must carry a writable, non-enumerable, configurable `constructor`
back-reference to the function. Without it, the harness's custom `Test262Error`
instances did not satisfy `thrown.constructor === E`. Tests of the methods' own error
behavior therefore aborted in harness code. The named proposal residuals were
`callback-throws.js`, `iterator-next-throws.js`, and `invalid-property-key.js`
([source report:31](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/ironhorse-js-26-map-methods.md#L31)).

Blast radius: every constructable user function, `new`, `instanceof`, prototype
augmentation/reassignment, custom error identity, and any harness assertion that
checks a thrown constructor. The current implementation installs the back-reference
at [`rust/engine/ironhorse-vm/src/interp/function.rs:222`](https://github.com/endojs/endo-but-for-bots/blob/a894459f25bf07f9644b450c51fd4a2c65b47a58/rust/engine/ironhorse-vm/src/interp/function.rs#L222)
and the function's own prototype property at
[`function.rs:246`](https://github.com/endojs/endo-but-for-bots/blob/a894459f25bf07f9644b450c51fd4a2c65b47a58/rust/engine/ironhorse-vm/src/interp/function.rs#L246).
The regression suite states the original failure and its full surface at
[`function_prototype_property.rs:1`](https://github.com/endojs/endo-but-for-bots/blob/a894459f25bf07f9644b450c51fd4a2c65b47a58/rust/engine/ironhorse-262/tests/function_prototype_property.rs#L1).

### 2. Function `name` and `length` as reflective own properties

Ironhorse could synthesize `.name` and `.length` for a direct read, but the baseline
did not expose their own data descriptors and could not delete them. This blocked
`name.js`, `length.js`, and the descriptor checks in `getOrInsertComputed.js`
([source report:30](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/ironhorse-js-26-map-methods.md#L30)).
The exit behavior is an own data descriptor with the value supplied by the function
metadata, `writable: false`, `enumerable: false`, and `configurable: true`; successful
deletion must make all reflective paths agree that it is absent.

Blast radius: every user, native, bound, and harness-created function observed through
property access, `hasOwnProperty`, `Object.getOwnPropertyDescriptor`,
`Reflect.getOwnPropertyDescriptor`, `defineProperty`, deletion, or enumeration. The
current single descriptor view is at
[`rust/engine/ironhorse-vm/src/interp/property/ordinary.rs:103`](https://github.com/endojs/endo-but-for-bots/blob/a894459f25bf07f9644b450c51fd4a2c65b47a58/rust/engine/ironhorse-vm/src/interp/property/ordinary.rs#L103),
and its deletion tombstone is at
[`ordinary.rs:695`](https://github.com/endojs/endo-but-for-bots/blob/a894459f25bf07f9644b450c51fd4a2c65b47a58/rust/engine/ironhorse-vm/src/interp/property/ordinary.rs#L695).

### 3. `Reflect.construct` must validate `IsConstructor`

The baseline accepted a merely callable native method as `newTarget`. ECMA-262
`Reflect.construct` requires both `target` and the defaulted or explicit `newTarget`
to have `[[Construct]]`; a non-constructor must throw a catchable `TypeError` before
the argument-list operation. The gap blocked each `not-a-constructor.js` residual
([source report:32](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/ironhorse-js-26-map-methods.md#L32)).

Blast radius: every built-in method tested for non-constructability, plus user, native,
bound, and proxy constructor classification. The shared classifier is at
[`rust/engine/ironhorse-vm/src/interp/function.rs:447`](https://github.com/endojs/endo-but-for-bots/blob/a894459f25bf07f9644b450c51fd4a2c65b47a58/rust/engine/ironhorse-vm/src/interp/function.rs#L447),
and the required validation order is at
[`rust/engine/ironhorse-vm/src/interp/natives/reflect.rs:196`](https://github.com/endojs/endo-but-for-bots/blob/a894459f25bf07f9644b450c51fd4a2c65b47a58/rust/engine/ironhorse-vm/src/interp/natives/reflect.rs#L196).

### 4. `Array.from` over iterators

`Array.from` was an explicit `Array.from:iterator-protocol-metering` skip. The Map
grouping implementation was correct, but `evenOdd.js`, `groupLength.js`, `string.js`,
and `toPropertyKey.js` inspected `map.keys()` with `Array.from`, so the assertion
aborted before it could observe the result
([source report:33](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/ironhorse-js-26-map-methods.md#L33)).

Blast radius: the entire `Array.from` static, iterable and array-like dispatch,
constructor selection, mapping callbacks, collection and string iterators,
`IteratorClose`, property definition, and their computron charges. The current entry
point and abrupt-completion boundary are at
[`rust/engine/ironhorse-vm/src/interp/natives/array.rs:6`](https://github.com/endojs/endo-but-for-bots/blob/a894459f25bf07f9644b450c51fd4a2c65b47a58/rust/engine/ironhorse-vm/src/interp/natives/array.rs#L6),
with iterator acquisition starting at
[`array.rs:257`](https://github.com/endojs/endo-but-for-bots/blob/a894459f25bf07f9644b450c51fd4a2c65b47a58/rust/engine/ironhorse-vm/src/interp/natives/array.rs#L257).

## Increment gates

### Increment 1: function prototype and constructor

Entry condition: record a pinned full-suite baseline; reproduce an inaccessible
`T.prototype`, a failed `T.prototype.constructor === T`, and the custom
`Test262Error` constructor mismatch. No concurrent function-creation, prototype-MOP,
`new`, or `instanceof` change may be in flight.

Exit condition: constructor functions and generator-family constructors have the
specified reachable prototype/back-reference pair; prototype augmentation and
reassignment affect later instances; arrows, methods, and async functions do not gain
a constructable prototype; the exact-meter corpus has no delta.

Verification: run `function_prototype_property`, the Map/Set focused tests, and the
proposal subtrees. Prove the new test load-bearing by temporarily omitting the own
prototype or back-reference and observing the named constructor-identity failure,
then revert and pass. A full test262 sweep is required because this changes function
creation and error rendering. Expect at least the five named Map/Object source tests,
about ten sloppy/strict records, to move to covered, with a substantially larger
positive whole-tree delta from custom constructors. Any loss of an already-covered
case blocks exit.

### Increment 2: function own metadata

Entry condition: increment 1 is merged and its full sweep is the comparison baseline;
no property-MOP or function-metadata refactor is in flight.

Exit condition: independent `.name` and `.length` descriptor assertions pass for user
and native functions; direct read, own-presence, descriptor, delete, redefine, and
enumeration paths agree; exact metering is unchanged.

Verification: run the collection metadata regression at
[`collections.rs:214`](https://github.com/endojs/endo-but-for-bots/blob/a894459f25bf07f9644b450c51fd4a2c65b47a58/rust/engine/ironhorse-262/tests/collections.rs#L214)
and every intrinsic-metadata suite. Each metadatum gets its own assertion and message.
Temporarily bypass the synthetic descriptor or tombstone and observe the descriptor or
delete test fail, then revert. A full test262 sweep is required because all functions
share this reflection seam. Across the Map/Set/upsert/grouping proposal, expect roughly
20-24 source tests, or 40-48 sloppy/strict records, to move to covered; the wider
built-in metadata delta may be larger.

### Increment 3: `Reflect.construct` `IsConstructor`

Entry condition: increments 1 and 2 are merged; user, native, bound, and proxy
constructor classification has focused coverage; no call/construct trampoline change
is in flight.

Exit condition: invalid `target` and `newTarget` throw `TypeError` in specification
order, argument-list access does not run after either rejection, and all valid
constructors retain their prior result and meter behavior.

Verification: run the focused target/newTarget controls at
[`intl_numberformat_format_getter.rs:226`](https://github.com/endojs/endo-but-for-bots/blob/a894459f25bf07f9644b450c51fd4a2c65b47a58/rust/engine/ironhorse-262/tests/intl_numberformat_format_getter.rs#L226),
then sweep every proposal `not-a-constructor.js` and the full `not-a-constructor`
family. Temporarily weaken the `newTarget` check to callable-only and observe the
focused failure, then revert. A full test262 sweep is required because one classifier
serves every callable kind. Expect about 11 proposal source tests, or about 22 mode
records, to move to covered, plus the wider built-in-method family. No valid
constructor regression is acceptable.

### Increment 4: iterator-capable `Array.from`

Entry condition: increments 1-3 are merged and green; iterator acquisition/closing,
re-entrant callback invocation, array construction/property definition, and metering
have no concurrent feature changes. Record the exact `built-ins/Array/from` and
Map/Object grouping baselines.

Exit condition: iterable and array-like paths, strings by Unicode code point, mapper
arguments and `thisArg`, custom constructors, iterator-result validation, abrupt
mapping, `IteratorClose`, property-definition failure, and exact metering match the
pinned XS oracle. Map/Object grouping inspection no longer aborts in `Array.from`.

Verification: run the 13 oracle-backed groups at
[`array_from.rs:1`](https://github.com/endojs/endo-but-for-bots/blob/a894459f25bf07f9644b450c51fd4a2c65b47a58/rust/engine/ironhorse-262/tests/array_from.rs#L1),
the Map/Set focused suites, and the exact-meter corpus. Temporarily omit iterator
closing on mapper failure and observe `abrupt_mapping_closes_iterator_and_preserves_throw`
fail, then revert. Run a full test262 sweep: the proposal delta is the four named Map
grouping source tests, about eight mode records, while `built-ins/Array/from` should
gain on the order of 80-90 mode records once prerequisites are present. Treat any
smaller delta as a classification task, not as grounds to relabel skips.

The sweep command and its pinned-corpus behavior are documented at
[`rust/engine/ironhorse-262/scripts/README.md:18`](https://github.com/endojs/endo-but-for-bots/blob/a894459f25bf07f9644b450c51fd4a2c65b47a58/rust/engine/ironhorse-262/scripts/README.md#L18).
Every increment compares its report to the prior increment, permits only explained
skip-to-covered transitions, and rejects new failures, infrastructure results, or
losses from the covered set.

## Current disposition: do not queue

None of these build jobs should be posted now. The four fixes already exist on
`origin/llm`:

| Increment | Landed commit | Review provenance |
| --- | --- | --- |
| Function prototype/constructor | `d8d5d73725fa` | closed PR [#1087](https://github.com/endojs/endo-but-for-bots/pull/1087); commit is now on `llm` |
| Function own metadata | `5a310f05e74b` | merged PR [#970](https://github.com/endojs/endo-but-for-bots/pull/970) |
| `Reflect.construct` validation | `83ffe089f6d4` | merged PR [#970](https://github.com/endojs/endo-but-for-bots/pull/970) |
| Iterator-capable `Array.from` | `566bd5799f08` | closed PR [#1138](https://github.com/endojs/endo-but-for-bots/pull/1138); commit is now on `llm` |

The committed expectation shards at `a894459f25bf` show the named metadata,
constructor-identity, `not-a-constructor`, and Map/Object grouping records passing.
A local oracle-backed run on 2026-09-13 also passed all 47 tests in `array_from`,
`collections`, `function_prototype_property`, `intl_numberformat_format_getter`, and
`map_methods`.

A later producer may queue work only if a fresh pinned sweep demonstrates that one of
these exit conditions regressed. In that case, post a regression job for the observed
delta rather than replaying the historical increment. Increment 4 must still wait for
increments 1-3 to satisfy their exit conditions on the chosen base, and neither
increment 1 nor increment 4 may overlap another change to its engine-wide surface.
