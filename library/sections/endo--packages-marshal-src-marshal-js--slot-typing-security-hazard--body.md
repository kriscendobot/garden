---
title: Body
source: packages/marshal/src/marshal.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/marshal.js
source_line_range: "238-256, 322-336"
source_commit: da16a78e177904e08bd4603527fef98d68af2bbd
comment_subject: "TODO SECURITY HAZARD on decodeSlotCommon (remotable-vs-promise) and the matched implementation restriction on the capdata branch (#4334)"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, capability-security, captp]
status: current
parent: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard
---

### TODO SECURITY HAZARD on `decodeSlotCommon`

Inside `makeFullRevive`'s `decodeSlotCommon`, after the value-map
hit check and before the `convertSlotToVal` call:

```js
// TODO SECURITY HAZARD: must enfoce that remotable vs promise
// is according to the encoded string.
const slot = slots[Number(Nat(index))];
const val = convertSlotToVal(slot, iface);
```

The comment is short but load-bearing. The `decodeSlotCommon`
function is called from both the smallcaps `decodeRemotableFromSmallcaps`
(`makeDecodeSlotFromSmallcaps('$')`) and `decodePromiseFromSmallcaps`
(`makeDecodeSlotFromSmallcaps('&')`) paths. The decode-helper
prefix-matches the first byte against the expected prefix, but the
subsequent `decodeSlotCommon` *does not check* whether
`convertSlotToVal` returns a remotable or a promise. The
application-supplied `convertSlotToVal` decides based on its
internal mapping from slot-key to value; that mapping might
disagree with the prefix the peer sent. The hazard is: a peer that
sends a `$` (remotable) prefix for a slot the local side knows as a
promise would deliver a Promise where the local code expects a
Remotable, and the decode would not catch it.

The `Nat(index)` coercion at the next line is *not* the missing
check — `Nat` only validates that the index is a non-negative
integer; it does not validate the slot's kind. The TODO is
acknowledging that the kind information is in the encoded prefix
but is not currently used to validate the decoded value.

The hazard's exploitability depends on the application's
`convertSlotToVal`: an application that uses one slot-key for one
remotable and never aliases it to a promise is safe; an
application that ever returns different value kinds for different
prefixes from the same key is at risk. Marshal does not enforce
this; it relies on the application.

### Implementation restriction on the capdata branch

The capdata branch of `makeFullRevive` carries the matching
comment above `decodeRemotableOrPromiseFromCapData`:

```js
// The current encoding does not give the decoder enough into to
// distinguish whether a slot represents a promise or a remotable.
// As an implementation restriction until this is fixed, if either
// is provided, both must be provided and they must be the same.
// See https://github.com/Agoric/agoric-sdk/issues/4334
const decodeRemotableOrPromiseFromCapData = (rawTree, _decodeRecur) => {
  const { [QCLASS]: _, ...slotData } = rawTree;
  return decodeSlotCommon(slotData);
};
```

(The typo "into" appears in the source comment as well; it reads
"enough info to distinguish".) The
`decodeRemotableOrPromiseFromCapData` function is used as both
`decodeRemotableFromCapData` and `decodePromiseFromCapData` when
the `makeDecodeFromCapData` factory is called:

```js
const reviveFromCapData = makeDecodeFromCapData({
  decodeRemotableFromCapData: decodeRemotableOrPromiseFromCapData,
  decodePromiseFromCapData: decodeRemotableOrPromiseFromCapData,
  decodeErrorFromCapData,
});
```

This is the **implementation restriction** the comment names:
both decoder slots receive the *same* function. The application
that supplies `convertSlotToVal` is the one that returns a
remotable or a promise based on its own slot-table; marshal does
not differentiate at the wire layer. The result is that capdata's
old-form `{[QCLASS]: 'slot', index}` encoding does not need to
distinguish at decode time, *because* the decoder treats both
identically.

The agoric-sdk#4334 link is to the open issue where this is
tracked. The comment treats the restriction as temporary ("until
this is fixed"); the long-term answer is wire-level type tagging
of slots, which would require a backward-compatible encoding
extension on both sides.

### Why smallcaps escapes the restriction (mostly)

Smallcaps' encoding *does* tag the slot kind at the wire prefix:
`$` for remotable, `&` for promise. So smallcaps has more
information available at decode time than capdata. The
`makeDecodeSlotFromSmallcaps('$')` and `makeDecodeSlotFromSmallcaps('&')`
factories produce two different decoder functions, and each calls
`decodeSlotCommon` *after* validating the prefix matches the
expected sigil. So smallcaps does discriminate at the prefix layer.

But `decodeSlotCommon` itself, which both prefixed-decoders call,
still doesn't propagate the prefix into the `convertSlotToVal`
call — it passes the slot-key and the optional iface, but not the
kind. So the application's `convertSlotToVal` still has to make
its own kind decision. The smallcaps decode catches a *wrong
prefix* (a smallcaps-encoded slot that uses `$` where the encoder
should have used `&`); it does not catch a *correct prefix paired
with an application-side kind mismatch*.

The capdata case is strictly weaker (no prefix discrimination at
all); the smallcaps case is partially better (prefix discrimination
but the kind doesn't reach `convertSlotToVal`). Both are reasons
the `decodeSlotCommon` TODO stays open.

### The defense the application owns

`convertSlotToVal` is the chokepoint. The application supplies it
when it calls `makeMarshal(convertValToSlot, convertSlotToVal,
options)`. The discipline the implementation-restriction comment
names is:

> if either is provided, both must be provided and they must be
> the same.

This translates to: the application supplies *one* `convertSlotToVal`
function that handles both remotable and promise slots, deciding
based on whatever local table it maintains. The application's
slot-table is the trusted record of which slot-keys are remotables
and which are promises; the wire encoding doesn't carry the kind,
the application does.

In CapTP and adjacent protocols where marshal is used, the
application's slot-table is populated by the *outbound* side at
encode time: when `convertValToSlot` is called on a remotable, the
local side assigns a slot-key and remembers the kind. On the
inbound side, `convertSlotToVal` consults the same table and
returns a remotable. The table is the source of truth; the wire is
a reference into it. The TODO is about the inbound side not being
*able* to validate the wire's kind hint against the table, not
about the inbound side being unable to decide.

### Why this matters for protocol hardening

Three implications for the system architect:

1. **A marshal instance must trust its own slot-table.** The
   slot-table is per-marshal-instance (the closure created by
   `makeMarshal`); two marshal instances do not share slot-tables.
   The implementation restriction holds within an instance.
2. **A network peer's kind hint is *advisory* on capdata, *checked
   to match the prefix* on smallcaps, but neither path checks
   *against the local slot-table's recorded kind*.** A peer that
   sends a `$` prefix for a slot the local side knows as a promise
   would, under smallcaps, produce a Promise the local side hands
   to code expecting a Remotable (and vice versa). The
   ConvertSlotToVal supplier is the place to add table-vs-prefix
   validation if a protocol wants it.
3. **The migration path is toward type-tagged slot encoding.** A
   future encoding (perhaps the Syrup-based variant, perhaps a
   smallcaps successor) would put the kind on the wire in a way
   the decoder *can* validate against. The current implementation
   restriction is a holding pattern; the comment makes clear the
   maintainers consider it temporary.

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L238-L336) at commit `da16a78e`.
