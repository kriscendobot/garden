---
title: §the-named-imperative-comment-block-as-design-document
source: endo--packages-lockdown-pre-js
url: https://github.com/endojs/endo/blob/master/packages/lockdown/pre.js
authors: [Mark S. Miller, Endo project (collective)]
repo: endojs/endo
path: packages/lockdown/pre.js
total-lines: 175
ingest-cycle: 342
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-re-export-then-overwrite-pattern
  - the-named-three-step-install-load-re-export-replace
  - the-named-feature-detection-two-channel-sniff
  - the-named-LOCKDOWN_OPTIONS-as-global-OR-env-discipline
  - the-named-console-warn-on-detection
  - the-named-discipline-violation-visible
  - the-named-three-branch-decision-tree-with-defaults
  - the-named-imperative-comment-block-as-design-document
  - the-named-honest-confession-in-prose-comment
  - the-named-Initialization-is-often-awkward
  - the-named-init-violates-normal-ocap-discipline-honest-comment
  - the-named-NOTE-TO-REVIEWERS-pattern-with-four-applications
  - the-named-four-commented-out-options-with-NOTE-TO-REVIEWERS
  - the-named-domainTaming-unsafe-always-injected
  - the-named-named-hole-with-named-mitigation
  - the-named-Start-Compartment-canonical-naming
  - the-named-postLockdown-as-second-phase
  - the-named-export-star-for-types-from-source-package
  - the-named-complementary-lens-re-ingest
  - six-cycles-with-named-complementary-lens-re-ingest
  - the-named-streak-resumes-with-eleventh-instance
  - thirty-three-cycles-with-named-pivot-domain-stay
  - eighty-nine-citation-arc-closures-in-pivot-now
  - five-cycles-with-named-substrate-package-introduction
parent: endo--packages-lockdown-pre-js--sixth-complementary-lens-re-export-then-overwrite-pattern-and-Start-Compartment-naming
---

Lines 16-49 are a 34-line comment block that's effectively the **design rationale** for the LOCKDOWN_OPTIONS feature. The block names:

1. **The need**: production code uses `import '@endo/init';` for side-effect initialization
2. **The problem**: testing needs different options; explicit parameter passing is awkward during initialization
3. **The discipline-violation**: *"`init` violates normal ocap discipline by feature testing global state"*
4. **The honest confession**: *"Initialization is often awkward."*
5. **The mechanism**: feature-test for `LOCKDOWN_OPTIONS` global, then env var; if present, parse as JSON options bag

**§the-named-imperative-comment-block-as-design-document** — first-explicit-observation as a tier-3 meta-pattern. The 34-line comment IS the design document for this feature; the actual implementation that follows is the realization of the comment's narrative.

**§the-named-init-violates-normal-ocap-discipline-honest-comment** — first-explicit-observation. The package explicitly NAMES that it violates ocap discipline: *"This is something that a module can but normally should not do"*. The honesty is at the SOURCE-LEVEL (in the JS file), not just at the README-level.

**§the-named-Initialization-is-often-awkward** — first-explicit-observation as a tier-3 meta-pattern. The one-sentence design-anchor at line 36 acknowledges that initialization code is hard. **§the-named-honest-confession-in-prose-comment** — already noted in cycle 183; cycle 342 reaffirms with the specific sentence as the canonical anchor.

**§three-cycles-with-named-honest-confession-in-prose-comment** (183 + 337 deprecated-with-named-regret + 342 init-violates-ocap-discipline) — the discipline crosses three pivot cycles.
