---
source: packages/import-bundle/src/compartment-wrapper.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/import-bundle/src/compartment-wrapper.js
source_path: packages/import-bundle/src/compartment-wrapper.js
section_kind: source
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Brian Warner (prompted)
topics:
  - compartments
  - hardened-javascript
  - bundles
genre: §endo-source-comment-fragment §canonical-inescapable-compartment-pattern
cycle: 193
lane: chat
status: current
title: §Reflect.construct-for-subclass-compatibility
parent: endo--packages-import-bundle-src-compartment-wrapper-js--inescapable-compartment-wrapper-with-dual-signature-compatibility-and-propagate-the-wrapper-to-child-compartments
---

```js
const c = Reflect.construct(OldCompartment, [newOptions], new.target);
```

§Reflect.construct(target, argumentsList, newTarget) lets the
wrapper §forward-the-subclass-target. §If-a-user-subclasses-
NewCompartment as `class MyCompartment extends NewCompartment`,
the `new.target` will be `MyCompartment`, and `Reflect.construct`
preserves that prototype chain.

§Without-Reflect.construct: `new OldCompartment(newOptions)`
would always produce an `OldCompartment` instance, breaking
subclass inheritance.

§Compare-to-cycle-181-base64's §Reflect.apply-captured-at-
module-load. §Both-use-Reflect-method-static-forms; cycle 181
captures `apply` for defensive binding, cycle 193 uses
`construct` for subclass-forwarding.
