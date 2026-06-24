---
title: See also
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
parent: endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler
---

- [[hardened-javascript]] (topic) — the SES substrate; this module exports the canonical `loggedErrorHandler` consumed by SES's causal-console.
- [[errors]] (topic) — the broader SES error-handling system; this section is the rendering-machinery layer.
- `endo--packages-ses-src-error-assert-js--declassifiers-quote-bare-and-redacted-vs-unredacted-details` — the previous section: the redaction discipline that produces the details-tokens this section's `makeError` and `note` consume.
- `endo--packages-ses-src-error-assert-js--makeAssert-and-the-assert-function-family` — the next section: the user-facing `makeAssert` factory and the `assert` / `Fail` / `assert.equal` / `assert.typeof` family.
- `endo--packages-ses-src-error-console-js--*` (cycle 96) — the causal-console rendering surface; `makeCausalConsole(baseConsole, loggedErrorHandler)` consumes this section's exported bridge.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--*` (cycle 93) — provides `globalThis.getStackString` that `loggedErrorHandler.getStackString` prefers when present.
- `endo--packages-eventual-send-src-track-turns-js--*` (cycle 90) — produces annotations that pass through `note(error, details)`.
- `endo--packages-pass-style-src-error-js--*` (cycle 87) — pass-style's error-validation surface; sanitized errors flow through that gate.
