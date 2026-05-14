---
title: convertValToSlot / convertSlotToVal
source: packages/marshal/README.md
source_repo: endojs/endo
source_commit: 70bcca3d4ba93e92221a9188f583126ca84e4e4d
source_date: 2024-02-05
source_authors: [Richard Gibson, Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [marshal, pass-style, captp]
status: current
notes: convertValToSlot / convertSlotToVal is where CapTP plugs marshal into a particular transport. CapTP's HandledPromise infrastructure (endo--pkg-eventual-send-readme--handled-promise) is the corresponding plug-in for promise references; both hooks are co-installed when a CapTP implementation bridges marshal + eventual-send to a wire protocol.
---

> Abstract: Application-supplied callbacks that bridge marshal's slot-index abstraction to the application's notion of capability identity. convertValToSlot takes a remotable and returns a unique slot identifier (typically a string from a sender-side table). convertSlotToVal takes a slot identifier and returns a remotable (typically by constructing a proxy on the receiver side). CapTP plugs its own implementations in to make sender-side and receiver-side identity consistent across the wire.

## `convertValToSlot` / `convertSlotToVal`

When `m.toCapData()` encounters a pass-by-presence object, it will call the
`convertValToSlot` callback with the value to be serialized. The return value
will be used as the slot identifier to be placed into the slots array, and the
serialized `body`, in place of the object, will contain a special value
referencing that slot identifier by its index in the slots array. For example:

```js
import '@endo/init';
import { makeMarshal } from '@endo/marshal';

const slotAssignments = new Map();
const convertValToSlot = obj => {
  let slot = slotAssignments.get(obj);
  if (slot === undefined) {
    slot = `id1:${(slotAssignments.size + 10).toString(36)}`;
    slotAssignments.set(obj, slot);
  }
  return slot;
};

const p = harden(Promise.resolve());

// Smallcaps encoding.
const m1 = makeMarshal(convertValToSlot, undefined, { serializeBodyFormat: 'smallcaps' });
m1.toCapData(p);
// { body: '#"&0"', slots: [ 'id1:a' ] }

// Original encoding.
const m2 = makeMarshal(convertValToSlot);
m2.toCapData(p);
// { body: '{"@qclass":"slot","index":0}', slots: [ 'id1:a' ] }
```

Each time `m.fromCapData()` encounters a slot reference, it calls
`convertSlotToVal` with the value from the slots array. `convertSlotToVal`
should create and return a proxy (or other representative) of the
pass-by-presence object.


Source: [packages/marshal/README.md](https://github.com/endojs/endo/blob/70bcca3d4ba93e92221a9188f583126ca84e4e4d/packages/marshal/README.md) at commit `70bcca3d`.
