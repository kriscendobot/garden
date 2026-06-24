---
title: §the-named-by-default-discipline-with-named-opt-in
source: endo--packages-ses-docs-preparing-for-stabilize-md
url: https://github.com/endojs/endo/blob/master/packages/ses/docs/preparing-for-stabilize.md
authors: [Mark S. Miller, Endo project (collective)]
repo: endojs/endo
path: packages/ses/docs/preparing-for-stabilize.md
total-lines: 30
ingest-cycle: 349
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-three-language-anti-features-mitigated-by-SES
  - the-named-Stabilize-proposal-with-three-integrity-traits
  - the-named-return-override-mistake
  - the-named-assignment-override-mistake
  - the-named-proxy-based-reentrancy-hazard
  - the-named-fixed-overridable-non-trapping-three-traits
  - the-named-forward-looking-design-document-discipline
  - the-named-prepare-for-future-changes-discipline
  - the-named-placeholder-names-are-not-final
  - the-named-bikeshedding-process-acknowledged
  - the-named-by-default-discipline-with-named-opt-in
  - the-named-E-returns-proxy-with-frozen-trivial-target
  - the-named-top-level-target-discipline
  - the-named-TC39-stage-1-named
  - the-named-draft-PR-named-with-issue-number
  - the-named-harden-discipline-changing-meaning
  - the-named-30-line-forward-looking-design-doc
  - the-named-streak-of-zero-cross-package
  - forty-cycles-with-named-pivot-domain-stay
  - one-hundred-thirty-five-citation-arc-closures-in-pivot-now
parent: endo--packages-ses-docs-preparing-for-stabilize-md--three-language-anti-features-mitigated-by-SES-and-forward-looking-design-document-discipline
---

Lines 16-17 + 24:

> [#2673] will *by default* produce proxies that refuse to be made non-trapping. An explicit handler trap... will need to be explicitly provided to make a proxy that allows itself to be made non-trapping.

**§the-named-by-default-discipline-with-named-opt-in** — first-explicit-observation. Safety by default; opt-in for less safety. **§the-named-safety-by-default-opt-in-for-less-safety**.

Compare to:
- Cycle 337 @endo/harden: §the-named-fail-loud-or-pay-cost-binary-choice (build-time choice)
- Cycle 343 @endo/init: §the-named-default-is-fully-locked-down (default = strict)
- Cycle 345 @endo/ses: §the-named-three-tiers-of-isolation-claims (each tier opt-in)
- **Cycle 349 stabilize**: §the-named-safety-by-default-opt-in-for-less-safety (runtime opt-in via handler trap)

**§four-cycles-with-named-safety-by-default-discipline** (337 + 343 + 345 + 349) — first-explicit-observation as a tier-2 multi-cycle pattern.
