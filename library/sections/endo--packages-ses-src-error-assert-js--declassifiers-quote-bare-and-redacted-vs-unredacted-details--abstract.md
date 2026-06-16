---
title: Abstract
source: packages/ses/src/error/assert.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson]
source_lines: "1-202 (file header + declassifiers/quote/bare + hiddenDetailsMap + DetailsTokenProto + redactedDetails + unredactedDetails)"
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

The §file-header comment block (lines 1-12) opens with the same *no-special-privilege* axiom as cycle 96's `console.js`: *Subject to the conditions and limitations of [the Apache 2.0 license]...*. But unlike `console.js`, the §next lines (lines 6-12) carry a candid admission:

> Note that this module is unusual among the packages in @endo, because it has top-level mutable state, observable to any code that has access to the `loggedErrorHandler`. ... The exposure is intentional: anyone holding `loggedErrorHandler` is, by definition, the logging substrate, and the substrate needs the mutable state to render annotations after the error has been thrown.

This is the §honest-mutable-state-with-narrow-exposure discipline. The §declassifiers WeakMap (lines 65-69) pairs an *opaque marker token* with the underlying value it intentionally exposes; the §quote function (lines 70-80) returns a frozen object whose `toString` invokes `bestEffortStringify(value)`; the §bare function (lines 83-92) returns its argument verbatim if it matches `canBeBare = /^[\w:-]( ?[\w:-])*$/` and otherwise falls back to `quote`. The §canBeBare regex is the *safe-as-prose* gate: a string matches if it contains only word characters, colons, or hyphens with optional single-space separators — the structural intent is *names that look like identifiers or short prose without metacharacters that could be confused with substitutions*. The §hiddenDetailsMap WeakMap (line 95) holds the parts of each details-token outside the token itself, so the token carries no own properties that could leak. The §DetailsTokenProto (lines 111-127) is the prototype of every details-token; its `toString` produces type-tag substitutions like `(a TypeError)` for non-declassified Error arguments. The §redactedDetails template tag (lines 144-178) is the canonical `X` / `details` tag: it captures the literal parts and substitution values, builds a frozen DetailsToken, and stores the parts in the hidden map. The §unredactedDetails template tag (lines 181-202) is the variant used by `errorTaming: 'unsafe'`: it wraps every substitution in `quote` so the substitution's underlying value survives into the rendered message instead of being redacted to a type-tag.
