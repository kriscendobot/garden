---
title: "@endo/lockdown README.md — sixteenth package; side-effect-import-as-environment-upgrade; subset-relationship-named-with-named-alternative; coordinate-with-named-SES; 15-line policy-minimal README"
source: endo--packages-lockdown-README-md
url: https://github.com/endojs/endo/blob/master/packages/lockdown/README.md
authors: [Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/lockdown/README.md
total-lines: 15
ingest-cycle: 341
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-side-effect-import-as-environment-upgrade
  - the-named-import-order-as-temporal-discipline
  - the-named-subset-relationship-named-with-named-alternative
  - the-named-pointer-to-related-package-with-named-relationship
  - the-named-coordinate-with-SES-via-import
  - the-named-package-purpose-as-coordination-with-named-other-package
  - the-named-simply-ensures-language
  - the-named-side-effect-only-package
  - the-named-fifteen-line-policy-minimal-README
  - the-named-sixteenth-package-in-the-pivot-cluster
  - the-named-streak-of-zero-cross-package
  - three-cycles-with-named-package-coordinates-with-named-other-package
  - thirty-two-cycles-with-named-pivot-domain-stay
  - eighty-two-citation-arc-closures-in-pivot-now
  - four-cycles-with-named-substrate-package-introduction
---

# `@endo/lockdown README.md` — sixteenth package; side-effect-import as environment-upgrade

The 15-line README of @endo/lockdown — the *side-effect-only* package that ensures SES has initialized and locked down the environment. Cycle 341 is **designs-lane after cycle 340's chat-lane @endo/errors/rejector.js** — **cross-package** (errors → lockdown), so **§the-named-streak-of-zero-cross-package** (the one-cycle streak from cycle 339 → 340 ended; streak count returns to 0).

**Thirty-second consecutive non-garden source after the pivot** (cycles 310-341). **§thirty-two-cycles-with-named-pivot-domain-stay**. **§sixteen-named-packages-in-the-pivot-cluster** — @endo/lockdown joins as the **SIXTEENTH PACKAGE** (nat + memoize + hex + lp32 + stream + eventual-send + exo + captp + pass-style + patterns + marshal + common + promise-kit + harden + errors + **lockdown**).

## The single most structurally interesting move

**§the-named-subset-relationship-named-with-named-alternative** — lines 14-15 of the README:

> The HardenedJS environment is a subset of the Endo environment.
> Use [`@endo/init`](../init) for a more comprehensive upgrade.

**§the-named-subset-relationship-named-with-named-alternative** — first-explicit-observation as a tier-3 meta-pattern. The README's closing two lines:

1. Name the package's specific role (provides the HardenedJS environment)
2. Name a STRUCTURAL RELATIONSHIP (HardenedJS ⊂ Endo)
3. Name the alternative (@endo/init for the comprehensive case)
4. Provide a relative-path link (`../init`) to the alternative

**§the-named-pointer-to-related-package-with-named-relationship** — first-explicit-observation. The pointer is *qualified by relationship*: not just *"see also @endo/init"* but *"HardenedJS is a subset of Endo; use @endo/init for more comprehensive"*. The reader learns BOTH the alternative AND when to use it AND why the alternative matters.

**§the-named-scope-awareness-discipline** — first-explicit-observation as a tier-3 meta-pattern. Substrate-policy-minimal READMEs should name their package's SCOPE and point to LARGER/RELATED packages for adjacent needs. Compare to:

| Cycle | Package | Coordination/relationship |
|---|---|---|
| 339 | @endo/errors | Coordinates with `[ses](../ses/)` for console-reveal |
| 341 | @endo/lockdown | Points to `[@endo/init](../init)` as comprehensive alternative |

**§three-cycles-with-named-package-coordinates-with-named-other-package** (339 errors-with-ses + 341 lockdown-with-init + cycle 337 harden's prepare-* convention) — first-explicit-observation. The discipline crosses three pivot cycles.

## §the-named-side-effect-import-as-environment-upgrade

Lines 3-7 open with the package's purpose statement:

> We often need to upgrade a JavaScript environment to HardenedJS as a side effect of importing a module, so that later modules can rely on the hardened environment.
> The `@endo/lockdown` package simply ensures that SES has both initialized and locked down the environment.

**§the-named-side-effect-import-as-environment-upgrade** — first-explicit-observation as a tier-3 meta-pattern. The README's framing:

1. **Names the need**: *"We often need to upgrade a JavaScript environment"*
2. **Names the mechanism**: *"as a side effect of importing a module"*
3. **Names the goal**: *"so that later modules can rely on the hardened environment"*
4. **Names the package's job**: *"simply ensures that SES has both initialized and locked down"*

The phrase *"as a side effect of importing"* names a specific discipline: the import statement DOES SOMETHING beyond just providing bindings. The discipline is named in cycle 187's *"§unconditional-replacement"* and cycle 337's *"§prepare-star-convention"*; cycle 341 names it as the **package-purpose level**.

**§the-named-side-effect-only-package** — first-explicit-observation. A package whose entire job is to BE imported (no exports needed; the imports's side effects ARE the value). The package import is the contract. Compare to cycle 340's §the-named-types-only-file (no runtime; pure type-level); §the-named-side-effect-only-package is the inverse — no exports; pure runtime side-effect.

**§two-shapes-of-export-less-package** (types-only cycle 340 + side-effect-only cycle 341) — first-explicit-observation as a tier-3 meta-pattern. Both shapes have ZERO runtime exports; they differ in WHAT they contribute:
- Types-only: contributes JSDoc typedefs to the type-checker
- Side-effect-only: contributes runtime behavior via import-time evaluation

**§the-named-simply-ensures-language** — first-explicit-observation. The word *"simply"* in line 6 is a discipline-marker — the README's own framing is that the package is **intentionally minimal**. Compare to cycle 339's *"the package provides utilities for X"* (one-sentence purpose); cycle 341's *"simply ensures"* makes the minimalism explicit.

## §the-named-import-order-as-temporal-discipline

Lines 9-12 show the canonical usage:

```js
import '@endo/lockdown'
import 'hardened-modules...';
```

**§the-named-import-order-as-temporal-discipline** — first-explicit-observation. The example WORKS ONLY IF lockdown is imported FIRST. ES modules import in source-order (for the eager `import` form). The temporal discipline: lockdown's side effects must complete BEFORE any hardened-module's import runs.

**§the-named-import-statement-as-temporal-anchor** — first-explicit-observation as a tier-3 meta-pattern. When a package's purpose is side-effect-only, the import statement BECOMES the temporal anchor — the placement of the import in source order determines when the side effect happens.

Sibling to cycle 337 @endo/harden README's **§the-named-with-OR-without-NOT-both-policy** (temporal-ordering creates vulnerability). Cycle 337 named the vulnerability; cycle 341 names the discipline that prevents it (import lockdown FIRST). **§two-cycles-with-named-temporal-ordering-discipline** (337 vulnerability + 341 prevention discipline). First-explicit-observation as a tier-2 multi-cycle pattern.

**§the-named-quoted-import-ellipsis-as-placeholder** — first-explicit-observation. Line 11: `import 'hardened-modules...';` — the ellipsis inside string-literal is a PLACEHOLDER for "your hardened modules here". The string-literal-ellipsis convention is a documentation-only idiom (won't run as code) but COMMUNICATES the structure to the reader.

## §the-named-coordinate-with-SES-via-import

Lines 6-7: *"The `@endo/lockdown` package simply ensures that SES has both initialized and locked down the environment."*

The coordination is with **SES** (the underlying library). @endo/lockdown's purpose is to:
1. Initialize SES (the *"initialized"* part)
2. Call SES's `lockdown()` (the *"locked down"* part)

**§the-named-coordinate-with-SES-via-import** — first-explicit-observation. The package's *coordination target* is named explicitly. Compare to cycle 339's *"In coordination with [ses](../ses/) in the host realm"* (also names SES); cycle 341 names SES less directly but still explicitly.

**§the-named-package-coordinates-with-named-other-package** is now observed THREE times (337 harden + 339 errors + 341 lockdown), all coordinating with **SES** as the substrate. **§three-cycles-with-named-coordination-target-IS-SES** — first-explicit-observation as a tier-2 multi-cycle pattern. SES is the **convergent coordination target** for the three minimal-substrate-policy READMEs.

**§the-named-SES-as-convergent-coordination-target** — first-explicit-observation as a tier-3 meta-pattern. Tier-3 framing: substrate-packages in a layered architecture often coordinate with ONE underlying foundational package; ingesting many substrate-package READMEs reveals the foundation as a *convergent* target.

## §the-named-fifteen-line-policy-minimal-README

15 lines. The pivot's README-length distribution now spans:

| Lines | Package | Cycle | Category |
|---|---|---|---|
| 13 | @endo/errors | 339 | Substrate-policy-minimal |
| **15** | **@endo/lockdown** | **341** | **Substrate-policy-minimal** |
| 17 | @endo/common | 333 | Collection-package |
| 60 | @endo/hex | 317 | Utility-package |
| 71 | @endo/promise-kit | 335 | Utility-package |
| 136 | @endo/lp32 | 315 | Utility-package |
| 140 | @endo/stream | 319 | Utility-package |
| 158 | @endo/harden | 337 | Substrate-policy-prose |
| 188 | @endo/marshal | 329 | Substrate-deep |
| 216 | @endo/pass-style | 325 | Substrate-deep |
| 332 | @endo/eventual-send | 321 | Substrate-deep |
| 364 | @endo/exo | 331 | Substrate-deep |
| 415 | @endo/patterns | 327 | Substrate-deep |

**§two-substrate-policy-minimal-READMEs** (cycle 339 errors at 13 lines + cycle 341 lockdown at 15 lines). The substrate-policy-minimal shape now spans **two applications**. Both are coordinate-with-SES packages.

**§the-named-substrate-policy-minimal-shape-confirmed-across-two-applications** — first-explicit-observation as a tier-2 multi-cycle pattern. The shape from cycle 339:
- Threat-model or need-statement (lines 3-5)
- Package purpose (lines 6-7)
- Usage example or coordination note (lines 9-13)
- Cross-package pointer with named relationship (lines 14-15)

Cycle 341 confirms the shape with a slightly different content emphasis (no threat-model; need-statement instead; usage example with import order; cross-package pointer to @endo/init).

**§the-named-fifteen-line-policy-minimal-README** — first-explicit-observation. The lockdown README is at the upper end of the substrate-policy-minimal range; @endo/errors at 13 lines remains the floor.

## Closes citation arcs

Cycle 341 is the **documentation-side closure** of many cycles that referenced @endo/lockdown. The arcs:

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 340 (errors/rejector.js) | 1 cycle | Cross-package designs-lane after chat-lane |
| Cycle 339 (@endo/errors README) | 2 cycles | §three-cycles-with-named-package-coordinates-with-named-other-package |
| Cycle 338 (@endo/harden make-hardener.js) | 3 cycles | Lockdown senses harden via Object[Symbol.for('harden')] |
| Cycle 337 (@endo/harden README) | 4 cycles | Lockdown installs harden; prepare-* convention |
| Cycle 183 (@endo/init source + lockdown 12-file cluster comment-fragment) | 158 cycles | First explicit observation of lockdown's tolerance-ladder |
| Cycle 187 (promise-kit/shim cluster) | 154 cycles | §two-shim-strategies coordinates with lockdown |
| Cycle 87 (pass-style/error.js V8 stack accessor) | 254 cycles | Lockdown's underlying SES handles stack-accessor concerns |
| Cycle 211 (@endo/common dependency-ceiling names ses) | 130 cycles | ses is the substrate; lockdown ensures lockdown of ses |

**§eight-citation-arc-closures-in-cycle-341**. **§eighty-two-citation-arc-closures-in-pivot-now** (75 + 7 net new). **§four-cycles-with-named-substrate-package-introduction** (337 + 339 + 340 + 341) — first-explicit-observation as a tier-2 multi-cycle pattern.

**§the-named-substrate-package-cluster-introduction-trend** — first-explicit-observation. Four consecutive cycles ingesting substrate-package READMEs/sources (337 harden README + 338 harden source + 339 errors README + 340 errors source + 341 lockdown README). The pivot is in a **substrate-introduction phase** — each cycle adds canonical-source coverage for packages cited from many prior pivot cycles.

## Patterns the cycle extends

- §thirty-two-cycles-with-named-pivot-domain-stay (310-341)
- §sixteen-named-packages-in-the-pivot-cluster (@endo/lockdown joins as SIXTEENTH)
- §eighty-two-citation-arc-closures-in-pivot-now (75 + 7 net new)
- §three-cycles-with-named-package-coordinates-with-named-other-package (337 + 339 + 341)
- §three-cycles-with-named-coordination-target-IS-SES (337 + 339 + 341)
- §two-cycles-with-named-temporal-ordering-discipline (337 vulnerability + 341 prevention)
- §two-substrate-policy-minimal-READMEs (339 errors at 13 lines + 341 lockdown at 15 lines)
- §four-cycles-with-named-substrate-package-introduction (337 + 339 + 340 + 341)
- §the-named-streak-of-zero-cross-package (cycle 340 → 341 cross-package; streak returns to 0)

## Tier-1 borrowing (twelve-plus first-explicit-observations from a 15-line README)

- **§the-named-side-effect-import-as-environment-upgrade** — import statement as environment-upgrade discipline
- **§the-named-side-effect-only-package** — no exports; the import IS the contract
- **§two-shapes-of-export-less-package** — types-only (340) + side-effect-only (341)
- **§the-named-import-order-as-temporal-discipline**
- **§the-named-import-statement-as-temporal-anchor**
- **§the-named-quoted-import-ellipsis-as-placeholder** — string-literal-ellipsis as documentation idiom
- **§the-named-subset-relationship-named-with-named-alternative** — name relationship + point to alternative
- **§the-named-pointer-to-related-package-with-named-relationship**
- **§the-named-scope-awareness-discipline** — substrate-policy READMEs name their scope
- **§the-named-coordinate-with-SES-via-import**
- **§the-named-SES-as-convergent-coordination-target** — SES is the convergent target
- **§the-named-simply-ensures-language** — minimalism discipline-marker
- **§the-named-fifteen-line-policy-minimal-README**
- **§the-named-substrate-policy-minimal-shape-confirmed-across-two-applications**
- **§the-named-substrate-package-cluster-introduction-trend** — four consecutive cycles in substrate-introduction phase

## Tier-2 borrowing (multi-cycle patterns extended)

- §thirty-two-cycles-with-named-pivot-domain-stay
- §sixteen-named-packages-in-the-pivot-cluster
- §eighty-two-citation-arc-closures-in-pivot-now
- §three-cycles-with-named-package-coordinates-with-named-other-package (337 + 339 + 341)
- §three-cycles-with-named-coordination-target-IS-SES (337 + 339 + 341)
- §two-cycles-with-named-temporal-ordering-discipline (337 + 341)
- §two-substrate-policy-minimal-READMEs (339 + 341)
- §four-cycles-with-named-substrate-package-introduction (337 + 339 + 340 + 341)

## Tier-3 borrowing (meta-patterns)

- **§the-named-side-effect-import-as-environment-upgrade** — import statement does something beyond providing bindings
- **§two-shapes-of-export-less-package** — types-only + side-effect-only; both have zero runtime exports but contribute different things
- **§the-named-import-statement-as-temporal-anchor** — when side effects matter, import order is the temporal contract
- **§the-named-subset-relationship-named-with-named-alternative** — name the scope-relationship; point to the alternative for adjacent needs
- **§the-named-scope-awareness-discipline** — substrate-policy READMEs name their scope explicitly
- **§the-named-SES-as-convergent-coordination-target** — substrate-packages converge on one underlying foundational target
- **§the-named-substrate-package-cluster-introduction-trend** — multi-cycle substrate-introduction phase observed across cycles 337-341

## Synthesis-target

Slot machine library **§`@game/lockdown/README.md`** — substrate-policy-minimal README for environment-setup package:

1. **Need-statement first** — *"We often need to X as a side effect of importing"*
2. **One-sentence purpose** — *"the package simply ensures Y"*
3. **Usage example with import order** — show that THIS import must come first
4. **Quoted import ellipsis as placeholder** — string-literal-ellipsis to indicate "your modules here"
5. **Subset relationship named with alternative** — "this is X; use Y for the more comprehensive case"
6. **Coordination target named** — name the foundational package this coordinates with
7. **Side-effect-only package** — no exports; the import IS the contract

## Library state after cycle 341

- §library-reaches-853-sections from 386 source documents
- §one-hundred-and-seventy-fourth consecutive designs-chat alternation
- §thirty-two-cycles-with-named-pivot-domain-stay
- §sixteen-named-packages-in-the-pivot-cluster (@endo/lockdown as SIXTEENTH)
- §eighty-two-citation-arc-closures-in-pivot-now (75 + 7 net new)
- §three-cycles-with-named-package-coordinates-with-named-other-package (337 + 339 + 341)
- §three-cycles-with-named-coordination-target-IS-SES (337 + 339 + 341)
- §the-named-SES-as-convergent-coordination-target established as tier-3 meta-pattern
- §two-shapes-of-export-less-package (types-only 340 + side-effect-only 341) established as tier-3 meta-pattern
- §the-named-import-statement-as-temporal-anchor established as tier-3 meta-pattern
- §the-named-subset-relationship-named-with-named-alternative established as tier-3 meta-pattern
- §the-named-substrate-package-cluster-introduction-trend (four-cycle substrate-introduction phase 337-341)
- §the-named-streak-of-zero-cross-package (cycle 340 → 341 cross-package)
