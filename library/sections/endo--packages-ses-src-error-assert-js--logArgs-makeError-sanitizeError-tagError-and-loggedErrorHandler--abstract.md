---
title: Abstract
source: packages/ses/src/error/assert.js
source_repo: endojs/endo
source_branch: master
source_commit: 0594e99fb7ecf2ff1ae64489125aea1da9e02ab2
source_date: 2026-06-29
source_authors: [Richard Gibson]
source_lines: "214-522 (getLogArgs + hiddenMessageLogArgs + errorTagNum + tagError + sanitizeError + makeError + note + defaultGetStackString + loggedErrorHandler)"
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
  error robust to redaction; since commit `0594e99f` (2026-06-29) it
  also conditionally whitelists a string-valued `code`, the counterpart
  of `makeError`'s new non-enumerable `code` option.
  The §loggedErrorHandler is the exact
  bridge cycle-96's makeCausalConsole consumes.
parent: endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler
---

The §getLogArgs function (lines 222-248) converts a hidden-details parts array into a console-substitution-friendly args array. Each substitution is checked against `declassifiers`: if registered, the underlying value replaces the wrapper; the literal-parts around it are trimmed of substitution-adjacent spaces because *the console logger inserts its own argument-separator space between adjacent log-args*. The §hiddenMessageLogArgs WeakMap (line 257) stores the per-error log-args form of the original message-details so the causal-console can later render the *most-informative* form. The §errorTagNum counter + §errorTags WeakMap + §tagError function (lines 260-281) assign each error a unique short tag like `Error#3` so the rendered short form (e.g. `(Error#3)` in a substitution) can be cross-referenced with the full annotation tree. The §sanitizeError function (lines 310-346) strips host-added own properties — in non-V8 engines, `Error` constructors silently add `fileName`/`lineNumber`/`columnNumber`/`name`/`message` as enumerable own properties; in V8, `stack` is a getter on the instance. The function captures these as a `dropped` object, removes them from the error, annotates the error with a `note` describing what was dropped, converts any remaining accessor properties (V8 `stack`) to data properties, and freezes. As of commit `0594e99f` (2026-06-29) its whitelist also carries `code`, but *conditionally*: a `code` whose value is present and not a string is pushed back onto the drop list, so only a string-valued (or accessor-valued) `code` survives sanitization. The §makeError factory (lines 351-430) constructs an `Error` from a details-token: it looks up the hidden details, computes the message string, handles `AggregateError` specially, optionally defines a non-enumerable `code` own-property from the new `code` option (the counterpart of that whitelist entry), stores the log-args form in `hiddenMessageLogArgs`, optionally tags the error, optionally sanitizes, and returns. The §note function (lines 450-472) is the after-the-error annotation surface; if a callback has been registered for the error (via `loggedErrorHandler.takeNoteLogArgsArray`), the callback is invoked immediately so the console can render the annotation *as it arrives* rather than waiting for next-log; otherwise the annotation is queued. The §defaultGetStackString function (lines 483-493) is the non-privileged fallback used when `globalThis.getStackString` is not present — it just reads `error.stack`. The §loggedErrorHandler (lines 496-521) is the canonical bridge object: it bundles `getStackString` (preferring `globalThis.getStackString`), `tagError`, `resetErrorTagNum`, `getMessageLogArgs`, `takeMessageLogArgs`, and `takeNoteLogArgsArray` — exactly the surface cycle 96's `makeCausalConsole` consumes.
