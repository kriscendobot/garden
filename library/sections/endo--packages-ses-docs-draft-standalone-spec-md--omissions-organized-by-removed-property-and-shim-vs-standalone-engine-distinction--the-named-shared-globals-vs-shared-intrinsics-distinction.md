---
title: §the-named-shared-globals-vs-shared-intrinsics-distinction
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

Lines 50-56:

> We define the *shared globals* as all the standard shared global variable bindings defined by the above, i.e., without `Intl` by default, with `Realm` (see below), without `eval`, without `Function`, without anything outside the EcmaScript 2018 spec, and with `BigInt`. We define the *shared intrinsics* as all the objects transitively reachable from the shared globals. Note that no global objects or evaluators are reachable from the shared intrinsics.

**§the-named-shared-globals-vs-shared-intrinsics-distinction** — first-explicit-observation. Two formally defined concepts:
- **Shared globals**: the global variable bindings (named by the spec)
- **Shared intrinsics**: all objects transitively reachable from the shared globals

**§the-named-formal-definitions-in-design-doc** — first-explicit-observation as a tier-3 meta-pattern. When a design document needs precision, italicize-define key terms before using them. Compare to cycle 345 @endo/ses README's §the-named-host-program-vs-guest-program-vocabulary (also in-section definitions).
