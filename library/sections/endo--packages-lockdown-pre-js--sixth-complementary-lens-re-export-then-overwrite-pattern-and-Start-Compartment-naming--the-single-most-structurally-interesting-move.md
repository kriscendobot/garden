---
title: The single most structurally interesting move
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

**§the-named-re-export-then-overwrite-pattern** — pre.js performs a three-step structural move:

```js
// Step 1: Load SES (side-effect import; sets up globalThis.lockdown)
import 'ses';

// Step 2: Re-export SES type definitions to consumers
export * from 'ses';

// Step 3a: Capture SES's lockdown as raw
const rawLockdown = globalThis.lockdown;

// Step 3b: Define a wrapper that adds LOCKDOWN_OPTIONS sniff feature
export const lockdown = defaultOptions => {
  // ... feature-detection + three-branch decision tree ...
};

// Step 3c: REPLACE the global with the wrapper
globalThis.lockdown = lockdown;
```

**§the-named-re-export-then-overwrite-pattern** — first-explicit-observation as a tier-3 meta-pattern. The pattern wraps an existing global function:

1. **Load** the source package (SES) for its side effects
2. **Re-export** the source package's types (so consumers get type info)
3. **Capture** the original global as a private reference
4. **Wrap** it with added behavior
5. **Replace** the global with the wrapper

**§the-named-three-step-install-load-re-export-replace** — first-explicit-observation. The three structural moves: load (side-effect) + re-export (type-pass-through) + replace (wrapper-installation).

Cycle 341's README named the package as *"simply ensures that SES has both initialized and locked down the environment"* — but **§the-named-simply-ensures-language** hides this implementation pattern. Cycle 342 reveals: *"simply ensures"* means *replace the global with a feature-detection-enhanced wrapper*. The wrapper adds LOCKDOWN_OPTIONS feature-detection that the underlying SES lockdown doesn't have.

**§the-named-substitution-discipline-in-the-substrate-stack** — first-explicit-observation as a tier-3 meta-pattern. Substrate packages wrap their underlying packages by:
- Importing for side-effect (the underlying package installs its globals)
- Capturing the global
- Replacing with a wrapper that adds package-specific features

Compare to cycle 337 @endo/harden's §the-named-multiple-instances-first-call-wins — also a replace-at-shared-location pattern; cycle 342's pre.js is the implementation in a different package showing the same discipline.
