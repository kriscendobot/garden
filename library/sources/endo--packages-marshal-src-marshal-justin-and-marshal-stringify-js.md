---
title: '@endo/marshal: src/marshal-justin.js + src/marshal-stringify.js'
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/marshal/src
source_paths:
  - packages/marshal/src/marshal-justin.js
  - packages/marshal/src/marshal-stringify.js
authors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
ingested: 2026-06-04
ingested_by: scholar
topics:
  - marshal
  - pass-style
  - errors
sections:
  - endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js--two-pass-decoder-with-mirror-control-flow-and-indenter-trait-and-SGML-comment-injection-defense.md
genre: §endo-source-comment-fragment §canonical-passable-rendering-pair
cycle: 189
lane: chat
---

# @endo/marshal: passable-rendering pair (justin + stringify)

## Files

| File | Lines | Role |
|------|-------|------|
| `packages/marshal/src/marshal-justin.js`     | 510 | Two-pass decoder + Indenter trait + passableAsJustin + qp |
| `packages/marshal/src/marshal-stringify.js`  |  69 | No-slot stringify/parse + badArray proxy |

## §Abstract

`marshal-justin.js` (510 lines) renders a passable value as a
Justin expression — a HardenedJS subset that, when evaluated
in a Justin-aware host (with `makeTagged`,
`passableSymbolForName`, `slotToVal`, and error constructors
in scope), reconstructs the original passable. `passableAsJustin`
is the CLAUDE.md-cited diagnostic API for rendering passables
in log messages (preferred over `JSON.stringify` which can't
render remotables/promises).

§The-key-mechanism: §two-pass-decoder-with-mirror-control-flow
(`prepare` validates; `recur` renders) feeding an §Indenter-
trait with §two-implementations (`makeYesIndenter` for readable
+ `makeNoIndenter` for minimum-whitespace). §The-minified-
indenter uses §badPair-detector regex `/^(?:\w\w|<<|>>|\+\+|
--|<!|->)$/` to decide when whitespace is required; §the-`<!`-
and-`->`-cases prevent §accidental-formation-of-html-like-
comment in HTML-embedded JavaScript contexts.

`marshal-stringify.js` (69 lines) is the §no-slot-marshal that
implements JSON.stringify-compatible round-trip via:

- §rejector-pair `doNotConvertValToSlot` + `doNotConvertSlotToVal`
  ensures serialize rejects presences/promises and parse
  rejects any body containing slot encodings.
- §badArray-proxy as the slots array — `length === 0` special
  case; any other property access throws "Marshal's parse
  must not encode any slot positions {name}."

`qp` template tag (in marshal-justin.js) pairs with `q` from
`@endo/errors`. §`q` is lazy and redacts; §`qp` is eager and
unredacts. §The-pair-covers §two-substitution-use-cases.

## §Files and identifiers

| File | Lines | Role |
|------|-------|------|
| `packages/marshal/src/marshal-justin.js` | 510 | Two-pass decoder + Indenter trait |
| `packages/marshal/src/marshal-stringify.js` | 69 | No-slot stringify/parse |
| (exported) `passableAsJustin` | — | CLAUDE.md-cited diagnostic API |
| (exported) `qp` | — | Quote-passable-as-quasi-quoted-Justin template tag |

## §Provenance and dependencies

- §Built-on cycle 74 (`marshal.js`) — `makeMarshal` substrate.
- §Built-on cycle 87 (`error/assert.js`) — `Fail`, `q`, `X`
  template tags.
- §Built-on cycle 152 (`pass-style/symbol.js`) —
  `nameForPassableSymbol`, `passableSymbolForName` (Hilbert-
  Hotel encoding).
- §Built-on cycle 69 (`encodeToSmallcaps.js`) — alternative
  body format (TODO migration deferred to fix tests).
- §Built-on cycle 81 (`encodePassable.js`) for the encoding
  taxonomy.
- §Built-on cycle 146 (`E.js`) — §freeze-but-not-harden-proxy-
  target discipline cited verbatim.
- §Built-on `@endo/nat` — `Nat(index)` validates slot indices.

## §Related sources in the library

- §Cycle 74 (`endo--packages-marshal-src-marshal-js.md`) —
  parent makeMarshal substrate.
- §Cycle 69 (`endo--packages-marshal-src-encodetosmallcaps-js.md`)
  — alternative body format; marshal-stringify uses capdata
  with TODO to migrate.
- §Cycle 81 (`endo--packages-marshal-src-encodepassable-js.md`)
  — encoding taxonomy sibling.
- §Cycle 87 (SES error/assert) — Fail/q/X template tags.
- §Cycle 152 (`endo--packages-pass-style-src-symbol-js.md`)
  — Hilbert-Hotel encoding round-trip preserved.
- §Cycle 146 (`endo--packages-eventual-send-src-E-js.md`) —
  §freeze-but-not-harden-proxy-target discipline shared.
- §Cycle 184 (`endo-but-for-bots--llm-designs-daemon-xs-worker-
  metering.md`) — §three-mechanisms-eliminated by invariant
  sibling at a different scale.
- §CLAUDE.md project instructions cite `passableAsJustin` as
  the recommended diagnostic API: "When rendering a passable
  value for a log message, use `passableAsJustin` from
  `@endo/marshal` rather than `JSON.stringify`."

## §Comment fragments worth preserving

```
Its control flow should mirror `recur` as closely as possible
and the two should be maintained together. They must visit
everything in the same order.

TODO now that ibids are gone, we should fold this back together
into one validating pass.
```

§The-§two-pass-maintenance-invariant + §TODO-named-explicitly.
§The-two-pass-structure-is-a-historical-artifact from when
ibids existed.

```
The `<!` and `->` cases prevent the accidental formation of an
html-like comment. I don't think the double angle brackets are
actually needed but I haven't thought about it enough to remove
them.
```

§The-§SGML-comment-injection-defense named + §honest-uncertainty
about the double-angle-bracket cases. §The-defense-is-cheap;
the-uncertainty-is-named-rather-than-silently-kept.

```
`freeze` but not `harden` the proxy target so it remains
trapping.
Thus, it should not be shared outside this module.
```

§Same-discipline-as-cycle-146-E.js' §freeze-but-not-harden
sibling. §Both-files-cite-the-same-§preparing-for-stabilize doc.

```
// JavaScript interprets `{__proto__: x, ...}`
// as making an object inheriting from `x`, whereas
// in JSON it is simply a property name. Preserve the
// JSON meaning.
```

§The-§`__proto__`-bracket-escape rationale. §Names-the-
discrepancy-between-JSON-and-JS-object-literal-semantics.

```
`q` is lazy, minimizing the cost for using it in an error
that's never logged. Unfortunately, due to layering
constraints, `qp` is not lazy, always rendering to quasi-
quoted Justin immediately.
```

§The-§lazy-vs-eager-asymmetry between q and qp. §Honest-
limitation-named in the doc comment.

```
// `throw` is noop since `Fail` throws. But linter confused
throw Fail`Marshal's parse must not encode any slot positions ${name}`;
```

§The-§linter-workaround-comment. §ESLint-can't-see Fail always
throws.
