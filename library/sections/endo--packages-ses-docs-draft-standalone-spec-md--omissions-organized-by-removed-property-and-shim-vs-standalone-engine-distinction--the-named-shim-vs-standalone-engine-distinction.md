---
title: §the-named-shim-vs-standalone-engine-distinction
source: endo--packages-ses-docs-draft-standalone-spec-md
url: https://github.com/endojs/endo/blob/master/packages/ses/docs/draft-standalone-spec.md
authors: [Mark S. Miller, Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/ses/docs/draft-standalone-spec.md
total-lines: 201
ingest-cycle: 351
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-shim-vs-standalone-engine-distinction
  - the-named-omissions-organized-by-removed-property
  - the-named-non-determinism-as-removed-feature
  - the-named-ambient-authority-as-removed-feature
  - the-named-global-communications-channel-language
  - the-named-throws-rather-than-returns-discipline
  - the-named-deterministic-replication-as-canonical-use-case
  - the-named-blockchain-as-shorthand-for-deterministic-replication
  - the-named-shared-globals-vs-shared-intrinsics-distinction
  - the-named-rom-able-immutable-discipline
  - the-named-IoT-and-blockchain-may-omit-evaluators
  - the-named-function-constructors-not-evaluators
  - the-named-makeRootRealm-feature-test-discipline
  - forty-two-cycles-with-named-pivot-domain-stay
  - one-hundred-forty-eight-citation-arc-closures-in-pivot-now
parent: endo--packages-ses-docs-draft-standalone-spec-md--omissions-organized-by-removed-property-and-shim-vs-standalone-engine-distinction
---

Opening lines 3-9:

> In the Realms, Frozen Realms, Realms shim, and SES shim work, we've generally worked towards standardizing the APIs for dynamically *creating* a SES world from within a standard EcmaScript world. For IoT or blockchain purposes, the more relevant question is: What is the resulting standard SES world, independent of whether it was created from within a standard EcmaScript world, or whether it was implemented directly by a standalone SES engine that supports only SES?

**§the-named-shim-vs-standalone-engine-distinction** — first-explicit-observation as a tier-3 meta-pattern. SES has **two implementation strategies**:
- **Shim-based**: dynamically *create* a SES world from JS (the current packages/ses implementation)
- **Standalone engine**: directly *implement* SES (what this spec describes)

Tier-3 framing: when a security-focused language subset exists, two implementation strategies are possible — shim it onto the full language OR build a native engine that ONLY supports the subset. The standalone variant is **simpler** because it has nothing to suppress.
