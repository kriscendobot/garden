---
title: §the-named-feature-detection-two-channel-sniff
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

Lines 51-65 implement a two-channel feature detection:

```js
let optionsString;
if (typeof LOCKDOWN_OPTIONS === 'string') {
  optionsString = LOCKDOWN_OPTIONS;
  console.warn(`'@endo/lockdown' sniffed and found a 'LOCKDOWN_OPTIONS' global variable\n`);
} else if (typeof process === 'object' && typeof process.env.LOCKDOWN_OPTIONS === 'string') {
  optionsString = process.env.LOCKDOWN_OPTIONS;
  console.warn(`'@endo/lockdown' sniffed and found a 'LOCKDOWN_OPTIONS' environment variable\n`);
}
```

**§the-named-feature-detection-two-channel-sniff** — first-explicit-observation. **TWO channels** checked in **deterministic order**:
1. JavaScript global variable `LOCKDOWN_OPTIONS`
2. Environment variable `process.env.LOCKDOWN_OPTIONS`

**§the-named-LOCKDOWN_OPTIONS-as-global-OR-env-discipline** — first-explicit-observation. The discipline: one feature can be configured via TWO channels (browser-friendly global + Node-friendly env var). The two channels are NOT redundant — they reflect different host environments (browsers don't have `process.env`; Node has both).

**§the-named-console-warn-on-detection** — first-explicit-observation. Each successful sniff emits a `console.warn` with the package name and which channel triggered. **§the-named-discipline-violation-visible** — first-explicit-observation as a tier-3 meta-pattern. When a package deliberately violates ocap discipline (using globals/env-vars instead of explicit parameters), it should make the violation VISIBLE via console.warn.

Compare to cycle 337 @endo/harden's §the-named-helpful-stack-on-misuse (runtime detection of pre-lockdown harden); cycle 342's console.warn is the *cooperative* version of the same discipline — the package itself logs what it did, so reviewers can audit.

**§two-cycles-with-named-visibility-discipline-on-discipline-violation** (337 stack + 342 console.warn) — first-explicit-observation as a tier-2 multi-cycle pattern.
