---
section: two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
source: endo--packages-captp-src-loopback-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: The §synchronous-trap-bridge via `trapGuest`
parent: endo--packages-captp-src-loopback-js--two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
---

The §single most subtle move is the `trapGuest` option:

```js
const { Trap, dispatch: nearDispatch, ... } = makeCapTP(
  `near-${ourId}`,
  o => farDispatch(o),
  bootstrap,
  {
    trapGuest: ({ trapMethod, slot, trapArgs }) => {
      let value;
      let isException = false;
      try {
        const far = farUnserialize({ body: slotBody, slots: [slot] });
        value = nearTrapImpl[trapMethod](far, trapArgs[0], trapArgs[1]);
      } catch (e) {
        isException = true;
        value = e;
      }
      harden(value);
      return [isException, farSerialize(value)];
    },
    ...nearOptions,
  },
);
```

The §sync-trap-by-crossing-the-boundary-immediately pattern:

1. The near side calls `Trap(x).method(...)` — synchronous-
   blocking semantics from cycle 154.
2. CapTP gives `trapGuest` the message components (method,
   slot, args).
3. `trapGuest` uses *the far side's* `farUnserialize` to
   reconstruct the actual JS object *synchronously*.
4. `nearTrapImpl[trapMethod](far, ...)` is invoked — cycle
   154's trivial local dispatch.
5. Result hardened, serialized back via `farSerialize`,
   returned as `[isException, serializedResult]`.

The §use-the-far-side's-marshal-functions discipline: instead
of going *through* CapTP for the trap, this *reaches across*
to the far side's marshal tables synchronously. The
§trap-bypasses-the-async-protocol property.

The §isException-tagged-tuple-result for the synchronous
return: `[isException: boolean, serialized: capdata]`. The
caller (CapTP's Trap implementation) decodes the tuple and
either throws or returns. The §tagged-tuple-because-no-
Promise-rejection-channel observation: sync calls don't have
a rejection-channel; the tuple replaces it.

The §slotBody-hardcoded-as-canonical-marshal-form: the JSON
literal `{ "@qclass": "slot", "index": 0 }` is precomputed and
shared. It's the *minimal valid marshal body* representing
"the single slot in this message." §canonical-single-slot-
marshal-string discipline.
