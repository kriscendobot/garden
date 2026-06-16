---
title: §the-named-NOTE-TO-REVIEWERS-pattern-with-four-applications
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

Lines 105-135 contain FOUR `NOTE TO REVIEWERS` blocks, each guarding a commented-out option:

| Option | Lines | Comment |
|---|---|---|
| `errorTaming: 'unsafe'` | 116-118 | "If you see the following line *not* commented out, this may be a development accident that MUST be fixed before merging" |
| `stackFiltering: ...` (four variants) | 128-134 | "If you see the `stackFiltering` settings *not* commented out below, this may be a development accident that MUST be fixed before merging" |
| `overrideTaming: 'min'` | 144-146 | Same NOTE TO REVIEWERS |
| `consoleTaming: 'unsafe'` | 156-158 | Same NOTE TO REVIEWERS |

**§the-named-NOTE-TO-REVIEWERS-pattern-with-four-applications** — first-explicit-observation. Cycle 183 named the NOTE TO REVIEWERS pattern in the high-level; cycle 342's complementary-lens reveals **four applications** of the pattern in pre.js alone.

**§the-named-four-commented-out-options-with-NOTE-TO-REVIEWERS** — first-explicit-observation. Each NOTE TO REVIEWERS block is associated with a SPECIFIC commented-out option that would weaken security. The pattern:

1. Comment block explaining when/why one MIGHT want to uncomment
2. NOTE TO REVIEWERS warning about development-accident
3. The commented-out option itself

**§the-named-NOTE-TO-REVIEWERS-as-merge-defense** — first-explicit-observation as a tier-3 meta-pattern. The mechanism: if a developer accidentally commits an uncommented insecure option, the code reviewer reads the embedded NOTE and catches the accident. The defense is *embedded in the source*, not in tooling.

Compare to cycle 333 @endo/common's §the-named-discipline-with-named-exception (honesty about scope); cycle 337's §the-named-isFake-deprecated-with-named-regret (honest regret); cycle 342's NOTE TO REVIEWERS is a third shape of honesty-in-source. **§four-shapes-of-source-level-honesty** (322 warning-thrice + 326 deprecation-with-redirect + 337 deprecated-with-named-regret + 342 NOTE-TO-REVIEWERS-as-merge-defense). First-explicit-observation as a tier-3 meta-pattern.
