---
section: JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
source: endo--packages-marshal-src-marshal-stringify-js
topics: [marshal, pass-style, hardened-javascript]
status: current
---

# JSON-equivalent for Passable pure-data via `badArray` Proxy that traps on slot access

> *Marshal's stringify rejects presences and promises [val].
> Marshal's parse must not encode any slots [slot].
> Marshal's parse must not encode any slot positions [name].*
>
> — `packages/marshal/src/marshal-stringify.js` lines 11, 15, 23

`marshal-stringify.js` (69 lines) is the **§JSON-equivalent-
for-pure-data-Passable surface**. Exports `stringify` and
`parse` — symmetric to `JSON.stringify` and `JSON.parse` but
operating on *Passable* values (cycle 71's pass-style
classification) rather than on raw JSON-compatible values.

Last touched 2025-10-09 by Kris Kowal in cycle 108's
coordinated-update commit `e56bf00f` (@endo/harden migration).
Cycle 160 is a **milestone tick**: 25 cycles of design+comment
alternation since the daemon-observability-pair landed at
cycle 145+147, with §runtime-introspection-trio completed by
cycle 159.

## The §load-bearing-restriction — §pure-data-version-of-marshal

The whole file is the §pure-data-no-slots projection of
`@endo/marshal`. The marshal package's full surface
(`makeMarshal`) supports *slot-bearing* serialization —
remotables and promises get wire-encoded as slot indices that
the receiver's marshal table dereferences.

`marshal-stringify.js` takes that machinery and *strips it
down* to the no-slots case. The result behaves like
`JSON.stringify`/`JSON.parse` but with the @endo passability
discipline:

- **Accepts**: undefined, null, booleans, numbers, bigints,
  strings, copyArrays, copyRecords, byteArrays, errors (per
  cycle 87 + cycle 144's errorTagging-off mode), tagged
  values (copySet/copyBag/copyMap).
- **Rejects**: remotables, promises, slot-references.

The §JSON-but-Passable distinction: JSON can't encode
bigints or byteArrays; smallcaps (cycle 69) can. JSON has no
copySet/copyBag/copyMap concept; pass-style does. The file
*reuses marshal's encoder* to gain those affordances, then
*forbids* the slot mechanism that JSON also lacks.

## The §single most structurally interesting move — §badArray-Proxy-traps-on-slot-access

The `parse` function passes a *proxy that pretends to be an
empty array* as the `slots` argument to `unserialize`:

```js
const badArrayHandler = harden({
  get: (_target, name, _receiver) => {
    if (name === 'length') {
      return 0;
    }
    throw Fail`Marshal's parse must not encode any slot positions ${name}`;
  },
});

const arrayTarget = freeze([]);
const badArray = new Proxy(arrayTarget, badArrayHandler);
```

The §badArray-Proxy-traps-on-slot-access discipline. Why a
proxy instead of just passing `[]`?

- **`unserialize({ body, slots: [] })`** would *silently
  accept* slot-bearing input — the decoder would look up
  `slots[42]`, get `undefined`, and produce a value with an
  undefined-where-a-remotable-belongs (a confusing later
  error).
- **`unserialize({ body, slots: badArray })`** *immediately
  errors* with `Marshal's parse must not encode any slot
  positions 42` — pointing at the *actual* offending input
  position.

The §loud-failure-when-input-violates-contract discipline:
the proxy converts a *silent type confusion* into a
*specific, actionable error message*.

The §length-returns-zero-everything-else-throws shape:
marshal's decoder may call `slots.length` (legitimate; should
return 0); any other property access *must be* a slot lookup
(numeric index or `0`/`1`/`2`/...) — none of which should
happen on slot-free input.

## The §refuse-converter-as-explicit-config discipline

The factory call:

```js
const { serialize, unserialize } = makeMarshal(
  doNotConvertValToSlot,
  doNotConvertSlotToVal,
  { errorTagging: 'off', serializeBodyFormat: 'capdata' },
);
```

Both converters are *deliberately-failing functions*:

```js
const doNotConvertValToSlot = val =>
  Fail`Marshal's stringify rejects presences and promises ${val}`;

const doNotConvertSlotToVal = (slot, _iface) =>
  Fail`Marshal's parse must not encode any slots ${slot}`;
```

The §refuse-converter-as-explicit-config discipline: instead
of `null`/`undefined` or a "you'll find out at use site"
failure, the converters are *explicit* refusals with *clear*
messages. The errors fire *exactly when* a remotable / promise
appears in input.

The §three-layered-defense observation:

1. **Encode side**: `doNotConvertValToSlot` fires when a
   remotable / promise is *encountered during encoding*.
2. **Decode side**: `doNotConvertSlotToVal` fires when a slot
   reference is *seen in the body string*.
3. **Decode-array-access side**: `badArray` fires if marshal
   even *attempts* to read `slots[n]`.

Three distinct failure modes, each with its own message. The
§each-layer-has-its-own-error-message discipline: the user
can tell from the message *where* the violation was caught.

## The §freeze-but-not-harden-the-target discipline

```js
const arrayTarget = freeze([]);
const badArray = new Proxy(arrayTarget, badArrayHandler);
```

The §stabilize-discipline carries over from cycle 146
(eventual-send/src/E.js) and cycle 154 (captp/src/trap.js):

> *`freeze` but not `harden` the proxy target so it remains
> trapping. Thus, it should not be shared outside this module.*

The §verbatim-comment-shared-across-derived-files pattern
(named in cycle 154): the same JSDoc word-for-word appears in
three @endo files — cycle 146 / cycle 154 / this file. All
three cite the same `preparing-for-stabilize.md` rationale.

The §trapping-proxy-needs-non-hardened-target invariant: a
hardened target may trigger V8 Proxy short-circuits that
bypass meta-traps. The badArray's *entire job* is to trap on
every access; a hardened target would defeat its purpose.

## The §stringify-discards-the-empty-slots-array

```js
const stringify = val => serialize(val).body;
```

The marshal `serialize` returns `{ body: string, slots: [] }`.
For slot-free input, `slots` is *always* `[]`. The
§discard-the-empty-slots-array idiom: `stringify` returns
*just the body string*, which is `parse`'s expected input
format.

The §symmetric-API-via-asymmetric-bodies observation:

- **stringify**: input is Passable; output is string.
- **parse**: input is string; output is Passable.

The asymmetry is in the *intermediate*: serialize produces
`{body, slots}`; we throw away the slots. Parse needs `{body,
slots}` to call unserialize; we synthesize the empty (but
trap-on-access) slots envelope.

## The §parse-passes-freeze-with-badArray-slots discipline

```js
const parse = str =>
  unserialize(
    freeze({
      body: str,
      slots: badArray,
    }),
  );
```

The §freeze-the-envelope: the `{body, slots}` capdata object
passed to `unserialize` is *frozen*. Why? `unserialize`
*shouldn't* mutate it, but freezing makes that *impossible*
even if a future bug or attack tries.

The §inline-comment-cites-stabilize-md: the file *again*
cites the preparing-for-stabilize.md doc — the third instance
of the same citation in this file. The §triple-stabilize-
citation across `arrayTarget` + `badArray` discussion + this
inline `freeze`-but-not-`harden` comment.

The §every-mention-cites-the-rationale discipline: the
author *anticipates* that future readers will ask "why
`freeze` and not `harden`?" at each occurrence; the answer is
*inlined at every occurrence*.

## The §capdata-not-smallcaps with §TODO-pin

```js
serializeBodyFormat: 'capdata',
// TODO fix tests to works with smallcaps.
```

The §legacy-format-pinned-with-TODO discipline. Cycle 69's
smallcaps is the *newer* body format; cycle 74 (marshal.js)
documents the *capdata vs smallcaps* dual-format. This file
*pins to capdata* because tests rely on the older string
format.

The §upgrade-blocked-on-test-rewrite observation: the
substantive blocker is *test brittleness* on string-literal
expectations — the smallcaps body format produces different
strings for the same input. Migrating means rewriting tests
that string-literally match expected bodies.

The §honest-TODO-not-silent-pin discipline: the choice is
*visible* in the source with a comment that names the
upgrade-blocker.

## The §errorTagging-off configuration

```js
{ errorTagging: 'off', ... }
```

The §errorTagging-off mode is the §no-error-correlation-id
configuration. Cycle 74's marshal.js documents the
errorTagging discipline — *errorIdNum* for cross-side
diagnostic correlation. This file *turns it off*.

Why? Because the §pure-data-version-of-marshal use case is
*round-trip identity*. The stringify-then-parse cycle should
yield *the same logical value*, not *a logically-equivalent
value with a new error-correlation tag*. Cycle 74's
errorTagging exists to correlate errors *across CapTP*; here
there's no CapTP.

## The §throw-is-noop-since-Fail-throws linter comment

```js
get: (_target, name, _receiver) => {
  if (name === 'length') {
    return 0;
  }
  // `throw` is noop since `Fail` throws. But linter confused
  throw Fail`Marshal's parse must not encode any slot positions ${name}`;
},
```

The §linter-noise-as-documentation pattern: `throw` is
*technically* a no-op because `Fail\`...\`` already throws.
But ESLint's flow analysis doesn't model `Fail` as
non-returning; the explicit `throw` *appeases the linter*.

The §comment-explains-the-extra-`throw` discipline: future
readers reading the code will see *both* `Fail` and `throw`;
the comment explains that one is for the *user* and one is
for the *linter*.

## How this file fits the @endo/marshal cluster

The marshal cluster grows:

| File | Ingest cycle | Role |
|------|--------------|------|
| `marshal.js` | cycle 74 | makeMarshal factory |
| `encodeToSmallcaps.js` | cycle 69 | newer body encoder |
| `encodePassable.js` | cycle 81 | rank-order encoder |
| `rankOrder.js` | cycle 84-85 | in-memory rank-order |
| `dot-membrane.js` | cycle 144 | full membrane via marshal |
| **`marshal-stringify.js`** | **cycle 160 (this)** | pure-data JSON-equivalent |

Six @endo/marshal source files now ingested. The §pure-data-
version-of-marshal projection sits *one layer above*
`marshal.js` — uses `makeMarshal` but with deliberately-
restricted configurations.

The §three-faces-of-marshal observation:

- **Full marshal** (cycle 74) — slot-bearing CapTP wire
  format.
- **Membrane marshal** (cycle 144) — slot-bearing but in-
  process across membrane boundary.
- **Stringify marshal** (this) — slot-rejecting pure-data
  JSON-equivalent.

The §same-substrate-three-API-faces discipline: one
`makeMarshal` factory, three quite different end-user APIs
selected by configuration + wrapping.

## Related sections

- cycle 74
  [[endo--packages-marshal-src-marshal-js--makeMarshal-constructor-rationale]]
  — the `makeMarshal` factory this file calls.
- cycle 69
  [[endo--packages-marshal-src-encodetosmallcaps-js--smallcaps-wire-format-rationale]]
  — the smallcaps format this file *pins away from* (with
  TODO).
- cycle 144
  [[endo--packages-marshal-src-dot-membrane-js--membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap]]
  — the sibling "marshal twice" idiom for the membrane case.
  Together with this file, they show *both* directions of
  configuring `makeMarshal`: this file *removes* slot
  handling; dot-membrane.js *adds* the mirror-pair-of-
  marshals shape.
- cycle 146
  [[endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets]]
  — sister §freeze-but-not-harden discipline with §verbatim-
  comment-shared-across-derived-files.
- cycle 154
  [[endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check]]
  — third file in the §triple-stabilize-citation cluster.
