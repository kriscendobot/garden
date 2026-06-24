---
section: E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
source: endo--packages-eventual-send-src-E-js
topics: [eventual-send, hardened-javascript, captp]
status: current
title: The §has-trap-pretends-everything-exists discipline
parent: endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
---

```js
has: (_target, _p) => {
  // We just pretend everything exists.
  return true;
}
```

The §pretend-everything-exists discipline. Comment is identical in
all three handlers. Since the proxy doesn't know which methods the
remote *actually* has (the remote could be anything; only at
dispatch-time does the actual receiver decide), `has` returns `true`
unconditionally.

This is the §unknown-shape-of-remote discipline: `E(x)` has no
type-level knowledge of what `x` is. The `has` trap respects this by
saying *yes* to every key.
