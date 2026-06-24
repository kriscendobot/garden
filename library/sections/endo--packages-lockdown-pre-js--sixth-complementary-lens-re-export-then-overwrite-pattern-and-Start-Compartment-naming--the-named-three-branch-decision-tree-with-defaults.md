---
title: §the-named-three-branch-decision-tree-with-defaults
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

Lines 67-160 implement a three-branch decision tree:

| Branch | Condition | Behavior |
|---|---|---|
| 1 | `optionsString` from sniff (lines 67-89) | Parse JSON; validate as object; merge with `domainTaming: 'unsafe'`; call rawLockdown |
| 2 | `defaultOptions` argument (lines 90-95) | Spread `defaultOptions`; add `domainTaming: 'unsafe'`; call rawLockdown |
| 3 | Fall through (lines 96-163) | Call rawLockdown with HARDCODED defaults including domainTaming: 'unsafe' |

**§the-named-three-branch-decision-tree-with-defaults** — first-explicit-observation. The branches enumerate THREE configuration sources: (1) external (sniffed); (2) caller-provided; (3) hardcoded fallback. The tree's structure: external-wins; caller-wins-over-default; default-as-last-resort.

**§the-named-domainTaming-unsafe-always-injected** — first-explicit-observation as a tier-3 meta-pattern. The `domainTaming: 'unsafe'` option is INJECTED in ALL THREE BRANCHES regardless of input. The rationale (lines 144-160):

> Domain taming causes lockdown to throw an error if the Node.js domain module has already been loaded... However, our platform still depends on systems like standardthings/esm which ultimately pull in domains. For now, we are resigned to leave this hole open, knowing that all contract code will be run under XS to avoid this vulnerability.

**§the-named-named-hole-with-named-mitigation** — already observed in cycle 183; reaffirmed in cycle 342 with a fuller treatment. The discipline: when a security hole cannot be closed in the immediate environment, name BOTH the hole AND the mitigation in another layer.

**§the-named-injected-default-as-platform-acknowledgment** — first-explicit-observation. The `domainTaming: 'unsafe'` injection acknowledges that the *npm ecosystem* (standardthings/esm) makes the strict default impossible. The injection is a PRAGMATIC compromise made explicit.
