---
source: packages/marshal/src/marshal-justin.js + packages/marshal/src/marshal-stringify.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/marshal/src
source_path: packages/marshal/src/marshal-justin.js, packages/marshal/src/marshal-stringify.js
section_kind: source
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
topics:
  - marshal
  - pass-style
  - errors
genre: §endo-source-comment-fragment §canonical-passable-rendering-pair
cycle: 189
lane: chat
status: current
title: §Cohesion notes
parent: endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js--two-pass-decoder-with-mirror-control-flow-and-indenter-trait-and-SGML-comment-injection-defense
---

- §Two-pass-decoder-with-mirror-control-flow (prepare
  validates; decode renders). §Comment-instructs-maintenance:
  "must visit everything in the same order."
- §Indenter-trait with §two-implementations (makeYesIndenter
  for readable + makeNoIndenter for minimum-whitespace).
- §badPair-detector with §SGML-comment-injection-defense
  (`<!` and `->` cases prevent accidental HTML-comment
  formation in minified output).
- §badArray-proxy in marshal-stringify rejects all slot
  position accesses; `length === 0` special case lets length-
  check pass.
- §`__proto__`-bracket-escape preserves JSON meaning vs JS
  prototype-set syntax.
- §nestedRender (try/finally-with-mutable-binding) for inline
  sub-string composition with different indenter.
- §passableAsJustin is the §CLAUDE.md-cited diagnostic API for
  passable rendering — preferred over JSON.stringify because
  JSON.stringify can't render remotables/promises.
- §`qp` template tag pairs with `q` from @endo/errors. §Lazy-
  vs-eager + §redact-vs-unredact: q is lazy and redacts; qp
  is eager and unredacts.
- §Three-layer-defense for the no-slot path: rejector functions
  + badArray proxy + serializer-side rejection.
- §`freeze` but not `harden` discipline for proxy targets
  (sibling to cycle 146 E.js).
- §`throw` is noop since `Fail` throws (linter workaround
  comment).
- §TODO-in-comment names §honest-known-blockers (fold-back to
  one pass; smallcaps test migration; double-angle-bracket
  necessity).
- §Eight-or-eleven qclass cases in the decoder (depending on
  how you count; including the synthesized error/hilbert
  cases).
- §Three-fail-fast-error-cases (cause + AggregateError +
  errors) for unimplemented features.
- §Thirteenth-member-of-§small-files-with-large-knowledge-
  density family (cycles 165/167/169/171/173/175/177/179/181/
  183/185/187/189 — well, technically 579 lines isn't small,
  but the §discipline-density-per-line is on par with the
  smaller files).
