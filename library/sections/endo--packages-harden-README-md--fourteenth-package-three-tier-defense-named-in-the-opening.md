---
title: "@endo/harden README.md — fourteenth package; three-tier-defense-named-in-the-opening; helpful-stack-on-misuse; honest-regret-with-named-migration; closes 16-plus citation arcs across the substrate-cluster"
source: endo--packages-harden-README-md
url: https://github.com/endojs/endo/blob/master/packages/harden/README.md
authors: [Kris Kowal, Mark S. Miller, Jean-Francois Paradis, Endo project (collective)]
repo: endojs/endo
path: packages/harden/README.md
total-lines: 158
ingest-cycle: 337
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-three-tier-defense-named-in-the-opening
  - the-named-threat-model-named-first
  - the-named-supply-chain-attack-IS-named-threat-model
  - the-named-place-to-stand-toward-its-own-defense-metaphor
  - the-named-dual-purpose-of-harden
  - the-named-Object-Symbol.for-harden-intrinsic
  - the-named-intrinsic-over-endowment-discipline
  - the-named-build-condition-as-policy-knob
  - the-named-two-named-build-conditions
  - the-named-multiple-instances-first-call-wins
  - the-named-shim-like-behavior-pre-lockdown
  - the-named-with-OR-without-NOT-both-policy
  - the-named-temporal-ordering-creates-vulnerability
  - the-named-helpful-stack-on-misuse
  - the-named-stack-points-to-the-offending-module
  - the-named-isFake-deprecated-with-named-regret
  - the-named-honest-regret-in-README
  - the-named-migration-path-with-named-alternative
  - the-named-Without-HardenedJS-degradation-mode
  - the-named-partial-safety-with-named-tradeoff
  - the-named-test-and-UI-framework-acknowledgment
  - the-named-six-section-policy-README-shape
  - the-named-fourteenth-package-in-the-pivot-cluster
  - twenty-eight-cycles-with-named-pivot-domain-stay
  - fifty-six-citation-arc-closures-in-pivot-now
  - the-named-substrate-package-with-policy-README
---

# `@endo/harden README.md` — fourteenth package; three-tier defense named in the opening

The 158-line README of @endo/harden, the substrate-level package whose `harden()` function is imported across nearly every pivot source. Cycle 337 is **designs-lane after cycle 336's chat-lane @endo/promise-kit/src/memo-race.js** (cross-package adjacent pair; not a same-package README↔source pair).

**Twenty-eighth consecutive non-garden source after the pivot** (cycles 310-337). **§twenty-eight-cycles-with-named-pivot-domain-stay**. **§fourteen-named-packages-in-the-pivot-cluster** — @endo/harden joins as the FOURTEENTH PACKAGE (nat + memoize + hex + lp32 + stream + eventual-send + exo + captp + pass-style + patterns + marshal + common + promise-kit + harden).

The @endo/harden package has been **referenced from sixteen-plus prior cycles** without the README itself being ingested. Cycles touching `e56bf00f` (the @endo/harden migration commit): 108 + 110 + 115 + 118 + 123 + 125 + 132 + 134 + 136 + 138 + 140 + 144 + 148 + 150 + 152 + 154. Plus all subsequent pivot cycles whose source imports `import harden from '@endo/harden';`. Cycle 337 is the **documentation-side closure** of every one of those implementation-side observations.

## The single most structurally interesting move

**§the-named-three-tier-defense-named-in-the-opening** — lines 3-17 of the README open with the threat model and three coordinated defenses:

1. **Sentence 1 (lines 3-5)**: *"Hardened modules are modules that make their interface resist tampering by other modules that import them, **making them less susceptible to supply chain attack**."*
2. **Tier 1 — HardenedJS (lines 7-12)**: *"In HardenedJS, the global `harden` function transitively freezes an object and all of the objects that are reachable by walking chains of properties and prototypes. All the primordials like `Array.prototype` and `Object` are frozen in this environment, **which gives your module a place to stand toward its own defense**."*
3. **Tier 2 — LavaMoat (lines 13-17)**: *"Then, with LavaMoat, each package is credibly isolated and only receives the subset of globals and host modules it needs to function. That is, we can enforce **Principle of Least Authority**."*
4. **Tier 3 — harden() (lines 18-19)**: *"But, that leaves the module to use `harden` to freeze all its exports and anything it returns that might be shared by other packages that use it."*

**§the-named-three-tier-defense-named-in-the-opening** — first-explicit-observation as a tier-3 meta-pattern. The README's opening paragraph:
- Names the **threat** first (supply chain attack via tampering)
- Names **three coordinated defenses** — HardenedJS (primordials) + LavaMoat (POLA) + harden() (per-module hardening)
- Identifies **the package's role** as the third tier — what to do AFTER your environment gives you a place to stand

**§the-named-threat-model-named-first** — first-explicit-observation. README opens with WHAT WE ARE DEFENDING AGAINST before HOW WE DEFEND. Compare to cycle 317 @endo/hex README (§the-named-supply-chain-attack-exposure-IS-named-threat-model-for-harden, which named the threat model in the *context of the hex package*); cycle 337 is the **canonical statement** of the threat model — supply chain attack is the *primary* threat that the entire HardenedJS stack defends against.

**§the-named-supply-chain-attack-IS-named-threat-model** — first-explicit-observation as the canonical threat-model anchor. The phrase *"supply chain attack"* appears in the README's first sentence; no other threat is named higher. Tier-3 meta-pattern: when a substrate package's README defines a defense, name the threat at the highest level.

**§the-named-place-to-stand-toward-its-own-defense-metaphor** — first-explicit-observation. The phrase *"gives your module a place to stand toward its own defense"* is a vivid metaphor for what HardenedJS provides. Compare to cycle 87 pass-style/error.js's §V8-stack-accessor-channel (a metaphor for capability channels). Two cycles with named architectural metaphors in @endo. **§two-cycles-with-named-architectural-metaphor** (87 + 337).

## §the-named-dual-purpose-of-harden

Lines 21-24:

> In order to provide type information about the global `harden` in locked-down HardenedJS, **and also** to make it possible for hardened modules to be used outside HardenedJS, the `@endo/harden` package exports a `harden` function that can be used either way.

**§the-named-dual-purpose-of-harden** — first-explicit-observation. ONE package serves TWO purposes:
1. **Type information** — give TypeScript a typed surface for the global `harden`
2. **Cross-environment portability** — let hardened modules work both *inside* HardenedJS (where global harden is real) and *outside* (where harden degrades gracefully)

The dual purpose is named **explicitly with "and also"** as the conjunction. The README does not bury one purpose behind the other; both are stated as primary.

**§the-named-and-also-as-two-purpose-conjunction** — first-explicit-observation. Compare to cycle 333 @endo/common's §the-named-four-named-membership-criteria (four named purposes for the package); §the-named-dual-purpose is the two-purpose variant of the same naming discipline.

**§the-named-substrate-package-with-policy-README** — first-explicit-observation. The README documents **purposes and policies**, not API. Compare to cycle 333 @endo/common's §the-named-README-as-policy-not-API; cycle 337 harden's README extends the pattern: substrate-packages with policy-README shape (not API documentation).

## §the-named-Object-Symbol.for-harden-intrinsic

Lines 42-43 + 55-59:

> The package `@endo/harden` reexports `Object[Symbol.for('harden')]` or `globalThis.harden` in its execution environment, **in order of preference**. (...)
>
> The `harden` in `@endo/harden` **prefers `Object[Symbol.for('harden')]`** because endowments cannot override that intrinsic. Any multi-tenant `Compartment` should freeze its own `globalThis`, including making `harden` non-configurable and non-writable, so there is no risk of tampering.

**§the-named-Object-Symbol.for-harden-intrinsic** — first-explicit-observation. The intrinsic location is `Object[Symbol.for('harden')]` — a SHARED intrinsic property accessed through Symbol.for. **Why a symbol property?** Because:
- Plain string property names (`Object.harden`) would collide with user code; symbols don't
- `Symbol.for(name)` creates a *registered symbol* available across realms — every compartment that calls `Symbol.for('harden')` gets the same symbol
- `Object` is a hardened shared intrinsic; properties of it cannot be overridden in a compartment

**§the-named-intrinsic-over-endowment-discipline** — first-explicit-observation. The discipline: **when both an intrinsic property and an endowment can provide a capability, prefer the intrinsic** because endowments can be overridden in nested compartments. Compare to cycle 142 passStyle-helpers.js's §safer-but-slower-on-XS tradeoff (different security/performance trade-off); §the-named-intrinsic-over-endowment is the security/portability variant. **§the-named-intrinsic-vs-endowment-distinction** as a tier-3 meta-pattern.

**§the-named-cannot-be-subverted-in-a-compartment** — line 53: *"a property of one of the hardened shared intrinsics and **cannot be subverted in a compartment**"*. The README NAMES THE INVARIANT explicitly. **§the-named-invariant-named-with-cannot-language** — first-explicit-observation. "Cannot" is a stronger guarantee than "should not" or "is not"; the README uses the strongest available language. Compare to cycle 152 memo-race.js's §state-machine-with-frozen-terminal-state (state can't be un-frozen).

## §the-named-build-condition-as-policy-knob

Two build conditions named in the README:

| Build condition | Section | Behavior |
|---|---|---|
| `-C hardened` | "With HardenedJS" (lines 61-68) | Smallest version; throws if `harden` not present |
| `-C harden:unsafe` | "Without HardenedJS" (lines 83-85) | Opt out of safety guarantees; avoid transitive-harden computation cost |

**§the-named-build-condition-as-policy-knob** — first-explicit-observation. The build condition is a **policy knob exposed at build time**. The two conditions span the safety-vs-cost spectrum:
- `-C hardened` — *we assert this code runs in HardenedJS; fail loud if not*
- `-C harden:unsafe` — *we opt out of safety; pay no harden cost*

**§the-named-two-named-build-conditions** — first-explicit-observation. The README names BOTH endpoints of the policy spectrum, not just one. Compare to cycle 183 @endo/init's §tolerance-ladder-via-separate-entry-point-files (four entry-point files for four safety levels); §the-named-build-condition-as-policy-knob is the build-time variant of the same tolerance-discipline. **§two-shapes-of-policy-knob** (separate-entry-point-files + build-condition) — first-explicit-observation as a tier-3 meta-pattern.

**§the-named-fail-loud-or-pay-cost-binary-choice** — first-explicit-observation. The build conditions encode a binary policy: either *fail loud in non-HardenedJS environments* OR *don't pay the harden cost*. There is no middle ground at build time; the middle ground (degraded-mode harden) is the default. Three named modes:
1. `-C hardened` — strict-only mode
2. (default) — degraded-mode (own-properties only; no prototype-chain traversal)
3. `-C harden:unsafe` — no-harden mode

**§the-named-three-build-time-modes** — first-explicit-observation.

## §the-named-multiple-instances-first-call-wins

Lines 87-97 (Multiple instances section):

> The first call to `harden` from any instance of `@endo/harden` determines the behavior of any subsequent instance of `@endo/harden` that initializes later, regardless of differences in behavior.
> In a mutable, pre-lockdown JavaScript environment, it does this by **behaving somewhat like a shim**.
> A side-effect of that first call is that it installs its flavor of `harden` at `Object[Symbol.for('harden')]` and all subsequent initializations just adopt that behavior.
> This property is how `lockdown` senses that it should fail.

**§the-named-multiple-instances-first-call-wins** — first-explicit-observation. Multiple copies of @endo/harden can be loaded (npm hoisting, multi-version dependency trees). The first-call-wins discipline means: **whichever instance calls `harden` first installs its implementation at the shared intrinsic location; all subsequent instances adopt that implementation**. The discipline is enforced by the shared intrinsic location (`Object[Symbol.for('harden')]`) — once any instance writes there, it's visible to all.

**§the-named-shim-like-behavior-pre-lockdown** — first-explicit-observation. The README's own framing: *"behaving somewhat like a shim"*. The package is not a shim (because it has its own API); but it *behaves* like one in the pre-lockdown phase by installing at a global location. Compare to cycle 187's §two-shim-strategies-side-by-side (conditional vs unconditional); §the-named-shim-like-behavior-pre-lockdown is a third shim shape: shim-like-by-side-effect-of-first-call.

**§the-named-side-effect-as-coordination-mechanism** — first-explicit-observation. The first call has a SIDE EFFECT (installation at the shared intrinsic location) that becomes the coordination mechanism for all subsequent instances. Tier-3 meta-pattern: when multiple instances of a package can coexist, use a SIDE EFFECT at a SHARED LOCATION as the coordination mechanism.

**§the-named-lockdown-senses-failure-via-installed-harden** — line 96-97: *"This property is how `lockdown` senses that it should fail."* The README ACKNOWLEDGES that lockdown uses the installed harden as a sentinel for whether harden has been called pre-lockdown. **§the-named-installed-harden-as-pre-lockdown-sentinel** — first-explicit-observation. Tier-3 meta-pattern: pre-lockdown discipline violations are detectable by the *presence* of the installed harden at the shared intrinsic location.

## §the-named-with-OR-without-NOT-both-policy

Section heading lines 99-116 — *"With or Without not Both"*:

> However, initializing a hardened module before setting up a HardenedJS environment (before calling `lockdown`) and then proceeding on the assumption that it's hardened after `lockdown` would leave the apparently-hardened module **vulnerable**.

**§the-named-with-OR-without-NOT-both-policy** — first-explicit-observation. The section heading itself encodes the policy with explicit NOT BOTH language. The discipline:
- **WITH HardenedJS** is fine (transitive freeze + intrinsic-protected harden)
- **WITHOUT HardenedJS** is fine (partial-safety degraded mode)
- **MIXED (start without, switch to with)** is NOT fine because the apparently-hardened module is actually only partially hardened, and post-lockdown code assumes full hardening

**§the-named-temporal-ordering-creates-vulnerability** — first-explicit-observation. The vulnerability is **temporal** — it's not about WHAT but about WHEN. A module hardened *before* lockdown is structurally identical to a module hardened *after* lockdown — but the *guarantees* differ because the *environment* changed between them.

**§the-named-helpful-stack-on-misuse** — lines 109-113:

> So, `@endo/harden` arranges for `lockdown()` and `repairIntrinsics()` to throw an exception with a **_helpful_** stack if `harden` gets called before either one.
> The stack **points to the module that was initialized before `lockdown`** and which should be moved after `lockdown`.

**§the-named-helpful-stack-on-misuse** — first-explicit-observation. The package implements a runtime check: if harden was called before lockdown, the lockdown throws with a stack that **points to the offending module**. The stack is the *diagnostic*; the module reference is the *fix-location*.

**§the-named-stack-points-to-the-offending-module** — first-explicit-observation. Compare to cycle 87 pass-style/error.js's §V8-own-stack-accessor (capability channel via stack); cycle 336 memo-race's §honest-TODO-with-named-obstacle (acknowledges the gap but doesn't fix at runtime); §the-named-helpful-stack-on-misuse is a third stack-based discipline — runtime-detected misuse with stack-pointing-to-the-fix. **§three-cycles-with-named-stack-as-diagnostic** (87 + 336 + 337) — first-explicit-observation.

**§the-named-prepare-star-convention** — line 115-116: *"The `lockdown` call often occurs as a side-effect of initializing `@endo/lockdown`, `@endo/init`, or **by convention, modules with names like `prepare-*`**."* The README names a NAMING CONVENTION explicitly. Modules whose names start with `prepare-` are by convention initialization-side-effect modules. **§the-named-naming-convention-as-import-time-side-effect-marker** — first-explicit-observation as a tier-3 meta-pattern. Sibling to cycle 187's prepare-endo.js + prepare-endo-config.js — those are instances of the named convention.

## §the-named-isFake-deprecated-with-named-regret

Section heading lines 127-149 — *"isFake (deprecated)"*:

> We **regret this misfeature**.

**§the-named-isFake-deprecated-with-named-regret** — first-explicit-observation. The package's own README **explicitly regrets a past design decision**. This is stronger language than "deprecated" — deprecation says *don't use this*; regret says *we made a mistake*.

**§the-named-honest-regret-in-README** — first-explicit-observation as a tier-3 meta-pattern. Compare to:
- Cycle 326 @endo/patterns/index.js: @deprecated tags with canonical pointers (deprecation with redirect)
- Cycle 336 @endo/promise-kit/src/memo-race.js: §the-named-honest-TODO-with-named-obstacle (incomplete refactor honestly named)
- Cycle 337 @endo/harden README: §the-named-isFake-deprecated-with-named-regret (past design choice explicitly regretted)

**§three-shapes-of-honesty-about-past-decisions** — deprecation-with-redirect (326) + TODO-with-named-obstacle (336) + deprecated-with-named-regret (337). First-explicit-observation as a tier-3 meta-pattern.

**§the-named-migration-path-with-named-alternative** — lines 137-145:

> Code, especially tests, migrating to use `@endo/harden` should refactor `harden.isFake` to use a more legible indicator of the misbehavior of `isFrozen` and its compatriots. (...)
> For example, `Object.isFrozen({})` when `harden.isFake` and more clearly conveys the reason a test might be invalidated by `unsafe` `hardenTaming`.
> Testing that the outcome of `Object.isFrozen({})` is the same as the outcome of `Object.isFrozen(object)` for an object that should not be frozen makes a test work just as well between `safe` and `unsafe` `hardenTaming`.

The README provides the **migration code itself** for the deprecated feature. Not just *"don't use isFake"*; rather *"here's the more-legible code to use instead"*. **§the-named-migration-path-with-named-alternative** — first-explicit-observation. Compare to cycle 326's @deprecated *"Import directly from `@endo/common/list-difference.js` instead"* — different deprecation shape (pointer to canonical location); cycle 337's shape is *worked-migration-code-with-named-rationale*.

**§the-named-deprecation-explains-WHY-the-alternative-works** — first-explicit-observation. Lines 143-145 explain WHY `Object.isFrozen({})` is the right alternative: *"makes a test work just as well between `safe` and `unsafe` `hardenTaming`"*. The migration code is justified, not just provided.

**§the-named-hardenIsNoop-as-replacement-API** — line 147-148:

> The module `@endo/harden/is-noop.js` provides `hardenIsNoop(harden)` to detect whether `harden` is a no-op, regardless of `hardenTaming`.

A separate module (is-noop.js) provides a **named replacement API** for the deprecated isFake. Cycle 337 sees the README pointing to a separate file in the same package as the canonical replacement. **§the-named-deprecation-points-to-named-replacement-in-same-package** — first-explicit-observation. Compare to cycle 326's deprecation-points-to-different-package; §the-named-deprecation-points-to-named-replacement-in-same-package is the intra-package variant.

## §the-named-Without-HardenedJS-degradation-mode

Lines 70-81 (Without HardenedJS section):

> Libraries that use `@endo/harden` can be used without HardenedJS and the exported `harden` freezes the object itself and the transitive own properties of the object, **and does not traverse prototype chains**.
>
> Consequently, the surface of an object is immutable. However, if any fields of an object are optional, an attacker can subvert them **by altering their prototype**.
> This provides a degree of immutability that is useful for partial safety and does not interfere with uncoordinated alteration of the realm intrinsics, on which some testing and frontend user interface frameworks rely.

**§the-named-Without-HardenedJS-degradation-mode** — first-explicit-observation. The README explicitly documents the **degradation mode**:
- WHAT WORKS: surface immutability via transitive own-properties freeze
- WHAT DOESN'T: prototype-chain traversal — attackers can subvert via prototype alteration
- WHO BENEFITS: testing frameworks + frontend UI frameworks that rely on alterable intrinsics

**§the-named-partial-safety-with-named-tradeoff** — first-explicit-observation. The README NAMES the partial-safety mode as *useful* (not just acceptable). The tradeoff is named explicitly: less safety in exchange for compatibility with testing/UI frameworks.

**§the-named-test-and-UI-framework-acknowledgment** — first-explicit-observation. The README acknowledges PARALLEL ECOSYSTEM CONSTRAINTS: testing and UI frameworks rely on alterable intrinsics; @endo/harden in degraded mode coexists with them. Compare to cycle 327 @endo/patterns README's §the-named-three-Why-X-sections (three context-setting paragraphs); §the-named-test-and-UI-framework-acknowledgment is a one-line variant — name the parallel ecosystem in a single clause.

**§the-named-uncoordinated-alteration-of-realm-intrinsics** — the phrase is the README's own naming for what testing and UI frameworks do. The pejorative-sounding word "uncoordinated" is used neutrally as a technical description of the alteration pattern. **§the-named-precise-technical-language-without-pejorative-tone** — first-explicit-observation as a tier-3 meta-pattern. Compare to cycle 186's *"illusion of an option"* (sharper pejorative); cycle 337's *"uncoordinated alteration"* is the neutral variant. **§two-shapes-of-precise-technical-language** (sharp + neutral) — first-explicit-observation.

## §the-named-six-section-policy-README-shape

The README's section structure:

| Section | Lines | Purpose |
|---|---|---|
| (intro, no heading) | 1-38 | Threat model + three-tier defense + canonical-import pattern |
| With HardenedJS | 40-68 | Intrinsic-over-endowment + build-condition `-C hardened` |
| Without HardenedJS | 70-85 | Degradation mode + tradeoff + build-condition `-C harden:unsafe` |
| Multiple instances | 87-97 | First-call-wins coordination |
| With _or_ Without _not_ Both | 99-116 | Temporal-ordering vulnerability + helpful-stack-on-misuse |
| Configurability of Compartment harden | 118-125 | Intrinsic-over-endowment elaboration |
| isFake (deprecated) | 127-149 | Honest-regret + migration-path |

**Six headed sections + one heading-less intro = seven sections** (cycle 335 @endo/promise-kit had six total). **§the-named-six-headed-section-policy-README-shape** — first-explicit-observation. Compare:
- Cycle 333 @endo/common (17 lines; no canonical sections) — collection-package shape
- Cycle 335 @endo/promise-kit (71 lines; six-section README) — utility-package shape
- Cycle 337 @endo/harden (158 lines; seven sections) — **substrate-package policy README shape**

**§the-named-substrate-package-with-policy-README** as a new package category. **§the-named-four-shapes-of-README** — collection + utility + substrate-policy + substrate-deep (cycle 325 pass-style). First-explicit-observation as a tier-3 meta-pattern refining cycle 333's three-way categorization with a fourth category.

## Closes citation arcs (substrate-cluster documentation-side closure)

Cycle 337 is the **documentation-side closure** of every prior cycle that observed `import harden from '@endo/harden';` or that touched the `e56bf00f` migration commit. The arcs:

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 108 (exo-makers; e56bf00f migration first observation) | 229 cycles | First implementation-side observation of @endo/harden migration |
| Cycle 110 (e56bf00f cluster member) | 227 cycles | Same migration commit |
| Cycle 115 (e56bf00f cluster member) | 222 cycles | Same migration commit |
| Cycle 118 (exo-tools; e56bf00f cluster) | 219 cycles | Same migration commit + exo-tools imports harden |
| Cycle 142 (passStyle-helpers.js isPrimitive duplication) | 195 cycles | layering-constraints related to @endo/harden positioning |
| Cycle 148 (symbol.js) | 189 cycles | Imports @endo/harden |
| Cycle 150 (typeGuards.js) | 187 cycles | Imports @endo/harden |
| Cycle 152 (memo-race.js comment-fragment) | 185 cycles | First @endo/promise-kit ingest imports @endo/harden |
| Cycle 154 (trap.js) | 183 cycles | Imports @endo/harden |
| Cycle 173 (promise-executor-kit.js) | 164 cycles | Imports @endo/harden |
| Cycle 187 (shim-and-prepare cluster) | 150 cycles | §two-shim-strategies-side-by-side |
| Cycle 211 (@endo/common; harden in dependency-ceiling) | 126 cycles | Names harden as substrate-ceiling |
| Cycle 322 (exo-makers complementary-lens) | 15 cycles | harden() throughout |
| Cycle 325 (pass-style README) | 12 cycles | harden() across the surface |
| Cycle 333 (@endo/common README dependency-ceiling) | 4 cycles | Names @endo/harden in the ceiling |
| Cycle 336 (memo-race.js complementary-lens; line 31 `import harden from '@endo/harden';`) | 1 cycle | Cross-package adjacent pair (NOT same-package) |

**§sixteen-citation-arc-closures-in-cycle-337**. The cycle 108 arc of 229 cycles is the **second-longest pivot arc** (current record: 261 cycles from cycle 69 → 330). **§fifty-six-citation-arc-closures-in-pivot-now** (50 + 6 net new, after deduping arcs already counted).

**§the-named-substrate-package-introduction-closes-many-arcs** — first-explicit-observation as a librarian discipline. When a substrate package's README is finally ingested after many prior cycles have observed its usage in source code, the introduction cycle closes a *cascade* of arcs back to those source-side observations. Tier-3 meta-pattern: the documentation-side ingest of a substrate package is the **closing move** of a long-running citation network.

## Multi-cycle patterns extended

- §twenty-eight-cycles-with-named-pivot-domain-stay (310-337)
- §fourteen-named-packages-in-the-pivot-cluster (harden joins as the FOURTEENTH)
- §fifty-six-citation-arc-closures-in-pivot-now (50 + 6 net new)
- §three-cycles-with-named-stack-as-diagnostic (87 + 336 + 337)
- §three-shapes-of-honesty-about-past-decisions (326 + 336 + 337)
- §two-shapes-of-policy-knob (separate-entry-point-files cycle 183 + build-condition cycle 337)
- §two-cycles-with-named-architectural-metaphor (87 + 337)
- §two-shapes-of-precise-technical-language (sharp cycle 186 + neutral cycle 337)
- §the-named-streak-of-one (cycle 335 → 336 was the lone instance after the seven-cycle streak ended; cycle 336 → 337 is cross-package, ending the streak again at 1)

## Tier-1 borrowing (twenty-five-plus first-explicit-observations)

- **§the-named-three-tier-defense-named-in-the-opening** — threat + three coordinated defenses in the opening paragraph
- **§the-named-threat-model-named-first** — name what we're defending against before how we defend
- **§the-named-supply-chain-attack-IS-named-threat-model** — canonical threat-model anchor
- **§the-named-place-to-stand-toward-its-own-defense-metaphor** — vivid architectural metaphor
- **§the-named-dual-purpose-of-harden** — and-also conjunction; one package, two purposes
- **§the-named-and-also-as-two-purpose-conjunction**
- **§the-named-substrate-package-with-policy-README**
- **§the-named-Object-Symbol.for-harden-intrinsic** — registered-symbol property on shared intrinsic
- **§the-named-intrinsic-over-endowment-discipline**
- **§the-named-cannot-be-subverted-in-a-compartment**
- **§the-named-invariant-named-with-cannot-language**
- **§the-named-build-condition-as-policy-knob**
- **§the-named-two-named-build-conditions**
- **§the-named-fail-loud-or-pay-cost-binary-choice**
- **§the-named-three-build-time-modes**
- **§the-named-multiple-instances-first-call-wins**
- **§the-named-shim-like-behavior-pre-lockdown**
- **§the-named-side-effect-as-coordination-mechanism**
- **§the-named-installed-harden-as-pre-lockdown-sentinel**
- **§the-named-with-OR-without-NOT-both-policy**
- **§the-named-temporal-ordering-creates-vulnerability**
- **§the-named-helpful-stack-on-misuse**
- **§the-named-stack-points-to-the-offending-module**
- **§the-named-prepare-star-convention**
- **§the-named-naming-convention-as-import-time-side-effect-marker**
- **§the-named-isFake-deprecated-with-named-regret**
- **§the-named-honest-regret-in-README**
- **§the-named-migration-path-with-named-alternative**
- **§the-named-deprecation-explains-WHY-the-alternative-works**
- **§the-named-hardenIsNoop-as-replacement-API**
- **§the-named-deprecation-points-to-named-replacement-in-same-package**
- **§the-named-Without-HardenedJS-degradation-mode**
- **§the-named-partial-safety-with-named-tradeoff**
- **§the-named-test-and-UI-framework-acknowledgment**
- **§the-named-precise-technical-language-without-pejorative-tone**
- **§the-named-uncoordinated-alteration-of-realm-intrinsics**
- **§the-named-six-headed-section-policy-README-shape**
- **§the-named-four-shapes-of-README** (refines cycle 333's three-way categorization)

## Tier-2 borrowing (multi-cycle patterns extended)

- §twenty-eight-cycles-with-named-pivot-domain-stay (310-337)
- §fourteen-named-packages-in-the-pivot-cluster
- §fifty-six-citation-arc-closures-in-pivot-now
- §three-cycles-with-named-stack-as-diagnostic (87 + 336 + 337)
- §three-shapes-of-honesty-about-past-decisions (326 deprecation-with-redirect + 336 TODO-with-named-obstacle + 337 deprecated-with-named-regret)
- §two-shapes-of-policy-knob (cycle 183 separate-entry-point-files + cycle 337 build-condition)
- §two-cycles-with-named-architectural-metaphor (87 V8-stack-accessor-channel + 337 place-to-stand)
- §two-shapes-of-precise-technical-language (186 sharp + 337 neutral)

## Tier-3 borrowing (meta-patterns)

- **§the-named-three-tier-defense-named-in-the-opening** — README opening names threat + coordinated defenses + package's role in the stack
- **§the-named-threat-model-named-first** — name the threat before naming the defense
- **§the-named-supply-chain-attack-IS-named-threat-model** — canonical threat anchor for the whole HardenedJS stack
- **§the-named-intrinsic-vs-endowment-distinction** — when both intrinsic-property and endowment provide a capability, prefer the intrinsic
- **§the-named-two-shapes-of-policy-knob** — separate-entry-point-files + build-condition; both expose policy choices
- **§the-named-side-effect-as-coordination-mechanism** — when multiple instances can coexist, use a side effect at a shared location as the coordination mechanism
- **§the-named-temporal-ordering-creates-vulnerability** — same structural state at different times can have different guarantees
- **§the-named-stack-points-to-the-offending-module** — runtime-detected discipline violations should provide stack-pointing-to-the-fix
- **§three-shapes-of-honesty-about-past-decisions** — deprecation-with-redirect + TODO-with-named-obstacle + deprecated-with-named-regret
- **§the-named-deprecation-explains-WHY-the-alternative-works** — migration code justified, not just provided
- **§the-named-partial-safety-with-named-tradeoff** — degraded modes named as useful, not just acceptable
- **§the-named-test-and-UI-framework-acknowledgment** — name parallel ecosystem constraints
- **§the-named-precise-technical-language-without-pejorative-tone** — use neutral technical language for pattern names that could be pejorative
- **§the-named-four-shapes-of-README** — collection + utility + substrate-policy + substrate-deep (refines cycle 333)
- **§the-named-substrate-package-introduction-closes-many-arcs** — substrate documentation-side ingest closes a cascade of source-side arcs

## Synthesis-target

Slot machine library **§`@game/harden/README.md`** — substrate-package policy README:

1. **Threat model named first** — open with what we're defending against (e.g., cheating, unauthorized state mutation, side-channel attacks)
2. **Three-tier defense named in the opening** — name the threat + three coordinated defenses + the package's role in the stack
3. **Architectural metaphor for what the substrate provides** — *"a place to stand toward its own defense"* is borrowable; a slot-machine substrate could give modules *"a deterministic foundation for their own randomness"*
4. **Dual-purpose with and-also conjunction** — name multiple purposes explicitly; don't bury one behind the other
5. **Intrinsic over endowment** — when an intrinsic property AND a global both provide a capability, prefer the intrinsic
6. **Build conditions as policy knobs** — expose policy choices at build time; name both endpoints of the spectrum
7. **First-call-wins coordination for multiple instances**
8. **With OR Without NOT Both** — name the temporal-ordering trap explicitly
9. **Helpful stack on misuse** — runtime-detected discipline violations point to the offending module
10. **prepare-* naming convention** — by convention, modules whose names start with `prepare-` are initialization-side-effect modules
11. **Honest regret + migration path with named alternative** — when deprecating a past design choice, explicitly regret it and provide migration code with the rationale
12. **Degradation mode named with tradeoff** — when the package works in a less-safe environment, name what works AND what doesn't AND who benefits
13. **Precise technical language without pejorative tone** — *"uncoordinated alteration"* not *"misuse"*
14. **Six-headed-section policy README shape** for substrate-packages

## Library state after cycle 337

- §library-reaches-849-sections from 382 source documents (one new source page; one new section)
- §one-hundred-and-seventieth consecutive designs-chat alternation
- §twenty-eight-cycles-with-named-pivot-domain-stay
- §fourteen-named-packages-in-the-pivot-cluster (harden joins as the FOURTEENTH)
- §fifty-six-citation-arc-closures-in-pivot-now (MILESTONE — fifty crossed in cycle 336; cycle 337 adds six net new)
- §three-shapes-of-honesty-about-past-decisions established as a tier-3 meta-pattern
- §two-shapes-of-policy-knob (separate-entry-point-files cycle 183 + build-condition cycle 337) established as a tier-3 meta-pattern
- §the-named-four-shapes-of-README established as a tier-3 meta-pattern refining cycle 333's three-way categorization
- §the-named-substrate-package-introduction-closes-many-arcs established as a librarian-discipline observation
- §the-named-three-tier-defense-named-in-the-opening established as a tier-3 meta-pattern
- §the-named-supply-chain-attack-IS-named-threat-model named as the canonical threat anchor for the entire HardenedJS stack
