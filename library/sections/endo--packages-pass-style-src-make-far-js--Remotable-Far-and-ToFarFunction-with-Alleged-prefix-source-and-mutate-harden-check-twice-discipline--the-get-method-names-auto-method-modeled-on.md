---
section: Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
source: endo--packages-pass-style-src-make-far-js
topics: [pass-style, marshal]
status: current
title: The §GET_METHOD_NAMES auto-method — modeled on
parent: endo--packages-pass-style-src-make-far-js--Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
---

GET_INTERFACE_GUARD

The §GET_METHOD_NAMES constant:

```js
export const GET_METHOD_NAMES = '__getMethodNames__';
```

The §inline-help-comment names the lineage:

> *Modeled on `GET_INTERFACE_GUARD` from `@endo/exo`.*

Cycle 118's `exo-tools.js` section 2's §GET_INTERFACE_GUARD
auto-installation pattern is the precedent. *Every exo class
gets a runtime-introspection point* — this design extends the
same pattern to *every Far object*.

The §HAZARD comment:

> *HAZARD: Beware that an exo's interface can change across an
> upgrade, so remotes that cache it can become stale.*

The §interface-cache-staleness-across-upgrades caveat: the
returned method list is *a snapshot at one point*; if the
remotable is upgraded, the snapshot is wrong.

The §getMethodNamesMethod is *thisful*:

```js
const getMethodNamesMethod = harden({
  [GET_METHOD_NAMES]() {
    return getMethodNames(this);
  },
})[GET_METHOD_NAMES];
```

The §JSDoc comment:

> *Note that `getMethodNamesMethod` is a thisful method! It must
> be so that it works as expected with far-object inheritance.*

The §thisful-for-inheritance discipline: if `getMethodNamesMethod`
captured the outer `remotable` value, subclass remotables would
see *the parent's methods, not their own*. By using `this`, the
method correctly walks the prototype chain of the *receiver*,
giving subclasses their full method set.

The §descriptor:

```js
const getMethodNamesDescriptor = harden({
  value: getMethodNamesMethod,
  enumerable: false,
  configurable: false,
  writable: false,
});
```

`enumerable: false` keeps `__getMethodNames__` *out of normal
key enumeration* (so it doesn't pollute `Object.keys` results);
`configurable: false` + `writable: false` make it *unalterable*
once installed.
