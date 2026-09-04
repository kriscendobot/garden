---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Maintainer directive (2026-09-02, liaison session), based on the `llm`
branch: design an alternate pass-style representation for symbols, gated
behind a Node.js conditional-exports/imports build condition rather than
shipped as the default.

## Motivation, as given

For alignment with OCapN, among other reasons the design should substantiate:
eliminate support for passable **well-known symbols** (`Symbol.iterator` and
friends — today reified via `"@@" + propertyName`, see
`packages/pass-style/src/symbol.js`), and avoid `Symbol.for()` registered
symbols specifically because the global symbol registry is an unbounded,
process-lifetime, never-garbage-collected table keyed by string: if any path
lets untrusted content influence what string reaches `Symbol.for` (as
`passableSymbolForName` does today for any incoming passable symbol name),
an attacker can grow that table without bound — a durable memory-exhaustion
vector, not scoped to a compartment or vat. The design should confirm and
sharpen this threat model rather than take it as asserted.

## The agreed reified representation

The maintainers have agreed on:

```js
{ [Symbol.for('passStyle')]: 'symbol', [Symbol.toStringTag]: symbolName }
```

— a plain hardened **object**, not a primitive `Symbol` at all. This is not
a new mechanism: `packages/pass-style/src/passStyle-helpers.js` already
exports `PASS_STYLE = Symbol.for('passStyle')`, and
`packages/pass-style/src/passStyleOf.js`'s internal dispatcher already
special-cases exactly this shape — any frozen object carrying an own
`[PASS_STYLE]` property is routed by its string value straight to
`HelperTable[<value>]`, bypassing the generic `copyRecord`/`copyArray`/etc.
scan (see the `object` case around passStyleOf.js:180-186 as of this
writing). The proposal is to register a `'symbol'` entry in that table for
this shape.

**A real tension the design must resolve, found while grounding this brief,
not asserted**: `passStyleOf`'s dispatcher currently has TWO paths that can
each produce the string `'symbol'` — the existing `typeof inner === 'symbol'`
primitive-Symbol path (passStyleOf.js:157, `case 'symbol':`), and the new
`[PASS_STYLE]`-tagged-object path this design adds. Since this variant is
explicitly *not* the default, both paths coexist in the same running
process whenever the alternate condition is inactive — but the design still
needs to specify: does the tagged-object `HelperTable['symbol']` entry exist
unconditionally (harmless, since nothing produces that shape unless the
alternate encoder is in play), or is `HelperTable` itself part of what the
conditional swap changes? And on the decode side — `nameForPassableSymbol`/
`passableSymbolForName` in `symbol.js`, plus every encoder that calls them
(`encodeToSmallcaps.js:215-218`/`362-363`, `encodeToCapData.js:159-165`/
`366-368`, `encodePassable.js:679-683`/`774-777`) — a decoder must
reconstruct the *same kind* of value its sender's encoder produced, or a
round-trip across a sender/receiver pair running different variants breaks
silently. Specify exactly how much of this call chain is swapped together
as one unit under the condition, not just the leaf representation.

**`@endo/ocapn`'s selector convention** (`packages/ocapn/src/selector.js`,
`makeSelector`/`getSelectorName`, built directly on
`passableSymbolForName`/`nameForPassableSymbol`) sits squarely on this same
code path and was the concrete precedent the liaison was asked about just
before this directive. Since OCapN alignment is a stated motivation, the
design should say explicitly whether OCapN selectors adopt the alternate
representation under the same condition, or are deliberately left out of
scope for now, and why.

## The stated Ava advantage

Because the new representation is a plain object rather than an opaque
primitive `Symbol`, Ava's `t.deepEqual` can structurally compare two
instances by their `Symbol.toStringTag` name (and the `PASS_STYLE` tag)
directly, more closely approximating pass-by-copy equality than comparing
actual `Symbol` values ever could (two independently-produced `Symbol`
values with the same conceptual identity are `===`-unequal unless they
happen to share the same registry entry). Have the design note this
concretely — ideally with a small worked example or an early test proving
the claim — rather than repeat it as received wisdom.

## Not the default; switched by a Node conditional-exports/imports condition

This variant must **not** be the default pass-style-symbol implementation.
Introduce it as an alternate module selected via Node's package.json
conditional `exports`/`imports` resolution, gated on a custom condition
named `pass-style-symbol`, activated by running `node -C pass-style-symbol`
(equivalently `--conditions=pass-style-symbol`). Absent that flag, resolution
falls through to `"default"` — today's existing behavior, unchanged.
Concretely, the design should propose:

- Where the swap point lives: most likely an internal subpath `imports`
  alias (a `#`-prefixed specifier, package-private, not part of the public
  API) inside `@endo/pass-style` itself — e.g. something like
  `#pass-style-symbol-impl` resolving to today's `symbol.js` under
  `"default"` and to a new sibling module (implementing the same
  `isPassableSymbol`/`nameForPassableSymbol`/`passableSymbolForName`/
  `unpassableSymbolForName` surface, but producing/consuming the tagged-
  object shape) under the `pass-style-symbol` condition — with concrete
  `package.json` `imports` field wiring shown, not just described.
- **A load-bearing caveat to address, not gloss over**: Node resolves
  conditional exports/imports once, per process, for the whole module
  graph, at startup — it is not a per-call or per-package runtime toggle.
  Flipping the condition on therefore affects every consumer transitively
  loaded in that process, including tests and any other package that
  imports pass-style symbols indirectly. Specify a concrete test/CI
  strategy for exercising both branches (e.g. a second `test:pass-style-
  symbol` script running the existing Ava suite under `node -C
  pass-style-symbol`) and confirm empirically — don't assume — that Ava's
  own process/worker spawning actually forwards that flag to whatever
  process ultimately resolves the conditional import; if it does not, say
  so and propose a fix or a workaround.
- How a consumer's own build/typecheck step (the package's `.d.ts`
  generation, `tsc`, eslint) behaves under the non-default condition, so
  the alternate path doesn't silently bit-rot from lack of type coverage.

## Deliverable

A design document only — no implementation in this job. Land it as a PR
against `endojs/endo-but-for-bots`'s `llm` branch, in this repo's own design
convention (a `Created`/`Updated`/`Author`/`Status` table header, see
`designs/cbor-frame.md` for the shape — not the garden's own frontmatter
convention). Include an explicit "Open questions" section for whatever of
the tensions above remain genuinely unresolved rather than force a premature
answer, per this repo's normal design-PR review process.





<!-- garden-transient-elapsed: kind=signature through=2 values=2,1 -->

<!-- garden-reaped: 3 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T10:13:40Z
