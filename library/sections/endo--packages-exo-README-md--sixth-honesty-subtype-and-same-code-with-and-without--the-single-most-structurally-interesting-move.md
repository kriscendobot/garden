---
title: The single most structurally interesting move
source: endo--packages-exo-README-md
url: https://github.com/endojs/endo/blob/master/packages/exo/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/exo/README.md
total-lines: 364
ingest-cycle: 331
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-honesty-about-API-tradeoffs-gains-sixth-subtype
  - the-named-functionality-in-different-org-subtype
  - the-named-cross-org-pointer-to-Agoric
  - the-named-same-code-with-and-without-discipline
  - the-named-Exo-IS-Far-plus-InterfaceGuard-combination
  - the-named-three-patterns-for-creating-exos
  - the-named-makeExo-defineExoClass-defineExoClassKit-trio
  - the-named-Why-Exo-side-by-side-comparison
  - the-named-when-to-use-checklist-discipline
  - the-named-least-authority-as-named-discipline
  - the-named-canonical-three-facet-example
  - the-named-this.state-and-this.facets-canonical-shapes
  - the-named-M.callWhen-three-or-four-step-semantics
  - the-named-GET_INTERFACE_GUARD-as-meta-method
  - the-named-four-named-uses-of-interface-introspection
  - the-named-cache-staleness-on-upgrade-warning
  - the-named-three-runtime-backing-tiers
  - the-named-positive-when-to-use-after-pointing-elsewhere
  - twenty-two-cycles-with-named-pivot-domain-stay
  - six-cycles-with-named-honesty-about-API-tradeoffs
  - four-cycles-with-named-role-label-before-package-name
  - four-cycles-with-named-monorepo-docs-reference
  - four-cycles-with-named-Hardened-JS-discipline-streak-continues-broken
  - thirty-five-citation-arc-closures-in-pivot-now
parent: endo--packages-exo-README-md--sixth-honesty-subtype-and-same-code-with-and-without
---

**§the-named-honesty-about-API-tradeoffs gains a sixth subtype** — line 327-346 ("Virtual and Durable Exos" section) points to **@agoric/vat-data** for production exo variants:

> This package provides **heap-based exos** that don't survive vat termination. For production systems with high cardinality or upgrade requirements, see:
> - **[@agoric/vat-data](https://github.com/Agoric/agoric-sdk/tree/master/packages/vat-data)** — Provides: `defineVirtualExoClass`, `defineDurableExoClass`, `prepareExoClass`, `prepareExoClassKit`

**§the-named-cross-org-pointer-to-Agoric** — first-explicit-observation. The pointer crosses the **organizational boundary** from Endo (the @endo/* family) to Agoric (the @agoric/* family). This is the **sixth named subtype** of §the-named-honesty-about-API-tradeoffs:

| Subtype | Cycle | Phrase / pointer-to |
|---|---|---|
| Low-utility-paths | 321 | "Most users don't need this" |
| Relaxed-security-models | 323 | "Not for mutually-suspicious parties" |
| Functionality-elsewhere | 325 | "For validation, see @endo/exo" (sibling Endo package) |
| Documentation-language-cannot-express | 326 | "JSDoc cannot express these" |
| Functionality-not-supported-at-all | 329 | "The marshal-based alternatives do not" |
| **Functionality-in-different-org** | **331** | **"see @agoric/vat-data"** (different org/repository) |

**§six-cycles-with-named-honesty-about-API-tradeoffs** (321 + 323 + 325 + 326 + 329 + 331) — the parameterized meta-pattern now spans six cycles with six distinct subtypes. The sixth subtype is *structurally different* from cycle 325's "functionality-elsewhere" because Agoric is a *different organization/repository*, not just a different package within the same family. **§the-named-cross-org-discipline-IS-named-organizational-boundary-crossing** — when a sibling-product in a different organization handles a related use case, name it explicitly.

**§the-named-positive-when-to-use-after-pointing-elsewhere** (line 342-346) — after pointing to Agoric for the production use cases, the README names what heap-exos *are* ideal for (development/testing + low cardinality + temporary session state + non-critical services). The pattern: when pointing elsewhere for X, also explicitly state what THIS package IS good for. **§the-named-scope-positive-naming-after-cross-pointer**. First-explicit-observation.
