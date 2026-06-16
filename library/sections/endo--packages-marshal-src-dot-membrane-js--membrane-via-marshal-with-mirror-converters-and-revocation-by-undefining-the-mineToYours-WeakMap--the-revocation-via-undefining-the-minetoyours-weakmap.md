---
section: membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
source: endo--packages-marshal-src-dot-membrane-js
topics: [marshal, capability-security]
status: current
title: The §revocation via undefining the mineToYours WeakMap
parent: endo--packages-marshal-src-dot-membrane-js--membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
---

The §`myRevoke(reasonString)` function:

```js
const myRevoke = reasonString => {
  assert.typeof(reasonString, 'string');
  mineToYours = undefined;
  optReasonString = reasonString;
  if (optInnerRevoke) {
    optInnerRevoke(reasonString);
  }
};
```

The §undefine-the-cache trick: setting `mineToYours = undefined`
makes the next call to `convertMineToYours` *throw*:

```js
if (mineToYours === undefined) {
  throw harden(ReferenceError(`Revoked: ${optReasonString}`));
}
```

The §two-step-revocation: revoking *this* side also calls
`optInnerRevoke(reasonString)` which is the *mirror's revoke*.
A single `revoke()` call propagates to both sides of the membrane,
preventing any further passage.
