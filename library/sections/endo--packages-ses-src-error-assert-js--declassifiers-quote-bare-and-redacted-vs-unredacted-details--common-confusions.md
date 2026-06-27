---
title: Common confusions
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

- **"`top-level mutable state` is forbidden in hardened modules."** It is — *unless the module honestly admits it and narrows the exposure*. This module is the documented exception; the gate is `loggedErrorHandler`. The opening comment names the exception so a reader of the file is told up-front rather than discovering it later.
- **"`quote(value)` JSON-stringifies the value."** It returns a wrapper *whose `toString` invokes `bestEffortStringify`* — `bestEffortStringify` is JSON-stringify-shaped but handles cycles, exotic objects, and uncatchable getters by falling back to placeholders. It cannot throw.
- **"`bare` is just `quote` without quotes."** It is — *but only if the input matches the `canBeBare` regex*. Non-matching inputs fall back to `quote`. The regex acts as a *safe-prose gate* against metacharacter injection.
- **"`canBeBare` is too restrictive — what about `foo.bar`?"** The dot is intentionally excluded. The regex permits `[\w:-]` (word, colon, hyphen) only. A property-path like `foo.bar` will fall back to `quote` and be JSON-rendered. The conservative regex prevents accidental injection of newlines, dollar-braces, or other format-string metacharacters.
- **"`hiddenDetailsMap` is just an obfuscation."** It is *structural unobservability*. A `DetailsToken` has no own properties; reading it directly via `for-in`/`Object.keys`/`JSON.stringify` reveals nothing. The substitutions live in the WeakMap; only code that holds a reference to the map can inspect them. The token's `toString` is the only intentional channel.
- **"`redactedDetails` vs `unredactedDetails` is a config-knob bug — they should be one function."** They are deliberately separate. The redacted form is the *safe default*; the unredacted form is reached only via an explicit `lockdown({ errorTaming: 'unsafe' })`. Conflating them would let unsafe behavior leak into safe code paths.
- **"Why are Errors special-cased in the type-tag rendering?"** Errors are common substitution targets in assert messages (`X\`got error ${err}\``), and rendering `(a TypeError)` is more useful than `(an Object)` because the constructor identity is *non-confidential* (it's a primitive class name). Object instances of arbitrary classes get the generic `(an Object)` to avoid leaking class-naming information that might be confidential.
- **"`(a TypeError)` reveals the error class — that's a leak."** Class names are *types*, not *contents*. The SES threat model considers types non-confidential (they are part of the platform's universal vocabulary); contents (property values, message text) are confidential by default. The redacted form leaks types but not contents, which is the intentional information-disclosure trade-off.
