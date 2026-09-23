---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--9311d3
ts: 2026-06-03T09:15:06Z
ref_id: 9311d3
---

# Cycle 148 result — pass-style/src/symbol.js (thirty-third comment-fragment ingest)

Cycle 148 of the librarian arc. Nominally chat-lane (exhausted at
20/20); papers-lane blocked **42+ consecutive cycles**. Pivoted to
comments-lane.

## Source

`endo/packages/pass-style/src/symbol.js` (123 lines). Last touch
2025-10-09 by Kris Kowal in cycle 108's coordinated-update commit
`e56bf00f` (the @endo/harden migration that touched many @endo
files; same commit as cycles 108 + 110 + 115 + 118 + 123 + 125 +
132 + 134 + 136 + 138 + 140 + 144 + 148).

**Eighth pass-style file ingested** (cycles 71 + 87 + 134 + 136 +
138 + 140 + 142 + 148). The passable-symbol surface for
@endo/pass-style.

## Structural moves captured

- **Single most structurally interesting move**: §Hilbert-Hotel
  encoding, *named explicitly in the file's JSDoc as a load-bearing
  trick*. The naive encoding `name → Symbol.for(name)` claims
  *every* string for registered symbols. The Hilbert-Hotel encoding
  shifts: `"@@iterator"` → `Symbol.iterator` (well-known);
  `"@@@@iterator"` → `Symbol.for("@@iterator")` (registered, shifted
  by one more `@@`). Two encoding spaces disjoint because well-known
  names *don't* start with `@@` (host-platform invariant asserted at
  module load).

- **§Two-kinds-of-passable-symbols**: registered (via Symbol.for/
  keyFor) + well-known (static symbol values on `Symbol`). Anonymous
  `Symbol(description)` symbols excluded (can't round-trip).

- **§`wellKnownSymbolNames` Map** built at module load via
  `ownKeys(Symbol)` + filter + identity-keyed-Map<symbol-value,
  `@@name`>.

- **§Fail-at-load-not-at-use discipline**: the `!startsWith('@@')
  || Fail` invariant is checked *once* at module evaluation. If the
  host platform ever introduces a well-known symbol whose *name*
  starts with `@@`, this module fails loudly at load rather than
  silently corrupting the encoding.

- **§Three-case-decoder** `nameForPassableSymbol`: returns undefined
  for non-passable; double-prefix for registered-with-`@@`-prefix;
  `@@`-prefix for well-known; plain for registered.

- **§Three-case-parser** `passableSymbolForName` mirrors the
  encoder with **§forward-compatibility-via-throw discipline** —
  *if name begins with `@@` it may encode a registered symbol from a
  future version of JavaScript, but it is not one we can decode yet,
  so throw*. §Throw-rather-than-lose-identity rather than silently
  falling through to `Symbol.for` (silent fall-through would break
  equality across realm upgrades — receiver might *later* gain the
  well-known symbol).

- **§`AtAtPrefixPattern = /^@@(.*)$/`** compiled and hardened at
  module load.

- **§`unpassableSymbolForName(name) = Symbol(name)`** — one-line
  escape hatch for anonymous-symbol creation.

- **§hideAndHardenFunction asymmetry**: only on
  `assertPassableSymbol` (assertion identity hidden from stack
  traces — same discipline as cycles 134 / 138 / 142).

## How this file fits the @endo/pass-style stack

- **Cycle 71's passStyleOf** dispatches `typeof === 'symbol'` to
  `isPassableSymbol`.
- **Cycle 69's encodeToSmallcaps** and **cycle 81's encodePassable**
  both use `nameForPassableSymbol`.
- **Cycle 134's remotable.js** allows `@@toStringTag` as the only
  symbol property on remotables — depends on this file's encoding.
- **Coordinated-update commit `e56bf00f` cluster** at 13 files now.

## Output summary

- **Source slug**: `endo--packages-pass-style-src-symbol-js`
- **Sections**: 1 cohesion-honest section
  - `endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw.md`
- **Topics**: pass-style, marshal, hardened-javascript
- **Library totals**: 652 sections from 193 source documents
- **Lane rotation**: nominally chat-lane (exhausted; papers-lane
  blocked 42+ consecutive cycles); pivoted to comments-lane

Cycle 148 closes. Schedule next wake 1500s for cycle 149.
