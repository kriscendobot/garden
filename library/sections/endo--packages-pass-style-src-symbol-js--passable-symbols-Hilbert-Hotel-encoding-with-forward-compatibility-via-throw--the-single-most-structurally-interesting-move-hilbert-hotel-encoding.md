---
section: passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
source: endo--packages-pass-style-src-symbol-js
topics: [pass-style, marshal, hardened-javascript]
status: current
title: The §single most structurally interesting move — §Hilbert-Hotel encoding
parent: endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
---

The Hilbert-Hotel-encoding-technique is named *explicitly* in
the file's JSDoc as a load-bearing trick. The problem:

> *Since the registration string of a registered symbol can
> be any string, if we simply used that to identify those
> symbols, there would not be any remaining strings left over
> to identify the well-known symbols.*

The naive encoding `name → Symbol.for(name)` claims *every*
string for registered symbols, leaving *no* room for
well-known symbols. The §Hilbert-Hotel-encoding solves this
by shifting:

| String form | Decodes to |
|-------------|-----------|
| `"foo"` | `Symbol.for("foo")` (registered) |
| `"@@iterator"` | `Symbol.iterator` (well-known) |
| `"@@@@iterator"` | `Symbol.for("@@iterator")` (registered, shifted) |
| `"@@@@@@foo"` | `Symbol.for("@@@@foo")` (registered, shifted) |

The §reference-to-Hilbert's-paradox encoding shifts the
"problematic" registered symbols (those whose name starts
with `@@`) *one room over* by adding another `@@`. Every
registered symbol gets a unique encoding; every well-known
symbol gets a unique encoding; the two encoding spaces are
disjoint because well-known names *don't* start with `@@` (the
host-platform invariant, asserted at module load).

The §infinite-room-by-shifting parallel to Hilbert's
infinite-hotel-of-rooms: the hotel is *full*, but you can
always make room for a new guest by shifting every existing
guest to the next room over. Here the "shift" is *prepending
two characters*.
