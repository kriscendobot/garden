---
kind: result
role: liaison
dispatch-root: dispatches/liaison--e1f3e5
cycle: 322
lane: chat
host: endolin
date: 2026-06-15
---

# Result — liaison cycle 322: @endo/exo src/exo-makers.js (chat-lane; seventh package in pivot; complementary-lens re-ingest of cycle 108's source)

Cycle 322 ingest: **@endo/exo src/exo-makers.js** (242 lines) — the file that defines `defineExoClass`, `defineExoClassKit`, and `makeExo`. Chat-lane after cycle 321's designs-lane eventual-send README. **Thirteenth consecutive non-garden source after the pivot** (cycles 310-322). **§thirteen-cycles-with-named-pivot-domain-stay**. **Seventh package added to the pivot cluster** (nat + memoize + hex + lp32 + stream + eventual-send + exo).

## Discovery: file already ingested in cycle 108

The same file (`exo-makers.js`) was already ingested in **cycle 108** as a comment-fragment with a *factory-trio* framing. Cycle 322 is a **complementary-lens re-ingest** — a full-source ingest with a different lens (*capability-discipline* + *seal-vs-freeze* + *circular-reference-via-late-binding*). The cycle 108 section file stays; cycle 322 adds a second section file alongside it.

**§the-named-complementary-lens-re-ingest** — first-explicit-observation as a *librarian discipline*. When a file warrants a second look with a different framing, the new section sits alongside the prior one rather than replacing. The source page records both sections; the source count doesn't bump (the source was already counted); the section count does. First-explicit-observation.

This realization adjusted the cycle's framing on the fly: I had to update my section file to acknowledge cycle 108, update the existing source page (cycle 108-authored) to record cycle 322's new section in the Sections table, bump section_count from 1 to 2, and add notes about the complementary-lens-re-ingest discipline. The library now exhibits a *librarian* meta-pattern that earlier cycles hadn't explicitly named.

## Single most structurally interesting move

**§the-named-callback-receives-capability-discipline** — `defineExoClassKit` accepts `receiveAmplifier` and `receiveInstanceTester` options as callbacks; the constructor calls them with the capability:

```js
const makeKit = defineExoClassKit(tag, guards, init, methods, {
  receiveAmplifier: amplify => { /* save the amplify capability */ },
  receiveInstanceTester: isInstance => { /* save the isInstance capability */ },
});
```

**§the-named-introduce-and-forget-capability-handoff** — the capability is *born* inside the constructor, *immediately* handed to a single named recipient via callback, and the constructor *forgets it*. The recipient holds the capability; the constructor doesn't. The discipline ensures one-way capability flow (constructor → receiver) and gives the *consumer* control over which downstream code receives the capability. First-explicit-observation in library.

This contrasts with three more common patterns:
- **Return the capability**: caller gets it; can freely pass to anyone
- **Constructor input**: caller must already have it
- **Global registry**: everyone has access

The callback-receives-capability pattern threads the capability one step further than either alternative, giving the *callback writer* (not the *constructor caller*) the right to decide who gets the capability.

## State sealed not frozen — warning thrice

**§the-named-state-is-sealed-not-frozen** + **§the-named-warning-comment-repeated-thrice-IS-named-load-bearing** — the comment `// Be careful not to freeze the state record` appears **three times** in the file (lines 88-89 + 163-164 + 175-176). When a discipline is one keystroke away from violation, repeat the warning at every site. **§the-named-warning-IS-named-paid-by-repetition**. First-explicit-observation.

**§the-named-seal-vs-freeze-distinction** — `Object.seal` prevents adding/removing properties but allows existing-property reassignment; `Object.freeze` prevents all changes. Exo state needs reassignment but not new properties. **§the-named-deliberate-non-freezing-of-state-record**.

**§the-named-frozen-outer-and-sealed-inner-discipline** — the context wrapper is frozen; the state inside is only sealed. Two-level immutability for records that bundle mutable-by-design state with non-mutable references.

## Four citation arcs closed in the pivot

The pivot has now closed **four citation arcs** of widely varying lengths:

| Cycle | Closes arc with | Arc length | Subject |
|---|---|---|---|
| 319 | 315 | 4 cycles | lp32 README cites `makePipe` from @endo/stream |
| 321 | 146 | 175 cycles | E.js comment-fragment → eventual-send README |
| 321 | 66 | 255 cycles | handled-promise.js handler protocol → eventual-send README |
| **322** | **108** | **214 cycles** | exo-makers.js comment-fragment → exo-makers.js full-source re-ingest |

Cycle 322's arc closure is intra-source (same file ingested twice with different lenses) rather than cross-source (one file citing another).

## First-explicit-observations (twenty-plus)

- §the-named-callback-receives-capability-discipline + §the-named-introduce-and-forget-capability-handoff
- §the-named-option-applicability-by-shape (defineExoClass rejects receiveAmplifier)
- §the-named-state-is-sealed-not-frozen + §the-named-warning-comment-repeated-thrice-IS-named-load-bearing
- §the-named-seal-vs-freeze-distinction + §the-named-deliberate-non-freezing-of-state-record
- §the-named-frozen-outer-and-sealed-inner-discipline
- §the-named-amplify-IS-named-cross-facet-access + §the-named-amplification-IS-named-capability-uplift
- §the-named-circular-reference-via-late-binding + §the-named-don't-freeze-context-until-facets-attached
- §the-named-defineExoClass-vs-defineExoClassKit-named-pair
- §the-named-makeExo-IS-named-singleton-wrapper
- §the-named-emptyRecord-hardened-and-shared
- §the-named-WeakMap-contextMap-keyed-by-instance + §the-named-context-is-not-accessible-from-outside
- §the-named-per-facet-WeakMap-discipline
- §the-named-isInstance-via-WeakMap-has + §the-named-membership-IS-named-WeakMap-key-test
- §the-named-five-name-Object-destructure-at-module-load
- §the-named-import-graph-from-exo-IS-named-fan-out (five external imports)
- §the-named-LABEL_INSTANCES-gated-debug-feature + §the-named-zero-cost-when-debug-flag-off
- §the-named-defineProperty-toStringTag-with-instanceCount
- §the-named-objectMap-IS-named-canonical-record-functor + §the-named-double-objectMap-discipline
- §the-named-complementary-lens-re-ingest (librarian discipline)
- §the-named-citation-arc-from-cycle-108-takes-214-cycles-to-close

## Multi-cycle patterns extended

- §thirteen-cycles-with-named-pivot-domain-stay (310-322)
- §seven-named-packages-in-the-pivot-cluster (seventh adds: exo)
- §eleven-cycles-with-named-Hardened-JS-discipline (310 + 312 + 313 + 315 + 316 + 317 + 318 + 319 + 320 + 321 + 322)
- §four-citation-arc-closures-in-pivot-now (4 + 175 + 214 + 255 cycles)
- §two-cycles-with-named-Object-destructure (310 small + 322 large)

## Tier-3 meta-patterns

- **§the-named-callback-receives-capability-discipline** — capability born inside constructor, handed to single recipient via callback, then forgotten
- **§the-named-option-applicability-by-shape** — option validity depends on the constructed object's shape; fail at construction if mis-applied
- **§the-named-seal-vs-freeze-distinction** — JS-language fact made load-bearing
- **§the-named-warning-comment-repeated-thrice-IS-named-load-bearing** — when a discipline is one keystroke from violation, repeat at every site
- **§the-named-frozen-outer-and-sealed-inner-discipline** — two-level immutability for records with mutable-by-design state
- **§the-named-circular-reference-via-late-binding** — bind then freeze; resolve self-reference by stage
- **§the-named-membership-IS-named-WeakMap-key-test** — the WeakMap is itself the type predicate
- **§the-named-complementary-lens-re-ingest** — librarian discipline; two section files for one source, each taking a different framing
- **§the-named-intra-source-citation-arc** — when the same source is ingested twice with different lenses, the second ingest closes a citation arc with the first

## Synthesis-target

Slot machine library **§`@game/exo/src/exo-makers.js`** — defensive class factories for game entities (bet records, payout tables, RNG state holders):

1. **Callback-receives-capability** for amplify and isInstance.
2. **State sealed not frozen** for mutable game-state fields with locked schema.
3. **Repeat the warning thrice** at every state-construction site.
4. **Frozen-outer-sealed-inner** for context records.
5. **Per-facet WeakMap** for multi-facet entities.
6. **Late-bind facets onto context** to resolve circular references.
7. **Option-applicability-by-shape**: single-facet entities reject amplify-option.
8. **LABEL_INSTANCES debug flag** via env-var.
9. **Large Object destructure at module load**.
10. **objectMap as canonical record functor**.

## Library state after cycle 322

- §library-reaches-834-sections from 371 source documents (source count unchanged because exo-makers.js was already counted from cycle 108)
- §one-hundred-and-fifty-fifth consecutive designs-chat alternation
- §thirteen-cycles-with-named-pivot-domain-stay
- §seven-named-packages-in-the-pivot-cluster
- §eleven-cycles-with-named-Hardened-JS-discipline
- §four-citation-arc-closures-in-pivot-now (4 + 175 + 214 + 255 cycles)
- §the-named-complementary-lens-re-ingest established as a librarian discipline

## Next cycle pacing

Cycle 323 is designs-lane next. With the complementary-lens-re-ingest discipline established and four citation arcs closed in the pivot, candidate moves:

- **@endo/exo README.md** — designs-lane; would form an adjacent-reverse pair with cycle 322 (source then README, mirroring lp32 cycle 315-316 README→source). Productive.
- **@endo/captp README.md** — designs-lane; would close cross-package citation arc from cycle 321's "Network Transport" role-label. Also closes arcs with the cycle 154 + 156 + 158 captp comment-fragment ingests.
- **@endo/patterns README.md** — designs-lane; would close cross-package citation arc from cycle 321's "Validation" role-label.
- **@endo/pass-style README.md** — designs-lane; would close many citation arcs (cycles 71 + 87 + 134 + 136 + 138 + 140 + 142 + 148 + 150 are all pass-style files).

@endo/captp README is the productive choice (would close three citation arcs to cycles 154 + 156 + 158, all from less than a year ago in cycle-terms, but also potentially closing the cycle 321 "Network Transport" arc; introduces an eighth package in the pivot cluster but @endo/captp is already in library extensively). Picking freely but tracking for future work.
