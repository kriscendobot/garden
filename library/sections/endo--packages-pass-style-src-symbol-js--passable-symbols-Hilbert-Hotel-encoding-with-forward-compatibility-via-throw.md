---
section: passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
source: endo--packages-pass-style-src-symbol-js
topics: [pass-style, marshal, hardened-javascript]
status: current
---

# Passable symbols: Hilbert-Hotel encoding with forward-compatibility via throw

> *Since the registration string of a registered symbol can
> be any string, if we simply used that to identify those
> symbols, there would not be any remaining strings left
> over to identify the well-known symbols. Instead, we
> reserve strings beginning with `"@@"` for purposes of this
> encoding... For registered symbols whose name happens to
> begin with `"@@"`, such as `Symbol.for('@@iterator')` or
> `Symbol.for('@@foo')`, we identify them by prefixing them
> with an extra `"@@"`, such as `"@@@@iterator"` or
> `"@@@@foo"`. **(This is the Hilbert Hotel encoding
> technique.)***
>
> — `packages/pass-style/src/symbol.js` lines 51-60

`symbol.js` (123 lines) is the **passable-symbol surface**
for @endo/pass-style. Defines what counts as a *passable
symbol* (predicate + assertion), the bidirectional encoding
between symbols and their wire-form string names, and an
escape hatch for non-passable symbols. Last touched 2025-10-09
by Kris Kowal in cycle 108's coordinated-update commit
`e56bf00f` (the @endo/harden migration that touched many
@endo files simultaneously).

## The §single most structurally interesting move — §Hilbert-Hotel encoding

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

## The §two-kinds-of-passable-symbols enumeration

```js
export const isPassableSymbol = sym =>
  typeof sym === 'symbol' &&
  (typeof Symbol.keyFor(sym) === 'string' || wellKnownSymbolNames.has(sym));
```

Two cases:

1. **Registered symbols**: created via `Symbol.for(name)`;
   `Symbol.keyFor(sym)` returns the registration string.
2. **Well-known symbols**: static symbol values on the
   `Symbol` constructor (`Symbol.iterator`, `Symbol.toStringTag`,
   `Symbol.asyncIterator`, etc.). Each is a *singleton* with
   identity across all realms (per the JS spec).

§Excluded: `Symbol(description)` symbols (anonymous, per-call
unique). These cannot be reliably round-tripped through wire-
form because the description isn't an identifier.

The §registered-via-keyFor + §well-known-via-Map-lookup
discipline: two different host APIs answer the
*is-this-passable* question; the predicate composes them with
OR.

## The §`wellKnownSymbolNames` Map built at module load

```js
const wellKnownSymbolNames = new Map(
  ownKeys(Symbol)
    .filter(name => typeof name === 'string' && typeof Symbol[name] === 'symbol')
    .filter(name => {
      !name.startsWith('@@') ||
        Fail`Did not expect Symbol to have a symbol-valued property name starting with "@@" ${q(name)}`;
      return true;
    })
    .map(name => [Symbol[name], `@@${name}`]),
);
```

The §Symbol-introspection-at-module-load discipline. Iterate
`ownKeys(Symbol)`; keep only string keys whose value is *a
symbol*; assert no well-known symbol's *name* starts with
`@@`; map each well-known symbol to its `@@`-prefixed wire
form.

The Map's keys are the *symbol values* themselves; lookup is
*identity-based* (`Map.has(sym)` matches the symbol singleton).
The §identity-keyed-Map discipline.

The §`!startsWith('@@') || Fail` invariant is the **single
host-platform precondition** that makes the Hilbert-Hotel
encoding sound. If the host platform ever introduces a
well-known symbol with a `@@`-prefixed *name* (e.g. `Symbol.atAt`
exposed as `Symbol['@@atAt']`), this module *fails loudly at
load time* rather than silently corrupting the encoding.

The §fail-at-load-not-at-use discipline: the invariant is
checked *once*, at module evaluation, when the realm's
`Symbol` constructor is examined. Future encodings/decodings
trust the invariant.

## The §three-case-decoder — `nameForPassableSymbol`

```js
export const nameForPassableSymbol = sym => {
  const name = Symbol.keyFor(sym);
  if (name === undefined) {
    return wellKnownSymbolNames.get(sym);
  }
  if (name.startsWith('@@')) {
    return `@@${name}`;
  }
  return name;
};
```

Three cases:

1. **`keyFor` returns `undefined`** → not registered. Fall
   back to the well-known-name Map. If it's not there, returns
   `undefined` (non-passable, e.g. `Symbol("foo")`).
2. **Registered with `@@`-prefix** → shift one room: prepend
   another `@@`.
3. **Registered without `@@`** → name as-is.

§Returns-undefined-for-non-passable: the encoder gracefully
declines to handle anonymous symbols rather than throwing.
Callers check the result.

## The §encoder-reverse — `passableSymbolForName`

```js
export const passableSymbolForName = name => {
  typeof name === 'string' ||
    Fail`${q(name)} must be a string, not ${q(typeof name)}`;
  const match = AtAtPrefixPattern.exec(name);
  if (match) {
    const suffix = match[1];
    if (suffix.startsWith('@@')) {
      return Symbol.for(suffix);
    } else {
      const sym = Symbol[suffix];
      if (typeof sym === 'symbol') {
        return sym;
      }
      Fail`Reserved for well known symbol ${q(suffix)}: ${q(name)}`;
    }
  }
  return Symbol.for(name);
};
```

The §three-case-parser mirrors the encoder:

1. **No `@@` prefix** → registered symbol via
   `Symbol.for(name)`.
2. **`@@` prefix + suffix starts with `@@`** → registered
   symbol whose name starts with `@@`, *shifted*: return
   `Symbol.for(suffix)` (one fewer `@@`).
3. **`@@` prefix + suffix is a well-known name** → return
   `Symbol[suffix]`.
4. **`@@` prefix + suffix is *not* a well-known name** →
   **throw**.

The §forward-compatibility-via-throw discipline (the most
structurally interesting decode-side move):

> *Otherwise, if name begins with `"@@"` it may encode a
> registered symbol from a future version of JavaScript, but
> it is not one we can decode yet, so throw.*

The §future-symbol-throws posture: the wire form might encode
a well-known symbol from a *future* version of JavaScript
that this realm doesn't yet have. Rather than silently
treating it as a registered symbol (which would *lose
identity* if the realm later upgrades), the decoder *refuses*
the encoding. The §throw-rather-than-lose-identity
discipline.

The alternative — *silently fall through to `Symbol.for`* —
would have a subtle bug: the receiver's realm might
*currently* not know `Symbol.futureSymbol` but might *later*
gain it; messages received before the upgrade would map to
registered symbols, while messages received after would map
to well-known symbols, breaking equality.

## The §`AtAtPrefixPattern` compiled at module load

```js
const AtAtPrefixPattern = /^@@(.*)$/;
harden(AtAtPrefixPattern);
```

The §regex-as-frozen-constant discipline. Compiled once,
hardened (so the prototype's `.exec` and `.lastIndex` can't
be tampered with via prototype pollution). The `^@@(.*)$`
matches *any* string starting with `@@`, capturing the rest.
Note: `(.*)` is non-greedy w.r.t. anchoring (the `$` forces
match to end of string), so `match[1]` is everything after
the *first* `@@`.

## The §`unpassableSymbolForName` escape hatch

```js
export const unpassableSymbolForName = name => Symbol(name);
```

§One-line export: given a name, produce an *anonymous* symbol
with that description. The §escape-hatch-for-when-passable-
isn't-needed discipline: callers who *want* a symbol but
don't need it to round-trip through marshal can use this
shortcut.

Not `harden`ed because `Symbol(name)` produces a fresh
symbol per call; there's no shared mutable state.

## The §hideAndHardenFunction asymmetry

Only `assertPassableSymbol` gets `hideAndHardenFunction`:

```js
export const assertPassableSymbol = sym =>
  isPassableSymbol(sym) ||
  Fail`Only registered symbols or well-known symbols are passable: ${q(sym)}`;
hideAndHardenFunction(assertPassableSymbol);
```

Whereas `isPassableSymbol` / `nameForPassableSymbol` /
`passableSymbolForName` get plain `harden`. The §hide-only-
assertion-functions discipline — same as cycle 134's
remotable.js, cycle 138's safe-promise.js, cycle 142's
passStyle-helpers.js: assertion functions hide their `.name`
from stack traces because the assertion's identity adds noise
to the call-site trace; the non-assertion exports retain
their name.

## How this file fits the @endo/pass-style stack

- **`packages/pass-style/src/passStyleOf.js`** (cycle 71)
  dispatches `typeof === 'symbol'` to `isPassableSymbol` from
  this file.
- **`packages/marshal/src/encodeToSmallcaps.js`** (cycle 69)
  and **`encodePassable.js`** (cycle 81) both use
  `nameForPassableSymbol` to convert symbols to wire form.
- **`@endo/marshal`'s decoder** uses `passableSymbolForName`
  to reconstruct symbols on the receiving end.
- The §`@@`-prefix convention propagates through cycle 134's
  `remotable.js` (where `@@toStringTag` is the only allowed
  symbol property on remotables).

## The §Symbol-passability-as-pass-style-leaf observation

Symbols are *leaves* in the pass-style tree (cycle 71's
passStyleOf classifier). The taxonomy distinguishes:

- **Passable symbols** (well-known + registered): can travel
  through marshal; reconstituted with *symbol identity*
  preserved across realms (well-known) or *registry string*
  preserved (registered).
- **Non-passable symbols** (anonymous `Symbol(description)`):
  marshal rejects them; equivalent to an error at encode time.

The §identity-vs-description-as-substrate distinction: a
well-known symbol's identity is its *role* (`Symbol.iterator`
*is* the iterator-protocol selector); a registered symbol's
identity is its *registry string*; an anonymous symbol's
identity is *only* its allocation moment, which doesn't
survive serialization.

## Related sections

- cycle 71
  [[endo--packages-pass-style-src-passstyleof-js--passStyle-classifier-internals]]
  — the passStyleOf classifier that dispatches symbols to this
  file's `isPassableSymbol`.
- cycle 69
  [[endo--packages-marshal-src-encodetosmallcaps-js--smallcaps-wire-format-rationale]]
  — the smallcaps encoder that uses `nameForPassableSymbol`.
- cycle 81
  [[endo--packages-marshal-src-encodepassable-js--rank-order-preserving-encoder]]
  — the rank-order encoder that also uses
  `nameForPassableSymbol`.
- cycle 134
  [[endo--packages-pass-style-src-remotable-js--two-distinct-shapes-with-tag-record-inheritance-and-canBeMethod-invariant]]
  — `@@toStringTag` is the only allowed symbol property on
  remotables; this file's encoding is what makes that name
  passable.
- cycle 108
  [[endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio]]
  — same coordinated-update commit `e56bf00f` (the
  @endo/harden migration).
