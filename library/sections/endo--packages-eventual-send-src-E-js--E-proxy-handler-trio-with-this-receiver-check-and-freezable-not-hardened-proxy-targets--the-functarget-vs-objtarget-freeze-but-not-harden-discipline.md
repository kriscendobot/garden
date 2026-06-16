---
section: E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
source: endo--packages-eventual-send-src-E-js
topics: [eventual-send, hardened-javascript, captp]
status: current
title: The §funcTarget vs §objTarget — §freeze-but-not-harden discipline
parent: endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
---

```js
const funcTarget = freeze(() => {});
const objTarget = freeze({ __proto__: null });
```

The §freeze-not-harden discipline. Comment:

> *`freeze` but not `harden` the proxy target so it remains trapping.
> Thus, it should not be shared outside this module.*
>
> *See https://github.com/endojs/endo/blob/master/packages/ses/docs/preparing-for-stabilize.md*

The §stabilize-discipline reference: a *hardened* object is `freeze`d
+ all properties recursively `freeze`d + the prototype `freeze`d *and
permanently sealed against future stabilization*. The Proxy mechanism
in V8 has an optimization: when the *target* is fully sealed,
property-access can short-circuit some Proxy meta-trap dispatch (this
is the *stabilization* work in progress). A *hardened* target would
trigger this short-circuit — but the E proxy's *whole point* is to
intercept every property access. So `funcTarget` and `objTarget`
stay only `freeze`d, never `harden`ed, *and* the comment specifies
that *they should not be shared outside this module* (because callers
might harden them).

§Two-targets-one-purpose: `funcTarget` (callable; for the
`apply` trap) and `objTarget` (object; for the `get` trap on `E.get`).
The choice of target shape determines what `typeof` reports and
whether the proxy is callable.
