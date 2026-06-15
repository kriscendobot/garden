---
title: "@endo/init README.md — seventeenth package; enumeration-of-side-effects-as-package-purpose; three-rung tolerance ladder named in README; debug-as-less-safe-but-conducive-to-debugging; cross-package compensation named"
source: endo--packages-init-README-md
url: https://github.com/endojs/endo/blob/master/packages/init/README.md
authors: [Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/init/README.md
total-lines: 52
ingest-cycle: 343
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-enumeration-of-side-effects-as-package-purpose
  - the-named-five-named-actions-performed-on-import
  - the-named-default-is-fully-locked-down
  - the-named-three-entry-point-tolerance-ladder-named-in-README
  - the-named-debug-as-less-safe-but-conducive-to-debugging
  - the-named-detailed-rationale-for-each-debug-option
  - the-named-cross-package-compensation-named
  - the-named-ses-ava-compensates-for-Ava-specifically
  - the-named-unsafe-fast-with-named-regret-and-named-aspiration
  - the-named-extreme-measure-we-hope-to-obviate
  - the-named-hr-separator-as-section-divider
  - the-named-seventeenth-package-in-the-pivot-cluster
  - the-named-fifty-two-line-policy-deep-README
  - the-named-substrate-policy-prose-shape-confirmed
  - thirty-four-cycles-with-named-pivot-domain-stay
  - ninety-eight-citation-arc-closures-in-pivot-now
  - six-cycles-with-named-substrate-package-introduction
---

# `@endo/init README.md` — seventeenth package; enumeration of side effects as package purpose

The 52-line README of @endo/init — the canonical entry point for setting up an Endo JavaScript realm. Cycle 343 is **designs-lane after cycle 342's chat-lane @endo/lockdown/pre.js** — cross-package (lockdown → init). But @endo/lockdown is *used by* @endo/init at the implementation level (cycle 342's pre.js wraps SES's lockdown which @endo/init then orchestrates).

**Thirty-fourth consecutive non-garden source after the pivot** (cycles 310-343). **§thirty-four-cycles-with-named-pivot-domain-stay**. **§seventeen-named-packages-in-the-pivot-cluster** — @endo/init joins as the **SEVENTEENTH PACKAGE** (nat + memoize + hex + lp32 + stream + eventual-send + exo + captp + pass-style + patterns + marshal + common + promise-kit + harden + errors + lockdown + **init**).

The @endo/init package has been **referenced from many prior cycles** — most directly cycle 183 (which ingested 12 init+lockdown bootstrap files as comment-fragment) and cycle 337 (harden's prepare-* convention names init as a canonical caller of lockdown). Cycle 343 closes the documentation-side gap.

## The single most structurally interesting move

**§the-named-enumeration-of-side-effects-as-package-purpose** — lines 3-7:

> Importing `@endo/init` sets up an Endo JavaScript realm.
> This includes setting up HardenedJS, including locking it down,
> sets the realm up for [Eventual Send](../eventual-send),
> ensures that `atob` and `btoa` are present, and ensures that promises can be
> hardened regardless of the platform.

**§the-named-enumeration-of-side-effects-as-package-purpose** — first-explicit-observation as a tier-3 meta-pattern. The README enumerates **FIVE specific actions** the package performs on import:

| # | Action | Detail |
|---|---|---|
| 1 | Sets up HardenedJS | Including locking it down |
| 2 | Sets up Eventual Send | Linked to ../eventual-send |
| 3 | Ensures atob present | Cross-platform base64 |
| 4 | Ensures btoa present | Cross-platform base64 |
| 5 | Ensures promises can be hardened | Regardless of platform |

**§the-named-five-named-actions-performed-on-import** — first-explicit-observation. Compare to cycle 341's @endo/lockdown which named ONE action (*"simply ensures that SES has both initialized and locked down"*). Cycle 343's @endo/init enumerates FIVE; the package is a higher-level aggregator.

**§the-named-side-effect-only-package-with-enumerated-side-effects** — first-explicit-observation as a tier-3 meta-pattern. Cycle 341 named §the-named-side-effect-only-package (the import IS the contract); cycle 343 reveals a refinement: side-effect-only packages SHOULD enumerate their side effects in the README. Tier-3 framing: the README's enumeration is the *contract* for what the import accomplishes.

**§three-cycles-with-named-side-effect-only-package** (cycle 187 shim cluster + cycle 341 lockdown + cycle 343 init) — first-explicit-observation as a tier-2 multi-cycle pattern. The discipline crosses three pivot cycles.

## §the-named-default-is-fully-locked-down

Lines 9-10:

> By default, the environment is fully locked down and as safe as we can make it for cotenant host and guest programs.

**§the-named-default-is-fully-locked-down** — first-explicit-observation. The DEFAULT is the strict mode. The README does not lead with options or configuration; it leads with *"safe by default, with as much safety as we can deliver"*. Compare to cycle 337 @endo/harden's §the-named-fail-loud-or-pay-cost-binary-choice (build-time policy); cycle 343's default IS the loud/safe mode.

**§the-named-cotenant-host-and-guest-programs** — first-explicit-observation. The threat model named: cotenant host AND guest programs sharing a JavaScript context. Sibling to cycle 339 @endo/errors's *"It is similarly possible that a guest would inadvertently reveal information to a cotenant guest"* — both cycles name the cotenant threat. **§two-cycles-with-named-cotenant-threat-model** (339 + 343).

## §the-named-three-entry-point-tolerance-ladder-named-in-README

The README documents THREE entry points:

| Entry point | Section | Safety vs debugging tradeoff |
|---|---|---|
| `@endo/init` | Lines 1-15 | Default; fully locked down |
| `@endo/init/debug.js` | Lines 18-43 | Less safe; conducive to debugging |
| `@endo/init/unsafe-fast.js` | Lines 47-52 | Extreme measure; avoid; "we hope to obviate" |

**§the-named-three-entry-point-tolerance-ladder-named-in-README** — first-explicit-observation. Cycle 183 named §tolerance-ladder-via-separate-entry-point-files at the SOURCE-level (observing the file structure); cycle 343 reveals the README's articulation: each rung named, with its own section explaining purpose and tradeoff.

**§the-named-hr-separator-as-section-divider** — first-explicit-observation. Lines 16 and 45 use Markdown `---` horizontal rules to separate the three entry-point discussions. The HR is a visual structural marker, not a header.

**§the-named-three-rung-ladder-default-debug-unsafe-fast** — first-explicit-observation. The three rungs correspond to three safety/performance choices:
- Default (rung 1): maximum safety
- Debug (rung 2): reduced safety, increased visibility into errors
- Unsafe-fast (rung 3): minimal safety, maximum performance

**§three-shapes-of-safety-vs-performance-tradeoff-exposure** — first-explicit-observation as a tier-3 meta-pattern:

| Cycle | Package | Shape |
|---|---|---|
| 183 | @endo/init source | Separate entry-point files (file-system as policy boundary) |
| 337 | @endo/harden README | Build conditions (`-C hardened`, `-C harden:unsafe`) |
| **343** | **@endo/init README** | **Documented entry-point ladder with named rationale per rung** |

Compare to cycle 342's NOTE-TO-REVIEWERS as merge-defense (source-level honesty about commented-out options) — that's a fourth shape but at a different *level* (per-option vs per-package).

## §the-named-debug-as-less-safe-but-conducive-to-debugging

Lines 18-19:

> The `@endo/init/debug.js` makes a less safe environment which is more conducive to debugging.

**§the-named-debug-as-less-safe-but-conducive-to-debugging** — first-explicit-observation. The README names the TRADEOFF EXPLICITLY: less safety in exchange for better debugging. The phrasing is *non-pejorative* (compare to cycle 337's §the-named-precise-technical-language-without-pejorative-tone).

**§the-named-detailed-rationale-for-each-debug-option** — lines 21-39 detail THREE SES options that debug.js relaxes:

1. **errorTaming** (lines 21-27): default `"safe"` redacts stack traces; tools like Ava look for stacks; debug.js relaxes this
2. **stackFiltering** (lines 29-31): default `"concise"` reduces noise; debug.js may show fuller stacks
3. **overrideTaming** (lines 33-39): default `"moderate"` introduces accessor noise in debugger; debug.js uses `"min"` for less noise

**§the-named-detailed-rationale-for-each-debug-option** — first-explicit-observation as a tier-3 meta-pattern. The discipline: when offering a less-safe variant, document EACH option that differs from default AND name the default behavior AND name when the relaxation might be needed.

Compare to cycle 342's NOTE-TO-REVIEWERS pattern (per-option warnings in source); cycle 343's documentation pattern (per-option rationale in README). **§two-shapes-of-per-option-discipline** (NOTE-TO-REVIEWERS in source + per-option rationale in README).

## §the-named-cross-package-compensation-named

Lines 25-27:

> The `@endo/ses-ava` package compensates for the case of Ava specifically, but `@endo/init/debug.js` may be necessary for other tools.

**§the-named-cross-package-compensation-named** — first-explicit-observation as a tier-3 meta-pattern. The README names a SPECIFIC OTHER PACKAGE (@endo/ses-ava) that handles a SPECIFIC USE CASE (Ava testing). The discipline: when a specific debugging tool has known compatibility issues, ANOTHER PACKAGE provides the compensation; the README points to it.

**§the-named-ses-ava-compensates-for-Ava-specifically** — first-explicit-observation. Cycle 187 ingested @endo/ses-ava as part of the shim-and-prepare cluster; cycle 343 reveals the README-level explanation of WHY ses-ava exists: it's a *compensation* mechanism for a specific test framework.

**§the-named-cross-package-compensation-mechanism** — first-explicit-observation as a tier-3 meta-pattern. When a package's defaults conflict with a tool's expectations, the architectural solution is a *compensation package* rather than weakening the defaults. The compensation is scoped to ONE consumer (Ava), keeping the defaults strict.

Compare to cycle 187's §two-shim-strategies (conditional + unconditional); cycle 343's compensation is a third strategy: *cross-package compensation*. **§three-shapes-of-compatibility-strategy** (conditional-install + unconditional-replacement + cross-package-compensation). First-explicit-observation as a tier-3 meta-pattern.

## §the-named-unsafe-fast-with-named-regret-and-named-aspiration

Lines 47-48:

> Avoid using `@endo/init/unsafe-fast.js`.
> **It is an extreme measure we hope to obviate.**

**§the-named-unsafe-fast-with-named-regret-and-named-aspiration** — first-explicit-observation. The README explicitly says:
1. *Avoid using* (named regret about its existence)
2. *Extreme measure* (named characterization of severity)
3. *We hope to obviate* (named aspiration to remove)

**§the-named-extreme-measure-we-hope-to-obviate** — first-explicit-observation as a tier-3 meta-pattern. Compare to cycle 337's §the-named-isFake-deprecated-with-named-regret (*"We regret this misfeature"*) — same shape of honest-regret-in-README, but at a different level:
- Cycle 337: regret about a past design choice
- Cycle 343: regret about an existing entry point + aspiration to remove it

**§two-cycles-with-named-honest-regret-with-named-aspiration** (337 + 343). The "regret" pattern continues to grow.

**§the-named-existing-entry-point-with-named-aspiration-to-remove** — first-explicit-observation. The package CURRENTLY ships this option but the README explicitly aspires to its REMOVAL. Tier-3 framing: when a package must ship an unsafe option for compatibility reasons, document the regret + aspiration to remove so future maintainers know it's not load-bearing in the design.

## §the-named-fifty-two-line-policy-deep-README

52 lines is in a new range:

| Lines | Package | Cycle | Category |
|---|---|---|---|
| 13 | @endo/errors | 339 | Substrate-policy-minimal |
| 15 | @endo/lockdown | 341 | Substrate-policy-minimal |
| 17 | @endo/common | 333 | Collection-package |
| **52** | **@endo/init** | **343** | **Substrate-policy-deep-mid** |
| 60 | @endo/hex | 317 | Utility-package |
| 71 | @endo/promise-kit | 335 | Utility-package |
| 158 | @endo/harden | 337 | Substrate-policy-prose |
| 188 | @endo/marshal | 329 | Substrate-deep |
| 216 | @endo/pass-style | 325 | Substrate-deep |
| 332 | @endo/eventual-send | 321 | Substrate-deep |
| 364 | @endo/exo | 331 | Substrate-deep |
| 415 | @endo/patterns | 327 | Substrate-deep |

**§the-named-fifty-two-line-policy-deep-README** — first-explicit-observation. 52 lines fills the gap between substrate-policy-minimal (13-15 lines) and substrate-policy-prose (158 lines). **§six-shapes-of-README** — collection + utility + substrate-policy-minimal + substrate-policy-mid + substrate-policy-prose + substrate-deep. First-explicit-observation refining cycle 339's five-shape categorization with a sixth shape (substrate-policy-mid).

**§the-named-substrate-policy-shape-spans-three-length-ranges** — first-explicit-observation. The substrate-policy category now has THREE length variants:
- Minimal (13-15 lines; cycles 339 errors + 341 lockdown): threat + purpose + coordination
- Mid (52 lines; cycle 343 init): enumeration + entry-point ladder + per-option rationale
- Prose (158 lines; cycle 337 harden): full policy details + multiple sections

## Closes citation arcs

Cycle 343 is the **documentation-side closure** of @endo/init's many references. The arcs:

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 342 (lockdown pre.js) | 1 cycle | Cross-package designs-lane after chat-lane; lockdown is internal to init |
| Cycle 341 (lockdown README) | 2 cycles | init/lockdown sibling packages |
| Cycle 340 (errors/rejector.js) | 3 cycles | substrate-package introduction cluster |
| Cycle 339 (@endo/errors README) | 4 cycles | §three-cycles-with-named-side-effect-only-package; §two-cycles-with-named-cotenant-threat-model |
| Cycle 337 (@endo/harden README) | 6 cycles | §the-named-prepare-star-convention named @endo/init |
| Cycle 183 (init+lockdown 12-file cluster comment-fragment) | **160 cycles** | First explicit observation of init's tolerance-ladder; cycle 343 confirms it at README level |
| Cycle 187 (shim cluster — @endo/init/pre-remoting + @endo/init/debug) | 156 cycles | @endo/init's debug rung named in shim discipline |
| Cycle 87 (pass-style/error.js V8 stack accessor) | 256 cycles | errorTaming-safe-redacts-stack named in cycle 343 README |
| Cycle 211 (@endo/common dependency-ceiling names ses + eventual-send + promise-kit) | 132 cycles | @endo/init coordinates these substrates |

**§nine-citation-arc-closures-in-cycle-343**. **§ninety-eight-citation-arc-closures-in-pivot-now** (89 + 9 net new). The cycle 87 → 343 arc at **256 cycles** is the new second-longest pivot arc (current record: 261 cycles from cycle 69 → 330).

**§six-cycles-with-named-substrate-package-introduction** (337 + 339 + 340 + 341 + 342 + 343) — first-explicit-observation. The substrate-introduction phase named in cycle 341 (five-cycle) extends to **seven consecutive cycles** counting all sources (337-343); counting only the package-introduction READMEs/anchors gives six.

**§the-named-substrate-package-cluster-introduction-trend-extends-to-seven-cycles** — first-explicit-observation. The trend named in cycle 341 (five-cycle phase) and extended in cycle 342 (six-cycle phase) now extends to **seven consecutive cycles** in the substrate-introduction phase.

## Patterns the cycle extends

- §thirty-four-cycles-with-named-pivot-domain-stay (310-343)
- §seventeen-named-packages-in-the-pivot-cluster (@endo/init joins as SEVENTEENTH)
- §ninety-eight-citation-arc-closures-in-pivot-now (89 + 9 net new)
- **§six-cycles-with-named-substrate-package-introduction** (337 + 339 + 340 + 341 + 342 + 343)
- §the-named-substrate-package-cluster-introduction-trend-extends-to-seven-cycles
- §two-cycles-with-named-cotenant-threat-model (339 + 343)
- §two-cycles-with-named-honest-regret-with-named-aspiration (337 + 343)
- §three-cycles-with-named-side-effect-only-package (187 + 341 + 343)
- §six-shapes-of-README — collection + utility + substrate-policy-minimal + substrate-policy-mid + substrate-policy-prose + substrate-deep

## Tier-1 borrowing (twenty-plus first-explicit-observations)

- **§the-named-enumeration-of-side-effects-as-package-purpose** — README enumerates specific actions
- **§the-named-five-named-actions-performed-on-import**
- **§the-named-side-effect-only-package-with-enumerated-side-effects**
- **§the-named-default-is-fully-locked-down**
- **§the-named-cotenant-host-and-guest-programs**
- **§the-named-three-entry-point-tolerance-ladder-named-in-README**
- **§the-named-hr-separator-as-section-divider**
- **§the-named-three-rung-ladder-default-debug-unsafe-fast**
- **§three-shapes-of-safety-vs-performance-tradeoff-exposure** — entry-point-files + build-conditions + entry-point-ladder-with-rationale
- **§the-named-debug-as-less-safe-but-conducive-to-debugging**
- **§the-named-detailed-rationale-for-each-debug-option** — per-option documentation
- **§two-shapes-of-per-option-discipline** — NOTE-TO-REVIEWERS in source + per-option rationale in README
- **§the-named-cross-package-compensation-named**
- **§the-named-ses-ava-compensates-for-Ava-specifically**
- **§the-named-cross-package-compensation-mechanism**
- **§three-shapes-of-compatibility-strategy** — conditional-install + unconditional-replacement + cross-package-compensation
- **§the-named-unsafe-fast-with-named-regret-and-named-aspiration**
- **§the-named-extreme-measure-we-hope-to-obviate**
- **§the-named-existing-entry-point-with-named-aspiration-to-remove**
- **§the-named-fifty-two-line-policy-deep-README**
- **§six-shapes-of-README**
- **§the-named-substrate-policy-shape-spans-three-length-ranges**

## Tier-2 borrowing (multi-cycle patterns extended)

- §thirty-four-cycles-with-named-pivot-domain-stay
- §seventeen-named-packages-in-the-pivot-cluster
- §ninety-eight-citation-arc-closures-in-pivot-now
- §six-cycles-with-named-substrate-package-introduction
- §the-named-substrate-package-cluster-introduction-trend-extends-to-seven-cycles
- §two-cycles-with-named-cotenant-threat-model (339 + 343)
- §two-cycles-with-named-honest-regret-with-named-aspiration (337 + 343)
- §three-cycles-with-named-side-effect-only-package (187 + 341 + 343)
- §six-shapes-of-README (refines cycle 339's five-shape categorization with sixth shape)

## Tier-3 borrowing (meta-patterns)

- **§the-named-enumeration-of-side-effects-as-package-purpose** — side-effect-only packages should enumerate their side effects in the README
- **§the-named-side-effect-only-package-with-enumerated-side-effects**
- **§three-shapes-of-safety-vs-performance-tradeoff-exposure** — entry-point-files + build-conditions + entry-point-ladder-with-rationale
- **§the-named-detailed-rationale-for-each-debug-option** — document each option that differs from default with its default behavior and when relaxation is needed
- **§the-named-cross-package-compensation-mechanism** — when defaults conflict with a specific tool, a compensation package solves it (preserving defaults)
- **§three-shapes-of-compatibility-strategy** — conditional-install + unconditional-replacement + cross-package-compensation
- **§the-named-existing-entry-point-with-named-aspiration-to-remove** — document regret + aspiration to remove
- **§six-shapes-of-README** — collection + utility + substrate-policy-minimal + substrate-policy-mid + substrate-policy-prose + substrate-deep
- **§the-named-substrate-policy-shape-spans-three-length-ranges** — minimal (13-15) + mid (52) + prose (158)

## Synthesis-target

Slot machine library **§`@game/init/README.md`** — substrate-policy-deep-mid README for the canonical entry-point:

1. **Enumerate side effects as package purpose** — list each thing the package does on import (five named actions, in our case)
2. **Default-is-fully-locked-down** statement — lead with the default behavior; safety FIRST
3. **Three-entry-point tolerance ladder** — default + debug + extreme, each with its own README section
4. **HR separators as section dividers** — `---` between entry-point discussions
5. **Detailed rationale for each debug option** — document each option that differs from default + when relaxation might be needed
6. **Cross-package compensation named** — when a tool has known compatibility issues, point to the compensation package
7. **Extreme measure with named aspiration to remove** — *"Avoid X. It is an extreme measure we hope to obviate."*
8. **Substrate-policy-mid shape** — 52 lines, fills the gap between minimal (13-15) and prose (158)

## Library state after cycle 343

- §library-reaches-855-sections from 388 source documents
- §one-hundred-and-seventy-sixth consecutive designs-chat alternation
- §thirty-four-cycles-with-named-pivot-domain-stay
- §seventeen-named-packages-in-the-pivot-cluster (@endo/init as SEVENTEENTH)
- §ninety-eight-citation-arc-closures-in-pivot-now (89 + 9 net new) — approaching the 100-arc milestone
- §six-cycles-with-named-substrate-package-introduction; §the-named-substrate-package-cluster-introduction-trend-extends-to-seven-cycles
- §the-named-enumeration-of-side-effects-as-package-purpose established as tier-3 meta-pattern
- §the-named-cross-package-compensation-mechanism established as tier-3 meta-pattern
- §three-shapes-of-safety-vs-performance-tradeoff-exposure established as tier-3 meta-pattern
- §three-shapes-of-compatibility-strategy established as tier-3 meta-pattern
- §six-shapes-of-README established as tier-3 meta-pattern refining cycle 339's five-shape
- §the-named-existing-entry-point-with-named-aspiration-to-remove established as tier-3 meta-pattern
- §the-named-substrate-policy-shape-spans-three-length-ranges established as tier-3 meta-pattern
