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
title: §Lazy-initialization-via-IIFE-closure
parent: endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install
---

```js
let selectedHarden;

const harden = object => {
  if (!selectedHarden) {
    selectedHarden = selectHarden();
  }
  return selectedHarden(object);
};
Object.freeze(harden);
```

§Lazy-first-call: §selectHarden-runs-once-per-instance.
§Subsequent-calls-skip-the-tier-walk.

§Why-lazy: §at-module-load-time-Object[@harden]-may-not-
yet-be-installed. §SES-might-be-loading-in-parallel.
§Defer-the-selection-until-first-actual-use.

§Object.freeze(harden) on the wrapper: §the-selector-
itself-cannot-be-modified. §Defensive-harden-of-the-
harden-selector.

§Two-levels-of-defensiveness: the wrapper is frozen; the
underlying harden (if from tier 3) is pinned in
Object[@harden].
