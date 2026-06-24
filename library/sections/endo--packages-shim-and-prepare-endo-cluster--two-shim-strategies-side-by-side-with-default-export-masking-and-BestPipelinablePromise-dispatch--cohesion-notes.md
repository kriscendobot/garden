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
title: §Cohesion notes
parent: endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch
---

- §Two-shim-strategies-side-by-side: eventual-send conditional;
  promise-kit unconditional. §The-design-rule: §conditional-if-
  the-target-may-be-correct; §unconditional-if-the-target-is-
  known-broken.
- §BestPipelinablePromise = `globalThis.HandledPromise ||
  Promise` at module load. §Pick-the-better-Promise gives
  `makePromiseKit` automatic pipelining when HandledPromise is
  available, plain Promise behavior otherwise.
- §racePromises as §explicit-API-paired-with-Promise.race-
  replacement. §The-platform-builtin-is-replaced-for-callers-
  who-don't-know; §the-named-export-exists-for-callers-who-do.
- §`isPromise` via `Promise.resolve(x) === x` is §realm-
  agnostic. §Cross-realm-detection-discipline.
- §postponedHandler with §interlockP-as-shared-await-point.
  Six handler traps all postpone through the same promise.
- §`@ts-expect-error 2454` with §named-issue-number is the
  §don't-suppress-blindly discipline.
- §prepare-endo.js is the §canonical-AVA-integration-of-Endo:
  one-import side-effects + default-export-of-wrapped-test.
- §prepare-endo-config.js is the §default-export-masking-via-
  thin-re-import pattern. §Comment-block-is-the-value.
- §The-§twelfth-member-of-§small-files-with-large-knowledge-
  density family (cycles 165/167/169/171/173/175/177/179/181/
  183/185/187).
