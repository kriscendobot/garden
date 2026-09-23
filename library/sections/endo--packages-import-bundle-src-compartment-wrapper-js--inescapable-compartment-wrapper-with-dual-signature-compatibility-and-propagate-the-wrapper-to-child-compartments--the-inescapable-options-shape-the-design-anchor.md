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
title: §The-§inescapable-options-shape (the design anchor)
parent: endo--packages-import-bundle-src-compartment-wrapper-js--inescapable-compartment-wrapper-with-dual-signature-compatibility-and-propagate-the-wrapper-to-child-compartments
---

> §Compartment-wrapper.md prose (the §local-design-doc):
> "To prevent code from escaping a transform by evaluating
> its code in a new child `Compartment`, the creator of the
> confined compartment must replace its `Compartment`
> constructor with a wrapped version. The wrapper will modify
> the arguments to include the transforms (and other
> options). It must merge the provided options with the
> imposed ones in the right order, to ensure they cannot be
> overridden (i.e. the imposed transforms must appear at the
> *end* of the list). Finally, it must also propogate the
> wrapper itself to the new child Compartment, by modifying
> `c.thisGlobal.Compartment` on each newly created
> compartment."

§Three-named-requirements:

1. §Wrap-the-Compartment-constructor.
2. §Merge-options-in-the-right-order (imposed at the end).
3. §Propagate-the-wrapper to each new child.

§The-§imposed-transforms-must-appear-at-the-end discipline
matches the cycle 190-endo-posix-sandbox §anti-shadowing-rule
(caller-granted mounts land AFTER rootfs-derived $PATH so
they extend but can't override). §Both-are-§order-matters-
for-non-override patterns.
