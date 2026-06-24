---
kind: result
role: liaison
dispatch-root: dispatches/liaison--3822fb
cycle: 329
lane: designs
host: endolin
date: 2026-06-15
---

# Result — liaison cycle 329: @endo/marshal README.md (designs-lane; adjacent-reverse pair with cycle 328; side-by-side format comparison; fifth honesty-about-API-tradeoffs subtype)

Cycle 329 ingest: **@endo/marshal README.md** (188 lines). Designs-lane after cycle 328. **Twentieth consecutive non-garden source after the pivot** (cycles 310-329). **§twenty-cycles-with-named-pivot-domain-stay**. **Eleventh package extends** (marshal; source → README adjacent-reverse pair, mirroring lp32 315-316 and patterns 326-327).

**§four-cycles-with-named-one-cycle-README-source-arc**: 323→324, 325→326, 326→327, **328→329**. **§twenty-five-citation-arc-closures-in-pivot-now** (22 + 3 new: cycle 328 = 1 cycle, cycle 160 marshal-stringify = 169 cycles, cycle 81 encodePassable via makePassableKit = 248 cycles).

## Single most structurally interesting move

**§the-named-side-by-side-format-comparison-discipline** — the "Beyond JSON" section (line 69-89) shows the SAME NaN input encoded in *both* formats simultaneously:

```js
// Smallcaps encoding.
m1.toCapData(NaN);
// { body: '#"#NaN"', slots: [] }

// Original encoding.
m2.toCapData(NaN);
// { body: '{"@qclass":"NaN"}', slots: [] }
```

The reader sees both the compact-prefix smallcaps format AND the verbose `@qclass` original format for the *same* input. Cycle 328's source-side **§the-named-CapData-vs-smallcaps-format-evolution** is now visible at the README level as *two outputs for one input*. **§the-named-comparison-by-side-by-side-output** as a documentation discipline. First-explicit-observation.

## §the-named-honesty-about-API-tradeoffs gains a fifth subtype

| Subtype | Cycle | Phrase |
|---|---|---|
| Low-utility-paths | 321 | "Most users don't need this" |
| Relaxed-security-models | 323 | "Not for mutually-suspicious parties" |
| Functionality-elsewhere | 325 | "For validation, see @endo/exo" |
| Documentation-language-cannot-express | 326 | "JSDoc cannot express these" |
| **Functionality-not-supported-at-all** | **329** | **"The marshal-based alternatives do not"** (no replacer/reviver) |

**§five-cycles-with-named-honesty-about-API-tradeoffs** (321 + 323 + 325 + 326 + 329) — the parameterized meta-pattern now spans five cycles with five distinct subtypes. The marshal stringify/parse documents what it deliberately *doesn't* provide that JSON.stringify/parse does. **§the-named-functionality-not-supported-at-all-subtype** — different from cycle 325's *functionality-elsewhere* because the missing functionality isn't available in any sibling package; the package simply chose not to include it.

## §the-named-more-tolerant-and-less-tolerant-IS-named-symmetric-comparison-discipline

The README names *both directions* of how marshal stringify differs from JSON.stringify:

> Compared to JSON, marshal's `stringify` is both **more tolerant and less tolerant** of what data it accepts. It is **more tolerant** in that it will encode `NaN`, `Infinity`, `-Infinity`, bigints, and `undefined`. It is **less tolerant** in that it accepts only pass-by-copy data...

Most documentation that compares two alternatives names *one* direction of difference; marshal names *both*. **§the-named-symmetric-comparison-via-both-directions** — first-explicit-observation. The honesty discipline applies to the comparison itself, not just to the package's own limitations.

§the-named-explicit-error-vs-silent-omission-discipline — *"JSON.stringify handles unserializable data by skipping it, but marshal's stringify rejects it by throwing an error"*. **§the-named-throw-not-skip-discipline**.

## Other first-explicit-observations

- §the-named-marshalling-IS-named-conversion-of-structured-data (opening sentence defines the term); §the-named-define-the-term-first-discipline
- §the-named-capability-bearing-data-IS-named-special-data — marshal specializes vs generic JSON
- §the-named-CapData-structure-IS-named-body-plus-slots; §the-named-slot-identifier-as-named-indirection-mechanism; §the-named-side-table-pattern
- §the-named-parameterized-with-two-functions-discipline (convertValToSlot + convertSlotToVal pair)
- §the-named-makePassableKit-as-alternative-API (closes cycle 81 encodePassable arc)
- §the-named-legacyOrdered-vs-compactOrdered with §the-named-PR-citation-for-historical-context (PR #1594) + §the-named-PR-link-as-design-record + §the-named-default-vs-preferred-distinction (the default has diverged from the preferred)
- §the-named-pass-by-presence-vs-pass-by-copy-with-distinguishing-criteria with §the-named-rejected-mixed-objects edge case
- §the-named-Empty-Objects-are-pass-by-copy-with-Far-as-alternative; §the-named-Far-IS-named-empty-marker-for-identity-comparison
- §the-named-rights-amplification-IS-named-canonical-pattern (closes cycle 322 exo amplify arc); §the-named-rights-amplification-IS-named-WeakMap-key-pattern
- §the-named-no-slots-IS-named-no-presence-discipline (stringify can't represent remotables/promises because no slots means no indirection)
- §the-named-intra-document-cross-section-anchoring (`[above](#beyond-json)` Markdown anchor); §the-named-self-referential-anchor-within-README

## Multi-cycle patterns extended

- §twenty-cycles-with-named-pivot-domain-stay (310-329)
- §twenty-five-citation-arc-closures-in-pivot-now (added three: 1 + 169 + 248)
- §four-cycles-with-named-one-cycle-README-source-arc (323→324 + 325→326 + 326→327 + 328→329 — recurring discipline confirmed across four cycles)
- §five-cycles-with-named-honesty-about-API-tradeoffs (parameterized meta-pattern with five named subtypes)

## Tier-3 meta-patterns

- **§the-named-side-by-side-format-comparison-discipline** — pedagogical: show same input in both formats so reader sees both at once
- **§the-named-honesty-about-API-tradeoffs** with five named subtypes
- **§the-named-symmetric-comparison-via-both-directions** — when comparing two alternatives, name BOTH directions of difference
- **§the-named-throw-not-skip-discipline** — explicit errors vs silent omission
- **§the-named-define-the-term-first-discipline** — opening sentence as definition
- **§the-named-PR-link-as-design-record** — cite historical PR for design context
- **§the-named-default-vs-preferred-distinction** — acknowledge when default and preferred have diverged
- **§the-named-intra-document-cross-section-anchoring** — README as small hypertext via Markdown anchors

## Synthesis-target

Slot machine library **§`@game/marshal/README.md`** — game-state marshalling between subsystems:

1. Opening sentence defines the term
2. Side-by-side format comparison if multiple wire formats
3. Two-callback parameterization pair
4. CapData {body, slots} structure named
5. Frozen objects only
6. Pass-by-presence vs pass-by-copy with rejected-mixed-objects edge case
7. Empty objects default + Far escape hatch
8. Rights amplification pattern named as canonical
9. More-tolerant-and-less-tolerant symmetric comparison
10. Throw-not-skip discipline
11. Explicitly name functionality not supported
12. PR link as design record
13. Intra-document cross-section anchoring
14. Default vs preferred distinction

## Library state after cycle 329

- §library-reaches-841-sections from 377 source documents
- §one-hundred-and-sixty-second consecutive designs-chat alternation
- §twenty-cycles-with-named-pivot-domain-stay
- §eleven-named-packages-in-the-pivot-cluster
- §twenty-five-citation-arc-closures-in-pivot-now
- §four-cycles-with-named-one-cycle-README-source-arc
- §five-cycles-with-named-honesty-about-API-tradeoffs (parameterized with five subtypes — this meta-pattern is now structurally rich enough to be a Tier-1 source of guidance)

## Next cycle pacing

Cycle 330 is chat-lane next. Candidate moves:

- **@endo/exo README.md** — designs-lane (defer; cycle 330 is chat-lane)
- **@endo/exo/src/exo-tools.js** — chat-lane; second complementary-lens re-ingest (cycle 118 ingested as comment-fragment); would match cycles 322/324 complementary-lens discipline at a third application
- **@endo/promise-kit source** — would introduce a twelfth package
- **@endo/common source** — would introduce a twelfth package; cited from cycle 326 patterns/index.js deprecated re-exports
- **@endo/marshal/src/encodeToSmallcaps.js** — would be a third complementary-lens re-ingest (cycle 69 had a different framing); pairs naturally with cycle 328's encodeToCapData.js

@endo/marshal/src/encodeToSmallcaps.js complementary-lens re-ingest is the most productive (third instance of cycle 322's librarian discipline; pairs with cycle 328's source-side smallcaps-vs-capdata observation; would let me apply the discipline to a third file). Picking freely but tracking for future work.
