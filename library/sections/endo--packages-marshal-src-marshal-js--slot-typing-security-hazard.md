---
title: Slot-typing security hazard — why the current wire encoding cannot distinguish a remotable slot from a promise slot, and the implementation restriction that makes the under-typed encoding safe (#4334)
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
---

## Abstract

`makeMarshal`'s `makeFullRevive` carries two related comments that
together name an under-typed-slot **security hazard** in marshal's
current wire encoding and the **implementation restriction** that
prevents the hazard from being exploited in deployed code. The
hazard is structural: the capdata and (in some readings) smallcaps
encoding emit the same shape for a remotable slot and a promise
slot — a `{[QCLASS]: 'slot', index}` object on capdata; a string
with a `$` or `&` prefix on smallcaps — but the decoder side has
no encoded way to verify *which* of the two the sender intended.
A confused-deputy or hostile peer could feed a remotable's slot
where a promise was expected, or vice versa, and the decoder would
construct the wrong kind of reference. The mitigation, recorded
in agoric-sdk#4334 and applied in this file's capdata-branch
`decodeRemotableOrPromiseFromCapData` wrapper, is an
**implementation restriction**: the caller must supply identical
decode handlers for both kinds, so that whichever kind the peer
encoded, the local side reconstructs the same value. The comment
cluster is the canonical record of the hazard and the workaround
the marshal package settled on while the wire encoding evolves
toward type-tagged slots.

## Body

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

## Translation

| Marshal idiom | Adjacent vocabulary |
|---|---|
| "slot" | "object reference" or "remote reference" in CapTP / OCapN discussions; "swissnum" in older E literature; "vref" in Agoric's SwingSet |
| "convertSlotToVal" / "convertValToSlot" | the **slot mapper** is the application-supplied bridge between marshal's slot-key abstraction and the application's reference-tracking; in CapTP this is the per-session **Question / Answer / Import / Export table** lookup |
| "implementation restriction" | a **temporary workaround at the implementation layer** that disambiguates a spec-level ambiguity; tracked as an issue, intended to lift when the spec/encoding tightens |
| "TODO SECURITY HAZARD" | a **known-but-not-yet-fixed** vulnerability marker; the convention is that such markers point at an issue or PR with the remediation plan |

## See also

- [`endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme`](endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme.md) — the contiguous reserved-character range that assigns `$` to remotable and `&` to promise, which is the smallcaps-side substrate for the partial prefix discrimination described here.
- [`endo--pkg-marshal-readme--convert-val-slot`](endo--pkg-marshal-readme--convert-val-slot.md) — the README's framing of the application-supplied slot-table; this section is the rationale for why that table has to carry the kind information the wire does not.
- [`endo--pkg-captp-readme`](../sources/endo--pkg-captp-readme.md) — CapTP is the consumer of marshal that maintains the per-session import/export tables which `convertSlotToVal` consults.
- [`endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise`](endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise.md) — the distinction between a remotable and a promise is partly about the *passable promise* invariant; the slot-kind hazard documented here is one way the distinction can be muddled at the wire boundary.
- [[smallcaps-encoding]] — the concept page for smallcaps' wire format.
- [[object-capability]] — the broader discipline this hazard threatens: an ambient confusion between two kinds of references is a way authority can leak between them.

## Common confusions

- The `Nat(index)` coercion is *not* the security check. `Nat`
  validates that the slot index is a non-negative integer (so the
  index can be used as an array index without coercion surprises);
  it does not validate the slot's kind. A reader who sees the
  `Nat` call and stops there has misread the hazard.
- "Implementation restriction" in this file does *not* mean "the
  spec forbids it". It means "until the wire encoding is upgraded
  to disambiguate, the implementation routes around the ambiguity
  by requiring identical handlers". A future capdata-successor
  encoding could lift the restriction; the comment treats this as
  the intended direction.
- The smallcaps prefix discrimination (`$` vs `&`) does *not* fully
  solve the hazard. It catches a wrong-prefix-on-wire case but not
  a kind-vs-application-slot-table mismatch. The TODO on
  `decodeSlotCommon` remains open in the smallcaps path as well.

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L238-L336) at commit `da16a78e`.
