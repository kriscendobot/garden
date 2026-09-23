---
kind: result
role: liaison
dispatch-root: dispatches/liaison--ad4aea
cycle: 330
lane: chat
host: endolin
date: 2026-06-15
---

# Result — liaison cycle 330: @endo/marshal src/encodeToSmallcaps.js (chat-lane; third complementary-lens re-ingest; third Hilbert-Hotel application; new pivot-record longest arc)

Cycle 330 ingest: **@endo/marshal src/encodeToSmallcaps.js** (474 lines) — complementary-lens re-ingest of cycle 69's same file. **Twenty-first consecutive non-garden source after the pivot** (cycles 310-330). **§twenty-one-cycles-with-named-pivot-domain-stay**.

## Three milestones this cycle

**§three-cycles-with-named-complementary-lens-re-ingest** (322 exo-makers + 324 atomics + 330 smallcaps) — the librarian discipline is now established as recurring across three distinct prior ingests. Each cycle 322/324/330 added a second (or in cycle 330's case, fourth) section to a previously-ingested file with a complementary lens.

**§three-cycles-with-named-Hilbert-Hotel-encoding** (148 symbol-names + 328 QCLASS + 330 smallcaps) — the Hilbert-Hotel encoding technique now has three distinct applications:

| Cycle | Context | Cost | Bonus property |
|---|---|---|---|
| 148 (symbol.js) | `@@`-prefix for well-known symbols vs registered | Double-`@@` prefix per collision | (none) |
| 328 (capdata) | `@qclass` property collision in copyRecord | One extra object layer per collision | (none) |
| **330 (smallcaps)** | **`!`-prefix on string starting with special char** | **One byte per collision** | **Sort-order preservation** |

**§the-named-citation-arc-from-cycle-69-self-takes-261-cycles-to-close** — **NEW PIVOT-RECORD longest arc** (beats cycle 328's 259-cycle closure to cycle 69, because cycle 330 IS the same file with a complementary lens, making it a self-arc closure).

## Single most structurally interesting move

**§the-named-trivial-Hilbert-Hotel-via-character-range** — the smallcaps string-escape case is documented as *"trivially does the Hilbert hotel"* (line 184-187):

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
  return passable;
}
```

**§the-named-Hilbert-Hotel-IS-trivial-when-prefix-IS-in-the-special-range** — the technique is trivial here because the escape prefix (`!`) is *itself* in the special-character range (ASCII 33-45); no separate escape mechanism is needed. First-explicit-observation as a tier-3 transferable technique.

**§the-named-sort-order-preserving-encoding-discipline** — additionally, the smallcaps version *earns* a property that neither of the other two Hilbert-Hotel applications provided: sort-order preservation. The contiguous-range + minimum-character-as-escape gives a sort-stable prefix. Closes citation arc with cycle 81 encodePassable.js (the rank-order-preserving encoder).

## §the-named-sibling-file-shape-shared-between-capdata-and-smallcaps

Cycle 328 (capdata) and cycle 330 (smallcaps) share extensive structure:

- **Recur suffix naming** (`encodeToCapDataRecur` + `encodeToSmallcapsRecur`)
- **Three dontEncode default rejectors** (Remotable + Promise + Error)
- **encodeRecur callback parameter** for recursive composition
- **Exhaustive switch on passStyleOf** (11 cases + default)
- **Error special case at root** for diagnostic priority
- **byteArray TODO** (with the *same typo* "marsal" — sibling-file shared bug)
- **Verbatim rationale comment** *"This module is based on the encodePassable.js in @agoric/store"* — identical wording

The files differ ONLY in the *output format*: capdata produces nested `{ '@qclass': ..., ... }` objects; smallcaps produces prefixed strings. **§the-named-format-discriminator-collision-shifted-to-string-not-object** — capdata shifts collision-handling to the object level; smallcaps to the string level.

## Other first-explicit-observations

- §the-named-BANG-to-DASH-special-prefix-range (ASCII 33-45; 13 characters; 7 assigned + 6 reserved)
- §the-named-character-range-as-extensibility-zone (6 reserved characters await future use)
- §the-named-seven-prefix-discriminator-set (`!+-#%$&` for escaped-string + non-neg-bigint + neg-bigint + manifest-constant + symbol + remotable + promise)
- §the-named-bigint-sign-via-plus-vs-minus-prefix (smallcaps puts sign in prefix; capdata used digits property)
- §the-named-tag-pseudo-property (`'#tag'` as discriminator analogous to capdata's `@qclass`; `#` has TWO roles in smallcaps)
- §the-named-property-name-discriminator-prefix-discipline
- §the-named-startsSpecial-via-charCodeAt-comparison with §the-named-yoda-condition-disabled-deliberately
- §the-named-three-distinct-return-type-checks ($ for remotable + & for promise + #error for error) with §the-named-encoder-contract-via-output-prefix-check
- §the-named-compact-encoding-as-design-priority — smallcaps `#NaN` (5 bytes) vs capdata `{"@qclass":"NaN"}` (17 bytes); 3x compression
- §the-named-verbatim-rationale-comment-across-sibling-files; §two-cycles-with-named-verbatim-rationale-comment-across-sibling-files (cycle 320 lp32 + cycle 330 capdata/smallcaps)

## Multi-cycle patterns extended

- §twenty-one-cycles-with-named-pivot-domain-stay (310-330)
- §three-cycles-with-named-complementary-lens-re-ingest (322 + 324 + 330)
- §three-cycles-with-named-Hilbert-Hotel-encoding (148 + 328 + 330) — three distinct cost-profiles
- §twenty-nine-citation-arc-closures-in-pivot-now (25 + 4)
- §two-cycles-with-named-verbatim-rationale-comment-across-sibling-files (320 + 330)
- §the-named-citation-arc-from-cycle-69-self-takes-261-cycles-to-close (NEW pivot-record)

## Tier-3 meta-patterns

- **§the-named-Hilbert-Hotel-encoding parameterized by cost-profile** — three distinct cost-profiles documented across the library (double-prefix + object-wrap + one-byte trivial-in-special-range)
- **§the-named-sort-order-preserving-encoding-discipline** — when the encoding will be used for ordered comparison, the encoding must preserve sort order; contiguous-range-prefix + minimum-character-as-escape achieves this
- **§the-named-character-range-as-extensibility-zone** — reserve a contiguous range; the contiguousness preserves sort properties
- **§the-named-format-discriminator-collision-shifted-to-string-not-object** — capdata shifts collision-handling to object level; smallcaps to string level; the choice affects sort-order preservation and compactness
- **§the-named-sibling-file-shape-shared** — sibling files share *almost everything* except the format-specific part; the structure becomes a parametrizable template

## Synthesis-target

Slot machine library **§`@game/marshal/src/encodeToWireFormat.js`** (mirror of cycle 328 synthesis-target):

1. Contiguous character range as extensibility zone
2. Trivial Hilbert-Hotel via in-range prefix
3. Sort-order preservation as design property if encoding used for ordered comparison
4. Sign-via-prefix for signed numerics
5. Property-name-discriminator-prefix discipline
6. Encoder contract via output prefix check
7. Sibling-file shape shared with capdata-equivalent if multiple wire-format variants

## Library state after cycle 330

- §library-reaches-842-sections from 377 source documents (source count unchanged because smallcaps was already counted from cycle 69)
- §one-hundred-and-sixty-third consecutive designs-chat alternation
- §twenty-one-cycles-with-named-pivot-domain-stay
- §eleven-named-packages-in-the-pivot-cluster
- §twenty-nine-citation-arc-closures-in-pivot-now
- §three-cycles-with-named-complementary-lens-re-ingest (librarian discipline established across three applications)
- §three-cycles-with-named-Hilbert-Hotel-encoding (technique transferable across three contexts)
- §the-named-citation-arc-from-cycle-69-self-takes-261-cycles-to-close (new pivot-record longest arc)

## Next cycle pacing

Cycle 331 is designs-lane next. Candidate moves:

- **@endo/exo README.md** — designs-lane; companion to cycles 322 + 239 + 118 exo source-side ingests; would extend the exo cluster and likely close some long arcs.
- **@endo/promise-kit README.md** — would introduce a twelfth package; cycle 152 ingested memo-race.js from promise-kit.
- **@endo/common README.md** — would introduce a twelfth package; cited from cycle 326 patterns/index.js for deprecated re-exports.
- **@endo/init README.md** — cycle 329 marshal README cited @endo/init as the canonical harden installer; would close that 1-cycle arc.

@endo/exo README is the most productive (closes long arcs to cycles 108/118/239/322; extends an existing cluster rather than adding a new one). Picking freely but tracking for future work.
