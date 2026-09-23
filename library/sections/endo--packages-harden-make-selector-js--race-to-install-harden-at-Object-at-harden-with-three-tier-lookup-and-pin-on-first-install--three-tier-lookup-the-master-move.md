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
title: §Three-tier-lookup (the master move)
parent: endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install
---

```js
const selectHarden = () => {
  // Tier 1: Object[@harden]
  const { [symbolForHarden]: objectHarden } = Object;
  if (objectHarden) {
    if (typeof objectHarden !== 'function') throw Error(...);
    return objectHarden;
  }

  // Tier 2: globalThis.harden
  const { harden: globalHarden } = globalThis;
  if (globalHarden) {
    if (typeof globalHarden !== 'function') throw Error(...);
    return globalHarden;
  }

  // Tier 3: fresh make + pin
  const harden = makeHardener();
  Object.defineProperty(Object, symbolForHarden, {
    value: harden,
    configurable: false,
    writable: false,
  });
  return harden;
};
```

§Three-tier-lookup-with-fallthrough:

| Tier | Source | When |
|------|--------|------|
| 1 | `Object[@harden]` | New convention; this file's preferred slot |
| 2 | `globalThis.harden` | HardenedJS / SES legacy convention |
| 3 | Fresh `makeHardener()` | Neither exists; install + pin |

§Each-tier-falls-through-to-the-next. §New-then-legacy-
then-make. §Backward-compatible-with-three-flavors.

§Type-check-the-existing-implementation: if the slot is
populated but not a function, throw. §Defensive-against-
collisions with code that put something else in the slot.

§The-throw-message-tells-you-what-was-expected: `@endo/
harden expected callable Object[@harden]`. §Helpful-
diagnostic for the bug.
