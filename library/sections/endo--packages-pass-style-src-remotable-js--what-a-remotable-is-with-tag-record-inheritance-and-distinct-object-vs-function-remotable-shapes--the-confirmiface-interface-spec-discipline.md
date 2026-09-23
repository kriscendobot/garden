---
section: what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
source: endo--packages-pass-style-src-remotable-js
topics: [pass-style, marshal]
status: current
title: The §confirmIface interface-spec discipline
parent: endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
---

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
