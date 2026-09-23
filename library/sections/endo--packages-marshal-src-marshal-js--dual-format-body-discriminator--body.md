---
title: Body
source: packages/marshal/src/marshal.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/marshal.js
source_line_range: "47-60, 219-227, 387-409"
source_commit: da16a78e177904e08bd4603527fef98d68af2bbd
comment_subject: "Why marshal uses '#' as the JSON-illegal first-byte sentinel to discriminate smallcaps from capdata in a single decoder, and the historical reason capdata remains the default serializeBodyFormat"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, captp, ocapn]
status: current
parent: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator
---

### `#` as the JSON-illegal sentinel

The encoder side of the dual-format boundary (the smallcaps branch
of `toCapData`):

```js
const encoded = encodeToSmallcaps(root);
const smallcapsBody = JSON.stringify(encoded);
return harden({
  // Valid JSON cannot begin with a '#', so this is a valid signal
  // indicating smallcaps format.
  body: `#${smallcapsBody}`,
  slots,
});
```

The decoder side (`fromCapData`):

```js
let result;
// JSON cannot begin with a '#', so this is an unambiguous signal.
if (body.charAt(0) === '#') {
  const smallcapsBody = body.slice(1);
  const encoding = harden(JSON.parse(smallcapsBody));
  result = harden(reviveFromSmallcaps(encoding));
} else {
  const rawTree = harden(JSON.parse(body));
  result = harden(reviveFromCapData(rawTree));
}
```

The encoder produces `#` + valid-JSON; the decoder strips `#` and
treats the rest as smallcaps, or treats the unprefixed body as
capdata. The discrimination is **decided by the encoder**, not
negotiated between peers: the encoder calling `toCapData` picks the
format based on its `serializeBodyFormat` option and signals it
on the wire. The decoder reads the signal and routes; the peer
does not need to know in advance which format it will receive.

Three properties of `#` make it the right sentinel:

1. **It is illegal as the first byte of valid JSON.** Valid JSON
   starts with `{`, `[`, `"`, `-`, a digit, `t`, `f`, or `n` (the
   first letters of `true`, `false`, `null`). The character class
   that *cannot* start valid JSON is large; `#` is one member of it.
2. **It is a single byte, so the decoder's branch is `charAt(0)`,
   not a startsWith-with-tag-prefix.** A multi-byte tag (e.g.,
   `"SMALLCAPS:"`) would work but would cost bytes on every wire
   send. `#` is the cheapest discriminator.
3. **It is already meaningful inside smallcaps as a sigil.** The
   smallcaps prefix scheme uses `#` for *manifest constants*
   (`#undefined`, `#NaN`, `#Infinity`) and as the property-name
   prefix for tag fields (`#tag`, `#error`). The body-leading `#`
   "rhymes" with this internal usage: a smallcaps body always
   starts with `#` (the discriminator), and inside the body, `#`
   keeps showing up at sigil positions. This is incidental rather
   than load-bearing, but it avoids the awkwardness of picking a
   sentinel that's never used inside the encoding.

The
[special-character-prefix-scheme](endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme.md)
section documents the contiguous BANG-to-DASH reserved range that
smallcaps uses internally; the body-prefix `#` is *outside* that
range (the body wraps the JSON, not a smallcaps string-position
value).

### Why a JSON-illegal sentinel rather than a JSON wrapper

A valid JSON wrapper like `{"format": "smallcaps", "data": ...}`
would also work as a discriminator. The chosen approach (raw `#` +
inner JSON) saves bytes on every wire send and avoids a double
JSON.parse: the receiver does one `JSON.parse` on either path
rather than parsing a wrapper to discover the format. The `slice(1)`
on the smallcaps branch is cheaper than wrapping/unwrapping a JSON
header. For a high-throughput message-passing system the savings
add up.

The cost is that the wire body is *not* valid JSON when smallcaps
is used. Tooling that assumes the body field of a capdata-shaped
message is JSON-parseable as-is will fail on smallcaps bodies. The
discipline is: the `body` field of a `{body, slots}` capdata
envelope is **either** valid JSON **or** a `#`-prefixed valid JSON.
Consumers that hand the body to a non-marshal JSON parser have to
strip the leading `#` first. In practice this means consumers run
through marshal's `fromCapData`, not through a generic JSON
toolchain, which is the intended discipline anyway: marshal does
hardened-JS guarantees the generic toolchain does not.

### "Ontogeny does recapitulate phylogeny ;)"

The `serializeBodyFormat` default is set in the
`MakeMarshalOptions` destructuring at the top of `makeMarshal`:

```js
// Default to 'capdata' because it was implemented first.
// Sometimes, ontogeny does recapitulate phylogeny ;)
serializeBodyFormat = 'capdata',
```

The capdata format was marshal's first wire format; smallcaps
landed later as a more compact, more readable successor. The
*natural* migration path would be to flip the default to
`'smallcaps'` once smallcaps was stable, but the comment marks
that the default *intentionally* still favors the older format.
Two reasons sit behind the choice:

1. **Backward compatibility for legacy callers.** A caller that
   uses the default `makeMarshal()` and relies on capdata wire
   shape (its peer reads capdata, or its tooling assumes capdata)
   would break if the default flipped. The marshal package is
   downstream of many consumers (agoric-sdk, captp); changing the
   default at any point is a coordination problem with all of
   them.
2. **The hen-and-egg cost is asymmetric.** New callers can pass
   `serializeBodyFormat: 'smallcaps'` explicitly and get the
   better behavior; old callers cannot get the same one-line
   override (they'd have to also update their decoder side and
   any test fixtures). Defaulting to the older format imposes a
   small opt-in cost on new callers and zero cost on old ones;
   defaulting to the newer format would impose a small opt-out
   cost on every existing caller and zero on new ones, but the
   set of existing callers is much larger than the set of new
   callers.

The "ontogeny does recapitulate phylogeny" wink is a tongue-in-
cheek reference to Haeckel's biological recapitulation theory:
each new marshal instance, by defaulting to the format that
marshal historically implemented first, "develops" through
marshal's own evolutionary history before its caller has the
chance to override. The joke is also a self-aware acknowledgment
that the default is *not* the technically preferred format; the
preferred format is smallcaps. The wink concedes the historical
inertia.

### How the dual-format coexistence is built

`makeFullRevive` is constructed once per `fromCapData` call:

```js
const makeFullRevive = slots => {
  // ... decodeSlotCommon, decodeErrorCommon
  const reviveFromCapData = makeDecodeFromCapData({ ... });
  // ...
  const reviveFromSmallcaps = makeDecodeFromSmallcaps({ ... });
  return harden({ reviveFromCapData, reviveFromSmallcaps });
};
```

Both deciders are always built, and `fromCapData` picks one per
call based on the body discriminator. This is cheap because the
factory functions just close over the shared `slots` and the
shared `decodeSlotCommon` / `decodeErrorCommon` helpers; the
per-call cost is the construction of two closure pairs, not the
re-parsing of a wire format.

The encoder side is the asymmetric branch: `toCapData` *picks one*
based on `serializeBodyFormat` and only invokes the corresponding
encoder factory. Encoders are not pre-built in `makeFullRevive`'s
shape; they're built fresh inside `toCapData` because the encoders
need closure access to `slotMap` (a per-encoding-call map from
passable to slot index), which can't be shared across calls.

The asymmetry is intentional: a `makeMarshal` instance encodes
in *one* format (the option-selected one), but decodes in either
(whatever the peer sent). A single marshal instance can
interoperate with peers that use different formats, as long as
those peers can decode whichever format the local marshal emits.

### Practical migration implications

For a deployment migrating from capdata to smallcaps:

1. **Decoders first.** Every peer must update to a marshal that
   decodes both formats. This is automatic for marshal versions
   that include the `'#'` discriminator (essentially every modern
   version).
2. **Encoders second, per-call.** Application code that calls
   `makeMarshal` can begin passing
   `serializeBodyFormat: 'smallcaps'` opt-in, instance by instance.
3. **Default flip never (per the current comment).** The default
   stays `'capdata'` until the maintainer community agrees the
   migration is complete; there is no deadline.

The migration discipline is one-way: a peer that decodes both can
talk to a peer that emits either, but a peer that decodes only one
constrains the encoder choice. The conservative default
(`'capdata'`) is the format the largest installed-decoder base can
read.

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L47-L409) at commit `da16a78e`.
