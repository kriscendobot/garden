---
title: See also
source: packages/ses/src/error/assert.js
source_repo: endojs/endo
source_branch: master
source_commit: bfa149b4f18c6ad1cf1fed3e91cbaddf1e61b39d
source_date: 2026-06-23
source_authors: [Richard Gibson]
source_lines: "1-212 (file header + declassifiers/quote/bare + hiddenDetailsMap + DetailsTokenProto + redactedDetails + unredactedDetails)"
topics: [hardened-javascript, errors]
status: current
notes: |
  The *redaction discipline* surface of SES's assert module. Three
  threads: (1) the *no-special-privilege* prelude that mirrors cycle
  96's console.js prelude, paired with an explicit *but-actually-this-
  one-has-top-level-mutable-state* admission for the `loggedErrorHandler`
  bridge; (2) the *declassifier* discipline — `quote`/`bare` mark
  substitutions whose underlying value is *intentionally exposed* to
  the message rendering, while everything else is *redacted* to a
  type-tag string; (3) the `redactedDetails` (default `X` template
  tag) vs `unredactedDetails` (`errorTaming: 'unsafe'` mode that
  preserves substitution content) split. The §canBeBare regex
  `/^[\w:-]( ?[\w:-])*$/` is the *safe-as-prose* gate: a string
  matches if it contains only word-chars/colons/hyphens with
  optional single-space separators, in which case `bare` returns
  the text directly; otherwise it falls back to `quote`-with-
  bestEffortStringify. The §DetailsTokenProto is structurally a
  *frozen-marker-with-toString* — the `hiddenDetailsMap` WeakMap
  pairs each token with its parts; the token itself carries no own
  properties, so it cannot leak its substitutions accidentally.
parent: endo--packages-ses-src-error-assert-js--declassifiers-quote-bare-and-redacted-vs-unredacted-details
---

- [[hardened-javascript]] (topic) — the SES substrate; this module is one of SES's internal taming surfaces.
- [[errors]] (topic) — the broader SES error-handling system this module's *redaction discipline* is the canonical entry point to.
- `endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler` — the next section: the rendering machinery that consumes these tokens and the loggedErrorHandler bridge to cycle 96's `console.js`.
- `endo--packages-ses-src-error-assert-js--makeAssert-and-the-assert-function-family` — the third section: `makeAssert` factory plus the `fail` / `Fail` / `assert` / `assert.equal` / `assert.typeof` family.
- `endo--packages-ses-src-error-console-js--*` (cycle 96) — the causal-console rendering surface; that module receives the `loggedErrorHandler` this module exports.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--*` (cycle 93) — provides the privileged `getStackString` capability that `loggedErrorHandler.getStackString` prefers when available.
- `endo--packages-eventual-send-src-track-turns-js--*` (cycle 90) — produces the causal annotations that pass through `note(error, details)` (covered in next section).
