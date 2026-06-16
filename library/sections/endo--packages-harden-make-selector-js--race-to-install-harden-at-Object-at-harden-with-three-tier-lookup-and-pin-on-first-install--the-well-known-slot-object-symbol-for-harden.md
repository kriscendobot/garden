---
source: packages/harden/make-selector.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/harden/make-selector.js
source_path: packages/harden/make-selector.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mark S. Miller (prompted)
topics:
  - hardened-javascript
  - patterns
  - tooling
genre: §endo-source-comment-fragment
cycle: 175
lane: chat
status: current
title: "§The-well-known-slot: `Object[Symbol.for('harden')]`"
parent: endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install
---

```js
const symbolForHarden = Symbol.for('harden');
```

§Symbol.for(name)-is-realm-cross-cutting: the same symbol
across all packages that look it up by this name.
§Different-from-unique-symbol: §Symbol.for-is-the-
canonical-registered-symbol.

§Why-on-Object-not-globalThis: §Object-is-the-realm-
canonical-base-class; §every-realm-has-it. §Putting-
harden-here makes it discoverable from any code that has
`Object`.

§Cycle-142's-passStyle-helpers-PASS_STYLE used the same
`Symbol.for(name)` pattern. §Registered-symbols-as-
canonical-slots is the §coordination-via-registered-
symbols discipline.
