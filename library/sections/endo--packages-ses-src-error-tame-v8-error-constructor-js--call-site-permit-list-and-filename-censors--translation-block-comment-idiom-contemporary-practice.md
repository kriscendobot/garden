---
title: Translation block (comment idiom → contemporary practice)
source: packages/ses/src/error/tame-v8-error-constructor.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson and prior contributors]
source_lines: "23-122 (safeV8CallSiteMethodNames + filename censors + filterFileName)"
topics: [hardened-javascript, errors, capability-security]
status: current
notes: |
  The opening section of `packages/ses/src/error/tame-v8-error-constructor.js`
  is SES's defensive response to the V8 stack-trace API's *too-much-
  information* problem. The V8 CallSite methods (documented at
  v8.dev/docs/stack-trace-api) expose useful frame information but
  also a few that leak too much (`getThis`, `getFunction`). The file
  defines an explicit *permit list* of 16 names that user-prepareFns
  may invoke; everything else is suppressed at the safeV8CallSiteFacet
  level. Separately, five filename-censor regexes drop infrastructure
  frames from *concise* stack traces — node_modules dependents, node:
  internal/, SES's own assert.js, the eventual-send shim, and ses-ava.
  These two mechanisms — permit-list on methods, censor-list on
  filenames — work together to produce stack traces useful for
  debugging without exposing channels (file paths, function bodies)
  that a malicious user-prepareFn could exploit.
parent: endo--packages-ses-src-error-tame-v8-error-constructor-js--call-site-permit-list-and-filename-censors
---

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| Permit list (allowlist) of CallSite methods | Standard capability-attenuation pattern; *positive spec* on the allowed surface. |
| `suppress 'getThis' definitely` | The two-tier suppression labeling: *definitely* (deep semantic reason) vs *for now* (conservative-by-default). |
| `TODO this is a ridiculously expensive way` | Honest cost-disclosure as TODO; signals future-redesign without blocking. |
| Five filename-censor regexes | Frame-filtering by source-path heuristic. |
| `Note that the eventual-send package will move from agoric-sdk to Endo` | In-comment future-work note for a known monorepo migration. |
| `Exported only so it can be unit tested.` | The export-for-testability pattern; signals non-API status. |
| `Seems to suppress builtins like Array.every (<anonymous>)` | Honest-uncertainty comment style; the author's observation is documented even when not proved. |
| `TODO Enable users to configure FILENAME_CENSORS via lockdown options.` | Configurability future-work direction. |
| `TODO Move so that it applies not just to v8.` | Generalization-across-engines future-work direction. |
