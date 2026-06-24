---
title: The 16-name V8 call-site method allowlist (suppressing `getThis`, `getFunction`, `isPromiseAll`, `getPromiseIndex`); the five filename-censor regexes that drop infrastructure frames from concise stack traces (node_modules / node-internals / SES assert.js / eventual-send / ses-ava); the `filterFileName` function that consults the censor list; the TODO-this-is-ridiculously-expensive admission about the per-call attenuation cost
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-ses-src-error-tame-v8-error-constructor-js--call-site-permit-list-and-filename-censors--abstract.md)
- [Body](endo--packages-ses-src-error-tame-v8-error-constructor-js--call-site-permit-list-and-filename-censors--body.md)
- [Connection to the wider library](endo--packages-ses-src-error-tame-v8-error-constructor-js--call-site-permit-list-and-filename-censors--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-ses-src-error-tame-v8-error-constructor-js--call-site-permit-list-and-filename-censors--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-ses-src-error-tame-v8-error-constructor-js--call-site-permit-list-and-filename-censors--see-also.md)
- [Common confusions](endo--packages-ses-src-error-tame-v8-error-constructor-js--call-site-permit-list-and-filename-censors--common-confusions.md)
