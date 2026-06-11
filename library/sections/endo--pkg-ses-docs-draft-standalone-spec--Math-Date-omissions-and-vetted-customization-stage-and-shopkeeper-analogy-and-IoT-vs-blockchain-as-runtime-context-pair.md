---
title: "@endo/ses/docs/draft-standalone-spec.md — Draft SES spec for IoT and blockchain; ambient-authority-and-non-determinism omissions (Math.random + Date.now + Date constructor); vetted-customization-stage; shopkeeper analogy; build-time-vs-runtime mapping"
section-slug: endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair
source-slug: endo--pkg-ses-docs-draft-standalone-spec
url: https://github.com/endojs/endo/blob/master/packages/ses/docs/draft-standalone-spec.md
authors: [Mark S. Miller (et al.)]
repo: endojs/endo
path: packages/ses/docs/draft-standalone-spec.md
total-lines: 201
ingest-cycle: 291
ingest-date: 2026-06-11
lane: designs
scope: full
---

# `@endo/ses/docs/draft-standalone-spec.md` (full design)

A 201-line draft spec for standalone SES — the standardization pathway for Hardened JavaScript implementations targeting IoT and deterministically-replicated-computation use cases. **Distinct from full SES**: this is the spec for *engines that implement only SES*, not *shims that derive SES from full EcmaScript*. The doc names the omissions (what gets removed from EcmaScript) and the additions (what gets added beyond EcmaScript) for a SES-from-scratch implementation.

## §the-"Draft Spec"-genre-as-named-tentativeness-marker (first-explicit-observation)

The title opens with **"Draft Spec for ..."** — not "Spec for ..." or "Specification of ...". The word **"Draft"** IS the explicit tentativeness marker at the document title level. §the-title-bears-the-tentativeness-marker. Compare cycle 263's prose hedges ("my current recommendation") and cycle 288's code-comment hedge ("tentatively just DEFLATE-RAW") — three named locations for tentativeness markers (document-title + design-prose + code-comment). **§three-cycles-with-named-tentativeness-marker-locations** (263 + 288 + 291).

§the-Draft-IS-the-named-not-yet-canonical: a document that names itself as Draft IS not yet the authoritative spec; it IS the *current best understanding*. The implementation may diverge; the reader IS warned.

## §the-IoT-vs-blockchain-as-named-runtime-context-pair (first-explicit-observation)

> "For IoT or blockchain purposes, the more relevant question is: What is the resulting standard SES world..."

**§two-named-non-browser-runtime-contexts** for SES: IoT + blockchain. The standalone-SES spec exists for *these* contexts; browser/Node use full SES with shims. §the-runtime-context-IS-the-named-design-driver.

## §the-shorthand-definition-disclaimer (first-explicit-observation)

> '(We use "blockchain" here as shorthand for the more general category of deterministically replicated SES computation, whether on a blockchain, permissioned BFT system, or whatever.)'

**§the-named-disclaimer-of-shorthand-use**: the doc uses a familiar concrete term ("blockchain") for accessibility, then *explicitly disclaims* that the term is shorthand for a more general category. **§the-concrete-term-IS-named-as-stand-in-for-the-general-category**.

§the-`(whether on X, Y, or whatever)`-enumeration shape: three named examples + the explicit "or whatever" closer that signals the enumeration IS not exhaustive. §the-named-incomplete-enumeration as a discipline.

## §the-`## Omissions and Simplifications` section as named subtractive-spec discipline (first-explicit-observation)

The largest section IS **`## Omissions and Simplifications`** — naming what's *removed* from full EcmaScript to get to standalone SES. **§the-subtractive-spec-discipline**: instead of describing the full spec from scratch, the doc references EcmaScript and names the *delta*. This is **§the-spec-as-named-delta-from-a-reference-spec**.

§named-omissions-list:
- All support for sloppy mode (the spec's syntactic shortcut)
- Everything outside ES2018 (except `BigInt`)
- `import()` and `import.meta` expressions
- Annex B (with named ses-permitted exceptions)
- `RegExp` static properties (global communications channel)
- `Math.random()` (source of non-determinism)
- `Date.now()`, `new Date()`, `Date(...)` (three named Date constructor variants all-blocked)
- `Intl` by default (internationalization APIs)
- Function constructors via `.constructor` (always throw)

**§nine-named-omissions** as the categorical-list of "what's not in standalone SES".

## §the-three-named-Date-constructor-variants-all-block (first-explicit-observation)

The spec names **three named ways the Date constructor can be invoked** + **a defense for each**:

1. `Date.now()` → throws TypeError
2. `new Date()` (no arguments) → throws TypeError
3. `Date(...)` (called without `new`) → throws TypeError

**§the-exhaustive-named-attack-surface enumeration**: the doc doesn't just say "block Date"; it enumerates *each invocation form* and says "this also throws". §the-defense-IS-exhaustive-only-when-the-attack-surface-IS-enumerated.

§the-named-three-named-call-shapes-for-the-same-constructor: function call + constructor call + static method. The defense must cover all three; missing one would be a defect.

## §the-Math.random-and-Date.now-as-named-sources-of-non-determinism (first-explicit-observation)

> "Math.random() throws a TypeError rather than provide a random number, which would be a source of non-determinism."
> "Date.now() throws a TypeError rather than returning the millisecods representing the current time."

**§two-named-sources-of-non-determinism in the JS standard library**: random + clock. **§the-non-determinism-IS-the-named-property-being-defended-against**. In a deterministically-replicated computation, *both* must be blocked for the computation to converge across replicas.

§the-non-determinism-IS-the-named-attack-vector-for-replicated-computation. Sibling-pattern to capability theory's *ambient authority* — the random and clock are *ambient* sources of variability.

## §the-shared-globals-and-shared-intrinsics-named-definitions (first-explicit-observation)

> "We define the *shared globals* as all the standard shared global variable bindings defined by the above..."
> "We define the *shared intrinsics* as all the objects transitively reachable from the shared globals."

**§two-named-technical-terms-defined-inline**: shared-globals + shared-intrinsics. The definitions are *transitively-reachable* (shared-intrinsics IS the reflective closure of shared-globals). **§the-transitively-reachable-closure-as-named-implementation-discipline**.

§the-spec-defines-its-own-vocabulary-explicitly: the doc IS not assuming the reader knows the terms; it defines them in context.

## §the-`## Additions` section as named additive-spec discipline (first-explicit-observation)

The complementary section is `## Additions` — what standalone SES *adds* beyond EcmaScript. **§the-Omissions + Additions pair-of-named-sections** (first-explicit-observation): the delta IS a *bidirectional* description — *what's removed* + *what's new*. **§three-cycles-with-Omissions-and-Additions-or-similar-symmetric-pair-of-sections** (?) — actually first instance.

§named-additions-list:
- `Realm.makeCompartment(options)` — compartment-creation method.
- `Realm.prototype.global` — getter-only accessor.
- `Realm.prototype.evaluateProgram(programSrc, endowments)` — program evaluation.
- `Realm.prototype.evaluateExpr(exprSrc, endowments)` — expression evaluation.
- `Realm.makeRootRealm(options)` — *optional* root-realm creation (feature-detected).

**§the-feature-detection-via-property-presence as named discipline** (first-explicit-observation in this context): "On platforms that do not support `Realm.makeRootRealm`, the property must be absent so that SES code can feature-test for it." **§the-named-feature-test-IS-property-presence**.

## §the-vetted-customization-code-named-stage (first-explicit-observation)

> "Full SES, as embedded into EcmaScript, supports running vetted customization code in a freezable realm prior to freezing it into a SES realm."

**§the-named-pre-freeze-stage**: a discrete stage where code runs against *mutable* shared intrinsics, then the intrinsics are frozen. **§two-named-stages-in-SES-startup**: vetted-customization-stage + frozen-runtime-stage. The transition IS the freeze.

§the-vetted-IS-the-named-trust-boundary: the customization code IS *vetted* before being given access to the mutable pre-freeze world; once frozen, *no* code can mutate the intrinsics. **§the-trust-IS-front-loaded-to-the-vetted-stage**.

§the-"why-we-refer-to-them-as-vetted"-naming-rationale: the doc explains the term in line — "Although the customizations run confined, because they can arbitrarily mutate the shared intrinsic state before other code runs, all later code is fully vulnerable to these customizations." **§the-explicit-rationale-for-the-named-stage**.

## §the-shopkeeper-analogy as named-domain-shift discipline (first-explicit-observation)

> "An analogy is that vetted customizations are what a shopkeeper does to their shop in preparation for opening for business. Freezing the intrinsics is the last step before opening the doors and allowing in untrusted customers."

**§the-named-analogy-for-an-abstract-startup-stage**: a *named domain* (shopkeeper + shop + opening-for-business) carried in by analogy to make the abstract stage concrete. **§the-analogy-IS-the-pedagogy-bridge**.

§the-shopkeeper-IS-the-named-host-vs-the-customers-IS-the-named-untrusted-code; §the-shop-preparation-IS-the-vetted-customization-stage + §the-opening-the-doors-IS-the-freeze + §the-customers-arriving-IS-the-untrusted-runtime-code. **§three-named-analogue-mappings** for the three named SES startup phases.

§the-named-domain-shift-IS-the-named-pedagogy-discipline: the spec uses an everyday domain (commerce) to illustrate a security boundary that has no familiar analogue in pure code-speak.

## §the-build-time-vs-runtime-mapping (first-explicit-observation)

> "In an IoT context, we should associate these two stages with build-time and runtime. The build-time environment should support more of the Realms and SES APIs for creating a SES world, that would be absent from within the standalone SES world they are creating."

**§the-named-two-named-IoT-stages-mapped-to-named-SES-stages**: build-time = vetted-customization + runtime = frozen-SES. **§the-named-stage-mapping**: the vetted-customization concept (originally a JS-engine startup notion) maps onto the IoT lifecycle (build vs run). The same abstract distinction lives in two named domains.

§three-named-instantiations-of-the-same-pre-freeze-vs-post-freeze-stage:
- JS-engine: vetted-customization + frozen-SES.
- Real-world shop: preparation + opening-for-business.
- IoT: build-time + runtime.

**§the-named-cross-domain-stage-mapping IS the named generalization-axis**.

## §the-frozen-shared-intrinsics-IS-ROM-able (first-explicit-observation)

> "Freeze all shared intrinsics. With the above omissions, there is no hidden state or ambient authority among the shared intrinsics, so transitive freezing means that the shared intrinsics are immutable and rom-able."

**§the-named-ROM-ability-property**: the frozen intrinsics can be placed in read-only memory (ROM) because they reference no objects outside ROM. **§the-named-implementation-target-IS-microcontroller-memory-shape**. §the-spec-anticipates-the-bare-metal-deployment-target.

§the-ROM-able-IS-the-named-bytes-in-static-memory shape: a property only achievable when *all* mutable state is gone. The omissions list IS what makes this possible.

## §the-`Function !== Function.prototype.constructor`-invariant (first-explicit-observation)

> "Each compartment scope has its own `Function`, which does evaluate. All compartment scopes share the same `Function.prototype` and therefore the same `Function.prototype.constructor` which is a function that only throws. Thus, in all compartment scopes, `Function !== Function.prototype.constructor`"

**§the-named-counter-intuitive-invariant**: in standalone SES, `Function` (the eval-capable constructor) IS distinct from `Function.prototype.constructor` (the always-throw stub). This breaks the JS expectation that `F.prototype.constructor === F`.

§the-named-prototype-vs-constructor-decoupling: the prototype chain points back to the throw-only stub; the actual `Function` IS a separate per-compartment binding. **§the-decoupling-IS-the-named-isolation-mechanism**.

§the-counter-intuitive-invariant-IS-named-explicitly: the doc states the invariant as an equation rather than burying it in prose. §the-spec-states-its-counter-intuitive-claims-as-equations.

## §the-`TBD:` section as named-open-questions discipline (first-explicit-observation)

```
TBD:
 * What portion of the additions above are relevant to a standalone
   SES without runtime evaluators?
 * Should `eval` and `Function` actually
   be on a compartment's global object, or should we include them in the
   compartment's global lexical scope?
```

**§the-`TBD:`-section-as-named-open-questions-list** (first-explicit-observation): a section header that IS the abbreviation "TBD" (To Be Determined) followed by a bullet list of open questions. **§the-shorter-name-IS-the-named-section-name**.

§the-document-tracks-its-own-open-questions-inline (sibling-pattern to cycle 287's `## Open Questions` section + cycle 283's `## Open Questions` from endo-gateway). **§three-cycles-with-named-open-questions-section-shapes** (283 + 287 + 291).

§three-named-shapes-for-open-questions:
- `## Open Questions` (cycle 283 + 287; canonical name).
- `## Resolved by review` (cycle 283; pairs with Open Questions).
- `TBD:` (cycle 291; shorter, may appear multiple times in a doc).

§the-cluster-has-named-shapes-for-tracking-unresolved-design-decisions.

## §the-`## Work in Progress` section as named-deferred-topic-marker (first-explicit-observation)

> "## Work in Progress
> We are still working towards specifying how SES supports modules."

**§the-named-deferred-topic-with-named-content** (first-explicit-observation): a section that names a *whole topic* as deferred. **§the-deferred-IS-the-named-non-final-topic**.

§the-Work-in-Progress-section-IS-paired-with-a-subsequent-TBD-list (the section has both a prose description AND a TBD bullet list).

§the-document-IS-explicit-about-what-it-doesn't-yet-cover: §the-named-incompleteness-discipline.

## §the-`## Stage Separated SES`-section-IS-named-distinct-from-standalone-SES (first-explicit-observation)

> "Full SES, as embedded into EcmaScript, supports running vetted customization code in a freezable realm prior to freezing it into a SES realm."

**§the-named-distinction-between-full-SES-and-standalone-SES + the-named-distinction-between-stage-separated-SES-and-the-frozen-SES-environment**. **§three-named-SES-variants** in the doc:

1. **Full SES** (browser/Node; shim-based; multi-root-realm).
2. **Standalone SES** (IoT/blockchain; bespoke engine; possibly no evaluators).
3. **Stage-separated SES** (the pre-freeze-then-freeze pattern within either).

§the-named-multi-variant-discipline: the spec doesn't describe ONE SES; it names ITS VARIANTS and how they relate.

## §the-direct-eval-syntax-low-priority-named-omission (first-explicit-observation)

> "The direct-eval feature is impossible to shim and rarely needed anyway, and so is low priority. When omitted, the direct-eval syntax should also be statically rejected with an early error."

**§the-named-low-priority-omission with explicit rationale**: hard-to-shim + rarely-needed = deprioritized. §the-explicit-priority-naming-as-named-design-discipline.

§the-static-rejection-as-named-error-handling: when a feature IS omitted, the syntax should produce an *early error* (compile-time) rather than a *runtime* error. **§the-named-early-error-discipline**.

## Patterns from prior cycles, reaffirmed

- **§the-no-metadata-table-shape** — this doc has no Created/Author/Status table. **§four-cycles-with-no-metadata-table-shape** (285 + 287 + 289 + 291).
- **§named-Open-Questions-shapes** (283 + 287 + 291) — three cycles now.
- **§Mark-S.-Miller-author-context** — the doc reads as Mark's voice (defensive-consistency framing); §the-MSM-pedagogy-style-IS-named-in-the-cluster-pedagogy (rigorous-with-analogy).

## Borrowing tiers

- **Tier 1 (direct, exact-shape)**: §the-"Draft Spec"-genre-as-named-tentativeness-marker + §the-IoT-vs-blockchain-as-named-runtime-context-pair + §the-shorthand-definition-disclaimer + §the-named-incomplete-enumeration + §the-`## Omissions and Simplifications`-section + §the-subtractive-spec-discipline + §the-spec-as-named-delta-from-a-reference-spec + §nine-named-omissions + §the-three-named-Date-constructor-variants-all-block + §the-exhaustive-named-attack-surface-enumeration + §the-Math.random-and-Date.now-as-named-sources-of-non-determinism + §two-named-sources-of-non-determinism + §the-non-determinism-IS-the-named-attack-vector-for-replicated-computation + §the-shared-globals-and-shared-intrinsics-named-definitions + §the-transitively-reachable-closure-as-named-implementation-discipline + §the-`## Additions`-section-as-named-additive-spec-discipline + §the-Omissions-and-Additions-pair-of-named-sections + §the-feature-detection-via-property-presence + §the-vetted-customization-code-named-stage + §two-named-stages-in-SES-startup + §the-trust-IS-front-loaded-to-the-vetted-stage + §the-explicit-rationale-for-the-named-stage + §the-shopkeeper-analogy + §the-named-analogy-for-an-abstract-startup-stage + §the-analogy-IS-the-pedagogy-bridge + §three-named-analogue-mappings + §the-build-time-vs-runtime-mapping + §the-named-stage-mapping + §three-named-instantiations-of-the-same-pre-freeze-vs-post-freeze-stage + §the-frozen-shared-intrinsics-IS-ROM-able + §the-named-ROM-ability-property + §the-`Function !== Function.prototype.constructor`-invariant + §the-named-counter-intuitive-invariant + §the-decoupling-IS-the-named-isolation-mechanism + §the-`TBD:`-section-as-named-open-questions-list + §the-`## Work in Progress`-section-as-named-deferred-topic-marker + §the-named-incompleteness-discipline + §the-`## Stage Separated SES`-section + §three-named-SES-variants + §the-named-multi-variant-discipline + §the-direct-eval-syntax-low-priority-named-omission + §the-named-early-error-discipline — all forty-one first-explicit-observations.
- **Tier 2 (clear analogue, named-shape)**: §three-named-shapes-for-open-questions (Open-Questions + Resolved-by-review + TBD) + §the-spec-states-its-counter-intuitive-claims-as-equations + §the-named-cross-domain-stage-mapping + §the-spec-defines-its-own-vocabulary-explicitly.
- **Tier 3 (multi-cycle pattern recognition)**: §three-cycles-with-named-tentativeness-marker-locations (263 prose-hedge + 288 code-comment + 291 document-title) + §three-cycles-with-named-open-questions-section-shapes (283 + 287 + 291) + §four-cycles-with-no-metadata-table-shape (285 + 287 + 289 + 291).

## Synthesis target

Slot machine library `@game/replay/docs/draft-standalone-spec.md` (a draft spec for deterministic-replicated game engine): "Draft Spec for ..." in the title (named tentativeness marker); two named non-browser runtime contexts (IoT slot-machine + blockchain casino); shorthand definition disclaimer for "blockchain"; `## Omissions and Simplifications` section enumerating what's removed; `## Additions` section enumerating what's new; named sources of non-determinism (Math.random + Date.now + Date constructor variants); shared-globals + shared-intrinsics + transitively-reachable-closure as named technical terms; feature-detection-via-property-presence (`Realm.makeRootRealm` IS optional); vetted-customization-stage as named pre-freeze phase + frozen-runtime-stage as named post-freeze phase; the-shopkeeper analogy for the abstract stages; build-time-vs-runtime mapping for IoT; ROM-able-frozen-intrinsics; counter-intuitive `GameEngine !== GameEngine.prototype.constructor` invariant stated as equation; `TBD:` section as open-questions list; `## Work in Progress` for named deferred topics; three named SES variants → three named game-engine variants; named early-error discipline for omitted features.

## Single most structurally interesting move

**§the-three-named-instantiations-of-the-same-pre-freeze-vs-post-freeze-stage** with **§the-shopkeeper-analogy** as the pedagogy bridge — the doc describes ONE abstract pattern (mutable-then-frozen state) and instantiates it in **three named domains**: the JS-engine (vetted-customization → frozen-SES), the everyday domain (shop preparation → opening), and the IoT lifecycle (build-time → runtime). The shopkeeper analogy IS the named pedagogy device that lets a reader transfer understanding *between* the abstract and concrete instantiations.

This is **§the-named-cross-domain-stage-mapping IS the named generalization-axis** — the spec doesn't just describe an implementation; it names the *kind of thing* the implementation IS, and shows the same kind of thing in adjacent domains. The reader can transfer the stage-mapping to *yet another domain* (database transaction commit; build pipeline; deployment) by the same analogical move.

§the-spec-IS-pedagogically-multi-tiered: an abstract technical layer + an everyday-domain analogy + a concrete deployment-context mapping. The reader IS not asked to grasp one layer; the reader IS given three named layers that mutually reinforce.
