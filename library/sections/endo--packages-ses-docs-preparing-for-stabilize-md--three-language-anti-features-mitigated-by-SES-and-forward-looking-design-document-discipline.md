---
title: "@endo/ses docs/preparing-for-stabilize.md — three-language-anti-features-mitigated-by-SES (return-override + assignment-override + proxy-reentrancy); forward-looking design document discipline; closes 203-cycle arc to cycle 146 E.js"
source: endo--packages-ses-docs-preparing-for-stabilize-md
url: https://github.com/endojs/endo/blob/master/packages/ses/docs/preparing-for-stabilize.md
authors: [Mark S. Miller, Endo project (collective)]
repo: endojs/endo
path: packages/ses/docs/preparing-for-stabilize.md
total-lines: 30
ingest-cycle: 349
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-three-language-anti-features-mitigated-by-SES
  - the-named-Stabilize-proposal-with-three-integrity-traits
  - the-named-return-override-mistake
  - the-named-assignment-override-mistake
  - the-named-proxy-based-reentrancy-hazard
  - the-named-fixed-overridable-non-trapping-three-traits
  - the-named-forward-looking-design-document-discipline
  - the-named-prepare-for-future-changes-discipline
  - the-named-placeholder-names-are-not-final
  - the-named-bikeshedding-process-acknowledged
  - the-named-by-default-discipline-with-named-opt-in
  - the-named-E-returns-proxy-with-frozen-trivial-target
  - the-named-top-level-target-discipline
  - the-named-TC39-stage-1-named
  - the-named-draft-PR-named-with-issue-number
  - the-named-harden-discipline-changing-meaning
  - the-named-30-line-forward-looking-design-doc
  - the-named-streak-of-zero-cross-package
  - forty-cycles-with-named-pivot-domain-stay
  - one-hundred-thirty-five-citation-arc-closures-in-pivot-now
---

# `@endo/ses docs/preparing-for-stabilize.md` — three language anti-features mitigated by SES

A 30-line forward-looking design document in SES's docs/ directory. Cycle 349 is **designs-lane after cycle 348's chat-lane @endo/where/index.js** — cross-package (where → ses/docs). **§the-named-streak-of-zero-cross-package**.

**Fortieth consecutive non-garden source after the pivot** (cycles 310-349). **§forty-cycles-with-named-pivot-domain-stay**. The pivot has reached **FORTY consecutive @endo/* sources** without leaving the domain.

This document is **forward-looking** — it describes upcoming language changes from TC39's Stabilize proposal and explains how SES will adapt. Multiple prior pivot cycles (146 E.js + 154 trap.js + 322 exo-makers complementary-lens) explicitly referenced this very document by name (§preparing-for-stabilize.md). Cycle 349 is the documentation-side closure of those references.

## The single most structurally interesting move

**§the-named-three-language-anti-features-mitigated-by-SES** — lines 3-6 of the document name **THREE distinct JavaScript language anti-features** and the **THREE Stabilize-proposal integrity traits** that mitigate each:

| Integrity trait | Language anti-feature mitigated | Mechanism |
|---|---|---|
| **fixed** | Return-override mistake | Prevents objects with this trait from being stamped with new class-private-fields |
| **overridable** | Assignment-override mistake | Enables non-writable properties inherited from an object with this trait to be overridden by property assignment on an inheriting object |
| **non-trapping** | Proxy-based reentrancy hazards | Proxy whose target carries this trait never traps to its handler; just performs the default action directly |

**§the-named-three-language-anti-features-mitigated-by-SES** — first-explicit-observation as a tier-3 meta-pattern. Cycle 345 @endo/ses README named ONE language anti-feature (the assignment-override mistake). Cycle 349 reveals SES mitigates **THREE distinct anti-features**, each with its own named integrity trait.

**§the-named-Stabilize-proposal-with-three-integrity-traits** — first-explicit-observation. The TC39 Stabilize proposal organizes the mitigations into three orthogonal integrity traits with placeholder names (fixed + overridable + non-trapping).

**§the-named-return-override-mistake** + **§the-named-assignment-override-mistake** + **§the-named-proxy-based-reentrancy-hazard** — three distinct JS language warts named individually. Compare to:

| Cycle | Anti-feature named |
|---|---|
| 345 | Override mistake (= assignment-override) — one anti-feature |
| **349** | **return-override + assignment-override + proxy-reentrancy** — three anti-features |

**§the-named-language-anti-features-as-orthogonal-traits** — first-explicit-observation as a tier-3 meta-pattern. The three traits are *orthogonal* — they address different attack surfaces. Tier-3 framing: when a security project mitigates multiple language anti-features, organize them as orthogonal traits (not a single composite property).

**§three-shapes-of-language-anti-feature-mitigation** — first-explicit-observation:

1. **Spec-level mitigation**: TC39 integrity traits (Stabilize proposal)
2. **Library-level mitigation**: SES taming + harden (existing)
3. **User-level workaround**: defineProperties workaround (cycle 345's README)

## §the-named-forward-looking-design-document-discipline

The entire document is forward-looking. It describes:
1. **What's coming** (Stabilize proposal at TC39 stage 1)
2. **What's implemented** (Draft PRs #2673 and #2675 in endo repo)
3. **How callers should prepare** (How proxy code should prepare + How passable objects should prepare)
4. **What the changes mean** semantically (harden discipline changing meaning)

**§the-named-forward-looking-design-document-discipline** — first-explicit-observation as a tier-3 meta-pattern. The document is **not retrospective** (describing what exists); it's **prospective** (describing what's about to happen and how to prepare).

**§the-named-prepare-for-future-changes-discipline** — first-explicit-observation. The document NAMES the discipline for callers: *"to prepare for these changes, we need to avoid hardening both such proxies and their targets"* (line 20) and *"use `harden` explicitly instead"* (line 30).

**§the-named-30-line-forward-looking-design-doc** — first-explicit-observation. Only 30 lines, but encodes:
- Three language anti-features named
- Three integrity traits named
- Two draft PRs named with URLs
- TC39 stage named (stage 1)
- Two preparation guidance sections
- Multiple references to existing SES disciplines (harden + passStyleOf + E(...))

Compare to cycle 339 @endo/errors README (13 lines, retrospective threat-model + purpose) — cycle 349 is the **prospective complement** at similar line count. **§two-shapes-of-30-line-substrate-document** (retrospective threat-model + prospective change-preparation).

## §the-named-placeholder-names-are-not-final

Line 3 + line 8: *"current placeholder names are"* + *"The names it introduces are placeholders, since the bikeshedding process for these names has not yet concluded."*

**§the-named-placeholder-names-are-not-final** — first-explicit-observation. The document NAMES the placeholders AS placeholders. Readers should expect the names to change.

**§the-named-bikeshedding-process-acknowledged** — first-explicit-observation. The standards process for name selection is named explicitly as "bikeshedding". This is honesty about the slow social aspect of standards work.

**§the-named-stabilize-renaming-suppressTrapping-with-named-alternatives** — line 16: *"An explicit handler trap (perhaps named `stabilize` or `suppressTrapping`)"* — TWO candidate names listed for the same future feature.

**§the-named-name-not-yet-finalized-honesty-discipline** — first-explicit-observation as a tier-3 meta-pattern. When a design document references a feature whose name is not finalized, list the candidate names and note that the process is ongoing. Compare to cycle 343 @endo/init's §the-named-unsafe-fast-with-named-regret-and-named-aspiration (named aspiration to remove); cycle 349 is the **inverse** — naming things that may CHANGE BUT NOT BE REMOVED.

## §the-named-by-default-discipline-with-named-opt-in

Lines 16-17 + 24:

> [#2673] will *by default* produce proxies that refuse to be made non-trapping. An explicit handler trap... will need to be explicitly provided to make a proxy that allows itself to be made non-trapping.

**§the-named-by-default-discipline-with-named-opt-in** — first-explicit-observation. Safety by default; opt-in for less safety. **§the-named-safety-by-default-opt-in-for-less-safety**.

Compare to:
- Cycle 337 @endo/harden: §the-named-fail-loud-or-pay-cost-binary-choice (build-time choice)
- Cycle 343 @endo/init: §the-named-default-is-fully-locked-down (default = strict)
- Cycle 345 @endo/ses: §the-named-three-tiers-of-isolation-claims (each tier opt-in)
- **Cycle 349 stabilize**: §the-named-safety-by-default-opt-in-for-less-safety (runtime opt-in via handler trap)

**§four-cycles-with-named-safety-by-default-discipline** (337 + 343 + 345 + 349) — first-explicit-observation as a tier-2 multi-cycle pattern.

## §the-named-E-returns-proxy-with-frozen-trivial-target

Lines 22-26:

> Some proxies, such as that returned by `E(...)`, exist only to provide such trapping behavior. Their targets will typically be trivial useless empty frozen objects or almost empty frozen functions. Such frozen targets can be safely shared between multiple proxy instances because they are encapsulated within the proxy.

**§the-named-E-returns-proxy-with-frozen-trivial-target** — first-explicit-observation. The document NAMES the specific use case: E() (cycle 146) returns proxies whose targets are trivial frozen objects existing only to satisfy the Proxy invariant.

This **closes the citation arc** with cycle 146 (E.js) and cycle 154 (trap.js) — both files explicitly cited this very document (§stabilize-discipline + §preparing-for-stabilize.md references).

**§the-named-trivial-frozen-target-as-proxy-pattern** — first-explicit-observation as a tier-3 meta-pattern. When a Proxy exists only to provide trapping behavior, its target can be a TRIVIAL FROZEN OBJECT (not the actual data); the target satisfies Proxy invariants while the handler does the real work.

**§the-named-top-level-target-discipline** — line 26: *"their definitions should typically appear at top level of their module"*. The trivial target should be MODULE-LEVEL (not function-local) so it can be shared across proxy instances. **§the-named-shared-trivial-target-via-module-scope** — first-explicit-observation as a tier-3 meta-pattern.

## §the-named-draft-PR-named-with-issue-number

Lines 8 and 10 reference TWO draft PRs:
- #2673 — *"shim of the non-trapping integrity trait"*
- #2675 — *"use non-trapping integity trait for safety"* [sic — typo "integity" in source]

**§the-named-draft-PR-named-with-issue-number** — first-explicit-observation. The document references the work-in-progress implementation by PR number with named titles.

**§the-named-implementation-PRs-named-explicitly** — first-explicit-observation as a tier-3 meta-pattern. When a design document describes future changes, name the SPECIFIC PRs implementing them so readers can track progress.

Compare to:
- Cycle 337 @endo/harden's §the-named-platform-specific-repair-with-named-error-code (named error code points to Markdown doc)
- Cycle 338 @endo/harden/make-hardener's §the-named-Safari-bug-workaround-with-named-tracking-URL (bug URL + error code)
- **Cycle 349 stabilize**: §the-named-implementation-PRs-named-explicitly (PRs as work tracking)

**§three-shapes-of-stable-pointer-discipline-extended** — extending cycle 338's three shapes (deprecation-pointer + issue-link + error-code-Markdown) with a fourth: PR-link-for-WIP-implementation. **§four-shapes-of-stable-pointer-discipline** (326 + 336 + 338 + 349) — first-explicit-observation as a tier-2 multi-cycle pattern.

## §the-named-harden-discipline-changing-meaning

Line 11: *"Where `harden` made the object at every step frozen, that PR changes `harden` to also make those objects non-trapping."*

Line 30: *"Although we think of `passStyleOf` as requiring its input to be hardened, `passStyleOf` instead checked that each relevant object is frozen. Manually freezing all objects reachable from a root object had been equivalent to hardening that root object. With these changes, even such manual transitive freezing will not make an object passable. To prepare for these changes, use `harden` explicitly instead."*

**§the-named-harden-discipline-changing-meaning** — first-explicit-observation. The SEMANTICS of harden vs Object.freeze is changing:
- **Before**: harden = transitive Object.freeze; passStyleOf checks frozen
- **After**: harden = transitive Object.freeze + non-trapping mark; passStyleOf checks both

**§the-named-discipline-semantics-evolution-with-named-migration** — first-explicit-observation as a tier-3 meta-pattern. When a discipline's semantics change, the document names BOTH the old semantics AND the new semantics AND the migration path (*"use `harden` explicitly instead"*).

## Closes citation arcs

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 348 (@endo/where/index.js) | 1 cycle | Cross-package designs-lane after chat-lane |
| Cycle 346 (@endo/ses entry cluster) | 3 cycles | Same-package SES |
| Cycle 345 (@endo/ses README) | 4 cycles | §the-named-three-language-anti-features-mitigated-by-SES extends cycle 345's override-mistake observation |
| **Cycle 146 (E.js §stabilize-discipline reference)** | **203 cycles** | E.js explicitly cited this document; cycle 349 closes the arc |
| **Cycle 154 (trap.js §preparing-for-stabilize comment)** | **195 cycles** | trap.js explicitly cited this document |
| Cycle 322 (exo-makers complementary-lens §state-sealed-not-frozen) | 27 cycles | Hardening discipline evolution |
| Cycle 187 (shim cluster) | 162 cycles | Hardening-related |
| Cycle 343 (@endo/init README) | 6 cycles | §four-cycles-with-named-safety-by-default-discipline |

**§eight-citation-arc-closures-in-cycle-349**. **§one-hundred-thirty-five-citation-arc-closures-in-pivot-now** (130 + 5 net new).

## Patterns the cycle extends

- §forty-cycles-with-named-pivot-domain-stay (310-349)
- §nineteen-named-packages-in-the-pivot-cluster
- §one-hundred-thirty-five-citation-arc-closures-in-pivot-now (130 + 5 net new)
- §four-cycles-with-named-safety-by-default-discipline (337 + 343 + 345 + 349)
- §four-shapes-of-stable-pointer-discipline (326 + 336 + 338 + 349)
- §the-named-streak-of-zero-cross-package

## Tier-1 borrowing (twenty-plus first-explicit-observations from a 30-line doc)

- **§the-named-three-language-anti-features-mitigated-by-SES** — return-override + assignment-override + proxy-reentrancy
- **§the-named-Stabilize-proposal-with-three-integrity-traits**
- **§the-named-return-override-mistake** + **§the-named-assignment-override-mistake** + **§the-named-proxy-based-reentrancy-hazard**
- **§the-named-fixed-overridable-non-trapping-three-traits**
- **§the-named-language-anti-features-as-orthogonal-traits**
- **§three-shapes-of-language-anti-feature-mitigation** — spec + library + user-workaround
- **§the-named-forward-looking-design-document-discipline**
- **§the-named-prepare-for-future-changes-discipline**
- **§the-named-30-line-forward-looking-design-doc**
- **§two-shapes-of-30-line-substrate-document** — retrospective + prospective
- **§the-named-placeholder-names-are-not-final**
- **§the-named-bikeshedding-process-acknowledged**
- **§the-named-stabilize-renaming-suppressTrapping-with-named-alternatives**
- **§the-named-name-not-yet-finalized-honesty-discipline**
- **§the-named-by-default-discipline-with-named-opt-in**
- **§the-named-safety-by-default-opt-in-for-less-safety**
- **§the-named-E-returns-proxy-with-frozen-trivial-target**
- **§the-named-trivial-frozen-target-as-proxy-pattern**
- **§the-named-top-level-target-discipline**
- **§the-named-shared-trivial-target-via-module-scope**
- **§the-named-draft-PR-named-with-issue-number**
- **§the-named-implementation-PRs-named-explicitly**
- **§the-named-harden-discipline-changing-meaning**
- **§the-named-discipline-semantics-evolution-with-named-migration**
- **§the-named-TC39-stage-1-named**

## Tier-3 borrowing (meta-patterns)

- **§the-named-three-language-anti-features-mitigated-by-SES** — name each anti-feature distinctly as orthogonal mitigation surface
- **§the-named-language-anti-features-as-orthogonal-traits**
- **§three-shapes-of-language-anti-feature-mitigation** — spec + library + user-workaround layers
- **§the-named-forward-looking-design-document-discipline** — prospective documentation for upcoming changes
- **§the-named-name-not-yet-finalized-honesty-discipline** — list candidate names when bikeshedding is in progress
- **§the-named-safety-by-default-opt-in-for-less-safety** — applied at the runtime-trap level
- **§the-named-trivial-frozen-target-as-proxy-pattern** — proxy whose handler does the real work has a trivial frozen target
- **§the-named-shared-trivial-target-via-module-scope** — module-level definitions enable safe sharing
- **§the-named-implementation-PRs-named-explicitly** — name specific WIP PRs for traceability
- **§four-shapes-of-stable-pointer-discipline** — deprecation-pointer + issue-link + error-code-Markdown + PR-link-for-WIP
- **§the-named-discipline-semantics-evolution-with-named-migration** — name old + new + migration path

## Synthesis-target

Slot machine library **§`@game/ses/docs/preparing-for-X.md`** — forward-looking design document:

1. **Three language anti-features mitigated** — name each distinctly with named integrity trait
2. **Placeholder names are not final** — list candidate names; acknowledge bikeshedding
3. **By default safety, opt-in for less safety** — runtime trap discipline
4. **Trivial frozen target as proxy pattern** — share at module scope
5. **Implementation PRs named explicitly** — work tracking via PR links
6. **Discipline semantics evolution with named migration** — old + new + how to prepare
7. **Forward-looking design document discipline** — prospective complement to retrospective READMEs

## Library state after cycle 349

- §library-reaches-861-sections from 393 source documents
- §one-hundred-and-eighty-second consecutive designs-chat alternation
- §forty-cycles-with-named-pivot-domain-stay (310-349)
- §nineteen-named-packages-in-the-pivot-cluster
- §one-hundred-thirty-five-citation-arc-closures-in-pivot-now (130 + 5 net new)
- §four-cycles-with-named-safety-by-default-discipline (337 + 343 + 345 + 349)
- §four-shapes-of-stable-pointer-discipline (326 + 336 + 338 + 349)
- §the-named-three-language-anti-features-mitigated-by-SES established as tier-3 meta-pattern
- §the-named-forward-looking-design-document-discipline established as tier-3 meta-pattern
- §the-named-name-not-yet-finalized-honesty-discipline established as tier-3 meta-pattern
- §the-named-trivial-frozen-target-as-proxy-pattern established as tier-3 meta-pattern
- §the-named-implementation-PRs-named-explicitly established as tier-3 meta-pattern
- §the-named-discipline-semantics-evolution-with-named-migration established as tier-3 meta-pattern
- §the-named-streak-of-zero-cross-package (cycle 348 → 349 cross-package)
