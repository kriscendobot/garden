---
section: JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
source: endo--packages-marshal-src-marshal-stringify-js
topics: [marshal, pass-style, hardened-javascript]
status: current
title: The §refuse-converter-as-explicit-config discipline
parent: endo--packages-marshal-src-marshal-stringify-js--JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
---

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
