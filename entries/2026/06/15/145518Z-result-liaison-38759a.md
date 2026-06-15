---
kind: result
role: liaison
dispatch-root: dispatches/liaison--38759a
cycle: 336
lane: chat
host: endolin
date: 2026-06-15
refs:
  - 2026/06/15/141650Z-result-liaison-3ad844.md
---

# Result — liaison cycle 336: @endo/promise-kit/src/memo-race.js (chat-lane; fifth complementary-lens re-ingest; deviation-named-in-the-source-too; FIFTY citation-arc closures milestone)

Cycle 336 ingest: **@endo/promise-kit/src/memo-race.js** (170 lines). Chat-lane after cycle 335. **Twenty-seventh consecutive non-garden source after the pivot** (cycles 310-336). **§twenty-seven-cycles-with-named-pivot-domain-stay**. **§thirteen-named-packages-in-the-pivot-cluster** continues (memo-race.js belongs to promise-kit, the thirteenth package added in cycle 335).

## FIFTH complementary-lens re-ingest

Cycle 336 is the **fifth application** of the §the-named-complementary-lens-re-ingest librarian discipline (after 322 exo-makers + 324 atomics + 330 smallcaps + 332 exo-tools). **§five-cycles-with-named-complementary-lens-re-ingest**. The discipline now spans **five applications** — a more durable pattern than the earlier four-application count.

Cycle 152 first ingested memo-race.js as a comment-fragment with the **algorithm lens** (WeakMap-shared-deferred-sets, finally-cleanup, primitive-fake-settled-record). Cycle 336 takes the **discipline / architecture lens** — what disciplines does the file embody beyond the algorithm; how does the file relate to the README-level claims at cycle 335; what structural choices make the file load-bearing.

Closes **six citation arcs** in one cycle:

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 152 (memo-race.js comment-fragment) | 184 cycles | Self-arc; complementary-lens re-ingest |
| Cycle 335 (promise-kit README) | 1 cycle | Adjacent-reverse pair; implementation-side closure of *deliberately-imperfect-ponyfill* |
| Cycle 173 (promise-executor-kit.js) | 163 cycles | §executor-body-as-synchronous-capture-hook sibling |
| Cycle 187 (promise-kit/shim.js cluster) | 149 cycles | §unconditional-replacement `Promise.race = memoRace` |
| Cycle 108 (exo-makers.js / e56bf00f migration) | 228 cycles | Same coordinated-update commit cluster |
| Cycle 142 (passStyle-helpers.js isPrimitive duplication) | 194 cycles | §honest-duplication acknowledged from both sides |

**§fifty-citation-arc-closures-in-pivot-now** (49 + 1 net new). The accumulated count **crosses the 50-arc threshold**.

## Single most structurally interesting move

**§the-named-deviation-named-in-the-source-too** — line 127-128 of memo-race.js, in the `race` method's JSDoc:

> Creates a Promise that is resolved or rejected when any of the provided Promises are resolved or rejected.
>
> **Unlike `Promise.race`** it cleans up after itself so a non-resolved value doesn't hold onto the result promise.

The README at **cycle 335** made the abstract *deliberately-imperfect-ponyfill* claim (*"this serves as a 'ponyfill' for `Promise.withResolvers`, making certain accommodations to ensure that the resulting promises can pipeline messages through @endo/eventual-send"*). The **SOURCE at cycle 336** names the divergence **explicitly in JSDoc** — *"Unlike `Promise.race` ..."*.

**§the-named-implementation-of-the-accommodation** — first-explicit-observation. The README's abstract claim about *"certain accommodations"* materializes in the source's JSDoc statement of the divergence. The implementation does not silently diverge; **the divergence is named at the API surface** so callers reading the JSDoc know what they're getting that `Promise.race` doesn't give them.

**§the-named-honesty-at-two-levels-discipline** — first-explicit-observation as a tier-3 meta-pattern. **Package-level honesty (README) and symbol-level honesty (JSDoc) are independent commitments**. Cycle 335 named the package-level honesty; cycle 336 names the symbol-level honesty. The two together: when a README claims deliberate divergence, the source should ALSO name the divergence at the JSDoc level.

This is the **implementation-side closure** of cycle 335's *deliberately-imperfect-ponyfill* claim. §the-named-citation-arc-from-cycle-335-takes-1-cycle-to-close as an *implementation-of-the-deliberate-imperfection* arc.

## §the-named-streak-resumes-after-one-cycle-gap

Cycle 335 ended the §seven-cycles-with-named-one-cycle-README-source-arc streak (cycle 334 → 335 was cross-package). Cycle 335 → 336 is **the eighth INSTANCE** of the one-cycle README↔source pattern, but **isolated** — the streak count restarts at 1 since cycle 334 → 335 broke the streak. **§the-named-streak-resumes-after-one-cycle-gap** — first-explicit-observation as a discipline-resumption. The *pattern* continues (eighth application across all cycles); the *streak* (consecutive without interruption) restarts.

## Other notable first-explicit-observations (twenty-plus)

- **§the-named-public-domain-license-header-preserved-verbatim** — 29 lines (1-29) of Unlicense dedication preserved verbatim from Brian Kim's original 2017 contribution to nodejs/node#17469; @endo/promise-kit package overall is Apache-2.0 (per cycle 335's License section); §the-named-licensing-asymmetry-within-a-single-package
- **§the-named-attribution-discipline-when-adopting-public-domain-code** — preserve the dedication block verbatim; the dedication is the historical record of the author's gift
- **§the-named-canonical-URL-as-provenance** — cite the original GitHub issue comment URL, not a recreation
- **§the-named-name-both-the-goal-and-the-obstacle** — TODO at line 34-36 names what to do AND why it hasn't been done; §the-named-honest-TODO-with-named-obstacle
- **§the-named-helpers-private-export-single-public** — 5 private names (isPrimitive + markSettled + knownPromises + getMemoRecord + race) + 1 public export (memoRace); §the-named-export-the-noun-not-the-verbs
- **§the-named-three-shapes-of-export-discipline** — barrel-index (substrate; cycle 326 @endo/patterns) + one-file-one-export-no-index (collection; cycle 333 @endo/common) + single-file-single-export-with-private-helpers (utility; cycle 336 memo-race.js); **refines cycle 333's three-way package categorization with an export-shape parameter**
- **§the-named-in-place-transition-for-shared-references** — markSettled uses Object.assign(record, {...}) to mutate in place because multiple races hold pointers; replace would orphan
- **§the-named-fake-record-honors-real-record-discipline** — `harden({ settled: true })` for primitives matches real-record structural shape
- **§the-named-named-function-via-object-destructure** — method-syntax + object-destructure + named-binding in one idiom; **§the-named-api-name-vs-impl-name-asymmetry** (internal `race` generic; external `memoRace` qualified)
- **§the-named-JSDoc-as-three-tools** — semantic-marker (deprecation; cycle 326) + type-level-surgery (casts; cycle 334) + generic-this-binding (subclassability; cycle 336)
- **§the-named-iterable-vs-array-discipline** — document broader contract in prose; type narrower constraint in JSDoc; implement defensively
- **§the-named-synchronous-registration-via-promise-constructor-body** — use `new Promise((resolve, reject) => { ... })`'s executor body as your synchronous-initialization hook

## Multi-cycle patterns extended

- §twenty-seven-cycles-with-named-pivot-domain-stay (310-336)
- §five-cycles-with-named-complementary-lens-re-ingest (322 + 324 + 330 + 332 + 336)
- §thirteen-named-packages-in-the-pivot-cluster (memo-race.js belongs to promise-kit, the thirteenth)
- §fifty-citation-arc-closures-in-pivot-now (49 + 1 net new; **MILESTONE**)
- §the-named-streak-resumes-after-one-cycle-gap (eighth instance of one-cycle README↔source pattern)
- §four-cycles-with-named-ts-expect-error-discipline (146 + 187 + 211 + 336)
- §two-cycles-with-named-executor-body-as-synchronous-capture-hook (173 + 336)

## Tier-3 meta-patterns

- **§the-named-deviation-named-in-the-source-too** — when the README claims deliberate divergence, the source's JSDoc should NAME the divergence at the JSDoc level too
- **§the-named-honesty-at-two-levels-discipline** — package-level (README) and symbol-level (JSDoc) honesty are independent commitments
- **§the-named-attribution-discipline-when-adopting-public-domain-code** — preserve the original dedication block verbatim
- **§the-named-name-both-the-goal-and-the-obstacle** — honest TODOs name what to do AND why it hasn't been done
- **§the-named-three-shapes-of-export-discipline** — barrel-index, one-file-one-export-no-index, single-file-single-export-with-private-helpers; each tracks a package category; **refines cycle 333**
- **§the-named-in-place-transition-for-shared-references** — mutate when multiple holders share the reference; replace would orphan
- **§the-named-JSDoc-as-three-tools** — semantic-marker + type-level-surgery + generic-this-binding
- **§the-named-iterable-vs-array-discipline** — document broader; type narrower; implement defensively
- **§the-named-synchronous-registration-via-promise-constructor-body** — the promise executor body as your initialization hook

## Synthesis-target

Slot machine library **§`@game/promise-kit/src/memo-race.js`** — memory-safe race primitive:

1. **Deviation named at the source level** — if the package README claims deliberate imperfection, the source's JSDoc should ALSO name the deviation.
2. **Public-domain dedication preserved verbatim** if adopting public-domain code from a named author; include the original URL.
3. **Honest TODO with named obstacle** — when a duplication can't be eliminated, the TODO names BOTH the goal AND the layering constraint blocking it.
4. **Helpers private; single public export** — utility files expose one function.
5. **In-place transition for shared references** — when multiple holders share a record, mutate in place; replace would orphan.
6. **Fake record honors real record discipline** — sentinel objects match the real record's structural shape.
7. **API name vs impl name asymmetry** — internal generic name; external qualified name.
8. **Subclassable via JSDoc only** — express constructor-genericity through `@this {P}` + `@template P`.
9. **Iterable vs array discipline** — document broader; type narrower; implement defensively.
10. **Synchronous registration via promise constructor body** — use the executor body as your initialization hook.

## Library state after cycle 336

- §library-reaches-848-sections from 381 source documents (source count unchanged because memo-race.js was already counted from cycle 152)
- §one-hundred-and-sixty-ninth consecutive designs-chat alternation
- §twenty-seven-cycles-with-named-pivot-domain-stay
- §thirteen-named-packages-in-the-pivot-cluster (promise-kit's second source observation)
- **§fifty-citation-arc-closures-in-pivot-now — MILESTONE**
- §five-cycles-with-named-complementary-lens-re-ingest (librarian discipline confirmed across five applications)
- §the-named-streak-resumes-after-one-cycle-gap (eighth instance of one-cycle README↔source pattern, isolated)
- §the-named-deviation-named-in-the-source-too established as a tier-3 meta-pattern
- §the-named-honesty-at-two-levels-discipline (README + JSDoc) established as a tier-3 meta-pattern
- §the-named-attribution-discipline-when-adopting-public-domain-code established as a tier-3 meta-pattern
- §the-named-three-shapes-of-export-discipline refines cycle 333's three-way package categorization with an export-shape parameter
- §the-named-JSDoc-as-three-tools (semantic-marker + type-level-surgery + generic-this-binding) named as a tier-3 meta-pattern

## Next cycle pacing

Cycle 337 is **designs-lane** next. Candidate moves:

- **@endo/promise-kit/src/promise-executor-kit.js** — adjacent forward pair with cycle 336; sibling complementary-lens to cycle 173's comment-fragment ingest (would be sixth complementary-lens re-ingest)
- **@endo/init source or README** — would introduce a fourteenth package; cycle 183 already ingested as comment-fragment so this would extend the pivot toward a complementary-lens re-ingest
- **@endo/harden source or README** — would introduce a fourteenth package (referenced from cycles 108 + 152 + 187 + 211)
- **@endo/eventual-send source files** — cycles 146 + 187 already ingested as comment-fragment; would be sixth complementary-lens

Designs-lane preference would suggest a README, which means @endo/init or @endo/harden (introducing a fourteenth package). Picking freely but tracking for future work; the fourteenth-package addition would be the next natural pivot expansion after the FIFTY-arc-closures milestone.
