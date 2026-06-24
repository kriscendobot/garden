---
title: §the-named-import-order-as-temporal-discipline
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
parent: endo--packages-lockdown-README-md--sixteenth-package-side-effect-import-as-environment-upgrade-and-subset-relationship-with-named-alternative
---

Lines 9-12 show the canonical usage:

```js
import '@endo/lockdown'
import 'hardened-modules...';
```

**§the-named-import-order-as-temporal-discipline** — first-explicit-observation. The example WORKS ONLY IF lockdown is imported FIRST. ES modules import in source-order (for the eager `import` form). The temporal discipline: lockdown's side effects must complete BEFORE any hardened-module's import runs.

**§the-named-import-statement-as-temporal-anchor** — first-explicit-observation as a tier-3 meta-pattern. When a package's purpose is side-effect-only, the import statement BECOMES the temporal anchor — the placement of the import in source order determines when the side effect happens.

Sibling to cycle 337 @endo/harden README's **§the-named-with-OR-without-NOT-both-policy** (temporal-ordering creates vulnerability). Cycle 337 named the vulnerability; cycle 341 names the discipline that prevents it (import lockdown FIRST). **§two-cycles-with-named-temporal-ordering-discipline** (337 vulnerability + 341 prevention discipline). First-explicit-observation as a tier-2 multi-cycle pattern.

**§the-named-quoted-import-ellipsis-as-placeholder** — first-explicit-observation. Line 11: `import 'hardened-modules...';` — the ellipsis inside string-literal is a PLACEHOLDER for "your hardened modules here". The string-literal-ellipsis convention is a documentation-only idiom (won't run as code) but COMMUNICATES the structure to the reader.
