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
title: §propagate-the-wrapper-to-child-compartments
parent: endo--packages-import-bundle-src-compartment-wrapper-js--inescapable-compartment-wrapper-with-dual-signature-compatibility-and-propagate-the-wrapper-to-child-compartments
---

```js
// The confinement applies to all compartments too. This relies upon the
// child's normal Compartment behaving the same way as the parent's,
// which will cease to be the case soon (their module tables are
// different). TODO: update this when that happens, we need something
// like c.globalThis.Compartment = wrap(c.globalThis.Compartment), but
// there are details to work out.
c.globalThis.Compartment = NewCompartment;
```

§One-line-implementation-with-multi-line-comment. §The-§child-
Compartment's-Compartment-property is overwritten with the
wrapper. §This-propagates-the-inescapable-options to all
transitive children.

§The-comment-names-the-load-bearing-assumption: "This relies
upon the child's normal Compartment behaving the same way as
the parent's, which will cease to be the case soon (their
module tables are different)." §A-§named-TODO with the
specific-shape-of-the-future-fix.

§The-§TODO-with-named-shape pattern: "we need something like
`c.globalThis.Compartment = wrap(c.globalThis.Compartment)`,
but there are details to work out." §The-future-fix-is-sketched
even though not-implemented.

§Compare-to-cycle-189-marshal-justin's §TODO-in-comment naming
known-blockers and cycle 167-where/index.js' §named-TODO
§roaming-AppData-with-content-addressable-state-merge. §All-
three-are-§sketch-the-future-fix-in-source patterns.
