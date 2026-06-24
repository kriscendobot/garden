---
title: Connection to the wider library
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

This section is the **canonical worked example of *attenuating-the-V8-stack-trace-API channel at the SES layer***. Three threads:

1. **The permit-list-for-CallSite-methods discipline** is reusable for any *capability-narrowing wrapper* around a richer host API. Generalizes to: *enumerate the names you allow; suppress everything else; wrap each allowed name in a closure that calls the original under controlled-this-binding*.

2. **The filename-censor pattern is reusable for any *frame-filtering* concern**: identify the categories of frames that are infrastructure (not user code); express them as regexes; consult the list in the filter. Generalizes to logging filters, profiler frame attribution, etc.

3. **The TODO-in-comment as future-work-marker** is a corpus-wide discipline. The library can cite this section whenever a design needs to *record known future-work without blocking current implementation*.
