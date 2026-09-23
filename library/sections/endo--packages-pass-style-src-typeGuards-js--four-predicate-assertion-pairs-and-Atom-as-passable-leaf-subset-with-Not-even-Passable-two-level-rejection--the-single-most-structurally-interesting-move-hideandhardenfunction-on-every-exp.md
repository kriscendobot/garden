---
section: four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection
source: endo--packages-pass-style-src-typeGuards-js
topics: [pass-style, hardened-javascript, marshal]
status: current
title: The §single most structurally interesting move — §hideAndHardenFunction on every export
parent: endo--packages-pass-style-src-typeGuards-js--four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection
---

> *Every single one of the eight exports gets
> `hideAndHardenFunction`, not just the assertions.*

The §all-predicates-and-assertions-hide-name discipline. This
is a *departure* from the cycle 134 / 138 / 142 pattern
where only *assertion* functions were hidden:

- **Cycle 134** (`remotable.js`): only `assertIface` is
  hidden; `isObjectRemotable` etc. retain their `.name`.
- **Cycle 138** (`safe-promise.js`): only `assertSafePromise`
  is hidden; `isSafePromise` retains its `.name`.
- **Cycle 142** (`passStyle-helpers.js`): only assertion-like
  predicates hidden (`confirmPassStyle`, `confirmTagRecord`,
  `confirmFunctionTagRecord`); raw lookups (`getTag`,
  `isPrimitive`) retain `.name`.
- **Cycle 148** (`symbol.js`): only `assertPassableSymbol`
  hidden; `isPassableSymbol` etc. retain `.name`.

**typeGuards.js does it differently**: every export — `isX`
*and* `assertX` *and* `isAtom` *and* `assertAtom` — gets
`hideAndHardenFunction`. The §user-facing-thin-wrapper
discipline: these are *meant* to be invoked as named
references in stack traces from user code, where their
identity is *uninformative* (the user already knows what
they're checking). The wrappers' identity adds noise.

The §wrapper-identity-irrelevant observation: a one-line
`val => passStyleOf(val) === 'copyArray'` is *less* informative
in a stack trace than the *caller's* identity. Hiding the
wrapper concentrates the trace on the calling site.

This is one of the few @endo files where the §hide-everything
rather than §hide-only-assertions discipline applies. Worth
noting as a *style departure* in the otherwise-consistent
hide-only-assertion pattern across the rest of @endo/pass-style.
