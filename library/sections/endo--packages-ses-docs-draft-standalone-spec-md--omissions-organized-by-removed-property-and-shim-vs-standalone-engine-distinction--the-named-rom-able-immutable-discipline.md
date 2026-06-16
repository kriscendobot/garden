---
title: §the-named-rom-able-immutable-discipline
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

Lines 96-101:

> Freeze all shared intrinsics. With the above omissions, there is no hidden state or ambient authority among the shared intrinsics, so transitive freezing means that the shared intrinsics are immutable and rom-able. Since no global objects or evaluators are reachable from the shared intrinsics. They can be placed in ROM without the bookkeeping needed for them to point at any objects not in ROM.

**§the-named-rom-able-immutable-discipline** — first-explicit-observation as a tier-3 meta-pattern. When shared intrinsics are frozen + no hidden state + no ambient authority + no reachable globals or evaluators, they become **ROM-able** (can be placed in read-only memory). This is the IoT-friendly property — no GC, no mutable refs, no kernel mapping.

Tier-3 framing: when designing a security-focused subset, the ability to put intrinsics in ROM is a measurable end-state property — it certifies the absence of state.
