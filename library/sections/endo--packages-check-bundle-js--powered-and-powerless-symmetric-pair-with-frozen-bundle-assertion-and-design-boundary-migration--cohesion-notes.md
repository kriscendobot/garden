---
source: packages/check-bundle/{index,lite,src/json}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/check-bundle
source_path: packages/check-bundle/index.js, packages/check-bundle/lite.js, packages/check-bundle/src/json.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - capability-security
  - bundles
  - hardened-javascript
genre: §endo-source-comment-fragment §canonical-powered-powerless-pair
cycle: 185
lane: chat
status: current
title: §Cohesion notes
parent: endo--packages-check-bundle-js--powered-and-powerless-symmetric-pair-with-frozen-bundle-assertion-and-design-boundary-migration
---

- §Powered-and-powerless-symmetric-pair is the §canonical-
  pattern for crypto/fs separation in @endo. The powerless
  core runs in any SES realm; the powered shim provides
  Node-specific affordances.
- §Three-public-function-progression makes the §powered-ness-
  axis explicit in the API surface, not just in the file
  layout.
- §Frozen-bundle-assertion + §three-class-property-rejection
  form a §defense-in-depth for bundle integrity. A frozen
  object alone isn't enough if it has getters; a record-of-
  strings is the minimum verifiable shape.
- §Three-moduleFormat-cases enumerate §which-formats-have-
  stable-hashes (endoZipBase64) and §why-others-don't
  (getExport / nestedEvaluate are §not-necessarily-consistent
  across toolchain versions).
- §`parseArchive` integration delegates hash-of-hashes
  verification to compartment-mapper; check-bundle is the
  §thin-orchestrator.
- §The-§gap-between-design-and-implementation: cycle 180 hex-
  package design marked check-bundle/index.js as §retained-at-
  boundary; the actual source migrated. §Designs-are-guides-
  not-contracts.
- §await-null discipline + §module-scoped-TextDecoder + §`@ts-
  check` + `<reference types="ses"/>` are §SES-specific-
  conventions that recur across many @endo packages.
- §parseLocatedJson is a §error-rewrapping-with-location
  helper (22 lines); sibling to cycle 181-base64's error
  rewrapping for native boundary.
