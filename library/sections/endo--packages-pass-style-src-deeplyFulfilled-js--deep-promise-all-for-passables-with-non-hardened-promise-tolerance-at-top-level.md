---
section: deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
source: endo--packages-pass-style-src-deeplyFulfilled-js
topics: [pass-style, eventual-send]
status: current
---

# Deep Promise.all for Passables with non-hardened-promise tolerance at top level

> *This is a deep form of `Promise.all` specialized for Passables.
> For each encountered promise, replace it with the deeply
> fulfilled form of its fulfillment.*
>
> — `packages/pass-style/src/deeplyFulfilled.js` §JSDoc

`deeplyFulfilled.js` (153 lines, Kris Kowal-last-touched
2026-02-24 in commit `e56bf00f` — same coordinated-update
cluster as cycles 108/110/115/118/123/125/132/134/136/138) is the
*deep Promise.all for Passables* primitive. Single export
`deeplyFulfilled(val)` that recursively replaces every promise
in a Passable's pass-by-copy structure with its fulfillment
value.

## The §deep-form-of-Promise.all thesis

The §JSDoc:

> *Given a Passable `val` whose pass-by-copy structure may
> contain leaf promises, return a promise for a replacement
> Passable, where that replacement is *deeply fulfilled*, i.e.,
> its pass-by-copy structure does not contain any promises.*
>
> *This is a deep form of `Promise.all` specialized for
> Passables. For each encountered promise, replace it with the
> deeply fulfilled form of its fulfillment.*

The §recursive-shape: `deeplyFulfilled` is the fixed point of
*for each promise, await + recurse*. The result is a *Passable
without any embedded promises*.

## The §three-failure-modes

The §JSDoc names three ways the operation can fail to settle in
the expected way:

1. **Reject** — *If any of the promises reject, then the promise
   for the replacement rejects.* Standard Promise.all
   short-circuit behavior.

2. **Never settle** — *If any of the promises never settle, then
   the promise for the replacement never settles.* No timeout;
   the operation waits forever for the slowest promise.

3. **Not-Passable** — *If the replacement would not be Passable,
   i.e., if `val` is not Passable, or if any of the transitive
   promises fulfill to something that is not Passable, then the
   returned promise rejects.* The §reject-on-non-passable-leaf
   discipline catches errors where promises resolve to values
   that *can't* travel through pass-style.

## The single most structurally interesting move — §non-hardened-
promise tolerance at top level

The §opening branches handle two pre-passStyle cases before the
main switch:

```js
if (isAtom(val)) {
  return val;
}
if (isPromise(val)) {
  return E.when(val, nonp => deeplyFulfilled(nonp));
}
const passStyle = passStyleOf(val);
```

The §inline comment names the *non-passable-promise-tolerance*
behavior:

> *if `val` is a promise but not a passable promise, for
> example, because it is not hardened, `isPromise` will return
> true, which is ok here because we unwrap it to its settlement
> and dispense with the promise*

The §discipline: `passStyleOf` *throws* on non-hardened (non-
Passable) promises; `isPromise` does *not*. By checking
`isPromise` *before* `passStyleOf`, the function handles
non-hardened top-level promises gracefully — *we unwrap it to
its settlement and dispense with the promise*.

The §continuation:

> *If `val` is any other non-Passable, the `passStyleOf(val)`
> will throw. So this exemption for non-Passable promises is
> only for the top-level.*

The §exemption-is-top-level-only discipline: a non-hardened
promise *as the input* is tolerated; non-hardened promises
*nested inside* a Passable would fail (because their containing
`copyRecord`/`copyArray`/etc. would fail `passStyleOf`). The
exception is *narrow* and *intentional*.

## The §seven-case switch on passStyle

After the top-level isAtom + isPromise checks, the function
switches on `passStyleOf(val)`:

| passStyle | Action |
|-----------|--------|
| `copyRecord` | Recursively `deeplyFulfilled` each value; `fromEntries(vals.map((c, i) => [names[i], c]))`; harden |
| `copyArray` | Recursively `deeplyFulfilled` each element; `Promise.all(...)`; harden |
| `byteArray` | Pass through unchanged (no recursion needed — bytes are atoms) |
| `tagged` | Recursively `deeplyFulfilled` the payload; `makeTagged(tag, payload)` |
| `remotable` | Pass through unchanged (a remotable is a leaf) |
| `error` | Pass through unchanged (an error is a leaf) |
| `promise` | `E.when(prom, nonp => deeplyFulfilled(nonp))` — recurse into fulfillment |

Three §leaf-styles pass through unchanged: `byteArray`,
`remotable`, `error`. Two §composite-styles recurse into their
parts: `copyRecord` and `copyArray`. One §wrapper-style recurses
into its payload: `tagged`. One §special-style awaits and
recurses: `promise`.

The §isAtom-check at the top *also* handles `byteArray`,
because byteArrays are atoms. The §switch's `byteArray` case
is therefore *almost* dead code — it would only fire if an
implementation distinguished byteArray-pass-style without
making byteArrays atoms. The §defensive-duplication discipline.

## The §key-status-deferred-to-patterns observation

The §JSDoc names the *key-status* question:

> *If `val` or its parts are non-key Passables only *because*
> they contain promises, the deeply fulfilled forms of val or
> its parts may be keys. This is for the higher "@endo/patterns"
> level of abstraction to determine, because it defines the
> `Key` notion in question.*

The §layering-discipline: this file *doesn't* know about Keys
(cycles 102/104/110/115/120/123/125). The result of
`deeplyFulfilled` is a *Passable*; whether that Passable is a
*Key* is determined by the @endo/patterns layer above.

The §observation: a Passable containing a Promise is *not* a
Key (Keys are leaf-free); but its deeply-fulfilled form *might*
be (no more promises, so all leaves are concrete). The
*possibility-of-becoming-a-Key-after-deep-fulfillment* is
what the JSDoc names.

## The §E.when vs await usage

The function uses `E.when(...)` to await promises rather than
plain `await`. The §rationale:

- `await` operates on JavaScript promises only.
- `E.when(...)` operates on JavaScript promises *and* on
  HandledPromises (cycle 66) — including those routed through
  CapTP to remote vats.

The §use-E.when-not-await discipline lets `deeplyFulfilled`
work on *remote* promises (eventual-send promises that haven't
returned to the local vat yet). The §lifted-promise-monad
discipline.

The §`async val =>` declaration: the outer function is `async`
because it always returns a promise; the body uses `E.when`
internally for HandledPromise compatibility.

## The §`@ts-expect-error not assignable to type 'DeeplyAwaited<T>'` markers

Five `@ts-expect-error` markers appear throughout the function,
each tagged *not assignable to type 'DeeplyAwaited<T>'*. The
§TypeScript-limitation acknowledgement:

> *TODO Figure out why we need these at-expect-error directives
> below and fix if possible.
> https://github.com/endojs/endo/issues/1257 may be relevant.*

The §DeeplyAwaited recursive type is hard for TypeScript to
verify; the `@ts-expect-error` markers acknowledge the gap
without resolving it. The §honest-known-limitation discipline.

## The §three-types-copied-from-@agoric/internal TODO

The opening §JSDoc has *three* identical TODOs:

> *Currently copied from @agoric/internal utils.js.*
> *TODO Should migrate here and then, if needed, reexported
> there.*

Applied to three type definitions: `Simplify`, `Callable`,
`DeeplyAwaitedObject`. The §canonical-home-yet-to-be-resolved
discipline: the types are *currently duplicated*; the design
intent is to *move them here* and let agoric/internal re-export
them (the §upside-down-dependency observation that
@endo/pass-style is *more foundational* than
@agoric/internal).

## How this file fits into the pass-style / eventual-send picture

`deeplyFulfilled` is the *bridge* between pass-style's leaf-
oriented validation and eventual-send's promise-routing
mechanics:

- Pass-style says: *a copyRecord must contain only Passables;
  promises are not Passables; deeply-fulfilled forms are
  Passables*.
- Eventual-send says: *promises route through E() to local-
  delivery or remote-CapTP*.

`deeplyFulfilled` *resolves* the embedded promises so the
result is a *fully-Passable structure* ready to cross a
serialization boundary. Without `deeplyFulfilled`, a `marshal()`
call on a structure containing promises would fail; with it, the
caller can *await the deeply-fulfilled form* and then marshal
the result.

## Related sections

- cycle 71
  [[endo--packages-pass-style-src-passstyleof-js--passstyleof-classifier-internals]]
  — the classifier whose result switches the recursion in this
  function. The §`isAtom` + `isPromise` + `passStyleOf` triple
  is the standard pass-style entry pattern.
- cycle 66 (§handler-protocol)
  [[endo--packages-eventual-send-src-handled-promise-js--handler-protocol]]
  — the HandledPromise dispatch this function's `E.when(...)`
  uses for remote promises.
- cycle 138
  [[endo--packages-pass-style-src-safe-promise-js--safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist]]
  — the §`isPromise` from @endo/promise-kit is the same one cycle
  138 uses; this file's §non-hardened-promise tolerance is *not*
  the same as a safe-promise (a non-hardened promise fails
  safe-promise's frozen check; both can pass `isPromise`).
- cycle 134
  [[endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes]]
  — the *remotable* leaf style this function's `case 'remotable'`
  passes through unchanged.
