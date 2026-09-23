---
title: §the-named-Start-Compartment-canonical-naming
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

Lines 167-174:

```js
// We are now in the "Start Compartment". Our global has all the same
// powerful things it had before, but the primordials have changed to make
// them safe to use in the arguments of API calls we make into more limited
// compartments

// 'Compartment', 'assert', and 'harden' are now present in our global scope.
postLockdown();
```

**§the-named-Start-Compartment-canonical-naming** — first-explicit-observation. The post-lockdown state is *named* explicitly as the "Start Compartment". This is a key concept in the SES architecture; cycle 342 reveals where the canonical naming lives.

**§the-named-three-names-installed-after-lockdown** — first-explicit-observation. After lockdown, three names are *globally available*: `Compartment` + `assert` + `harden`. The comment names them explicitly. These are the **canonical post-lockdown surface**.

**§the-named-canonical-comment-after-lockdown-names-the-surface** — first-explicit-observation as a tier-3 meta-pattern. The comment ANNOTATES the state transition; the reader knows what's available post-call.

**§the-named-postLockdown-as-second-phase** — first-explicit-observation. The function call `postLockdown()` at line 174 runs the second phase of the two-phase init. Cycle 183 named §two-phase-init-with-tolerance-ladder; cycle 342 reveals the specific second-phase call site.
