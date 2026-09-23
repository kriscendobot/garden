---
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/pass-style/src/symbol.js
source_line_range: 1-123
file_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
file_commit_date: 2025-10-09
file_commit_author: Kris Kowal
comment_subject: passable symbols — Hilbert-Hotel encoding with forward-compatibility via throw
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-third comment-fragment ingest (cycle 148). 123-line
  tight file defining the *passable-symbol surface* for
  @endo/pass-style. Last touched 2025-10-09 by Kris Kowal in
  cycle 108's coordinated-update commit `e56bf00f` (the
  @endo/harden migration; same commit as cycles 108 + 110 +
  115 + 118 + 123 + 125 + 132 + 134 + 136 + 138 + 140 + 144 +
  148).

  Single most structurally interesting move: §Hilbert-Hotel
  encoding, *named explicitly in the file's JSDoc*. The naive
  encoding `name → Symbol.for(name)` claims every string for
  registered symbols, leaving no room for well-known symbols.
  The Hilbert-Hotel encoding shifts: `@@iterator` → well-known
  `Symbol.iterator`; `@@@@iterator` → registered
  `Symbol.for('@@iterator')`. Two encoding spaces are
  disjoint because well-known names don't start with `@@`
  (asserted at module load as a host-platform invariant —
  §fail-at-load-not-at-use discipline).

  §Two-kinds-of-passable-symbols: registered (via
  Symbol.for/keyFor) + well-known (static symbol values on
  the Symbol constructor). Anonymous Symbol(description)
  symbols are *not* passable (per-call unique; can't round-
  trip).

  §`wellKnownSymbolNames` Map built at module load by
  iterating `ownKeys(Symbol)`, filtering string keys whose
  value is `typeof === 'symbol'`, asserting no `@@`-prefixed
  name, mapping symbol-value → `@@name` wire form. §Identity-
  keyed-Map for symbol-singleton lookup.

  §Three-case-decoder `nameForPassableSymbol`: returns
  undefined for non-passable; double-prefix for registered-
  with-`@@`-prefix; `@@`-prefix for well-known; plain for
  registered.

  §Encoder-reverse `passableSymbolForName`: three-case parse
  with §forward-compatibility-via-throw discipline — *if name
  begins with `@@` it may encode a registered symbol from a
  future version of JavaScript, but it is not one we can
  decode yet, so throw*. §Throw-rather-than-lose-identity:
  the receiver might *later* gain the well-known symbol;
  silent fall-through to `Symbol.for` would map pre-upgrade
  and post-upgrade messages to different symbols, breaking
  equality.

  §`AtAtPrefixPattern = /^@@(.*)$/` compiled and hardened at
  module load. §regex-as-frozen-constant discipline.

  §`unpassableSymbolForName(name) = Symbol(name)` — one-line
  escape hatch for when callers want a symbol but don't need
  passability.

  §hideAndHardenFunction asymmetry: only on
  `assertPassableSymbol` (assertion function hides its name
  from stack traces — same discipline as cycles 134 / 138 /
  142). Other exports get plain `harden`.

  Foundational across the @endo/pass-style stack: cycle 71's
  passStyleOf dispatches `typeof === 'symbol'` here; cycle
  69's encodeToSmallcaps and cycle 81's encodePassable both
  use `nameForPassableSymbol`. §`@@`-prefix convention
  propagates through cycle 134's remotable.js (where
  `@@toStringTag` is the only allowed symbol property on
  remotables).

  §Symbol-passability-as-pass-style-leaf observation: symbols
  are *leaves* in the pass-style tree (cycle 71's classifier
  taxonomy). The §identity-vs-description-as-substrate
  distinction: well-known symbol's identity is its *role*;
  registered symbol's identity is its *registry string*;
  anonymous symbol's identity is *only* its allocation moment.

  Cycle 148 was nominally chat-lane (cycle 147 was designs).
  Papers-lane blocked 42+ consecutive cycles; chat-lane long
  exhausted at 20/20. Cycle 148 pivoted to comments-lane to
  continue the @endo/pass-style cluster (cycles 71 + 87 +
  134 + 136 + 138 + 140 + 142 + 148; this is the eighth
  pass-style file ingested).
---

> Abstract: `symbol.js` (123 lines) is the **passable-symbol
> surface** for @endo/pass-style. Defines what counts as
> *passable* (predicate + assertion), the bidirectional
> encoding between symbols and wire-form strings, and an
> escape hatch for non-passable.
>
> **Single most structurally interesting move**: §Hilbert-
> Hotel encoding, named explicitly. Two encoding spaces
> (well-known + registered) are disjoint because well-known
> names don't start with `@@` (host-platform invariant
> asserted at module load). Registered symbols whose name
> already starts with `@@` are shifted by *one more* `@@`.
> *Hilbert Hotel encoding technique* — make room for new
> guests by shifting existing guests over.
>
> §Two-kinds-of-passable-symbols: registered + well-known.
> Anonymous `Symbol(description)` excluded (can't round-
> trip).
>
> §`wellKnownSymbolNames` Map built at module load via
> `ownKeys(Symbol)` + filter + Map<symbol-value, @@name>.
> §Identity-keyed-Map; §fail-at-load-not-at-use precondition.
>
> §Three-case-decoder + §three-case-parser mirror.
>
> **§Forward-compatibility-via-throw discipline** (decode
> side): if `@@xxx` doesn't match a well-known symbol *this
> realm has*, throw — *it may encode a registered symbol from
> a future version of JavaScript, but it is not one we can
> decode yet*. §Throw-rather-than-lose-identity rather than
> silently falling through to `Symbol.for`.
>
> §hideAndHardenFunction only on `assertPassableSymbol`.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw](../sections/endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw.md) | pass-style, marshal, hardened-javascript | current |

Tight 123-line file. One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@HEAD` (commit
  `e56bf00f289ff8484094b785b11636b8bc71d87e`) via the local
  bare-clone.
- Last substantive touch 2025-10-09 by Kris Kowal in commit
  `e56bf00f` ("feat: Adopt @endo/harden"). Same coordinated-
  update commit as cycles 108 + 110 + 115 + 118 + 123 + 125 +
  132 + 134 + 136 + 138 + 140 + 144 + 148.
- **Thirty-third comment-fragment ingest.**
- Continues the @endo/pass-style cluster (cycles 71 + 87 +
  134 + 136 + 138 + 140 + 142 + 148; **eighth pass-style
  file**).
- Cycle 148 was nominally **chat-lane** (cycle 147 was
  designs). Papers-lane blocked **42+ consecutive cycles**;
  chat-lane long exhausted at 20/20. Cycle 148 pivoted to
  comments-lane.
- One cohesion-honest section.
