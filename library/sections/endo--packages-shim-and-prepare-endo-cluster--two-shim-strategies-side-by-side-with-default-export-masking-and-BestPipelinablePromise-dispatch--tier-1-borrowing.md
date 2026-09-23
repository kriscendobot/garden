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
title: §Tier-1 borrowing
parent: endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch
---

- §two-shim-strategies-side-by-side (§conditional-if-target-
  may-be-correct vs §unconditional-if-target-is-known-broken)
- §BestPipelinablePromise dispatch (`globalThis.HandledPromise
  || Promise`)
- §realm-agnostic-Promise-detection-via-`Promise.resolve(x) === x`
- §racePromises as explicit-API-paired-with-builtin-replacement
- §considered-and-rejected discipline (the releasing-executor
  alternative would have a different leak)
- §postponedHandler with §interlockP-as-shared-await-point
  (six traps converge on one promise)
- §`@ts-expect-error N` with named issue number (don't suppress
  blindly; name the runtime invariant)
- §default-export-masking-via-thin-re-import (when a consumer
  can't tolerate the default export)
- §comment-block-is-the-value (a one-line file whose
  documentation explains the indirection)
- §three-purpose-prepare-module (one import that does lockdown
  + env + ava-wrap in 27 lines)
- §`/* global globalThis */` for pre-lockdown shim modules
- §canonical-thin-barrel as public-API-surface
