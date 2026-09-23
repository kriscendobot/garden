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
title: §Tier-1 borrowing
parent: endo--packages-import-bundle-src-compartment-wrapper-js--inescapable-compartment-wrapper-with-dual-signature-compatibility-and-propagate-the-wrapper-to-child-compartments
---

- §inescapable-compartment-wrapper-pattern (§three-named-
  requirements: wrap-constructor + merge-options-in-order +
  propagate-wrapper)
- §__options__-sigil for §dual-signature-compatibility-during-
  migration
- §preserve-.name-via-function-name-while-binding-to-a-
  different-local (lint-friendly shadowing)
- §`new.target===undefined`-throw for §constructor-only-
  discipline
- §`Reflect.construct(...)` for subclass-forwarding (sibling
  to cycle 181 base64's `Reflect.apply` capture)
- §propagate-the-wrapper-via-globalThis-Compartment-
  reassignment (transitive confinement)
- §prototype-aliasing for §instanceof-preserving
- §SECURITY-NOTE-prefix for §security-disclosure-comments
  (greppable; distinctive from regular comments)
- §`Reflect.ownKeys`-not-`Object.keys` for §full-key-
  enumeration (symbols + non-enumerable)
- §named-TODO-with-shape-of-future-fix
- §co-located-design-doc-pattern (compartment-wrapper.md
  alongside compartment-wrapper.js)
