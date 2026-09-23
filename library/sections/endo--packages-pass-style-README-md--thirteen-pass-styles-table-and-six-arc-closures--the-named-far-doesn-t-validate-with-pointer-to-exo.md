---
title: §the-named-Far-doesn-t-validate-with-pointer-to-exo
source: endo--packages-pass-style-README-md
url: https://github.com/endojs/endo/blob/master/packages/pass-style/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/pass-style/README.md
total-lines: 216
ingest-cycle: 325
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-exhaustive-enumeration-via-table
  - the-named-thirteen-pass-styles-in-one-table-fixed-set
  - the-named-closed-set-IS-named-security-foundation
  - the-named-pass-by-copy-vs-pass-by-presence-distinction
  - the-named-binary-distinction-with-internal-substructure
  - the-named-Far-doesn-t-validate-with-pointer-to-exo
  - the-named-cross-package-pointer-when-functionality-is-here-not-elsewhere
  - the-named-makeTagged-IS-named-extension-point
  - the-named-extension-point-IS-named-API-shape
  - the-named-five-named-requirements-for-passability
  - the-named-tentatively-modal
  - the-named-hedge-word-in-canonical-rule
  - the-named-canonical-counterexamples-after-canonical-examples
  - the-named-counterexample-discipline
  - the-named-Use-for-and-Pass-styles-pair-rows-discipline
  - the-named-type-guards-section-with-canonical-imports
  - the-named-Deep-Dives-IS-named-implementation-detail-section
  - the-named-monorepo-docs-reference
  - the-named-Hardened-JS-mentioned-pervasively-but-no-section
  - sixteen-cycles-with-named-pivot-domain-stay
  - nine-named-packages-in-the-pivot-cluster
  - fourteen-citation-arc-closures-in-pivot-now
  - six-citation-arc-closures-in-one-cycle
  - two-cycles-with-named-role-label-before-package-name
  - two-cycles-with-named-Hardened-JS-discipline-streak-continues-broken
parent: endo--packages-pass-style-README-md--thirteen-pass-styles-table-and-six-arc-closures
---

(Line 88-90) — *"Far objects are remotable but don't validate their inputs. For defensive objects with automatic input validation, see [@endo/exo](../exo/README.md)."*

**§the-named-cross-package-pointer-when-functionality-is-here-not-elsewhere** — the README *explicitly admits a limit* (pass-style doesn't do input validation) and *points to the sibling package that does*. This is the **inverse** of cycle 321's role-label discipline (which named what each package does, FROM the citing package). Here, the *cited* package names what it *doesn't* do.

First-explicit-observation. Structurally novel because it:
1. Admits the limit honestly
2. Points to the solution
3. Implicitly says "this package's role is X; for Y, see Z"
4. Forms a *two-way* citation graph: cycle 321 cited @endo/exo as "Defensive Objects"; cycle 325 cites @endo/exo as "where to go for validation". Both ends agree on the role.

This is sibling to cycle 323's **§the-named-API-with-honesty-about-relaxed-security-model** (the TrapCaps disclaimer) and cycle 321's **§the-named-API-with-honesty-about-low-utility-paths** ("most users don't need this"). The pattern is **§the-named-honesty-about-API-boundaries** — admit what the API doesn't do.

**§the-named-honesty-about-API-tradeoffs** now has **three named subtypes**:
- **Low-utility-paths** (cycle 321): "most users don't need this"
- **Relaxed-security-models** (cycle 323): "not for mutually-suspicious parties"
- **Functionality-not-in-this-package** (cycle 325): "for validation, see @endo/exo"

§three-cycles-with-named-honesty-about-API-tradeoffs (321 + 323 + 325) — first-explicit-observation as a *parameterized* meta-pattern with three subtypes.
