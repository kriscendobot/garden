---
title: Abstract
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

The §opening cluster of `tame-v8-error-constructor.js` establishes the *two-layer attenuation* of the V8 stack-trace API. **Layer 1: the 16-name CallSite method permit list** — `safeV8CallSiteMethodNames` enumerates exactly the methods a user-prepareFn may invoke through the *safeV8CallSiteFacet* wrapper: `getTypeName`, `getFunctionName`, `getMethodName`, `getFileName`, `getLineNumber`, `getColumnNumber`, `getEvalOrigin`, `isToplevel`, `isEval`, `isNative`, `isConstructor`, `isAsync`, plus two by-experiment-found names not in the V8 spec (`getPosition`, `getScriptNameOrSourceURL`), and `toString` (with a *TODO replace to use only permitted info* note). Explicitly *suppressed*: `getThis` (would expose the receiver object), `getFunction` (would expose the function value itself), `isPromiseAll` (suppressed for now), `getPromiseIndex` (suppressed for now). The list's authors document the cost: *TODO this is a ridiculously expensive way to attenuate callsites. Before that matters, we should switch to a reasonable representation.* — a candid admission that the per-frame proxy-creation overhead is high but acceptable until a redesign. **Layer 2: the five filename-censor regexes** that drop infrastructure frames from concise stack traces: (1) `/\/node_modules\//` — frames in dependent packages on Node are usually infrastructure; (2) `/^(?:node:)?internal\//` — Node's own internals; (3) `/\/packages\/ses\/src\/error\/assert\.js$/` — SES's `assert.js`, the *steps towards creating the error object in question*; (4) `/\/packages\/eventual-send\/src\//` — the eventual-send shim, *deep stacks omit the internals of the eventual-sending mechanism causing asynchronous messages to be sent* (and the comment notes the package's planned migration from agoric-sdk to Endo); (5) `/\/packages\/ses-ava\/src\/ses-ava-test\.js$/` — the ses-ava test infrastructure. The `filterFileName(fileName)` function returns `false` for any frame whose `fileName` matches any of the five censor patterns or is `null` (which suppresses anonymous-builtin frames like `Array.every (<anonymous>)`). The `// TODO Enable users to configure FILENAME_CENSORS via `lockdown` options.` comment names a *known future-work direction*: today the censor list is hardcoded; tomorrow it should be user-configurable.
