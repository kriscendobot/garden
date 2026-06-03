---
section: what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
source: endo--packages-pass-style-src-remotable-js
topics: [pass-style, marshal]
status: current
---

# What a remotable is — tag-record inheritance + distinct object-vs-function shapes

> *For a function to be a valid method, it must not be passable.
> Otherwise, we risk confusing pass-by-copy data carrying far
> functions with attempts at far objects with methods.*
>
> — `packages/pass-style/src/remotable.js` §canBeMethod JSDoc

`remotable.js` (305 lines, Kris Kowal-last-touched 2026-02-24 in
commit `e56bf00f` — same coordinated-update wave as cycles 108,
110, 115, 118, 123, 125, 132) is the *what-counts-as-a-remotable*
predicate layer. The file exports the `RemotableHelper`
PassStyleHelper (cycle 71's `passStyleOf.js` dispatches to this
for `pass-style === 'remotable'` values), plus four public
predicates: `canBeMethod`, `getRemotableMethodNames`,
`assertIface`, `getInterfaceOf`.

## The §canBeMethod = function-not-passable invariant

The §opening predicate defines the *function-not-passable*
distinction:

```js
export const canBeMethod = func =>
  typeof func === 'function' && !(PASS_STYLE in func);
```

A method must be a *function without the PASS_STYLE marker*. If
the function carries PASS_STYLE, it's already a *Far function* —
itself a remotable, not a method on another remotable. The
§rationale:

> *we risk confusing pass-by-copy data carrying far functions with
> attempts at far objects with methods.*

The discipline: methods are *inert function values* that live
*on* a remotable; Far functions are *remotables themselves*. The
two cannot coexist on the same object — a Far function cannot
have methods, and an object's properties cannot be Far functions.

## The §TODO HAZARD note — *we cannot yet check that func is hardened*

The §JSDoc carries an honest hazard acknowledgement:

> *TODO HAZARD Because we check this on the way to hardening a
> remotable, we cannot yet check that `func` is hardened. However,
> without doing so, its inheritance might change after the
> PASS_STYLE check below.*

The §timing-hazard: `canBeMethod` is called *during* the harden
process; the function may not yet be hardened, so its prototype
chain may still mutate after the PASS_STYLE check. The discipline
acknowledges the gap *without resolving it* — a deliberate
*known-limitation-marker*.

## The §canBeMethodName — strings, symbols, *and numbers*

The §predicate accepts three key types:

```js
const canBeMethodName = key =>
  typeof key === 'string' || typeof key === 'symbol' || typeof key === 'number';
```

The §commented-out-stricter-line `// typeof key === 'string' ||
typeof key === 'symbol';` is the *narrower* version this design
was considering. The current implementation also accepts numbers;
the §TODO links to issue #2884:

> *TODO https://github.com/endojs/endo/issues/2884*
> *Abstract out canBeMethodName so later PRs agree on method name
> restrictions.*

The §number-as-method-name allowance is open: the predicate
admits it now; a future PR will tighten or formalize.

## The §getRemotableMethodNames is currently just an alias

The §`getRemotableMethodNames` re-exports cycle 132's
`getMethodNames` from `@endo/eventual-send/utils.js`:

```js
export const getRemotableMethodNames = behaviorMethods =>
  getMethodNames(behaviorMethods);
```

The §JSDoc names the *abstraction-for-a-future-PR* rationale:

> *Currently, just alias `getMethodNames` but this abstraction
> exists so a future PR can enforce restrictions on method names
> of remotables.*

The §abstraction-anticipating-restriction discipline: today the
two notions coincide; the indirection layer lets one diverge
later without breaking callers.

Cycle 132's `getMethodNames` is in `@endo/eventual-send` at *the
eventual-send level of abstraction that does not know anything
about remotables*. This file's `getRemotableMethodNames` is the
*remotable-aware* surface. The §layering-stepwise discipline:
eventual-send doesn't know about remotables, pass-style doesn't
know about eventual-send dispatch — they compose at the
introspection-helper boundary.

## The §confirmIface interface-spec discipline

```js
const confirmIface = (iface, reject) => {
  return (
    (typeof iface === 'string' || ...) &&
    (iface === 'Remotable' ||
      iface.startsWith('Alleged: ') ||
      iface.startsWith('DebugName: ') || ...)
  );
};
```

The §interface-spec is one of:

- `'Remotable'` (the literal default tag)
- `'Alleged: '` + something
- `'DebugName: '` + something

This is the §source-of-truth for the prefix conventions cycle
130's `message-breakpoints.js` `simplifyTag` strips. The §pair
discipline: this file *requires* the prefixes; cycle 130 *strips*
them for matching. Together they form a *prefix-required-when-
producing / prefix-stripped-when-matching* convention.

The §future-third-party-veracity TODO names the design horizon:

> *TODO other possible ifaces, once we have third party veracity*

Eventually the interface spec could be a richer pass-by-copy
structure, but *for now must be a string*. The §iface-must-be-pure
JSDoc:

> *An `iface` must be pure. Right now it must be a string, which is
> pure. Later we expect to include some other values that qualify
> as `PureData`, which is a pass-by-copy superstructure ending
> only in primitives or empty pass-by-copy composites. No
> remotables, promises, or errors.*

The §PureData precondition: an iface must be *self-describing* —
it cannot contain references to other capabilities or pending
state. The current string restriction is a *conservative subset*
of PureData.

## The §confirmRemotableProtoOf recursive tag-record walk

The §`confirmRemotableProtoOf(original, reject)` function is the
*structurally-most-interesting* piece. The remotable's prototype
chain must end in a *tag record* — a plain-object prototype
consisting of *only* a `PASS_STYLE` property with value
`'remotable'` and a suitable `Symbol.toStringTag` property.

The §recursive walk:

```js
const proto = getPrototypeOf(original);
if (proto === objectPrototype || proto === null || proto === Function.prototype) {
  return reject && reject`Remotables must be explicitly declared: ${q(original)}`;
}

if (typeof original === 'object') {
  const protoProto = getPrototypeOf(proto);
  if (protoProto !== objectPrototype && protoProto !== null) {
    return confirmRemotable(proto, reject);  // recursive
  }
  if (!confirmTagRecord(proto, 'remotable', reject)) {
    return false;
  }
} ...
```

The §two-cases:

1. **Direct tag-record parent** — the proto is the tag record;
   confirmTagRecord checks it.
2. **Inherited remotable parent** — the proto is itself a
   remotable; recursively confirm it.

The §remotables-can-inherit-from-other-remotables discipline:
*the remotable could inherit directly from such a tag record, or
it could inherit from another valid remotable, that therefore
itself inherits directly or indirectly from such a tag record*.

The §never-direct-inheritance-from-Object.prototype invariant:
*Remotables must be explicitly declared*. If the proto is
`objectPrototype`, `null`, or `Function.prototype`, the remotable
isn't explicitly declared — reject. The check forces *intentional
remotability* — accidentally-passable objects are caught.

## The §confirmedRemotables WeakSet cache

The §memoization:

```js
const confirmedRemotables = new WeakSet();

const confirmRemotable = (val, reject) => {
  if (confirmedRemotables.has(val)) {
    return true;
  }
  // ... check ...
  if (result) {
    confirmedRemotables.add(val);
  }
  return result;
};
```

The §cache-positive-not-negative discipline:

> *We don't remember rejections because they are possible to
> correct with e.g. `harden`.*

A non-frozen object would fail today; after the caller hardens
it, the same object passes. So *no false negatives via cache* —
only positives are cached. The §discipline-anticipates-mutation:
the cache is *forward-only* — once true, always true (because the
checks are about frozen-ness + structure, both of which are
permanent once set); rejections are *not* cached because they're
about *the value at this moment*.

The *use of WeakSet* lets the cache GC entries when the remotable
itself is collected — *no leak*.

## The §getInterfaceOf — public introspection with overloaded type

The §public introspection function:

```js
export const getInterfaceOf = val => {
  if (
    isPrimitive(val) ||
    val[PASS_STYLE] !== 'remotable' ||
    !confirmRemotable(val, false)
  ) {
    return undefined;
  }
  return getTag(val);
};
```

The §TypeScript-overload typedef:

```ts
{
  <T extends string>(val: PassStyled<any, T>): T;
  (val: any): InterfaceSpec | undefined;
}
```

The §two-signatures: given a `PassStyled<any, T>` value, return
the *narrowed-to-T* tag string; given anything else, return
`InterfaceSpec | undefined`. The discipline lets typed callers
recover the *literal interface tag* from a `PassStyled<any, 'Foo'>`
without an explicit cast.

## The §RemotableHelper — distinct object-vs-function shapes

The §exported `RemotableHelper` is the PassStyleHelper that
cycle 71's `passStyleOf.js` dispatches to for
`pass-style === 'remotable'`. The interesting structure is
`confirmCanBeValid`: it branches on `typeof candidate`:

- **`'object'`**: *every own property (regardless of
  enumerability) must have a function value*. No accessors
  (*cannot serialize Remotables with accessors like X*). No
  non-method properties (*cannot serialize Remotables with
  non-methods like X*). No PASS_STYLE shadowing (*A pass-by-remote
  cannot shadow PASS_STYLE*). The `@@toStringTag` is exempt
  (validated via `confirmIface`).

- **`'function'`** (Far functions): *Far functions cannot be
  methods, and cannot have methods*. The function must have *only*
  `.name` (string), `.length` (number), and optionally
  `@@toStringTag` (string via `confirmIface`). The §`...restDescs`
  destructure followed by `restKeys.length === 0` check enforces
  *exactly these three* properties — *Far functions unexpected
  properties besides .name and .length*.

The §two-distinct-shapes discipline is the design's central
asymmetry:

- **Object remotables**: a *bag of methods* + `@@toStringTag`.
  Methods don't carry PASS_STYLE (per `canBeMethod`); the object
  itself does.
- **Function remotables (Far functions)**: a *single callable* +
  metadata. No methods can hang off it; *Far functions cannot
  have methods*.

The §Far-functions-cannot-be-methods-and-cannot-have-methods
discipline rules out the recursive case (a Far function with
methods that are themselves Far functions). The two shapes are
*mutually exclusive* — an object remotable is *not* a callable;
a Far function is *not* a bag of properties.

## The §every: always-true short-circuit

The PassStyleHelper interface (cycle 71's framework) requires an
`every(passable, fn)` method that iterates the passable's
internal structure. Remotables have no internal pass-style
structure — they're *leaves* in the pass-style tree. So:

```js
every: (_passable, _fn) => true,
```

The §leaf-no-iteration discipline. Remotables are opaque from
pass-style's perspective; their internal state is *not* enumerated
or recursed into.

## How this file integrates the cycle 132 + cycle 130 + cycle 71 layers

The file connects *three previously-ingested layers*:

- **cycle 71** (`passStyleOf.js`) dispatches to this file's
  `RemotableHelper.confirmCanBeValid` for any value with
  `PASS_STYLE === 'remotable'`.
- **cycle 132** (`local.js`) provides `getMethodNames`; this file
  re-exports as `getRemotableMethodNames`.
- **cycle 130** (`message-breakpoints.js`) strips the
  `'Alleged: '` / `'DebugName: '` prefixes this file *requires*.

Together they form the *what-a-remotable-is + how-to-discover-its-
methods + how-to-name-them-for-debugging* triple. Each layer is
clean of the others; the composition is at the boundary.

## Related sections

- cycle 71
  [[endo--packages-pass-style-src-passstyleof-js--passstyleof-classifier-internals]]
  — the dispatcher that calls `RemotableHelper.confirmCanBeValid`
  for remotables.
- cycle 132
  [[endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection]]
  — the source of `getMethodNames` this file re-exports as
  `getRemotableMethodNames`. The *abstraction-anticipating-
  restriction* discipline lets the two notions diverge later.
- cycle 130
  [[endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics]]
  — `simplifyTag` strips the `'Alleged: '` / `'DebugName: '`
  prefixes this file requires.
- cycle 108
  [[endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio]]
  — the `Far(tag, prototype)` call site that produces tag-record-
  rooted remotables this file confirms.
