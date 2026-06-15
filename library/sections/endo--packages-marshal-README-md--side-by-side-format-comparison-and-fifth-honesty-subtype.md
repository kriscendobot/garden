---
title: "@endo/marshal README.md — side-by-side smallcaps/original format comparison; fifth honesty-about-API-tradeoffs subtype (functionality-not-supported); convertValToSlot/convertSlotToVal pair; fourth one-cycle README↔source arc"
source: endo--packages-marshal-README-md
url: https://github.com/endojs/endo/blob/master/packages/marshal/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/marshal/README.md
total-lines: 188
ingest-cycle: 329
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-side-by-side-format-comparison-discipline
  - the-named-marshalling-IS-named-conversion-of-structured-data
  - the-named-capability-bearing-data-IS-named-special-data
  - the-named-slot-identifier-as-named-indirection-mechanism
  - the-named-CapData-structure-IS-named-body-plus-slots
  - the-named-parameterized-with-two-functions-discipline
  - the-named-convertValToSlot-and-convertSlotToVal-named-pair
  - the-named-side-table-pattern
  - the-named-makePassableKit-as-alternative-API
  - the-named-legacyOrdered-vs-compactOrdered
  - the-named-PR-citation-for-historical-context
  - the-named-format-variation-with-named-historical-default
  - the-named-rejected-mixed-objects
  - the-named-Empty-Objects-are-pass-by-copy-with-Far-as-alternative
  - the-named-Far-IS-named-empty-marker-for-identity-comparison
  - the-named-rights-amplification-IS-named-canonical-pattern
  - the-named-more-tolerant-and-less-tolerant-IS-named-symmetric-comparison-discipline
  - the-named-explicit-error-vs-silent-omission-discipline
  - the-named-no-replacer-or-reviver-customization
  - the-named-honesty-about-API-tradeoffs-gains-fifth-subtype
  - the-named-functionality-not-supported-at-all-subtype
  - the-named-stringify-vs-toCapData-with-no-slots
  - the-named-intra-document-cross-section-anchoring
  - twenty-cycles-with-named-pivot-domain-stay
  - twenty-five-citation-arc-closures-in-pivot-now
  - four-cycles-with-named-one-cycle-README-source-arc
  - five-cycles-with-named-honesty-about-API-tradeoffs
---

# `@endo/marshal README.md` — side-by-side format comparison; fifth honesty-subtype

The 188-line README for `@endo/marshal`. Cycle 329 is **designs-lane after cycle 328's chat-lane @endo/marshal src/encodeToCapData.js**. **Twentieth consecutive non-garden source after the pivot** (cycles 310-329). **§twenty-cycles-with-named-pivot-domain-stay**. **Eleventh package extends** (marshal; source → README adjacent-reverse pair, mirroring lp32 315-316 and patterns 326-327 shapes).

**§the-named-citation-arc-from-cycle-328-takes-1-cycle-to-close** — **fourth one-cycle README↔source arc closure in the pivot**:
- 323 README → 324 atomics.js
- 325 README → 326 index.js
- 326 index.js → 327 README
- 328 encodeToCapData.js → 329 README

**§four-cycles-with-named-one-cycle-README-source-arc** — recurring discipline confirmed across four cycles. **§twenty-five-citation-arc-closures-in-pivot-now** (22 + 3): cycle 328 → 329 (1) + cycle 160 → 329 marshal-stringify (169) + cycle 81 → 329 encodePassable / makePassableKit (248).

## The single most structurally interesting move

**§the-named-side-by-side-format-comparison-discipline** — the "Beyond JSON" section (line 69-89) shows the SAME input encoded in *both* formats side-by-side:

```js
// Smallcaps encoding.
const m1 = makeMarshal(undefined, undefined, { serializeBodyFormat: 'smallcaps' });
console.log(m1.toCapData(NaN));
// { body: '#"#NaN"', slots: [] }

// Original encoding.
const m2 = makeMarshal();
console.log(m2.toCapData(NaN));
// { body: '{"@qclass":"NaN"}', slots: [] }
```

The reader sees *both* the compact-prefix smallcaps format AND the verbose `@qclass` original format for the *same* NaN input. **§the-named-side-by-side-format-comparison-discipline** — first-explicit-observation. The pedagogical move makes the format-evolution narrative concrete: cycle 328's source-side §the-named-CapData-vs-smallcaps-format-evolution is now visible at the README level as *two outputs for one input*.

Sibling to cycle 327's @endo/patterns README's three Why-X sections (which compared chosen design vs natural alternative); here the comparison is between two equally-supported alternatives within the same package. **§the-named-comparison-by-side-by-side-output** as a documentation discipline.

## §the-named-honesty-about-API-tradeoffs gains a fifth subtype

**§the-named-honesty-about-API-tradeoffs** now has **five named subtypes**:

| Subtype | Cycle | Phrase |
|---|---|---|
| Low-utility-paths | 321 | "Most users don't need this" |
| Relaxed-security-models | 323 | "Not for mutually-suspicious parties" |
| Functionality-elsewhere | 325 | "For validation, see @endo/exo" |
| Documentation-language-cannot-express | 326 | "JSDoc cannot express these" |
| **Functionality-not-supported-at-all** | **329** | **"The marshal-based alternatives do not"** (no replacer/reviver) |

**§five-cycles-with-named-honesty-about-API-tradeoffs** (321 + 323 + 325 + 326 + 329) — the parameterized meta-pattern now spans five cycles with five distinct subtypes. The marshal stringify/parse pair documents what it deliberately *doesn't* provide that JSON.stringify/parse does: *"The JSON functions have parameters for customizing serialization and deserialization, for example with a *replacer* or *reviver*. The marshal-based alternatives do not."*

**§the-named-functionality-not-supported-at-all-subtype** — different from cycle 325's *functionality-elsewhere* because the missing functionality isn't available in any sibling package; the package simply chose not to include it. First-explicit-observation.

## §the-named-more-tolerant-and-less-tolerant-IS-named-symmetric-comparison-discipline

Line 165-173 explicitly names *both directions* of how marshal stringify differs from JSON.stringify:

> Compared to JSON, marshal's `stringify` is both more tolerant and less tolerant of what data it accepts. It is more tolerant in that it will encode `NaN`, `Infinity`, `-Infinity`, bigints, and `undefined`. It is less tolerant in that it accepts only pass-by-copy data...

**§the-named-symmetric-comparison-via-both-directions** — first-explicit-observation. Most documentation that compares two alternatives names *one* direction of difference ("X supports Y that Z doesn't"); marshal names *both* ("X is more tolerant of A, less tolerant of B"). The honesty discipline applies to *the comparison itself*, not just to the package's own limitations.

§the-named-explicit-error-vs-silent-omission-discipline (line 172-173) — *"JSON.stringify handles unserializable data by skipping it, but marshal's stringify rejects it by throwing an error."* Names the specific behavioral difference: silent skip vs explicit throw. **§the-named-throw-not-skip-discipline**.

## Other key moves

- **§the-named-marshalling-IS-named-conversion-of-structured-data** (line 3-4) — opening sentence defines the term: *"Marshalling refers to the conversion of structured data (a tree or graph of objects) into a string, and back again."* §the-named-define-the-term-first-discipline.

- **§the-named-capability-bearing-data-IS-named-special-data** (line 6-9) — marshal specializes in *"capability-bearing data"* (vs generic JSON). The capability vocabulary names the package's distinctive scope.

- **§the-named-slot-identifier-as-named-indirection-mechanism** + **§the-named-CapData-structure-IS-named-body-plus-slots** — `{ body: '...', slots: [...] }` is the canonical CapData format. The README *defines* what cycle 328's encodeToCapData.js produces. §the-named-side-table-pattern (slots array as side table outside the body string).

- **§the-named-parameterized-with-two-functions-discipline** — `convertValToSlot` + `convertSlotToVal` is the host-environment-binding pair. **§the-named-convertValToSlot-and-convertSlotToVal-named-pair** — symmetric callback pair (encoder/decoder). §the-named-each-callback-defaults-to-identity-function (line 25-26).

- **§the-named-makePassableKit-as-alternative-API** (line 44-62) — a *second* exported factory for direct-serialization format (string comparison corresponds with value comparison). Different from the `makeMarshal` slot-based API. Closes citation arc with cycle 81 encodePassable.js (which is the implementation this kit exposes).

- **§the-named-legacyOrdered-vs-compactOrdered** (line 55-61) — two format variations of the rank-order encoding. Legacy is the historical default; compact is preferred. **§the-named-PR-citation-for-historical-context** — the README cites a specific PR (#1594) for the historical background; **§the-named-PR-link-as-design-record**. First-explicit-observation.

- **§the-named-format-variation-with-named-historical-default** — *"former is the default for historical reasons (see ... for background) but the latter is preferred"*. The legacy is *named* as legacy; the preferred is *named* as preferred; the default is *not* preferred. **§the-named-default-vs-preferred-distinction** — the README acknowledges that the default and the preferred have diverged. Sibling to cycle 326's @deprecated-but-still-working.

- **§the-named-Frozen-Objects-Only-section** (line 63-67) — *"The entire object graph must be 'hardened' (recursively frozen), such as done by the `harden` function installed when importing `@endo/init`."* Names the hardening requirement and cites `@endo/init` as the installer. **§the-named-toCapData-refuses-non-frozen** — first-explicit-observation.

- **§the-named-pass-by-presence-vs-pass-by-copy-with-distinguishing-criteria** (line 91-110) — the README *defines* the criteria: pass-by-presence = all methods; pass-by-copy = all data + frozen + inherits-from-Object.prototype + enumerable + string-named. **§the-named-rejected-mixed-objects** (line 110) — *"Mixed objects having both methods and data properties are rejected."* First-explicit-observation. Closes citation arc with cycle 325 pass-style README (which named the categories).

- **§the-named-Empty-Objects-are-pass-by-copy-with-Far-as-alternative** (line 112-116) — vacuous case named explicitly: empty objects could be either, chosen to be pass-by-copy by default; `Far` (from `@endo/far`) for opting into pass-by-presence. **§the-named-Far-IS-named-empty-marker-for-identity-comparison**. First-explicit-observation.

- **§the-named-rights-amplification-IS-named-canonical-pattern** (line 116) — *"the 'rights amplification' pattern"*. Capability-security vocabulary cited casually as canonical. §the-named-rights-amplification-IS-named-WeakMap-key-pattern (Far objects as WeakMap keys for identity-based access control). Closes citation arc with cycle 322 @endo/exo (amplify capability).

- **§the-named-no-slots-IS-named-no-presence-discipline** — stringify is *string-only output*; without slots, it can't represent remotables or promises. Throws on encounter. **§the-named-shape-determines-which-types-supported** — the output shape (string vs body+slots) dictates which pass-style categories the function can handle.

- **§the-named-intra-document-cross-section-anchoring** (line 187-188) — *"per the original encoding described [above](#beyond-json)"* — Markdown anchor link from the "Direct alternative to JSON" section back to the "Beyond JSON" section. **§the-named-self-referential-anchor-within-README** — first-explicit-observation. The reader can navigate the README itself as a small hypertext.

## Patterns the cycle extends

- §twenty-cycles-with-named-pivot-domain-stay (310-329)
- §twenty-five-citation-arc-closures-in-pivot-now (22 + 3)
- §four-cycles-with-named-one-cycle-README-source-arc (323→324, 325→326, 326→327, 328→329)
- §five-cycles-with-named-honesty-about-API-tradeoffs (321 + 323 + 325 + 326 + 329; five named subtypes)
- §the-named-citation-arc-from-cycle-160-takes-169-cycles-to-close (marshal-stringify)
- §the-named-citation-arc-from-cycle-81-takes-248-cycles-to-close (encodePassable via makePassableKit)

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags marked first-explicit-observation above. Highest-portability:

- **§the-named-side-by-side-format-comparison-discipline** — show same input in both formats simultaneously
- **§the-named-functionality-not-supported-at-all-subtype** (fifth honesty subtype)
- **§the-named-symmetric-comparison-via-both-directions** ("more tolerant of X, less tolerant of Y")
- **§the-named-throw-not-skip-discipline** (explicit error vs silent omission)
- **§the-named-define-the-term-first-discipline** (opening sentence as definition)
- **§the-named-PR-link-as-design-record** (cite historical PR for design context)
- **§the-named-default-vs-preferred-distinction** (the default has diverged from the preferred)
- **§the-named-intra-document-cross-section-anchoring**
- **§the-named-rejected-mixed-objects** (explicit edge-case rejection)
- **§the-named-Far-IS-named-empty-marker-for-identity-comparison**

## Tier-2 borrowing (multi-cycle patterns extended)

- §twenty-cycles-with-named-pivot-domain-stay
- §twenty-five-citation-arc-closures-in-pivot-now
- §four-cycles-with-named-one-cycle-README-source-arc (recurring discipline confirmed across four cycles)
- §five-cycles-with-named-honesty-about-API-tradeoffs (five named subtypes confirms the parameterized meta-pattern across five cycles)

## Tier-3 borrowing (meta-patterns)

- **§the-named-side-by-side-format-comparison-discipline** — pedagogical: show the same input in both formats so the reader sees both at once
- **§the-named-honesty-about-API-tradeoffs** with five named subtypes (low-utility + relaxed-security + functionality-elsewhere + documentation-language-cannot-express + functionality-not-supported-at-all)
- **§the-named-symmetric-comparison-via-both-directions** — when comparing two alternatives, name BOTH directions of difference (more tolerant of X, less tolerant of Y)
- **§the-named-throw-not-skip-discipline** — explicit errors vs silent omission; the same data invalid in both becomes a *signal* in one and *invisible* in the other
- **§the-named-PR-link-as-design-record** — cite historical PR (#1594) for design rationale
- **§the-named-default-vs-preferred-distinction** — when the default and the preferred have diverged, acknowledge the gap rather than silently shifting

## Synthesis-target

Slot machine library **§`@game/marshal/README.md`** — game-state marshalling between subsystems:

1. **Opening sentence defines the term** ("Marshalling refers to...")
2. **Side-by-side format comparison** — if the library has multiple wire formats, show the same input encoded in each
3. **Two-callback parameterization pair** (convertValToSlot equivalent for game-side identifiers)
4. **CapData structure named** (`{ body, slots }`); side table pattern for identifiers
5. **Frozen objects only** with named hardening function
6. **Pass-by-presence vs pass-by-copy with distinguishing criteria** + rejected-mixed-objects edge case
7. **Empty objects default with Far escape hatch** for identity-comparison use cases
8. **Rights amplification pattern** named as canonical (Far objects as WeakMap keys)
9. **More-tolerant-and-less-tolerant** symmetric comparison with JSON
10. **Throw-not-skip discipline** for unsupported input
11. **No replacer/reviver** — explicitly name functionality not supported
12. **PR link as design record** for historical default
13. **Intra-document cross-section anchoring** for related sections
14. **Default vs preferred distinction** if the default has diverged from the preferred

## Library state after cycle 329

- §library-reaches-841-sections from 377 source documents
- §one-hundred-and-sixty-second consecutive designs-chat alternation
- §twenty-cycles-with-named-pivot-domain-stay
- §eleven-named-packages-in-the-pivot-cluster
- §twenty-five-citation-arc-closures-in-pivot-now
- §four-cycles-with-named-one-cycle-README-source-arc
- §five-cycles-with-named-honesty-about-API-tradeoffs (parameterized with five named subtypes)
