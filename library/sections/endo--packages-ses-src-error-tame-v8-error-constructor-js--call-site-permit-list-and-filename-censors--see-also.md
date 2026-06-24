---
title: See also
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

- [[hardened-javascript]] (topic) — the SES substrate. tame-v8-error-constructor.js is one of SES's V8-specific taming files.
- [[errors]] (topic) — the broader SES error-handling surface.
- [[capability-security]] (topic) — the permit-list-for-CallSite-methods is the canonical capability-attenuation pattern at the V8-stack-API layer.
- `endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair` (cycle 87) — the *complementary* pass-style-layer V8-stack-accessor work: the pass-style side repairs the *accessor*; the SES side (this file) attenuates the *method-call surface*. Both handle V8-specific stack-trace channels.
- `endo--packages-eventual-send-src-track-turns-js--*` (cycle 90) — the causal-console module that the eventual-send shim feeds, instrumented with turn-and-event labels. The censor list keeps eventual-send frames out of concise stacks, but track-turns adds *causal* annotations that survive.
- `endo--packages-marshal-src-marshal-js--error-diagnostic-priority` (cycle 74) — the marshal-side complement: why the stack is deliberately not put on the wire. The wire-side and the local-stack-side handle different channels of the same stack-trace security concern.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--callsite-path-shortening-patterns` — the next section in this source: the four regex patterns that shorten kept callsite strings.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--tame-v8-error-constructor-and-system-vs-user-preparefns` — the third section: how the tameV8ErrorConstructor function wires together attenuation + system-vs-user prepareFn distinction.
