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
title: §Synthesis-target
parent: endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch
---

The §slot-machine-library's shim pattern (if it has one) can
§borrow-the-two-shim-strategies discipline: §conditional-vs-
unconditional based on §is-the-target-correct. §The-§default-
export-masking pattern is borrowable wherever §a-consumer-
expects-a-module-with-no-default-export.

§The-§BestPipelinablePromise-dispatch is borrowable for any
§extension-point-binding where a globalThis-installed
implementation should preempt the platform default.
