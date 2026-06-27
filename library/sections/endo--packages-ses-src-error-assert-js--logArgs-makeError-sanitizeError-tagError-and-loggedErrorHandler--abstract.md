---
title: Abstract
source: packages/ses/src/error/assert.js
source_repo: endojs/endo
source_branch: master
source_commit: bfa149b4f18c6ad1cf1fed3e91cbaddf1e61b39d
source_date: 2026-06-23
source_authors: [Richard Gibson]
source_lines: "214-506 (getLogArgs + hiddenMessageLogArgs + errorTagNum + tagError + sanitizeError + makeError + note + defaultGetStackString + loggedErrorHandler)"
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
parent: endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler
---

The §getLogArgs function (lines 204-238) converts a hidden-details parts array into a console-substitution-friendly args array. Each substitution is checked against `declassifiers`: if registered, the underlying value replaces the wrapper; the literal-parts around it are trimmed of substitution-adjacent spaces because *the console logger inserts its own argument-separator space between adjacent log-args*. The §hiddenMessageLogArgs WeakMap (line 246) stores the per-error log-args form of the original message-details so the causal-console can later render the *most-informative* form. The §errorTagNum counter + §errorTags WeakMap + §tagError function (lines 247-271) assign each error a unique short tag like `Error#3` so the rendered short form (e.g. `(Error#3)` in a substitution) can be cross-referenced with the full annotation tree. The §sanitizeError function (lines 273-330) strips host-added own properties — in non-V8 engines, `Error` constructors silently add `fileName`/`lineNumber`/`columnNumber`/`name`/`message` as enumerable own properties; in V8, `stack` is a getter on the instance. The function captures these as a `dropped` object, removes them from the error, annotates the error with a `note` describing what was dropped, converts any remaining accessor properties (V8 `stack`) to data properties, and freezes. The §makeError factory (lines 335-386) constructs an `Error` from a details-token: it looks up the hidden details, computes the message string, handles `AggregateError` specially, stores the log-args form in `hiddenMessageLogArgs`, optionally tags the error, optionally sanitizes, and returns. The §note function (lines 407-428) is the after-the-error annotation surface; if a callback has been registered for the error (via `loggedErrorHandler.takeNoteLogArgsArray`), the callback is invoked immediately so the console can render the annotation *as it arrives* rather than waiting for next-log; otherwise the annotation is queued. The §defaultGetStackString function (lines 438-448) is the non-privileged fallback used when `globalThis.getStackString` is not present — it just reads `error.stack`. The §loggedErrorHandler (lines 451-477) is the canonical bridge object: it bundles `getStackString` (preferring `globalThis.getStackString`), `tagError`, `resetErrorTagNum`, `getMessageLogArgs`, `takeMessageLogArgs`, and `takeNoteLogArgsArray` — exactly the surface cycle 96's `makeCausalConsole` consumes.
