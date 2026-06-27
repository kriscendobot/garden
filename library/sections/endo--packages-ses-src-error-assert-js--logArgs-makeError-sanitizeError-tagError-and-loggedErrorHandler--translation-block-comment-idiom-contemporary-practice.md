---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `Remove the extra spaces that would be inserted between adjacent log args` | The console-substitution-aware space-trimming discipline; substituted args are space-separated by the logger itself. |
| `originally with properties ${quote(dropped)}` (note from sanitizeError) | The moved-not-lost discipline; host-added own-properties survive as annotations even after being stripped. |
| `tagError` → `Error#3` cross-reference | The render-summary-here-detail-elsewhere cross-reference-by-tag pattern. |
| `unprivileged form that just uses the de facto error.stack property` | The honest-non-standard-fallback discipline; works on every engine with some stack property, even if formats diverge. |
| `globalThis.getStackString \|\| defaultGetStackString` | The optional-privileged-capability pattern; prefer the V8-tamed version if present, fall back to the unprivileged form. |
| `takeMessageLogArgs` (destructive) vs `getMessageLogArgs` (non-destructive) | The take-vs-get nomenclature for one-shot vs idempotent reads. |
| `freeze(loggedErrorHandler); export { loggedErrorHandler };` | The frozen-capability-bundle as the narrow-gate to module-internal state. |
| `The next line is a particularly fruitful place to put a breakpoint.` | The honest-debugger-affordance idiom; a maintainer-targeted comment about where to inject diagnostics. |
