---
source: packages/{eventual-send,promise-kit,ses-ava}/* (shim + prepare-endo cluster)
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages
source_path: packages/eventual-send/{shim,utils}.js, packages/eventual-send/src/postponed.js, packages/promise-kit/{shim,index}.js, packages/promise-kit/src/is-promise.js, packages/ses-ava/{index,prepare-endo,prepare-endo-config}.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
topics:
  - hardened-javascript
  - eventual-send
  - getting-started
  - testing
genre: §endo-source-comment-fragment §shim-and-prepare-cluster
cycle: 187
lane: chat
status: current
title: §The-two-shim-strategies (the spine)
parent: endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch
---

### §Conditional-install (eventual-send/shim.js)

```js
/* global globalThis */
import { makeHandledPromise } from './src/handled-promise.js';

if (typeof globalThis.HandledPromise === 'undefined') {
  globalThis.HandledPromise = makeHandledPromise();
}
```

§Six-lines-and-a-conditional. §The-discipline: §respect-prior-
installation. §If-another-shim-or-an-earlier-import already
installed HandledPromise, this file is a no-op.

§Why-conditional: HandledPromise is the §extension-point that
@endo/eventual-send defines for §eventual-send-aware-Promise-
implementations. §A-Compartment-may-install-a-different-
HandledPromise (cycle 66's handler-protocol) that already
satisfies the contract. §Don't-override-something-that's-
already-correct.

§Compare-to-cycle-175-make-selector.js' §race-to-install-at-
well-known-slot. §Both-are-§singleton-install-disciplines, but
cycle 175 pins on first install (configurable: false); cycle
187 eventual-send/shim simply yields to any prior installer.

### §Unconditional-replacement (promise-kit/shim.js)

```js
import { memoRace } from './src/memo-race.js';

// Unconditionally replace with a non-leaking version
Promise.race = memoRace;
```

§Four-lines-and-a-comment. §The-comment-is-the-justification:
"Promise.race" is replaced *unconditionally*.

§Why-unconditional: the platform's `Promise.race` has a
well-known §memory-leak (the unresolved values in the race
input hold onto the result Promise even after another value
wins). §Cycle-152-promise-kit's-§memo-race named the fix: a
race that cleans up after itself.

§The-platform-Promise.race-is-not-correct; §don't-respect-
prior-installation; §replace-unconditionally.

§Compare-to-cycle-183-lockdown's §domainTaming-unsafe-always-
injected — that's §unconditional-merge-of-safety-override.
§Promise.race-replacement is §unconditional-replacement-of-
broken-builtin. §Both-are-§unconditional-disciplines but for
different categories of "broken."
