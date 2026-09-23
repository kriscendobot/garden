---
title: §the-named-four-named-membership-criteria-discipline
source: endo--packages-common-README-md
url: https://github.com/endojs/endo/blob/master/packages/common/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/common/README.md
total-lines: 17
ingest-cycle: 333
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-no-barrel-index-discipline
  - the-named-no-barrel-index-IS-named-inverse-of-barrel-index
  - the-named-collection-package-vs-substrate-package-vs-utility-package
  - the-named-low-level-utilities-collection
  - the-named-dependency-ceiling-discipline
  - the-named-four-named-membership-criteria-discipline
  - the-named-one-file-one-export-with-named-export-name
  - the-named-deep-imports-enable-tree-shaking
  - the-named-src-directory-reserved-for-non-exports
  - the-named-discipline-with-named-exception
  - the-named-README-IS-named-package-policy-not-utility-documentation
  - the-named-tests-as-examples-discipline
  - the-named-shortest-README-in-pivot
  - the-named-no-canonical-sections-IS-named-curation-policy-shape
  - twenty-four-cycles-with-named-pivot-domain-stay
  - twelve-named-packages-in-the-pivot-cluster
  - six-cycles-with-named-one-cycle-README-source-arc
  - forty-three-citation-arc-closures-in-pivot-now
parent: endo--packages-common-README-md--twelfth-package-no-barrel-index-discipline-and-curation-policy-shape
---

Lines 5-9 list four criteria for membership in @endo/common:

1. **Low level** — *"not depending on anything higher level than `ses`, `@endo/eventual-send`, and `@endo/promise-kit`. Many depend on nothing beyond plain old JavaScript."*
2. **Highly reusable** — *"potentially useful many places."*
3. **Sufficiently general** — *"would be awkward to import from a more specialized package."*
4. **Self-contained explainability** — *"can be explained and motivated without much external knowledge."*

**§the-named-dependency-ceiling-discipline** — criterion #1 names an *upper bound* on dependencies. The "low level" property is defined by what utilities don't depend on (three named foundations: ses + eventual-send + promise-kit). **§the-named-low-level-IS-defined-by-negation**. First-explicit-observation as a discipline-by-negation pattern.

**§the-named-four-named-membership-criteria-discipline** — first-explicit-observation. The criteria are *aspirational*: they define the package's curation policy so future contributors know what *belongs* and what *doesn't*. A utility that fails any criterion shouldn't be added to @endo/common.

The fourth criterion (*"can be explained and motivated without much external knowledge"*) is structurally striking: it constrains the utilities to be *teachable in isolation*. This is the README's *self-imposed limit* on complexity.
