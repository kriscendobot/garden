---
title: Connection to the wider library
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

This section is the **canonical *narrow-gate-bridge between two SES-internal modules* worked example**. Three threads:

1. **The `loggedErrorHandler` is structurally a *capability object*** — a frozen bundle of methods whose holder is exactly the substrate authorized to observe the assert module's mutable state. The file header names the gate up-front; the bridge object is the gate's concrete form.

2. **The `sanitizeError` discipline** is the canonical *normalize-host-added-state-without-losing-it* pattern. Host engines silently add properties; SES strips them but preserves them as annotations so debugging is unaffected.

3. **The `tagError` cross-reference pattern** generalizes to any *render-the-summary-here-render-the-detail-elsewhere-cross-reference-by-tag* structure. The tag is the join key; the summary form (used in substitutions) is a short string; the full form is rendered separately under its tag header.

The §three-cycle trilogy of the SES causal-console architecture:

- **Cycle 90 `track-turns.js`** (Mark Miller) — produces annotations on errors as they cross turn boundaries.
- **Cycle 93 `tame-v8-error-constructor.js`** (Richard Gibson) — provides the privileged `getStackString`.
- **Cycle 96 `console.js`** (Mark Miller) — renders the structured errors using these capabilities.

This section *completes* the bridge: **cycle 98's `assert.js` (Richard Gibson) holds the mutable state and exports `loggedErrorHandler`** as the bridge object cycle 96's `console.js` imports.
