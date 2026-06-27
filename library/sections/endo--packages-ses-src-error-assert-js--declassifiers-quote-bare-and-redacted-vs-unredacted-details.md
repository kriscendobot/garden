---
title: The *no-special-privilege* prelude paired with the candid acknowledgment that this module holds *top-level mutable state observable to any code that has access to `loggedErrorHandler`*; the *declassifiers* WeakMap that pairs a `quote`/`bare` result with the underlying value it intentionally exposes; the `quote` operator that produces a frozen object whose `toString` invokes `bestEffortStringify`; the `bare` operator that returns its argument verbatim if it matches the `canBeBare` regex `/^[\w:-]( ?[\w:-])*$/` and otherwise falls back to `quote`; the `redactedDetails` template tag (the canonical `X`/`details`) that wraps every substitution into a `DetailsToken` whose `toString` produces *redacted* type-tag forms like `(a TypeError)`; the `unredactedDetails` variant used by `errorTaming: 'unsafe'` that wraps substitutions in `quote` so logged details survive into the rendered message
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-ses-src-error-assert-js--declassifiers-quote-bare-and-redacted-vs-unredacted-details--abstract.md)
- [Body](endo--packages-ses-src-error-assert-js--declassifiers-quote-bare-and-redacted-vs-unredacted-details--body.md)
- [Connection to the wider library](endo--packages-ses-src-error-assert-js--declassifiers-quote-bare-and-redacted-vs-unredacted-details--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-ses-src-error-assert-js--declassifiers-quote-bare-and-redacted-vs-unredacted-details--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-ses-src-error-assert-js--declassifiers-quote-bare-and-redacted-vs-unredacted-details--see-also.md)
- [Common confusions](endo--packages-ses-src-error-assert-js--declassifiers-quote-bare-and-redacted-vs-unredacted-details--common-confusions.md)
