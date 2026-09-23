---
title: "@endo/pass-style/src/internal-types.js — the PassStyleHelper type definition as metalanguage"
source-slug: endo--packages-pass-style-src-internal-types-js
url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/internal-types.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/pass-style/src/internal-types.js
total-lines: 30
ingest-cycle: 266
ingest-date: 2026-06-10
lane: chat
---

# `@endo/pass-style/src/internal-types.js`

A 30-line `export {};` typedef-only file that defines the **`PassStyleHelper`** typedef — the **metalanguage** of the cluster's three concrete helpers (cycle 260 byteArray + cycle 262 copyArray + cycle 264 copyRecord). The relationship is parallel to cycle 265's CLAUDE.md observation: the `designs/CLAUDE.md` is metalanguage to design docs; the `internal-types.js` is metalanguage to PassStyleHelper instances. §Two-cycles-with-metalanguage-to-object-language-relationship-discovered-side-by-side.

## Key moves

- **§`export {};` typedef-only file pattern** — §four-cycles now (254 + 256 + 258 + 266); discipline reified across four cycles.
- **§The internal-types file depends on the public types not the other way around** — `Rejector` from `@endo/errors/rejector.js` + `PassStyle` from `./types.js`; §the-public-IS-stable + §the-internal-evolves-faster.
- **§The helpers cluster's `helpers-are-pure-not-ambient` discipline named explicitly** — the doc comment specifies that each helper should be pure and get `passStyleOf` or `passStyleOfRecur` from its caller; §inversion-of-control to avoid cyclic module dependency.
- **§The three attack classes implicit in the trust model** — must-defend (malicious candidate) + may-defend (bugs in passStyleOfRecur) + need-not-defend (malicious passStyleOfRecur). §The-trust-model-IS-asymmetric.
- **§The italicized `*assume*` as named emphasis on a load-bearing trust assumption** — the markdown italic in the comment IS the named emphasis on the trust relationship.
- **§The mutual-exclusivity property named explicitly** — *"If `confirmCanBeValid` returns true, then the candidate would definitely not be valid for any of the other helpers"*; the property is a protocol invariant documented in the typedef but enforced by the helpers' implementations.
- **§Multi-paragraph JSDoc property descriptions encode protocol invariants** — when the property's shape isn't enough, use multi-paragraph prose in the `@property` description.
- **§The PassStyleHelper typedef defines a three-property protocol** — styleName (PassStyle) + confirmCanBeValid + assertRestValid.

## Closing-the-pair: metalanguage cycle 265 + cycle 266

Cycle 265 ingested `designs/CLAUDE.md` as the canonical design-doc-template spec. Cycle 266 ingests `internal-types.js` as the canonical PassStyleHelper typedef. Both files stand in metalanguage position to a cluster of instances. §two-cycles-with-metalanguage-to-object-language-relationship-discovered-side-by-side — §the-metalanguage-pattern-now-recognized-at-two-different-scopes-in-the-same-week.

## Section files

- [§The PassStyleHelper type definition as metalanguage + §the three attack classes implicit in the trust model + §helpers are pure not ambient + §mutual-exclusivity property named in the type](../sections/endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient.md) — full 30-line file in scope.

## Ingest scope

Cycle 266 (chat-lane after cycle 265's designs-lane endo-but-for-bots/designs/CLAUDE.md). Full 30-line file ingested. **First-explicit-observations (nine)**: two-cycles-with-metalanguage-to-object-language-relationship-discovered-side-by-side + four-cycles-with-`export {};`-typedef-only-file-pattern + the-internal-types-file-depends-on-the-public-types-not-the-other-way-around + the-helpers-cluster's-`helpers-are-pure-not-ambient`-discipline-named-explicitly + the-three-attack-classes-implicit-in-the-trust-model-named-explicitly + the-italicized-`*assume*`-as-named-emphasis + the-mutual-exclusivity-property-named-explicitly-in-the-PassStyleHelper-type-definition + multi-paragraph-JSDoc-property-descriptions-encode-protocol-invariants + two-cycles-with-prose-encoded-invariants-where-structure-cannot-express.
