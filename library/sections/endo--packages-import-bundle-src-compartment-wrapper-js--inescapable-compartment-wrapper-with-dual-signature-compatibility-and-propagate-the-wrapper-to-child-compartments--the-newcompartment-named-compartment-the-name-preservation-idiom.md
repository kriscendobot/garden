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
title: §The-§NewCompartment-named-Compartment (the §.name-preservation idiom)
parent: endo--packages-import-bundle-src-compartment-wrapper-js--inescapable-compartment-wrapper-with-dual-signature-compatibility-and-propagate-the-wrapper-to-child-compartments
---

```js
// This is the new Compartment constructor. We name it `Compartment` so
// that it's .name property is correct, but we hold it in 'NewCompartment'
// so that lint doesn't think we're shadowing the original.
const NewCompartment = function Compartment(...args) {
  // ...
};
```

§Two-name-bindings-for-one-function: §the-function-name (used
for `NewCompartment.name === 'Compartment'`) + §the-local-
variable-name (`NewCompartment` so ESLint doesn't flag a
shadow).

§Why-`.name` matters: error messages, stack traces, debugger
displays. §A-wrapped-Compartment-that-says-"NewCompartment"-
in-a-trace would obscure the fact that it's-a-Compartment.

§Why-the-ESLint-workaround: `Compartment` is a free name in
the closure scope; declaring `function Compartment(...)` as a
local would §shadow-the-outer-name. §Lint-disagrees-on-this-
even-though-it's-fine; the §local-variable-named-differently
keeps lint happy.

§Compare-to-cycle-191-zip's §`@ts-expect-error missing
properties from ArrayBuffer` + cycle 188's §`@ts-expect-error
2454`. §Cycle-193-uses-a-naming-workaround instead of a
suppression-comment.

§Compare-to-cycle-146-E.js' §computed-property-key-preserves-
name idiom (`{ [propertyKey](...) {...} }[propertyKey]`). §Both-
are-§preserve-the-name-property patterns at different scales.

§Tier-1-borrowing: §preserve-.name-via-function-name-while-
binding-to-a-different-local for lint-friendly-shadowing.
