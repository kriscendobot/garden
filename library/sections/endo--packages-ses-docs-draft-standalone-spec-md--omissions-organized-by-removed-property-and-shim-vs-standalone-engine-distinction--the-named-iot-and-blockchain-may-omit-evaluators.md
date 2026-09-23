---
title: §the-named-IoT-and-blockchain-may-omit-evaluators
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

Lines 60-62:

> Some IoT and blockchain configurations may omit all runtime evaluators.

**§the-named-IoT-and-blockchain-may-omit-evaluators** — first-explicit-observation. Even the runtime evaluators (eval, Function constructor, Realm.makeCompartment) are OPTIONAL in extreme configurations. The minimum standalone SES engine has NO runtime evaluation capability.

**§the-named-function-constructors-not-evaluators** — line 47: *"Because these function constructors always throw, we do not consider them to be evaluators."* The TAXONOMY distinguishes evaluators from non-evaluators based on whether they can construct code.

**§the-named-makeRootRealm-feature-test-discipline** — lines 87-94: *"On platforms that do not support `Realm.makeRootRealm`, the property must be absent so that SES code can feature-test for it."* The discipline: missing capabilities should be ABSENT, not present-but-broken, so callers can feature-test.
