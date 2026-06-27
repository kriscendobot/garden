---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `top-level mutable state, observable to any code that has access to the loggedErrorHandler` | The honest-mutable-state-with-narrow-exposure admission; surface the gate up-front in the file header. |
| `Maps the wrappers returned by quote and bare back to the underlying value they wrap` | The opaque-marker-plus-side-map declassification pattern. |
| `canBeBare = /^[\w:-]( ?[\w:-])*$/` | The whitelist-sanitization-for-string-interpolation discipline; constrain input to names-and-short-prose-only. |
| `redactedDetails` (the default `X` tag) | Default-redact substitutions; expose only declassified ones. |
| `unredactedDetails` (under `errorTaming: 'unsafe'`) | Opt-in unsafe verbose-rendering for development; default is sparse-type-tag rendering. |
| `(a TypeError)` / `(an Object)` type-tag rendering | The sparse-type-tag-without-content rendering for *known-class-but-redacted-content* substitutions. |
