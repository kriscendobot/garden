---
title: Common confusions
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

- **"The permit list is too restrictive — what if a user-prepareFn needs `getThis`?"** That is *precisely the point*. A user-prepareFn that needs `getThis` is reaching for a capability that should not be exposed to user code under the SES discipline. The library's design favors *suppress-by-default*; if a use case emerges that justifies adding `getThis`, the addition would require a security review.
- **"The TODO 'ridiculously expensive' suggests the file is broken."** It is not broken; it is *correctly slow*. The implementation is honest about the trade-off: correctness now, performance redesign later. Until error-creation rates make the cost matter, the simple design is acceptable.
- **"The eventual-send censor is too aggressive — sometimes I want to debug eventual-send itself."** Then run without `concise` stack-filtering. The censor only applies to concise stacks; *verbose* stacks include all frames. The `stackFiltering` lockdown option is the user-control mechanism.
- **"The `null` fileName check is fragile."** It works in practice for V8's anonymous-builtin frames. The comment `// Seems to suppress` is honest about the empirical-rather-than-formal basis. If V8 changes, this could need adjustment — but that's a known sensitivity, not a hidden bug.
- **"The five censors should be in a configuration file, not hardcoded."** The `TODO Enable users to configure FILENAME_CENSORS via lockdown options` records that future direction. Until configurability lands, the hardcoded list serves the common case (Node + SES + eventual-send + ses-ava).
- **"`getPosition` and `getScriptNameOrSourceURL` are *Additional names found by experiment* — that's sketchy."** The comment is honest about the discovery method. V8's stack-trace API has some undocumented surface that proves useful in practice; the file documents what was found *and* what is officially in the V8 docs. This is *honesty-about-the-API-frontier* discipline.
