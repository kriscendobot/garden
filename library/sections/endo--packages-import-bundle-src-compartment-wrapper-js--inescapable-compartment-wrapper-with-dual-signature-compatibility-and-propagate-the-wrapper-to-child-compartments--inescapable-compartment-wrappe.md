---
source: packages/import-bundle/src/compartment-wrapper.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/import-bundle/src/compartment-wrapper.js
source_path: packages/import-bundle/src/compartment-wrapper.js
section_kind: source
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Brian Warner (prompted)
topics:
  - compartments
  - hardened-javascript
  - bundles
genre: §endo-source-comment-fragment §canonical-inescapable-compartment-pattern
cycle: 193
lane: chat
status: current
title: Inescapable Compartment wrapper with dual-signature compatibility, propagate-the-wrapper-to-child-compartments, and prototype-preserving for instanceof
parent: endo--packages-import-bundle-src-compartment-wrapper-js--inescapable-compartment-wrapper-with-dual-signature-compatibility-and-propagate-the-wrapper-to-child-compartments
---

> §Chat-lane after cycle 192's designs-lane. §The-twenty-
> seventh-consecutive designs/chat alternation cycle (166-
> 193). §First-pivot-this-session: cycle 158 already covered
> loopback.js comprehensively, so I picked compartment-
> wrapper.js (fresh; §sibling-to-cycle-176-endor-architecture's
> §five-embedded-JS-bundles-via-include_str — both deal with
> Compartment-level confinement).

`packages/import-bundle/src/compartment-wrapper.js` (137
lines) implements `wrapInescapableCompartment(OldCompartment,
inescapableTransforms, inescapableGlobalProperties)` — the
§canonical-inescapable-compartment-pattern that lets a parent
impose options that propagate transitively to every child
Compartment.

§The-package-also-ships-a-design-doc: `compartment-wrapper.md`
in the same directory. §The-design-doc-and-the-source-are-
adjacent — a §local-design-doc-pattern that mirrors the
cycle 190-endo-posix-sandbox §source-mirror-to-PLAN pattern
but at the package layer instead of the workspace layer.

§The-single-most-structurally-interesting-move is §five-named-
mechanisms-composed: §dual-signature-compatibility (positional
vs options-bag) + §new.target-required-throw + §propagate-the-
wrapper-to-child-compartments-via-globalThis.Compartment-
reassignment + §prototype-preserving-for-instanceof + §SECURITY-
NOTE-about-non-SES-leak. §Five-moves-in-137-lines.
