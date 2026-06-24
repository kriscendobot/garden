---
title: The single most structurally interesting move
source: endo--packages-patterns-README-md
url: https://github.com/endojs/endo/blob/master/packages/patterns/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/patterns/README.md
total-lines: 415
ingest-cycle: 327
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-three-Why-X-sections-in-one-README
  - the-named-Why-X-section-discipline
  - the-named-comparative-justification-by-anticipated-objection
  - the-named-Key-Pattern-Passable-hierarchy-tree
  - the-named-ASCII-tree-for-type-hierarchy
  - the-named-Pattern-IS-itself-Passable
  - the-named-three-named-categories-Passable-Key-Pattern
  - the-named-M-namespace-as-canonical-builder
  - the-named-six-categories-of-M-matchers
  - the-named-Quick-Start-shows-error-output
  - the-named-required-optional-rest-tripartite
  - the-named-eref-IS-named-eventual-reference
  - the-named-call-vs-callWhen-distinction
  - the-named-chained-method-guard-builder
  - the-named-defensive-programming-IS-named-discipline
  - the-named-distributed-equality-semantics
  - the-named-partial-order-not-total-order
  - the-named-NaN-as-named-incomparable
  - the-named-bigint-for-arbitrary-precision-counts
  - the-named-counts-combine-on-duplicate-keys
  - eighteen-cycles-with-named-pivot-domain-stay
  - sixteen-citation-arc-closures-in-pivot-now
  - three-cycles-with-named-one-cycle-README-source-arc
  - three-cycles-with-named-role-label-before-package-name
  - three-cycles-with-named-monorepo-docs-reference
  - three-cycles-with-named-Hardened-JS-discipline-streak-continues-broken
parent: endo--packages-patterns-README-md--three-Why-X-sections-and-Key-Pattern-Passable-hierarchy-tree
---

**§the-named-three-Why-X-sections-in-one-README** — the README has *three* "Why X?" sections that explicitly justify design choices vs natural alternatives:

| Section | Where | Question | Answer |
|---|---|---|---|
| Why not use JavaScript Set? | Line 200-202 | Why CopySet over native Set? | Sets aren't passable; CopySet is frozen + comparable via keyEQ + efficiently serialized |
| Why not use plain objects? | Line 245-249 | Why CopyMap over plain objects? | Any Key as key (not just strings) + efficient compareKeys + subset relationships |
| Why partial order? | Line 367-371 | Why compareKeys returns NaN sometimes? | Different remotables have no ordering; CopySets use subset relationships |

**§the-named-Why-X-section-discipline** — first-explicit-observation as a *documentation discipline*. Each Why-section:
1. Names the natural alternative the reader might reach for
2. Explains why the package chose otherwise
3. Lists the properties the chosen design provides
4. Anticipates the reader's objection and disarms it

**§the-named-comparative-justification-by-anticipated-objection** — the README treats the *reader's likely confusion* as a structural feature of the document and addresses it directly. Sibling to cycle 325's **§the-named-cross-package-pointer-when-functionality-is-here-not-elsewhere** (which named what THIS package doesn't do); a Why-section names what THIS package DOES that an alternative doesn't. Together they form **§the-named-comparative-discipline**: explicitly position the package against alternatives.
