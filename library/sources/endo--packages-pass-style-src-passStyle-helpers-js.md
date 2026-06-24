---
source: packages/pass-style/src/passStyle-helpers.js
source_repo: endojs/endo
source_branch: master
source_commit: c05c9a884fd6f2f0888bd954ea8295af7020146f
source_date: 2026-04-15
source_authors: [Turadg Aleahmad]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirtieth comment-fragment ingest. 212-line file by Turadg
  Aleahmad in commit `c05c9a88` (2026-04-15) — newer than the
  `e56bf00f` coordinated-update cluster. The *foundational
  helpers* file that other pass-style files import from.

  Exports: `PASS_STYLE` symbol; `hasOwnPropertyOf` (deprecated);
  `isPrimitive` + `isObject` (latter deprecated) +
  `isTypedArray`; `assertChecker` (deprecated); `confirmOwnData-
  Descriptor`; `getTag`; `confirmPassStyle`; `confirmTagRecord`
  + `confirmFunctionTagRecord`.

  Single most structurally interesting move: §PASS_STYLE typed
  as string literal hack. *Typed as the string literal
  'Symbol(passStyle)' rather than as unique symbol, to keep the
  type nameable across module boundaries. The runtime value is
  still Symbol.for('passStyle') — JS computed property keys
  accept any value*. The §TypeScript-`unique symbol`-limitation
  rationale: unique symbol bindings are only nameable via their
  original declaration module — downstream packages whose
  inferred types structurally contain [PASS_STYLE] fail with
  TS4023 / TS9006. The §workaround: lie about the type; the
  runtime is unchanged.

  §typedArrayPrototype-getter-extraction at module load: pulls
  the @@toStringTag getter from `%TypedArray%.prototype` (via
  `getPrototypeOf(Uint8Array.prototype)`); the assert + typeof
  function check proves the assumption at module load. The
  §brand-check-via-getter pattern in `isTypedArray`. Inline
  comment: *Duplicates packages/ses/src/make-hardener.js to
  avoid a dependency*. The §don't-depend-on-ses discipline
  (pass-style is more foundational than ses).

  §isPrimitive / §isObject pair with §XS-cost warning. Inline
  comment: *Safer would be `Object(val) !== val` but is too
  expensive on XS. So instead we use this adhoc set of type
  tests. But this is not safe in the face of possible evolution
  of the language. Beware!* The §safer-but-slower-on-XS
  trade-off; the §Beware comment is the explicit acknowledgement
  that the cheaper check could miss future primitive types.

  §confirmOwnDataDescriptor four-condition check (property
  exists / data not accessor / enumerability matches / returns
  descriptor or undefined). §desc-or-undefined return shape
  serves *both* as predicate-via-short-circuit *and* as
  descriptor-returning lookup.

  §confirmTagRecord factory: §makeConfirmTagRecord
  parameterizes by proto-check; produces two specialized
  variants (`confirmTagRecord` for object tag records with
  Object.prototype proto; `confirmFunctionTagRecord` for
  function tag records with Function.prototype proto or one
  level of subclass). The §parameterize-the-proto-check-only
  discipline: all other checks identical (non-primitive +
  frozen + non-array + PASS_STYLE match + @@toStringTag
  string); only proto differs. Cycle 134's
  `confirmRemotableProtoOf` calls into both via the
  RemotableHelper.

  §Three deprecated exports — backward-compat carry-forward:
  hasOwnPropertyOf (use Object.hasOwn) / isObject (use
  !isPrimitive) / assertChecker (use Fail with confirm/reject
  pattern). §carry-forward-with-deprecation discipline: names
  stay exported; JSDoc marks deprecated; new code uses modern
  alternatives.

  §hideAndHardenFunction applied to four predicates
  (isPrimitive / isObject / isTypedArray / assertChecker) —
  same rationale as cycles 134/136/138/140: assertion-like
  functions hide their .name from stack traces to reduce
  information leak. The §predicates-are-assertion-adjacent
  discipline.

  §Helper-root position: this file's exports are used by nearly
  every pass-style file. Cycle 71's passStyleOf.js imports
  PASS_STYLE + isPrimitive + confirmTagRecord; cycle 134's
  remotable.js uses confirmTagRecord + confirmFunctionTagRecord
  for the recursive proto walk; cycle 136's make-far.js
  imports PASS_STYLE; cycle 140's deeplyFulfilled.js imports
  getTag.

  Cycle 142 was nominally chat-lane (cycle 141 was designs).
  Chat-lane exhausted at 20/20. Papers-lane has been blocked
  for 36+ consecutive cycles. Cycle 142 pivoted to comments-lane
  to continue the @endo/pass-style cluster (cycles 71 + 87 +
  134 + 136 + 138 + 140 + 142). Author Turadg Aleahmad — same
  as cycle 120's keycollection-operators.js (the type-system
  perspective contributor).
---

> Abstract: `packages/pass-style/src/passStyle-helpers.js` (212
> lines, Turadg Aleahmad, commit `c05c9a88`) is the *foundational
> helpers* file imported by every other pass-style file. Exports:
> `PASS_STYLE` + isPrimitive/isObject/isTypedArray + getTag +
> confirmOwnDataDescriptor + confirmPassStyle + confirmTagRecord
> + confirmFunctionTagRecord (plus three deprecated exports).
>
> **The single most structurally interesting move**: §PASS_STYLE
> typed as string literal hack. *Typed as the string literal
> `'Symbol(passStyle)'` rather than as `unique symbol`, to keep
> the type nameable across module boundaries*. The §workaround
> for TypeScript's TS4023/TS9006 errors on `unique symbol`
> bindings.
>
> §typedArrayPrototype-getter-extraction at module load + §brand-
> check-via-getter for isTypedArray. §isPrimitive's §safer-but-
> slower-on-XS trade-off (Beware: not safe in the face of
> possible evolution of the language).
>
> §confirmTagRecord factory parameterizes by proto-check;
> produces two specialized variants — `confirmTagRecord` for
> object tag records (Object.prototype) and
> `confirmFunctionTagRecord` for function tag records
> (Function.prototype). The §parameterize-the-proto-check-only
> discipline.
>
> §Three deprecated exports (hasOwnPropertyOf / isObject /
> assertChecker) — §carry-forward-with-deprecation discipline.
>
> §Helper-root position: imported by cycles 71 / 134 / 136 /
> 140 et al.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records](../sections/endo--packages-pass-style-src-passStyle-helpers-js--PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records.md) | pass-style | current |

Tight 212-line file. The PASS_STYLE typed-string-literal hack +
helper-predicates + confirmTagRecord factory form one coherent
foundation. One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@c05c9a88` (`master`) via
  the local bare-clone.
- Last touched 2026-04-15 by Turadg Aleahmad in commit
  `c05c9a88` — newer than the `e56bf00f` coordinated-update
  cluster. Same author as cycle 120's keycollection-operators.js.
- Verified file existence and structure via the local bare-clone:
  212 lines + 12 exports (PASS_STYLE + 11 functions) + 1 factory
  helper (makeConfirmTagRecord) + 3 module-level type
  extractions.
- **Thirtieth comment-fragment ingest.** Continues the
  @endo/pass-style cluster (cycles 71 + 87 + 134 + 136 + 138 +
  140 + 142).
- Cycle 142 was nominally **chat-lane** (cycle 141 was designs).
  Chat-lane is exhausted (20/20). Papers-lane has been blocked
  for **36+ consecutive cycles** due to lack of PDF-fetching
  infrastructure. Cycle 142 pivoted to comments-lane.
- One cohesion-honest section.
