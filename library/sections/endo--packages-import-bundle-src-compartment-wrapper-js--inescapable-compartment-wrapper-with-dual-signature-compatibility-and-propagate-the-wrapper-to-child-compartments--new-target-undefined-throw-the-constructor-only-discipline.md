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
title: §new.target===undefined throw (the §constructor-only-discipline)
parent: endo--packages-import-bundle-src-compartment-wrapper-js--inescapable-compartment-wrapper-with-dual-signature-compatibility-and-propagate-the-wrapper-to-child-compartments
---

```js
// The real Compartment is defined as a class, so 'new Compartment()'
// works but not 'Compartment()'. We can behave the same way. It would be
// nice to delegate the 'throw' to the original constructor by knowing
// calling it the wrong way, but I don't know how to do that.
if (new.target === undefined) {
  // `newCompartment` was called as a function
  throw Error('Compartment must be called as a constructor');
}
```

§The-§new.target-required-check ensures the wrapper-Compartment
can only be called with `new`. §Without-it: a caller could
write `Compartment(...)` (no `new`) and get unexpected
behavior.

§The-comment-acknowledges-a-discipline-gap: "It would be nice
to delegate the 'throw' to the original constructor by
knowing calling it the wrong way, but I don't know how to do
that." §Honest-uncertainty-named-in-comment (sibling to cycle
189-marshal-justin's §honest-uncertainty about double-angle-
brackets).

§The-real-Compartment-is-a-class so §new-is-required; §the-
wrapper-uses-function-syntax (to preserve `.name`); §the-
wrapper-manually-enforces-the-constructor-requirement.

§Compare-to-cycle-146-E.js' §avoid-function-syntax-keeps-it-
non-constructable. §Different-direction: E avoids `new`-ability;
Compartment requires it.
