---
section: what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
source: endo--packages-pass-style-src-remotable-js
topics: [pass-style, marshal]
status: current
title: The §confirmRemotableProtoOf recursive tag-record walk
parent: endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
---

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
