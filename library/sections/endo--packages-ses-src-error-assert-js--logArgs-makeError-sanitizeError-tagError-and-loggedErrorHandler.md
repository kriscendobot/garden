---
title: The `getLogArgs` function that converts a hidden-details parts array into a console-substitution-friendly args array by unquoting `declassifiers`-registered substitutions and trimming substitution-adjacent spaces (since console.log inserts its own argument-separator spaces); the `hiddenMessageLogArgs` WeakMap that lets the causal-console look up the *most-informative* log-args form of an error's message after the error has been constructed; the `errorTagNum` counter + `errorTags` WeakMap + `tagError` function that assign each error a unique tag like `Error#3` for cross-reference between the rendered short form and the full annotation tree; the `sanitizeError` function that strips host-added own properties (V8's `fileName`/`lineNumber`/`columnNumber`/`stack`/`message`/`name` getters), annotates the error with the dropped values via `note`, converts remaining accessor properties to data properties, and freezes; the `makeError` factory that constructs an `Error` from a details-token; the `note` annotation function with hiddenNoteCallbacks for after-the-error logging; the `defaultGetStackString` non-privileged fallback that the loggedErrorHandler prefers `globalThis.getStackString` over; the `loggedErrorHandler` itself — the canonical bridge object that cycle 96's console.js receives
source: packages/ses/src/error/assert.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson]
source_lines: "204-477 (getLogArgs + hiddenMessageLogArgs + errorTagNum + tagError + sanitizeError + makeError + note + defaultGetStackString + loggedErrorHandler)"
topics: [hardened-javascript, errors]
status: current
notes: |
  The *rendering machinery* of SES's assert module — the bridge
  between the cycle-90 (track-turns), cycle-93 (tame-v8), and cycle-96
  (causal-console) facets, all consumed via the exported
  `loggedErrorHandler`. Eight named surfaces: `getLogArgs`,
  `hiddenMessageLogArgs`, `errorTagNum` + `tagError`, `sanitizeError`,
  `makeError`, `note` + `hiddenNoteCallbacks`, `defaultGetStackString`,
  and `loggedErrorHandler`. The §getLogArgs structure unquotes
  declassifier-wrapped substitutions back to their underlying values
  for console-substitution and trims substitution-adjacent spaces
  *because the console logger inserts its own separating spaces
  between arguments*. The §sanitizeError function captures the
  host's automatically-added Error own-properties (fileName /
  lineNumber / etc. in non-V8 engines), annotates the error with a
  `note` describing the dropped values, and converts accessor
  properties (V8's `stack` getter) to data properties to make the
  error robust to redaction. The §loggedErrorHandler is the exact
  bridge cycle-96's makeCausalConsole consumes.
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler--abstract.md)
- [Body](endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler--body.md)
- [Connection to the wider library](endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler--see-also.md)
- [Common confusions](endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler--common-confusions.md)
