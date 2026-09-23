---
title: Other key moves
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

- **§the-named-Exo-IS-Far-plus-InterfaceGuard-combination** (line 1-12) — opening defines Exo as `Far + InterfaceGuard`. Two ingredients combine into a defensive remotable. First-explicit-observation.

- **§the-named-three-patterns-for-creating-exos** with **§the-named-makeExo-defineExoClass-defineExoClassKit-trio** (line 14-17) — the three factories named with one-line description each. Cycle 322 source already documented the trio; this README is the documentation-side closure.

- **§the-named-Why-Exo-section-with-Far-comparison** (line 19-55) — *Why-X-section-discipline* applied to a single binary comparison (Far vs Exo). §two-cycles-with-named-Why-X-section-discipline (327 patterns + 331 exo) — first-explicit-observation as a recurring discipline.

- **§the-named-when-to-use-checklist-discipline** (line 80-83, 124-126, 193-197) — each of the three patterns has a "When to use:" bullet list. Three checklists in one README. **§three-when-to-use-bullets-per-pattern**. First-explicit-observation.

- **§the-named-least-authority-as-named-discipline** (line 135-136) — *"the key pattern for least authority: give each client only the facet they need"*. Names capability-security discipline. First-explicit-observation. Closes citation arc with cycle 322 exo-makers.js (which discussed amplify capability for inter-facet access).

- **§the-named-canonical-three-facet-example** (line 142-191) — *up* (increment) + *down* (decrement) + *reader* (getValue). The canonical least-authority illustration: each client gets only the facet they need. **§the-named-incrementer-decrementer-reader-canonical-trio** — first-explicit-observation. Sibling to cycle 321 eventual-send's mint→purse→payment→deposit canonical example.

- **§the-named-this.state-and-this.facets-canonical-shapes** — `this.state` is per-instance (defineExoClass) or shared (defineExoClassKit); `this.facets` for inter-facet communication (defineExoClassKit only).

- **§the-named-M.callWhen-three-or-four-step-semantics** (line 226-230) — four numbered steps: validate pattern → await if promise → validate resolved value → call method. **§the-named-numbered-step-semantics-discipline**. First-explicit-observation. Closes cycle 327 patterns README arc (which named M.callWhen as async-method-guard).

- **§the-named-GET_INTERFACE_GUARD-as-meta-method** (line 297-325) — dedicated section on runtime interface introspection. **§the-named-four-named-uses-of-interface-introspection** (runtime discovery + dynamic client generation + documentation generation + protocol negotiation). First-explicit-observation as a numbered-uses pattern.

- **§the-named-cache-staleness-on-upgrade-warning** (line 324-325) — *"The interface can change across vat upgrades, so clients caching it may become stale."* First-explicit-observation. Closes cycle 239's *cache staleness caveat* arc (which named the same warning in get-interface.js).

- **§the-named-three-runtime-backing-tiers** — heap (this package) + virtual (paged storage) + durable (survives vat upgrade). The README names all three explicitly. **§the-named-three-tier-runtime-backing-IS-named-canonical-axis**. First-explicit-observation.

- **§the-named-vat-data-package-pointed-to-with-API-surface** (line 332-338) — the cross-org pointer names not just the package but its *specific exports*: defineVirtualExoClass + defineDurableExoClass + prepareExoClass + prepareExoClassKit. **§the-named-cross-package-pointer-names-the-specific-API-surface** — first-explicit-observation.

- **§the-named-Integration-with-Endo-Packages-with-role-labels** (line 348-355) — Foundation + Validation + Communication. **§four-cycles-with-named-role-label-before-package-name** (321 + 325 + 327 + 331) — the discipline now spans four cycles.

- **§the-named-Complete-Tutorial-link** (line 357-359) — `../../docs/message-passing.md`. **§four-cycles-with-named-monorepo-docs-reference** (321 + 325 + 327 + 331).

- **§the-named-See-Also-section-pointing-to-Exo-Taxonomy** (line 361-364) — points to `./docs/exo-taxonomy.md` for *complete API reference*. **§the-named-See-Also-IS-named-completeness-pointer**.

- **§the-named-no-Hardened-JavaScript-section** — like cycles 323, 325, 327: no dedicated Hardened-JS section; implicit via citation. **§four-cycles-with-named-Hardened-JS-discipline-streak-continues-broken** (323 + 325 + 327 + 331).

- **§the-named-nine-section-README-shape** — Overview + Why Exo? + Three Patterns (three sub-sections) + Async Methods + State Management + Introspection + Virtual and Durable Exos + Integration with Endo Packages + See Also. Nine top-level sections; deep-feature-package shape. Compare to cycle 321 eventual-send (twelve-section substrate); cycle 327 patterns (substantial; multiple sub-sections); cycle 331 exo is between substrate and utility — deep-feature without being substrate.
