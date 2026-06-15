---
title: "@endo/ses README.md — eighteenth package; THE foundational substrate; precise-claims-with-precise-caveats discipline; pre-written PR language for ecosystem cooperation; four pillars of HardenedJS; 964-line substrate-policy-vast README"
source: endo--packages-ses-README-md
url: https://github.com/endojs/endo/blob/master/packages/ses/README.md
authors: [Kris Kowal, Mark S. Miller, Endo project (collective)]
repo: endojs/endo
path: packages/ses/README.md
total-lines: 964
ingest-cycle: 345
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-precise-claims-with-precise-caveats-discipline
  - the-named-pre-written-PR-language-for-ecosystem-cooperation
  - the-named-acronym-with-named-philosophical-expansion
  - the-named-SES-stands-for-fearless-cooperation
  - the-named-four-pillars-of-HardenedJS
  - the-named-host-program-vs-guest-program-vocabulary
  - the-named-canonical-deployers-named-with-logos
  - the-named-three-attack-categories-lockdown-defends-against
  - the-named-undeniable-objects-discipline
  - the-named-taming-as-named-verb-of-art
  - the-named-realm-vs-compartment-distinction
  - the-named-three-tiers-of-isolation-claims
  - the-named-list-of-things-guest-cannot-do
  - the-named-list-of-things-guest-can-still-do
  - the-named-Trusted-Compute-Base-enumerated
  - the-named-override-mistake-as-named-JavaScript-anti-feature
  - the-named-defineProperties-workaround-for-override-mistake
  - the-named-audit-history-as-trust-signal
  - the-named-purple-teaming-as-collaborative-audit-style
  - the-named-Caja-as-named-predecessor-with-named-extensions
  - the-named-Math-random-and-Date-now-disabled-by-default
  - the-named-SharedArrayBuffer-as-named-attack-vector
  - the-named-reentrancy-attack-named-explicitly
  - the-named-defending-via-clean-stack-promise
  - the-named-locale-methods-as-fingerprinting-vector
  - the-named-eighteenth-package-in-the-pivot-cluster
  - the-named-964-line-substrate-policy-vast-README
  - eight-cycles-with-named-substrate-package-introduction
  - thirty-six-cycles-with-named-pivot-domain-stay
  - one-hundred-sixteen-citation-arc-closures-in-pivot-now
---

# `@endo/ses README.md` — eighteenth package; THE foundational substrate

The 964-line README of @endo/ses — the foundational SES shim that *all* other @endo packages coordinate with (cycles 337 + 339 + 341 + 342 + 343 + 344 all named SES as their coordination target). Cycle 345 is **designs-lane after cycle 344's chat-lane @endo/init source cluster** — cross-package; the substrate-introduction phase reaches its **culmination** with the foundational package.

**Thirty-sixth consecutive non-garden source after the pivot** (cycles 310-345). **§thirty-six-cycles-with-named-pivot-domain-stay**. **§eighteen-named-packages-in-the-pivot-cluster** — @endo/ses joins as the **EIGHTEENTH PACKAGE** (nat + memoize + hex + lp32 + stream + eventual-send + exo + captp + pass-style + patterns + marshal + common + promise-kit + harden + errors + lockdown + init + **ses**).

This is the **culmination of the substrate-introduction phase**. SES is referenced from cycle 87 (V8-stack-accessor; "ses occludes the stack on V8 and SpiderMonkey, but cannot on JavaScriptCore") + cycle 211 (@endo/common dependency-ceiling) + every substrate-introduction cycle 337-344 as the convergent coordination target.

## The single most structurally interesting move

**§the-named-precise-claims-with-precise-caveats-discipline** — the "Security claims and caveats" section (lines 693-859, ~166 lines) pairs each GUARANTEE with its LIMITATION explicitly. The section structure:

1. **Boundary definition** — what kind of boundary `ses` provides (lines 695-703)
2. **Vocabulary** — "host program" vs "guest program" (lines 705-707)
3. **Single-guest Compartment Isolation** — claims + limitations
4. **Multi-guest Compartment Isolation** — additional claims under additional conditions
5. **Endowment Protection** — what the host is responsible for
6. **Caveats** — explicit limitations of the boundary
7. **Trusted Compute Base** — what `ses` itself depends on

**Single-guest isolation claims** (lines 716-722):

> * will initially only have access to one mutable object, the compartment's `globalThis`,
> * specifically cannot modify any shared primordial objects, which are part of the default execution environment,
> * cannot initially perform any I/O (except I/O necessarily performed by the trusted compute base like paging virtual memory),
> * and specifically cannot measure the passage of time at any resolution.

**Immediately followed by limitations** (lines 724-734):

> However, such a program can:
> * execute for an indefinite amount of time,
> * allocate arbitrary amounts of memory,
> * detect the platform endianness,
> * in some JavaScript engines, observe the contents of the stack. (...) `ses` occludes the stack on V8 and SpiderMonkey, but cannot on JavaScriptCore.

**§the-named-precise-claims-with-precise-caveats-discipline** — first-explicit-observation as a tier-3 meta-pattern. The discipline:

| Element | Purpose |
|---|---|
| Numbered list of guarantees | Establishes the security claim |
| "However, such a program can:" + numbered list | Names the residual capabilities |
| Platform-specific caveats (e.g., JavaScriptCore) | Names where the guarantee weakens |

The discipline is to **never claim more than is true**, and to **explicitly enumerate what is NOT guaranteed**. Compare to:
- Cycle 337 @endo/harden's §the-named-partial-safety-with-named-tradeoff (without HardenedJS, surface immutability without prototype-chain traversal)
- Cycle 342 @endo/lockdown/pre.js's §the-named-named-hole-with-named-mitigation (domainTaming-unsafe always injected because standardthings/esm)
- **Cycle 345 @endo/ses's full claims+caveats section** — the canonical example of the discipline at the package-level

**§three-cycles-with-named-precise-security-claim-discipline** (337 + 342 + 345) — first-explicit-observation as a tier-2 multi-cycle pattern. The discipline crosses three substrate-introduction cycles.

## §the-named-pre-written-PR-language-for-ecosystem-cooperation

Lines 932-948 provide **verbatim text** for downstream maintainers to paste into upstream issues:

```
> This project has some assignments that break in an environment with frozen
> intrinsic objects, such as
> [Hardened JS (a.k.a. SES)](https://github.com/endojs/endo/blob/master/packages/ses#ecosystem-compatibility)
> or Node.js with the
> [`--frozen-intrinsics`](https://nodejs.org/docs/latest/api/cli.html#--frozen-intrinsics)
> option.
> Specifically, [link to source in the project] does not work correctly in such
> an environment.
>
> Please consider increasing support by replacing assignments to object
> properties inherited from intrinsics with use of `Object.defineProperties`
> (thereby working around the JavaScript "override mistake"), and if applicable
> also by avoiding mutation of intrinsic objects.
> If you don't have the capacity but would accept a PR, please comment to that
> effect so that a volunteer knows their efforts would be welcomed.
```

**§the-named-pre-written-PR-language-for-ecosystem-cooperation** — first-explicit-observation as a tier-3 meta-pattern. The README anticipates that downstream users will encounter incompatibilities AND that fixing those incompatibilities requires upstream cooperation. The README provides the EXACT TEXT to use.

**§the-named-README-as-cultural-artifact-not-just-documentation** — first-explicit-observation. The README is not merely describing the package; it's SCRIPTING the community-action that the package's adoption requires. Tier-3 framing: when a package's success depends on ecosystem cooperation, the README should provide *verbatim cooperation language* for downstream users to deploy.

Compare to cycle 343 @endo/init's §the-named-cross-package-compensation-named (pointing to @endo/ses-ava for Ava compatibility); cycle 345's pre-written PR text is the *scaled-up* version — instead of one named compensation package, the README provides text for AD HOC compensation across the entire JS ecosystem.

**§the-named-volunteer-PR-language-with-named-fallback-comment** — the text includes *"If you don't have the capacity but would accept a PR, please comment to that effect so that a volunteer knows their efforts would be welcomed"* — anticipating two distinct downstream maintainer responses (do-it-yourself vs accept-volunteer-PR) and naming both.

## §the-named-acronym-with-named-philosophical-expansion

Line 5: *"SES stands for *fearless cooperation*."*

**§the-named-acronym-with-named-philosophical-expansion** — first-explicit-observation as a tier-3 meta-pattern. The technical expansion (Secure ECMAScript) is NOT given; the README opens with the PHILOSOPHICAL stance. Tier-3 framing: when a project has a strong values position, lead with the values not the technical expansion.

**§the-named-SES-stands-for-fearless-cooperation** — first-explicit-observation. The phrase "fearless cooperation" encodes the project's identity: enabling parties to cooperate without fear of harm. Compare to:
- Cycle 337 @endo/harden's §the-named-place-to-stand-toward-its-own-defense-metaphor (vivid architectural metaphor)
- Cycle 339 @endo/errors's §the-named-symmetric-disclosure-risk-named-twice (host AND guest)
- **Cycle 345 @endo/ses's §the-named-fearless-cooperation** — the value statement that ANCHORS the entire HardenedJS stack

**§three-cycles-with-named-architectural-philosophy** (87 V8-stack-accessor + 337 place-to-stand + 345 fearless-cooperation) — first-explicit-observation as a tier-2 multi-cycle pattern.

## §the-named-four-pillars-of-HardenedJS

Lines 9-20 enumerate the FOUR pillars:

| Pillar | One-line description |
|---|---|
| **Compartments** | Separate execution contexts each with own globalThis and global lexical scope |
| **Frozen realm** | Compartments share intrinsics (avoids identity discontinuity); freezing protects programs from each other |
| **Strict mode** | Enforces JavaScript strict mode (silent failures become thrown errors) |
| **POLA** (Principle of Least Authority) | Compartments receive no ambient authority by default |

**§the-named-four-pillars-of-HardenedJS** — first-explicit-observation as a tier-3 meta-pattern. The README distills the entire HardenedJS architecture to FOUR named pillars, each with a bolded keyword + one-line description.

Compare to:
- Cycle 337 @endo/harden's three-tier defense (HardenedJS + LavaMoat + harden()) — at the META level (three layers of defense)
- **Cycle 345 @endo/ses's four pillars** — at the COMPONENT level (four parts of HardenedJS itself)

**§two-shapes-of-architectural-summary** (cycle 337 three-tier-meta-defense + cycle 345 four-pillars-component-architecture) — first-explicit-observation as a tier-2 multi-cycle pattern.

**§the-named-bolded-keyword-as-pillar-marker** — first-explicit-observation. Each pillar starts with `**Bold**` to highlight the named concept. The discipline: when listing named components, bold the name.

## §the-named-host-program-vs-guest-program-vocabulary

Lines 705-707:

> For the purposes of these claims and caveats, a "host program" is a program that arranges `ses`, calls `lockdown`, and orchestrates one or more "guest programs", providing limited access to its resources.

**§the-named-host-program-vs-guest-program-vocabulary** — first-explicit-observation. The README defines its vocabulary IN-SECTION. Compare to:
- Cycle 339 @endo/errors's host/guest naming (no formal definition; uses the terms without introduction)
- **Cycle 345 @endo/ses's formal definition** — *"For the purposes of these claims and caveats, a 'host program' is..."*

The discipline: when a section uses vocabulary that's load-bearing for the claims, define it IN that section, not assume the reader knows.

**§the-named-vocabulary-definition-in-section** — first-explicit-observation as a tier-3 meta-pattern.

## §the-named-three-tiers-of-isolation-claims

The Security Claims section has THREE sub-claims:

| Tier | Section | Conditions |
|---|---|---|
| Single-guest | Lines 709-740 | One compartment, one guest |
| Multi-guest | Lines 742-762 | Frozen globalThis; two or more guests in one compartment |
| Endowment Protection | Lines 764-799 | Hosts responsible for hardening endowments |

**§the-named-three-tiers-of-isolation-claims** — first-explicit-observation. Each tier has ADDITIONAL conditions and ADDITIONAL guarantees:
- Single-guest = base claim
- Multi-guest = base + frozen-globalThis condition
- Endowment Protection = host responsibility

**§the-named-layered-isolation-claims-with-named-conditions** — first-explicit-observation as a tier-3 meta-pattern. The discipline: when a security boundary has multiple use-cases, document each tier separately with its specific conditions and the specific guarantees that flow from those conditions.

## §the-named-Trusted-Compute-Base-enumerated

Lines 844-859 enumerate the TCB:

1. The host hardware
2. The host operating system
3. Any intermediate virtual operating systems or hypervisors
4. The process memory manager
5. An implementation of JavaScript conforming to ECMAScript 262 as of 2021, providing no unspecified embedding host behavior
6. Any attached debugger
7. Any JavaScript that has executed in the same realm before `lockdown`

**§the-named-Trusted-Compute-Base-enumerated** — first-explicit-observation as a tier-3 meta-pattern. The TCB is explicitly named with SEVEN components. The discipline: name what the security boundary RELIES ON (the TCB), not just what it provides.

**§the-named-domain-property-on-promises-as-named-Node-host-behavior** — line 853-855: *"`ses` accounts for one such host behavior provided by Node.js, namely the `domain` property on promises, by preventing the use of `ses` in concert with the `domain` module"* — a specific platform misfeature named.

## §the-named-override-mistake-as-named-JavaScript-anti-feature

Line 908: *"the [override mistake]"* — a named JS language wart with hyperlink to the original ECMAScript wiki strawman.

**§the-named-override-mistake-as-named-JavaScript-anti-feature** — first-explicit-observation as a tier-3 meta-pattern. JavaScript has *language-level anti-features* that prevent or complicate security; the README names them with citations.

Lines 915-924 provide the **§the-named-defineProperties-workaround-for-override-mistake**:

```js
Object.defineProperties(<lhs>, {
  [<propertyKey>]: {
    value: <rhs>,
    writable: true,
    enumerable: true,
    configurable: true,
  },
});
```

**§the-named-language-anti-feature-with-workaround-code** — first-explicit-observation. Named anti-feature + named workaround code.

## §the-named-audit-history-as-trust-signal

Lines 860-894 detail FOUR trust-building activities:

| Activity | Date | Outcome |
|---|---|---|
| Formal third-party audit | June 2021 | No unknown vulnerabilities; one code change (domain module disable) |
| Collaborative bug hunt | July 2021 | No critical flaws; documentation improvements |
| Formal verification | Ongoing | OCAP model found sound |
| Bug bounty program | Ongoing | Active researcher engagement |

**§the-named-audit-history-as-trust-signal** — first-explicit-observation as a tier-3 meta-pattern. Security products demonstrate trustworthiness by documenting their audit history with **dates**, **outcomes**, and **resulting changes**.

**§the-named-purple-teaming-as-collaborative-audit-style** — line 872-873: *"`ses` was the target of an intensive collaborative bug hunt lead by the MetaMask team"* — named collaboration between deploying parties as audit modality.

## Closes citation arcs (substrate-cluster culmination)

Cycle 345's SES ingest is the **substrate-introduction culmination** — closing arcs to nearly every prior cycle that referenced SES, frozen-intrinsics, lockdown, or the HardenedJS substrate:

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 344 (init source cluster) | 1 cycle | init/ses parent-child relationship |
| Cycle 343 (@endo/init README) | 2 cycles | init coordinates with ses |
| Cycle 342 (lockdown pre.js) | 3 cycles | lockdown wraps ses's lockdown |
| Cycle 341 (lockdown README) | 4 cycles | lockdown coordinates with ses |
| Cycle 340 (errors/rejector.js) | 5 cycles | substrate-cluster introduction |
| Cycle 339 (@endo/errors README) | 6 cycles | errors coordinates with ses for console-reveal |
| Cycle 338 (harden make-hardener.js) | 7 cycles | substrate-of-substrates |
| Cycle 337 (@endo/harden README) | 8 cycles | three-tier defense names ses-equivalent |
| **Cycle 87 (pass-style/error.js V8 stack accessor)** | **258 cycles** | *"`ses` occludes the stack on V8 and SpiderMonkey, but cannot on JavaScriptCore"* — direct README quote of the V8-stack discipline |
| Cycle 211 (@endo/common dependency-ceiling names ses) | 134 cycles | @endo/common's substrate ceiling |
| Cycle 183 (init+lockdown 12-file cluster) | 162 cycles | First detailed observation of lockdown options |
| Cycle 322 (exo-makers complementary-lens) | 23 cycles | Compartments as named execution context |

**§eleven-citation-arc-closures-in-cycle-345**. **§one-hundred-sixteen-citation-arc-closures-in-pivot-now** (105 + 11 net new). The cycle 87 → 345 arc at **258 cycles** is a new second-longest pivot arc (just below the 261-cycle record from cycle 69 → 330).

**§eight-cycles-with-named-substrate-package-introduction** (337 + 339 + 340 + 341 + 342 + 343 + 344 + 345). The substrate-introduction phase reaches **NINE consecutive cycles** counting all sources (337-345).

**§the-named-substrate-package-cluster-introduction-trend-extends-to-nine-cycles** — first-explicit-observation. **§the-named-substrate-introduction-phase-culminates-at-foundational-package** — first-explicit-observation as a librarian-discipline observation. The phase moved from outer layers (harden + errors + lockdown + init) inward to the foundation (ses).

## §the-named-964-line-substrate-policy-vast-README

964 lines is a new range — by far the largest README in the pivot:

| Lines | Package | Cycle | Category |
|---|---|---|---|
| 13 | @endo/errors | 339 | Substrate-policy-minimal |
| 15 | @endo/lockdown | 341 | Substrate-policy-minimal |
| 17 | @endo/common | 333 | Collection-package |
| 52 | @endo/init | 343 | Substrate-policy-mid |
| 60-216 | (various) | (various) | Utility / substrate-deep |
| 415 | @endo/patterns | 327 | Substrate-deep |
| **964** | **@endo/ses** | **345** | **Substrate-policy-VAST** |

**§the-named-964-line-substrate-policy-vast-README** — first-explicit-observation. **§seven-shapes-of-README** — first-explicit-observation refining cycle 343's six-shape categorization with substrate-policy-vast as a SEVENTH shape:

| Shape | Length | Cycle |
|---|---|---|
| Collection | 17 | 333 |
| Substrate-policy-minimal | 13-15 | 339, 341 |
| Substrate-policy-mid | 52 | 343 |
| Utility | 60-140 | 315/317/319/335 |
| Substrate-policy-prose | 158 | 337 |
| Substrate-deep | 188-415 | 325/327/329/331/321 |
| **Substrate-policy-vast** | **964** | **345** |

The README-shape spectrum now spans **seven shapes** with @endo/ses at the extreme. **§the-named-foundational-package-gets-vast-README** — first-explicit-observation as a tier-3 meta-pattern. The most foundational package in the stack has the most extensive documentation; complexity tracks position in the layered architecture.

## Other key first-explicit-observations

- **§the-named-canonical-deployers-named-with-logos** — Agoric + MetaMask logos embedded; corporate validation as feature
- **§the-named-video-introductions-embedded** — TWO YouTube videos embedded as image-links
- **§the-named-community-channels-trio** — Mailing List + Matrix + weekly call
- **§the-named-Caja-as-named-predecessor-with-named-extensions** — *"SES starts where the Caja project left off ... introduces compartments and modernizes"*
- **§the-named-three-attack-categories-lockdown-defends-against** — prototype pollution + man-in-the-middle + covert communication channels
- **§the-named-undeniable-objects-discipline** — *"effectively undeniable to programs in the realm"*
- **§the-named-taming-as-named-verb-of-art** — *"tames"* is SES's verb for modifying intrinsics (RegExp + locale + errors)
- **§the-named-locale-methods-as-fingerprinting-vector** — locale methods reveal host locale; SES tames them
- **§the-named-realm-vs-compartment-distinction** — realm contains compartments; compartments share intrinsics with realm
- **§the-named-initial-compartment-named** — "the initial compartment, the initial execution environment of a realm"
- **§the-named-harden-as-post-lockdown-tool** — *"`*After*` calling `lockdown`, the `harden` function..."* — temporal ordering named
- **§the-named-surface-vs-state-distinction** — *"surface of the capability is frozen"* but "still closes over the mutable counter"
- **§the-named-hardening-makes-surface-immutable-but-not-side-effect-free**
- **§the-named-Math-random-and-Date-now-disabled-by-default** — covert-channel hazards named
- **§the-named-SharedArrayBuffer-as-named-attack-vector** — high-resolution-timer construction
- **§the-named-reentrancy-attack-named-explicitly** — *"call back into the program in pursuit of a reentrancy attack"*
- **§the-named-defending-via-clean-stack-promise** — *"interacts with guest objects on a clean stack through the use of promises"*
- **§the-named-supply-chain-attack-via-bundler-named** — bundlers themselves are a threat vector
- **§the-named-charset-utf-8-explicitly-required** — line 67-69
- **§the-named-Taxonomy-of-Security-Issues-paper-link** — research-paper link as boundary-definition reference

## Patterns the cycle extends

- §thirty-six-cycles-with-named-pivot-domain-stay (310-345)
- §eighteen-named-packages-in-the-pivot-cluster (@endo/ses as EIGHTEENTH)
- §one-hundred-sixteen-citation-arc-closures-in-pivot-now (105 + 11 net new)
- §eight-cycles-with-named-substrate-package-introduction (337-345)
- §the-named-substrate-package-cluster-introduction-trend-extends-to-nine-cycles
- §the-named-substrate-introduction-phase-culminates-at-foundational-package
- §three-cycles-with-named-precise-security-claim-discipline (337 + 342 + 345)
- §three-cycles-with-named-architectural-philosophy (87 + 337 + 345)
- §two-shapes-of-architectural-summary (cycle 337 three-tier-meta + cycle 345 four-pillars-component)
- §seven-shapes-of-README (refines cycle 343's six-shape categorization)

## Tier-3 borrowing (meta-patterns)

- **§the-named-precise-claims-with-precise-caveats-discipline** — never claim more than is true; explicitly enumerate non-guarantees
- **§the-named-pre-written-PR-language-for-ecosystem-cooperation** — when ecosystem cooperation is required, provide verbatim text
- **§the-named-README-as-cultural-artifact-not-just-documentation** — READMEs can script community-action
- **§the-named-acronym-with-named-philosophical-expansion** — lead with values, not technical expansion
- **§the-named-four-pillars-of-HardenedJS** — architectural summaries as canonical bulleted pillars
- **§the-named-vocabulary-definition-in-section** — define load-bearing vocabulary in the section that uses it
- **§the-named-layered-isolation-claims-with-named-conditions** — multi-tier claims with explicit conditions per tier
- **§the-named-Trusted-Compute-Base-enumerated** — name what the boundary RELIES on, not just what it provides
- **§the-named-override-mistake-as-named-JavaScript-anti-feature** — name language-level anti-features with citations
- **§the-named-language-anti-feature-with-workaround-code**
- **§the-named-audit-history-as-trust-signal** — security products demonstrate trustworthiness via documented audit history
- **§the-named-purple-teaming-as-collaborative-audit-style**
- **§the-named-foundational-package-gets-vast-README** — complexity tracks position in layered architecture
- **§seven-shapes-of-README** — collection + utility + minimal + mid + prose + deep + vast
- **§the-named-substrate-introduction-phase-culminates-at-foundational-package** — librarian discipline observation

## Synthesis-target

Slot machine library **§`@game/ses/README.md`** — substrate-policy-vast README for the foundational package:

1. **Acronym with named philosophical expansion** — lead with values
2. **Four pillars as architectural summary** — bolded keywords + one-line descriptions
3. **Canonical deployers named with logos** — corporate validation as feature
4. **Video introductions embedded** — TWO videos as image-links
5. **Precise claims with precise caveats** — never claim more than is true
6. **Three tiers of isolation claims** — separate sections per use-case + conditions
7. **Lists of guarantees + lists of residual capabilities** — explicit boundary
8. **Trusted Compute Base enumerated** — name what we rely on
9. **Vocabulary definition in section** — define host/guest in the section that uses them
10. **Named JavaScript anti-features with workaround code** — language warts named with citations
11. **Audit history as trust signal** — dates + outcomes + resulting changes
12. **Pre-written PR language for ecosystem cooperation** — verbatim text for downstream maintainers
13. **README as cultural artifact** — script community-action

## Library state after cycle 345

- §library-reaches-857-sections from 390 source documents
- §one-hundred-and-seventy-eighth consecutive designs-chat alternation
- §thirty-six-cycles-with-named-pivot-domain-stay
- §eighteen-named-packages-in-the-pivot-cluster (@endo/ses as EIGHTEENTH; SUBSTRATE-INTRODUCTION CULMINATION)
- §one-hundred-sixteen-citation-arc-closures-in-pivot-now (105 + 11 net new)
- §eight-cycles-with-named-substrate-package-introduction (337-345)
- §the-named-substrate-package-cluster-introduction-trend-extends-to-nine-cycles
- §the-named-substrate-introduction-phase-culminates-at-foundational-package established as a librarian-discipline observation
- §the-named-precise-claims-with-precise-caveats-discipline established as tier-3 meta-pattern
- §the-named-pre-written-PR-language-for-ecosystem-cooperation established as tier-3 meta-pattern
- §the-named-README-as-cultural-artifact-not-just-documentation established as tier-3 meta-pattern
- §the-named-foundational-package-gets-vast-README established as tier-3 meta-pattern
- §seven-shapes-of-README established as tier-3 meta-pattern refining cycle 343's six-shape with substrate-policy-vast as seventh
- §the-named-Trusted-Compute-Base-enumerated established as tier-3 meta-pattern
- §the-named-override-mistake-as-named-JavaScript-anti-feature established as tier-3 meta-pattern
- §the-named-audit-history-as-trust-signal established as tier-3 meta-pattern
- §the-named-acronym-with-named-philosophical-expansion established as tier-3 meta-pattern
- §the-named-four-pillars-of-HardenedJS established as the canonical architectural summary anchor
