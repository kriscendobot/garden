---
title: "@endo/marshal src/encodeToSmallcaps.js — third complementary-lens re-ingest; trivial Hilbert-Hotel via character range + sort-order preservation; sibling-file comparison with cycle 328 capdata; pivot-cluster context"
source: endo--packages-marshal-src-encodetosmallcaps-js
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/encodeToSmallcaps.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/marshal/src/encodeToSmallcaps.js
total-lines: 474
ingest-cycle: 330
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-trivial-Hilbert-Hotel-via-character-range
  - the-named-Hilbert-Hotel-IS-trivial-when-prefix-IS-in-the-special-range
  - the-named-sort-order-preserving-encoding-discipline
  - the-named-BANG-to-DASH-special-prefix-range
  - the-named-character-range-as-extensibility-zone
  - the-named-seven-prefix-discriminator-set
  - the-named-startsSpecial-via-charCodeAt-comparison
  - the-named-yoda-condition-disabled-deliberately
  - the-named-compact-encoding-as-design-priority
  - the-named-sibling-file-shape-shared-between-capdata-and-smallcaps
  - the-named-bigint-sign-via-plus-vs-minus-prefix
  - the-named-tag-pseudo-property
  - the-named-property-name-discriminator-prefix-discipline
  - the-named-three-distinct-return-type-checks
  - the-named-encoder-contract-via-output-prefix-check
  - the-named-format-discriminator-collision-shifted-to-string-not-object
  - the-named-verbatim-rationale-comment-across-sibling-files
  - the-named-complementary-lens-re-ingest
  - three-cycles-with-named-Hilbert-Hotel-encoding
  - three-cycles-with-named-complementary-lens-re-ingest
  - twenty-one-cycles-with-named-pivot-domain-stay
---

# `@endo/marshal src/encodeToSmallcaps.js` — third complementary-lens re-ingest; trivial Hilbert-Hotel; sibling comparison

The 474-line encodeToSmallcaps.js encoder. Cycle 330 is **chat-lane after cycle 329's designs-lane @endo/marshal README**. **Twenty-first consecutive non-garden source after the pivot** (cycles 310-330). **§twenty-one-cycles-with-named-pivot-domain-stay**. **Eleventh package extends** (marshal; this is the third file from marshal in the pivot after cycle 328 encodeToCapData.js + cycle 329 README).

**Note on prior ingest**: This file was first ingested in **cycle 69** by a scholar dispatch as the second comment-fragment ingest in the library (lines 34-293). The cycle 69 sections took three angles: (1) special-character-prefix-scheme; (2) canonical-encoding-invariants; (3) error-encoding-root-special-case.

Cycle 330 is a **§the-named-complementary-lens-re-ingest** (librarian discipline named in cycle 322 for exo-makers.js, applied to atomics.js in cycle 324). **§three-cycles-with-named-complementary-lens-re-ingest** (322 + 324 + 330) — the librarian discipline now has **three confirmed applications**, establishing it as a recurring pattern. The cycle 330 lens emphasizes:

1. **Sibling-file-shape comparison with cycle 328 encodeToCapData.js** — both files implement the same encoder/decoder pattern; what's *shared* and what *differs* by format choice
2. **Hilbert-Hotel encoding as a third application** — cycle 148 symbol-names + cycle 328 QCLASS + cycle 330 smallcaps string-escaping; **§three-cycles-with-named-Hilbert-Hotel-encoding**
3. **Sort-order preservation** as a load-bearing extra property smallcaps gets that capdata doesn't
4. **Pivot-cluster context** — how this file relates to cycles 328 + 329 + 81

## The single most structurally interesting move

**§the-named-trivial-Hilbert-Hotel-via-character-range** — the string-escape case (line 182-189) is documented in the source comment as *trivially* applying the Hilbert-Hotel:

```js
case 'string': {
  if (startsSpecial(passable)) {
    // Strings that start with a special char are quoted with `!`.
    // Since `!` is itself a special character, this trivially does
    // the Hilbert hotel. Also, since the special characters are
    // a continuous subrange of ascii, this quoting is sort-order
    // preserving.
    return `!${passable}`;
  }
  // All other strings pass through to JSON
  return passable;
}
```

This is the **third instance** of the Hilbert-Hotel encoding technique in the library (after cycle 148 symbol-name escaping and cycle 328 QCLASS collision-handling). What makes the smallcaps application *trivial* vs the others:

| Hilbert-Hotel instance | How it works | Cost |
|---|---|---|
| Cycle 148 symbol.js (`@@`-prefix) | Double-`@@` for registered symbol names that collide with well-known | One extra `@@` prefix per collision |
| Cycle 328 capdata (`@qclass`) | Wrap in `{ [QCLASS]: 'hilbert', original, rest }` | One extra object layer per collision |
| **Cycle 330 smallcaps (`!`-prefix)** | **`!` prepended to any string starting with a special char** | **One byte per collision** |

The smallcaps version is *trivial* because the discriminator (`!`) is itself *in* the special-character range — no separate escape mechanism needed; just re-apply the same prefix. **§the-named-Hilbert-Hotel-IS-trivial-when-prefix-IS-in-the-special-range** — first-explicit-observation as a tier-3 transferable technique.

But the smallcaps Hilbert-Hotel also *earns an additional property* that neither of the other two provided:

**§the-named-sort-order-preserving-encoding-discipline** — the source comment says *"since the special characters are a continuous subrange of ascii, this quoting is sort-order preserving."* The encoded form preserves the same sort order as the natural form. **§the-named-sort-order-preservation-as-encoding-property** — first-explicit-observation. This is load-bearing because smallcaps strings end up in encodings used for *rank-ordered comparisons* (cycle 81 encodePassable.js — closes citation arc).

The sort-order-preservation comes from two combined properties: (1) the special characters form a *contiguous* ASCII range (33-45); (2) the chosen escape prefix (`!`, ASCII 33) is the *minimum* of that range. Together they ensure that `!`+anything sorts before any character ≥ ASCII 33 that isn't escaped, and `!`+`!`+anything sorts before `!`+anything that isn't escaped. The escape acts like a sort-stable prefix.

## §the-named-BANG-to-DASH-special-prefix-range

ASCII codes 33 (`!`) to 45 (`-`) form a 13-character contiguous range reserved as the special-prefix zone:

```
!"#$%&'()*+,-
33                            45
```

Of these 13 reserved characters, **seven** are currently assigned to specific roles:

| Prefix | Role | Example |
|---|---|---|
| `!` | escaped string | `!#NaN` (a string literally `#NaN`) |
| `+` | non-negative bigint | `+0` for `0n` |
| `-` | negative bigint | `-1` for `-1n` |
| `#` | manifest constant or property-name prefix | `#NaN`, `#undefined`, `#tag`, `#error` |
| `%` | symbol | `%@@iterator` for `Symbol.iterator` |
| `$` | remotable | `$0` for slot 0 |
| `&` | promise | `&0` for slot 0 |

The remaining six (`"'()*,`) are reserved for future use. **§the-named-character-range-as-extensibility-zone** — first-explicit-observation. The 13-character window gives smallcaps headroom for *future* discriminators without breaking existing encodings.

**§the-named-seven-prefix-discriminator-set** — the seven currently-used prefixes; first-explicit-observation as a parameterized set.

## §the-named-sibling-file-shape-shared-between-capdata-and-smallcaps

Cycle 328 encodeToCapData.js and cycle 330 encodeToSmallcaps.js share extensive structure:

| Pattern | capdata (cycle 328) | smallcaps (cycle 330) |
|---|---|---|
| **Recur suffix naming** | `encodeToCapDataRecur` interior + `encodeToCapData` entry point | `encodeToSmallcapsRecur` interior + `encodeToSmallcaps` entry point |
| **Three dontEncode default rejectors** | `dontEncodeRemotableToCapData` + `dontEncodePromiseToCapData` + `dontEncodeErrorToCapData` | `dontEncodeRemotableToSmallcaps` + `dontEncodePromiseToSmallcaps` + `dontEncodeErrorToSmallcaps` |
| **encodeRecur callback parameter** | `(value, encodeToCapDataRecur) => Encoding` | `(value, encodeToSmallcapsRecur) => SmallcapsEncoding` |
| **Exhaustive switch on passStyleOf** | 11 cases + default | 11 cases + default |
| **Error special case at root** | `if (isErrorLike(passable))` at top-level | Same |
| **byteArray TODO** | `throw Fail\`marsal of byteArray not yet implemented\`` | `throw Fail\`marsal of byteArray not yet implemented\`` (same typo: *"marsal"* — sibling-file shared bug?) |
| **Verbatim rationale comment** | `// This module is based on the encodePassable.js in @agoric/store` | **Same comment, same wording** |
| **Hilbert-Hotel encoding** | Yes (for QCLASS collision in copyRecord) | Yes (for `!`-prefix in string) |

**§the-named-sibling-file-shape-shared-between-capdata-and-smallcaps** — first-explicit-observation. The two files share *almost everything* except the *output format*: capdata produces nested `{ '@qclass': ..., ... }` objects; smallcaps produces prefixed strings.

**§the-named-verbatim-rationale-comment-across-sibling-files** (already named in cycle 320 lp32 reader/writer for the DataView byte-order rationale) — recurs here for the encodePassable-genesis rationale. **§three-cycles-with-named-verbatim-comment-across-sibling-files**? Actually no, cycle 320 was about *one* file (lp32 reader) and cycle 330 is *between* two files (capdata + smallcaps). Different application of the same discipline. **§three-cycles-with-named-verbatim-rationale-comment-across-sibling-files** (cycle 320 lp32 reader/writer + cycle 322 within exo-tools + cycle 330 capdata/smallcaps — well, only verifying for cycle 320 + cycle 330 here; 322 used cite-the-sibling instead. So §two-cycles-with-named-verbatim-comment-across-sibling-files).

**§the-named-format-discriminator-collision-shifted-to-string-not-object** — smallcaps shifts the discriminator from the *object-level* (capdata's `@qclass` property) to the *string-level* (smallcaps's prefix character). The string-vs-object distinction is structurally significant:
- Object-level discriminators require nested structure but allow named properties
- String-level discriminators preserve string-position (sort order!) and are more compact but require fixed-character vocabulary

## Other key moves (complementary to cycle 69's three sections)

- **§the-named-bigint-sign-via-plus-vs-minus-prefix** (line 208-211) — `+0n` encodes as `'+0'`; `-1n` encodes as `'-1'`. The sign is *in the prefix*, not in the digits. Capdata (cycle 328) put `digits: String(passable)` in a `digits` named property and lost the sign-as-prefix advantage. **§the-named-sign-in-prefix-not-in-digits**. First-explicit-observation.

- **§the-named-tag-pseudo-property** (line 236-241) — `'#tag': ...` for the tagged-pass-style encoding. The `#` prefix appears in *two* roles in smallcaps: (1) manifest-constant values like `#NaN`; (2) discriminator property names like `#tag` and `#error`. **§the-named-property-name-discriminator-prefix-discipline** — first-explicit-observation.

- **§the-named-startsSpecial-via-charCodeAt-comparison** (line 78-86) — `BANG <= code && code <= DASH` for the range check on first character. The comment notes *"charCodeAt(0) and number compare is a bit faster"* than string comparison. **§the-named-charCodeAt-performance-discipline** — first-explicit-observation.

- **§the-named-yoda-condition-disabled-deliberately** (line 84) — `// eslint-disable-next-line yoda` — the BANG-first comparison is structurally a *range check*, not a yoda condition; the eslint rule misfires because the constant is on the left. First-explicit-observation. Sibling to cycle 324's line-level eslint-disable discipline (for no-bitwise).

- **§the-named-three-distinct-return-type-checks** (line 243-251, 253-261, 263-265) — each encoder's result is asserted to start with the specific discriminator: `$` for remotable, `&` for promise, `#error` for error. **§the-named-encoder-contract-via-output-prefix-check** — first-explicit-observation. The encoder *must* produce a specific shape; the wrapper validates.

- **§the-named-compact-encoding-as-design-priority** — closes citation arc with cycle 329 README's side-by-side comparison. Smallcaps `#NaN` (5 bytes) vs capdata `{"@qclass":"NaN"}` (17 bytes) — 3x compression on common edge cases. First-explicit-observation.

## §the-named-citation-arcs

- Cycle 329 README → 330 (1 cycle; fifth one-cycle README↔source arc closure — but cycle 329 was designs-lane, cycle 330 is chat-lane, and they're for different files; actually this might not count as a clean README↔source arc since the README cited smallcaps in passing, not directly. Closer arc: cycle 328 → 330 = 2 cycles, **smallcaps and capdata sibling-pair after cycle 329 README**.
- Cycle 148 symbol.js (Hilbert-Hotel) → 330 = 182 cycles
- Cycle 69 encodeToSmallcaps (prior ingest) → 330 = 261 cycles — **NEW pivot-record longest arc** (beats cycle 328's 259-cycle closure to cycle 69, because cycle 330 IS the same file with a new lens)
- Cycle 81 encodePassable (rank-order preserver) → 330 via sort-order-preservation property = 249 cycles

Four arc closures. **§twenty-nine-citation-arc-closures-in-pivot-now** (25 + 4).

## Patterns the cycle extends

- §twenty-one-cycles-with-named-pivot-domain-stay (310-330)
- §three-cycles-with-named-Hilbert-Hotel-encoding (148 + 328 + 330) — **discipline confirmed as transferable across three contexts**
- §three-cycles-with-named-complementary-lens-re-ingest (322 + 324 + 330) — **librarian discipline confirmed across three applications**
- §twenty-nine-citation-arc-closures-in-pivot-now (added cycle 148 = 182 + cycle 69 self = 261 + cycle 81 = 249 + cycle 328 sibling = 2; 4 new closures)
- §the-named-citation-arc-from-cycle-69-self-takes-261-cycles-to-close (cycle 330 is complementary-lens re-ingest of cycle 69's file; NEW pivot-record longest arc)
- §two-cycles-with-named-verbatim-rationale-comment-across-sibling-files (cycle 320 + cycle 330)

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags marked first-explicit-observation above. Highest-portability:

- **§the-named-trivial-Hilbert-Hotel-via-character-range** (third application of the technique)
- **§the-named-sort-order-preserving-encoding-discipline** with sort-stable-prefix property
- **§the-named-character-range-as-extensibility-zone** (six reserved characters await future use)
- **§the-named-sibling-file-shape-shared-between-capdata-and-smallcaps** with the format-discriminator-collision-shifted-to-string-not-object distinction
- **§the-named-encoder-contract-via-output-prefix-check** (three distinct return-type checks)
- **§the-named-bigint-sign-via-plus-vs-minus-prefix** vs capdata's digits-property approach
- **§the-named-charCodeAt-performance-discipline** with deliberately-disabled yoda lint

## Tier-2 borrowing (multi-cycle patterns extended)

- §twenty-one-cycles-with-named-pivot-domain-stay
- §three-cycles-with-named-Hilbert-Hotel-encoding (148 + 328 + 330)
- §three-cycles-with-named-complementary-lens-re-ingest (322 + 324 + 330)
- §twenty-nine-citation-arc-closures-in-pivot-now
- §the-named-citation-arc-from-cycle-69-self-takes-261-cycles-to-close (new pivot-record)
- §two-cycles-with-named-verbatim-rationale-comment-across-sibling-files

## Tier-3 borrowing (meta-patterns)

- **§the-named-Hilbert-Hotel-encoding** as a *parameterized* meta-pattern with **three distinct cost-profiles** (cycle 148 double-prefix; cycle 328 object-wrap; cycle 330 one-byte trivial-when-prefix-is-in-special-range)
- **§the-named-sort-order-preserving-encoding-discipline** — when the encoding will be used for ordered comparisons (rank-ordering, sort-keys), the encoding must preserve sort order; the contiguous-range-prefix trick achieves this with one-byte cost
- **§the-named-character-range-as-extensibility-zone** — reserve a *contiguous* range of characters for future discriminators; the contiguousness preserves sort properties
- **§the-named-format-discriminator-collision-shifted-to-string-not-object** — capdata shifts collision-handling to the object level; smallcaps shifts to the string level; the choice affects sort-order preservation and compactness
- **§the-named-sibling-file-shape-shared** — sibling files (capdata + smallcaps) share *almost everything* except the output format; the shape-shared structure is itself a reusable pattern (the format is a parameter)

## Synthesis-target

Slot machine library **§`@game/marshal/src/encodeToWireFormat.js`** (mirror of cycle 328 synthesis-target):

1. **Contiguous character range as extensibility zone** — pick a range of 10-15 characters at low ASCII; reserve all of them; document which are used and which are reserved.
2. **Trivial Hilbert-Hotel via in-range prefix** — pick the escape prefix from within the special range itself (typically the lowest); strings starting with any special character get one more copy of the escape prefix.
3. **Sort-order preservation as design property** — if the encoding will be used for ordered comparison, document the sort-order-preservation property explicitly.
4. **Sign-via-prefix for signed numerics** — use `+` and `-` (or analogous) as discriminator prefixes for non-negative vs negative, rather than encoding the sign in the digits.
5. **Property-name-discriminator-prefix discipline** — if the encoding uses property names for discrimination, choose a prefix character that can't appear in natural property names; document the dual role (value-prefix vs property-name-prefix) if applicable.
6. **Encoder contract via output prefix check** — when calling user-supplied encoders, validate the output's prefix matches the expected discriminator; throw on mismatch.
7. **Sibling-file shape shared with capdata-equivalent** — if there are multiple wire-format variants, share the structure (Recur naming, dontEncode family, encodeRecur callback, exhaustive switch, error special case at root, byteArray TODO).

## Library state after cycle 330

- §library-reaches-842-sections from 377 source documents (source count unchanged because smallcaps was already in library from cycle 69)
- §one-hundred-and-sixty-third consecutive designs-chat alternation
- §twenty-one-cycles-with-named-pivot-domain-stay
- §eleven-named-packages-in-the-pivot-cluster
- §twenty-nine-citation-arc-closures-in-pivot-now
- §three-cycles-with-named-Hilbert-Hotel-encoding (technique transferable across three contexts)
- §three-cycles-with-named-complementary-lens-re-ingest (librarian discipline established as recurring across three applications)
- §the-named-citation-arc-from-cycle-69-self-takes-261-cycles-to-close (new pivot-record longest arc; beats cycle 328's 259)
