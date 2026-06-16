---
section: PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
source: endo--packages-pass-style-src-passStyle-helpers-js
topics: [pass-style]
status: current
title: The §isPrimitive / §isObject pair with §XS-cost warning
parent: endo--packages-pass-style-src-passStyle-helpers-js--PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
---

```js
export const isPrimitive = val =>
  // Safer would be `Object(val) !== val` but is too expensive on XS.
  // So instead we use this adhoc set of type tests. But this is not safe in
  // the face of possible evolution of the language. Beware!
  !val || (typeof val !== 'object' && typeof val !== 'function');
```

The §inline-help comment is the *load-bearing warning*:

> *Safer would be `Object(val) !== val` but is too expensive on
> XS. So instead we use this adhoc set of type tests. But this is
> not safe in the face of possible evolution of the language.
> Beware!*

The §safer-but-slower-on-XS trade-off: `Object(val)` boxes
primitives, then strict-comparing against the original detects
primitives reliably even if new primitive types are introduced
(e.g., a future ECMAScript adds a new primitive). But XS
(JavaScript engine used by some Endo deployments) makes
`Object(val)` expensive — *expensive enough* that the trade-off
goes the other way.

The §current-implementation is *adhoc set of type tests*:
falsy-or-not-object-and-not-function. *But this is not safe in
the face of possible evolution of the language.* If JavaScript
adds a new primitive type that's neither falsy nor
`typeof !== 'object' && typeof !== 'function'`, this check would
fail. The §Beware comment is the explicit acknowledgement.

§isObject is the boolean dual:

```js
export const isObject = val =>
  !!val && (typeof val === 'object' || typeof val === 'function');
```

The §deprecation marker:

> *@deprecated use `!isPrimitive` instead*

The §isObject-deprecated-prefer-`!isPrimitive` discipline. Both
functions exist for backward compatibility; new code uses
`!isPrimitive(val)`.
