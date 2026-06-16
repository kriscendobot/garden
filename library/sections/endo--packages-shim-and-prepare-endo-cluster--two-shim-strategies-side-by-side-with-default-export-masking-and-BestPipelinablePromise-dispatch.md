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
kind: index
section_count: 14
---

Sections:

- [The shim-and-prepare-endo cluster: two shim strategies side by side, default-export-masking for AVA config, and BestPipelinablePromise dispatch](endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch--the-shim-and-prepare-endo-cluster-two-shim-strategies-side-by-side-default-expor.md)
- [§The-two-shim-strategies (the spine)](endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch--the-two-shim-strategies-the-spine.md)
- [§The-design-rule: §conditional-vs-unconditional-depends-on-whether-the-target-is-correct](endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch--the-design-rule-conditional-vs-unconditional-depends-on-whether-the-target-is-co.md)
- [§BestPipelinablePromise (promise-kit/index.js)](endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch--bestpipelinablepromise-promise-kit-index-js.md)
- [§`racePromises` — the leak-free public API](endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch--racepromises-the-leak-free-public-api.md)
- [§`isPromise` — the canonical detection](endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch--ispromise-the-canonical-detection.md)
- [§The-postponedHandler (eventual-send/src/postponed.js)](endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch--the-postponedhandler-eventual-send-src-postponed-js.md)
- [§The-three-purpose prepare-endo.js (ses-ava)](endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch--the-three-purpose-prepare-endo-js-ses-ava.md)
- [§`@endo/ses-ava/prepare-endo-config.js` — the default-export-masking trick](endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch--endo-ses-ava-prepare-endo-config-js-the-default-export-masking-trick.md)
- [§The-`@ts-expect-error 2454` pattern (revisited)](endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch--the-ts-expect-error-2454-pattern-revisited.md)
- [§`utils.js` — the canonical thin barrel](endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch--utils-js-the-canonical-thin-barrel.md)
- [§Cohesion notes](endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch--cohesion-notes.md)
- [§Tier-1 borrowing](endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch--tier-1-borrowing.md)
- [§Synthesis-target](endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch--synthesis-target.md)
