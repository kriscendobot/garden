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
title: §`racePromises` — the leak-free public API
parent: endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch
---

```js
export function racePromises(values) {
  return harden(
    memoRace.call(BestPipelinablePromise, values),
  );
}
harden(racePromises);
```

§The-named-export `racePromises` (not `Promise.race`) gives
callers an explicit way to use the leak-free race. §The-shim
replaces `Promise.race` unconditionally, but §callers-who-want-
to-be-explicit can import `racePromises` directly.

§The-comment-above explains a §rejected-alternative:

```
// NB: Another implementation for Promise.race would be to use
// the releasing executor.  However while it would no longer
// leak the raced promise objects themselves, it would still
// leak reactions on the non-resolved promises contending for
// the race.
```

§This-is-§considered-and-rejected-discipline (sibling to
cycle 186's §"illusion of an option" pattern). §The-§releasing-
executor-approach would have a §similar-but-distinct-leak
(reactions instead of promise objects).

§Cycle-156-finalize.js's §weak-value-map + cycle-173-promise-
executor-kit's §reference-release-on-settle + cycle-152-memo-
race's §memo-race are the §three-leak-prevention-disciplines
that converge on this design.
