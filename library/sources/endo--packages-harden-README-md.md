---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/harden/README.md
source_line_range: 1-158
file_commit: 20a61e3db35e5144be4edfddece8ba1c865a7656
file_commit_date: 2026-02-24
file_commit_author: Kris Kowal
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 337 designs-lane ingest. **Fourteenth package added to
  the pivot cluster** (nat + memoize + hex + lp32 + stream +
  eventual-send + exo + captp + pass-style + patterns +
  marshal + common + promise-kit + **harden**). Substrate-
  package documentation-side closure for sixteen-plus prior
  cycles that observed `import harden from '@endo/harden';` or
  touched the `e56bf00f` migration commit.

  Single most structurally interesting move: §the-named-three-
  tier-defense-named-in-the-opening — lines 3-19 name the
  threat (supply chain attack) and three coordinated defenses
  (HardenedJS primordials + LavaMoat POLA + harden() per-module)
  in the opening paragraph. §the-named-threat-model-named-first;
  §the-named-supply-chain-attack-IS-named-threat-model as the
  canonical threat anchor for the entire HardenedJS stack.

  Other key first-explicit-observations: §the-named-place-to-
  stand-toward-its-own-defense-metaphor (vivid architectural
  metaphor); §the-named-dual-purpose-of-harden (and-also
  conjunction; one package, two purposes); §the-named-Object-
  Symbol.for-harden-intrinsic + §the-named-intrinsic-over-
  endowment-discipline (registered-symbol property on shared
  intrinsic; intrinsic-cannot-be-subverted-in-a-compartment);
  §the-named-build-condition-as-policy-knob with §the-named-
  three-build-time-modes (`-C hardened` strict-only + default
  degraded + `-C harden:unsafe` no-harden); §the-named-multiple-
  instances-first-call-wins with §the-named-side-effect-as-
  coordination-mechanism + §the-named-installed-harden-as-pre-
  lockdown-sentinel; §the-named-with-OR-without-NOT-both-policy
  with §the-named-temporal-ordering-creates-vulnerability +
  §the-named-helpful-stack-on-misuse + §the-named-stack-points-
  to-the-offending-module + §the-named-prepare-star-convention
  (modules named `prepare-*` are initialization-side-effect by
  convention); §the-named-isFake-deprecated-with-named-regret
  with §the-named-honest-regret-in-README + §the-named-
  migration-path-with-named-alternative + §the-named-
  deprecation-explains-WHY-the-alternative-works + §the-named-
  hardenIsNoop-as-replacement-API + §the-named-deprecation-
  points-to-named-replacement-in-same-package; §the-named-
  Without-HardenedJS-degradation-mode with §the-named-partial-
  safety-with-named-tradeoff + §the-named-test-and-UI-framework-
  acknowledgment + §the-named-precise-technical-language-
  without-pejorative-tone; §the-named-six-headed-section-policy-
  README-shape; §the-named-substrate-package-with-policy-README;
  §the-named-four-shapes-of-README (collection + utility +
  substrate-policy + substrate-deep; refines cycle 333's three-
  way categorization).

  Closes sixteen citation arcs across the substrate-cluster:
  cycle 108 (229 cycles, second-longest pivot arc) + cycle 110
  + cycle 115 + cycle 118 (219 cycles) + cycle 142 (195 cycles,
  isPrimitive duplication layering-constraints) + cycle 148 +
  cycle 150 + cycle 152 (185 cycles, memo-race comment-fragment)
  + cycle 154 + cycle 173 + cycle 187 (150 cycles, shim cluster)
  + cycle 211 (126 cycles, @endo/common dependency-ceiling) +
  cycle 322 (15 cycles, exo-makers complementary-lens) + cycle
  325 (12 cycles, pass-style README) + cycle 333 (4 cycles,
  common README dependency-ceiling) + cycle 336 (1 cycle,
  memo-race complementary-lens cross-package adjacent). §the-
  named-substrate-package-introduction-closes-many-arcs as a
  librarian-discipline observation. **§fifty-six-citation-arc-
  closures-in-pivot-now** (50 + 6 net new beyond cycle 336's
  six, after deduping arcs already counted).
---

> Abstract: 158-line README for `@endo/harden`, the substrate-
> package whose `harden()` function is imported across nearly
> every pivot source. **Fourteenth package** added to the
> pivot cluster after sixteen-plus prior cycles observed its
> usage without the README itself being ingested.
>
> **Single most structurally interesting move**: §the-named-
> three-tier-defense-named-in-the-opening — the README's first
> paragraph names the threat (supply chain attack) and three
> coordinated defenses (HardenedJS + LavaMoat + harden()) and
> the package's role as the third tier. §the-named-threat-
> model-named-first; §the-named-supply-chain-attack-IS-named-
> threat-model as canonical threat anchor.
>
> §the-named-place-to-stand-toward-its-own-defense-metaphor —
> vivid architectural metaphor for what HardenedJS provides to
> a module. Sibling to cycle 87's §V8-stack-accessor-channel
> metaphor.
>
> §the-named-dual-purpose-of-harden — and-also conjunction
> naming both purposes: type information + cross-environment
> portability.
>
> §the-named-Object-Symbol.for-harden-intrinsic — registered-
> symbol property on shared intrinsic; §the-named-intrinsic-
> over-endowment-discipline (intrinsic cannot be subverted in
> a compartment).
>
> §the-named-build-condition-as-policy-knob with three named
> build-time modes (`-C hardened` strict + default degraded +
> `-C harden:unsafe` no-harden). §two-shapes-of-policy-knob
> (separate-entry-point-files cycle 183 + build-condition
> cycle 337).
>
> §the-named-multiple-instances-first-call-wins + §the-named-
> side-effect-as-coordination-mechanism — shared intrinsic
> location coordinates multiple package instances.
>
> §the-named-with-OR-without-NOT-both-policy + §the-named-
> temporal-ordering-creates-vulnerability + §the-named-
> helpful-stack-on-misuse — pre-lockdown harden call detected
> at runtime; lockdown throws with stack pointing to the
> offending module.
>
> §the-named-prepare-star-convention — modules named
> `prepare-*` are by convention initialization-side-effect
> modules.
>
> §the-named-isFake-deprecated-with-named-regret + §the-named-
> honest-regret-in-README — "We regret this misfeature."
> Stronger than deprecation. §three-shapes-of-honesty-about-
> past-decisions (cycle 326 deprecation-with-redirect + cycle
> 336 TODO-with-named-obstacle + cycle 337 deprecated-with-
> named-regret).
>
> §the-named-migration-path-with-named-alternative + §the-
> named-deprecation-explains-WHY-the-alternative-works — the
> README provides the migration code AND justifies why it
> works.
>
> §the-named-Without-HardenedJS-degradation-mode + §the-named-
> partial-safety-with-named-tradeoff + §the-named-test-and-UI-
> framework-acknowledgment — the README names parallel
> ecosystem constraints (testing + UI frameworks rely on
> alterable intrinsics).
>
> §the-named-six-headed-section-policy-README-shape + §the-
> named-substrate-package-with-policy-README + §the-named-
> four-shapes-of-README (collection + utility + substrate-
> policy + substrate-deep; refines cycle 333's three-way
> categorization with a fourth category).
>
> Closes sixteen citation arcs across the substrate-cluster.
> §the-named-substrate-package-introduction-closes-many-arcs.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [fourteenth-package-three-tier-defense-named-in-the-opening](../sections/endo--packages-harden-README-md--fourteenth-package-three-tier-defense-named-in-the-opening.md) | hardened-javascript, supply-chain-attack-defense, substrate-package, policy-README, README-shape, deprecation-discipline | current (cycle 337, designs-lane) |

158-line README. One section with dense first-explicit-observations across the README's threat-model + three-tier-defense + intrinsic-over-endowment + build-conditions + multiple-instances coordination + with-or-without-not-both temporal vulnerability + isFake deprecated-with-named-regret.

## Provenance

- Fetched 2026-06-15 from `endojs/endo@HEAD` (commit `20a61e3db35e5144be4edfddece8ba1c865a7656`) via the local clone.
- Last substantive touch 2026-02-24 by Kris Kowal in commit `20a61e3d` (one of the more recent updates; many prior touches dating back to Jean-Francois Paradis in 2020).
- Apache-2.0 license (per package LICENSE file).
- **Fourteenth package** added to the pivot cluster (cycles 310-337).
- **Substrate-package documentation-side closure** for sixteen-plus prior cycles that observed `import harden from '@endo/harden';` or touched the `e56bf00f` migration commit.
- Cycle 337 closes **sixteen citation arcs** in one cycle (one of the largest single-cycle arc-closure counts in the pivot).
- §the-named-substrate-package-introduction-closes-many-arcs as a librarian-discipline observation.
