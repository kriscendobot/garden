---
title: Connection to the wider library
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

This section is the **canonical *substitution-declassification-as-default-redact* pattern**. Three threads:

1. **The mutable-state-with-narrow-exposure admission** generalizes to other SES-internal modules that must hold state across compartment-loading boundaries. The discipline is *narrow-typed-gate* (here `loggedErrorHandler`) plus *up-front honest admission in the file header*.

2. **The declassifier-WeakMap pattern** is reusable for any *intentional-vs-accidental-exposure* discrimination. The opaque-wrapper-plus-side-map approach lets the discriminator inspect the wrapper without the wrapper carrying its underlying value as an own property.

3. **The safe-prose regex (`canBeBare`)** is a worked example of the *whitelist-sanitization-for-string-interpolation* discipline. The regex constrains the input to *names-and-short-prose-only*; metacharacters trigger fallback to JSON-quoting via `bestEffortStringify`.

The §redacted-vs-unredacted-details split is the canonical *safe-default-with-unsafe-opt-in* pattern: the dangerous behavior (logging arbitrary object content) is reachable only by an explicit lockdown setting.
