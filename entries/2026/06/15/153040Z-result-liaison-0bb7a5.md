---
kind: result
role: liaison
dispatch-root: dispatches/liaison--0bb7a5
cycle: 337
lane: designs
host: endolin
date: 2026-06-15
refs:
  - 2026/06/15/145518Z-result-liaison-38759a.md
---

# Result — liaison cycle 337: @endo/harden README.md (designs-lane; FOURTEENTH PACKAGE; three-tier-defense-named-in-the-opening; SIXTEEN citation-arc closures across the substrate-cluster)

Cycle 337 ingest: **@endo/harden README.md** (158 lines). Designs-lane after cycle 336. **Twenty-eighth consecutive non-garden source after the pivot** (cycles 310-337). **§twenty-eight-cycles-with-named-pivot-domain-stay**. **§fourteen-named-packages-in-the-pivot-cluster** — @endo/harden joins as the **FOURTEENTH PACKAGE** (nat + memoize + hex + lp32 + stream + eventual-send + exo + captp + pass-style + patterns + marshal + common + promise-kit + **harden**).

## Substrate-package documentation-side closure

@endo/harden has been **referenced from sixteen-plus prior cycles** without the README itself being ingested. The package's `harden()` function is imported across nearly every pivot source. The `e56bf00f` migration commit anchors a 16-cycle implementation-cluster (108 + 110 + 115 + 118 + 123 + 125 + 132 + 134 + 136 + 138 + 140 + 144 + 148 + 150 + 152 + 154).

Cycle 337 is the **documentation-side closure** of every one of those implementation-side observations. **§the-named-substrate-package-introduction-closes-many-arcs** — first-explicit-observation as a librarian-discipline observation. When a substrate package's README is finally ingested after many prior cycles have observed its usage, the introduction cycle closes a *cascade* of arcs back to those source-side observations.

Closes **sixteen citation arcs** in one cycle (one of the largest single-cycle arc-closure counts in the pivot):

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 108 (exo-makers; e56bf00f first observation) | 229 cycles | **Second-longest pivot arc** |
| Cycle 110 | 227 cycles | Same migration commit |
| Cycle 115 | 222 cycles | Same migration commit |
| Cycle 118 (exo-tools) | 219 cycles | Migration + imports harden |
| Cycle 142 (passStyle-helpers.js isPrimitive) | 195 cycles | Layering-constraints relative to harden |
| Cycle 148 (symbol.js) | 189 cycles | Imports @endo/harden |
| Cycle 150 (typeGuards.js) | 187 cycles | Imports @endo/harden |
| Cycle 152 (memo-race.js comment-fragment) | 185 cycles | First @endo/promise-kit imports harden |
| Cycle 154 (trap.js) | 183 cycles | Imports @endo/harden |
| Cycle 173 (promise-executor-kit.js) | 164 cycles | Imports @endo/harden |
| Cycle 187 (shim-and-prepare cluster) | 150 cycles | Two-shim-strategies-side-by-side |
| Cycle 211 (@endo/common dependency-ceiling) | 126 cycles | Names harden as substrate-ceiling |
| Cycle 322 (exo-makers complementary-lens) | 15 cycles | harden() throughout |
| Cycle 325 (pass-style README) | 12 cycles | harden() across the surface |
| Cycle 333 (@endo/common README dependency-ceiling) | 4 cycles | Names @endo/harden in the ceiling |
| Cycle 336 (memo-race.js complementary-lens; line 31) | 1 cycle | Cross-package adjacent pair |

**§sixteen-citation-arc-closures-in-cycle-337**. **§fifty-six-citation-arc-closures-in-pivot-now** (50 + 6 net new beyond cycle 336's six, after deduping arcs already counted).

## Single most structurally interesting move

**§the-named-three-tier-defense-named-in-the-opening** — lines 3-19 of the README open with the threat model and three coordinated defenses:

1. **Sentence 1**: *"Hardened modules are modules that make their interface resist tampering by other modules that import them, **making them less susceptible to supply chain attack**."*
2. **Tier 1 — HardenedJS**: *"the global `harden` function transitively freezes... primordials like `Array.prototype` and `Object` are frozen in this environment, **which gives your module a place to stand toward its own defense**."*
3. **Tier 2 — LavaMoat**: *"each package is credibly isolated... we can enforce **Principle of Least Authority**."*
4. **Tier 3 — harden()**: *"that leaves the module to use `harden` to freeze all its exports and anything it returns."*

**§the-named-three-tier-defense-named-in-the-opening** — first-explicit-observation as a tier-3 meta-pattern. The README opens with:
- **The threat** first (supply chain attack via tampering)
- **Three coordinated defenses** named — HardenedJS (primordials) + LavaMoat (POLA) + harden() (per-module hardening)
- **The package's role** as the third tier

**§the-named-threat-model-named-first** — name what we're defending against before how we defend. **§the-named-supply-chain-attack-IS-named-threat-model** as the **canonical threat anchor for the entire HardenedJS stack**. The phrase appears in the README's first sentence; no other threat is named higher.

**§the-named-place-to-stand-toward-its-own-defense-metaphor** — vivid architectural metaphor for what HardenedJS provides. Sibling to cycle 87 pass-style/error.js's §V8-stack-accessor-channel metaphor. **§two-cycles-with-named-architectural-metaphor** (87 + 337).

## Other key first-explicit-observations (thirty-plus)

### Dual-purpose with and-also conjunction

**§the-named-dual-purpose-of-harden** — lines 21-24 name BOTH purposes with explicit *"and also"* conjunction: (a) type information for global `harden`; (b) cross-environment portability for hardened modules. **§the-named-and-also-as-two-purpose-conjunction**.

### Intrinsic over endowment

**§the-named-Object-Symbol.for-harden-intrinsic** — registered-symbol property on shared intrinsic. **§the-named-intrinsic-over-endowment-discipline** — when both intrinsic property and endowment provide a capability, prefer the intrinsic because endowments can be overridden in nested compartments. The README's own language: *"cannot be subverted in a compartment"* — **§the-named-invariant-named-with-cannot-language** (strongest available guarantee).

### Build-condition as policy knob

**§the-named-build-condition-as-policy-knob** — two named conditions: `-C hardened` (strict-only) + `-C harden:unsafe` (no-harden). **§the-named-three-build-time-modes** (strict + default-degraded + no-harden). **§two-shapes-of-policy-knob** (cycle 183 separate-entry-point-files + cycle 337 build-condition). **§the-named-fail-loud-or-pay-cost-binary-choice**.

### Multiple-instances coordination

**§the-named-multiple-instances-first-call-wins** — first call installs at `Object[Symbol.for('harden')]`; subsequent instances adopt. The README's own framing: **§the-named-shim-like-behavior-pre-lockdown**. **§the-named-side-effect-as-coordination-mechanism** — shared intrinsic location coordinates multiple package instances. **§the-named-installed-harden-as-pre-lockdown-sentinel** — *"This property is how `lockdown` senses that it should fail."*

### With OR Without NOT Both

**§the-named-with-OR-without-NOT-both-policy** — section heading itself encodes the policy. **§the-named-temporal-ordering-creates-vulnerability** — same structural state at different times has different guarantees. **§the-named-helpful-stack-on-misuse** — lockdown throws with a stack **pointing to the offending module**. **§the-named-stack-points-to-the-offending-module**. **§three-cycles-with-named-stack-as-diagnostic** (87 + 336 + 337).

**§the-named-prepare-star-convention** — by convention, modules named `prepare-*` are initialization-side-effect modules. **§the-named-naming-convention-as-import-time-side-effect-marker**.

### Honest regret with named migration

**§the-named-isFake-deprecated-with-named-regret** — *"We regret this misfeature."* (line 135). Stronger than deprecation. **§the-named-honest-regret-in-README**. **§three-shapes-of-honesty-about-past-decisions** (326 deprecation-with-redirect + 336 TODO-with-named-obstacle + 337 deprecated-with-named-regret).

**§the-named-migration-path-with-named-alternative** — the README provides the migration code AND justifies why it works. **§the-named-deprecation-explains-WHY-the-alternative-works**. **§the-named-hardenIsNoop-as-replacement-API** — `@endo/harden/is-noop.js`'s `hardenIsNoop(harden)`. **§the-named-deprecation-points-to-named-replacement-in-same-package** (intra-package vs cycle 326's cross-package).

### Degradation mode with tradeoff

**§the-named-Without-HardenedJS-degradation-mode** — README documents degradation explicitly: surface immutability via own-properties; no prototype-chain traversal. **§the-named-partial-safety-with-named-tradeoff**. **§the-named-test-and-UI-framework-acknowledgment** — the README names parallel ecosystem constraints (testing + UI frameworks rely on alterable intrinsics).

**§the-named-uncoordinated-alteration-of-realm-intrinsics** + **§the-named-precise-technical-language-without-pejorative-tone**. **§two-shapes-of-precise-technical-language** (cycle 186 sharp *"illusion of an option"* + cycle 337 neutral *"uncoordinated alteration"*).

### Substrate-package README shape

**§the-named-six-headed-section-policy-README-shape** — seven sections total (six headed + one heading-less intro). **§the-named-substrate-package-with-policy-README**.

**§the-named-four-shapes-of-README** — collection (cycle 333 @endo/common) + utility (cycle 335 @endo/promise-kit) + substrate-policy (cycle 337 @endo/harden) + substrate-deep (cycle 325 @endo/pass-style). **Refines cycle 333's three-way categorization with a FOURTH category**.

## Multi-cycle patterns extended

- §twenty-eight-cycles-with-named-pivot-domain-stay (310-337)
- §fourteen-named-packages-in-the-pivot-cluster (harden joins as the FOURTEENTH)
- §fifty-six-citation-arc-closures-in-pivot-now (50 + 6 net new)
- §three-cycles-with-named-stack-as-diagnostic (87 + 336 + 337)
- §three-shapes-of-honesty-about-past-decisions (326 + 336 + 337)
- §two-shapes-of-policy-knob (183 + 337)
- §two-cycles-with-named-architectural-metaphor (87 + 337)
- §two-shapes-of-precise-technical-language (186 + 337)
- §the-named-streak-of-one (cycle 335 → 336 was the lone instance after the seven-cycle streak ended; cycle 336 → 337 is cross-package, so the streak count returns to 1 immediately)

## Tier-3 meta-patterns

- **§the-named-three-tier-defense-named-in-the-opening** — README opening names threat + coordinated defenses + package's role
- **§the-named-threat-model-named-first**
- **§the-named-supply-chain-attack-IS-named-threat-model** — canonical threat anchor for the entire HardenedJS stack
- **§the-named-intrinsic-vs-endowment-distinction**
- **§the-named-two-shapes-of-policy-knob** — separate-entry-point-files + build-condition
- **§the-named-side-effect-as-coordination-mechanism** — shared location coordinates multiple instances
- **§the-named-temporal-ordering-creates-vulnerability** — same state at different times has different guarantees
- **§the-named-stack-points-to-the-offending-module** — runtime-detected violations should provide fix-location
- **§three-shapes-of-honesty-about-past-decisions** — deprecation-with-redirect + TODO-with-named-obstacle + deprecated-with-named-regret
- **§the-named-deprecation-explains-WHY-the-alternative-works** — migration code justified, not just provided
- **§the-named-partial-safety-with-named-tradeoff** — degraded modes named as useful
- **§the-named-test-and-UI-framework-acknowledgment** — name parallel ecosystem constraints
- **§the-named-precise-technical-language-without-pejorative-tone**
- **§the-named-four-shapes-of-README** — collection + utility + substrate-policy + substrate-deep
- **§the-named-substrate-package-introduction-closes-many-arcs** — substrate documentation-side ingest closes cascade of source-side arcs

## Synthesis-target

Slot machine library **§`@game/harden/README.md`** — substrate-package policy README:

1. **Threat model named first** — open with what we defend against (e.g., cheating, unauthorized state mutation)
2. **Three-tier defense named in the opening** — name threat + three coordinated defenses + package's role
3. **Architectural metaphor for substrate**
4. **Dual-purpose with and-also conjunction**
5. **Intrinsic over endowment** — registered-symbol property at shared location
6. **Build conditions as policy knobs** — name both endpoints of the spectrum (three modes)
7. **First-call-wins coordination for multiple instances**
8. **With OR Without NOT Both** — name the temporal-ordering trap explicitly
9. **Helpful stack on misuse** — runtime-detected discipline violations point to offending module
10. **prepare-* naming convention** as import-time side-effect marker
11. **Honest regret + migration path with named alternative** — provide migration code AND the rationale
12. **Degradation mode named with tradeoff + parallel-ecosystem acknowledgment**
13. **Precise technical language without pejorative tone**
14. **Six-headed-section policy README shape** for substrate-packages

## Library state after cycle 337

- §library-reaches-849-sections from 382 source documents
- §one-hundred-and-seventieth consecutive designs-chat alternation
- §twenty-eight-cycles-with-named-pivot-domain-stay
- §fourteen-named-packages-in-the-pivot-cluster (harden as FOURTEENTH)
- **§fifty-six-citation-arc-closures-in-pivot-now** (50 + 6 net new; sixteen total arcs closed in cycle 337)
- §three-shapes-of-honesty-about-past-decisions established as a tier-3 meta-pattern
- §two-shapes-of-policy-knob established as a tier-3 meta-pattern
- §the-named-four-shapes-of-README established as a tier-3 meta-pattern refining cycle 333
- §the-named-substrate-package-introduction-closes-many-arcs established as a librarian-discipline observation
- §the-named-three-tier-defense-named-in-the-opening established as a tier-3 meta-pattern
- §the-named-supply-chain-attack-IS-named-threat-model named as the canonical threat anchor for the entire HardenedJS stack

## Next cycle pacing

Cycle 338 is **chat-lane** next. Candidate moves:

- **@endo/harden/make-hardener.js** — adjacent forward pair with cycle 337; 471 lines (largest source file in the pivot); the canonical harden implementation; would be the most natural follow-up
- **@endo/harden/index.js** + **@endo/harden/noop.js** — the 17-line + 20-line public surface
- **@endo/harden/is-noop.js** + **@endo/harden/hardened.js** — the smaller utility files (22 + 18 lines)
- **@endo/init source or README** — would introduce a fifteenth package; cycle 183 already ingested as comment-fragment so this would extend the pivot toward complementary-lens

@endo/harden/make-hardener.js is the most productive (forms adjacent forward pair with cycle 337; introduces the canonical harden implementation; 471 lines is dense; would close cycle 175 make-selector.js arc — they're sibling files). Picking freely but tracking for future work.
